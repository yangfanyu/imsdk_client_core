import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:imsdk_client_core/imsdk_client_core.dart';

class CommandLineApp extends EasyLogger {
  static const delayDuration = Duration(microseconds: 500);

  final bool autoClear;
  final NetClient _netClient;
  final Stream<String> _stdinLineStreamBroadcaster = stdin.transform<String>(utf8.decoder).transform<String>(const LineSplitter()).asBroadcastStream();
  final List<Function> _pageRouteStack = [];

  CommandLineApp({this.autoClear = false, EasyLogLevel logLevel = EasyLogLevel.info, required String host, required String bsid, required String secret, bool binary = true})
      : _netClient = NetClient(logLevel: logLevel, host: host, bsid: bsid, secret: secret, binary: binary, onCredentials: onCredentials),
        super(logTag: '');

  static String get credentialsDirectory => '${Directory.current.path}/example/credentials';

  static void onCredentials(String nick, String? credentials) {
    // print(credentials);
    try {
      final file = File('$credentialsDirectory/$nick.cer');
      if (credentials == null) {
        if (file.existsSync()) file.delete(); //异步删除即可
      } else {
        if (!file.existsSync()) file.createSync(recursive: true);
        file.writeAsString(credentials); //异步写入即可

      }
    } catch (error) {
      // print(error);
    }
  }

  ///导航到新页面
  void navigationTo({required Function from, required Function to}) {
    if (!_pageRouteStack.contains(from)) {
      _pageRouteStack.add(from);
    }
    to();
  }

  ///登录页
  void loginPage() {
    renderPage(
      '登录',
      [
        MenuItem('口令登录', () async {
          final List<FileSystemEntity> entityList = Directory(credentialsDirectory).existsSync() ? Directory(credentialsDirectory).listSync() : [];
          if (entityList.isEmpty) {
            logWarn(['未找到口令证书，请用其他方式登录!']);
            Future.delayed(delayDuration, () => loginPage());
          } else {
            logDebug(['证书目录下发现口令证书:']);
            entityList.sort((a, b) => a.path.compareTo(b.path));
            final pathMap = <String, String>{};
            for (var i = 0; i < entityList.length; i++) {
              logDebug(['    $i -> ${entityList[i].path.replaceFirst(credentialsDirectory, '')}']);
              pathMap['$i'] = entityList[i].path;
            }
            logInfo(['请输入口令证书序号:']);
            final key = (await readStdinLine()).trim();
            if (!pathMap.containsKey(key)) {
              logWarn(['没有这个证书选项!']);
              Future.delayed(delayDuration, () => loginPage());
            } else {
              try {
                final file = File(pathMap[key]!);
                final user = NetClient.decryptCredentials(file.readAsStringSync(), _netClient.secret)!;
                final result = await _netClient.loginByToken(uid: user.id, token: user.token);
                if (result.ok) {
                  onLoginSuccess();
                } else {
                  logWarn([result.desc]);
                  Future.delayed(delayDuration, () => loginPage());
                }
              } catch (error) {
                logError(['读取证书出错', error]);
                Future.delayed(delayDuration, () => loginPage());
              }
            }
          }
        }),
        MenuItem('账号密码登录', () async {
          logInfo(['请输入用户账号:']);
          final no = (await readStdinLine()).trim();
          logInfo(['请输入用户密码:']);
          final pwd = (await readStdinLine()).trim();
          final result = await _netClient.loginByNoPwd(no: no, pwd: pwd);
          if (result.ok) {
            onLoginSuccess();
          } else {
            logWarn([result.desc]);
            Future.delayed(delayDuration, () => loginPage());
          }
        }),
        MenuItem('手机号码登录', () async {
          logInfo(['请输入手机号码:']);
          final phone = (await readStdinLine()).trim();
          final sendres = await _netClient.sendRandcode(phone: phone);
          if (sendres.ok) {
            logDebug([sendres.desc]);
            logInfo(['请输入验证码:']);
            final code = (await readStdinLine()).trim();
            final result = await _netClient.loginByPhone(phone: phone, code: code);
            if (result.ok) {
              onLoginSuccess();
            } else {
              logWarn([result.desc]);
              Future.delayed(delayDuration, () => loginPage());
            }
          } else {
            logWarn([sendres.desc]);
            Future.delayed(delayDuration, () => loginPage());
          }
        }),
        MenuItem('重置密码', () async {
          logInfo(['请输入手机号码:']);
          final phone = (await readStdinLine()).trim();
          final sendres = await _netClient.sendRandcode(phone: phone);
          if (sendres.ok) {
            logDebug([sendres.desc]);
            logInfo(['请输入验证码:']);
            final code = (await readStdinLine()).trim();
            logInfo(['请输入新密码:']);
            final pwd = (await readStdinLine()).trim();
            final result = await _netClient.loginByPhone(phone: phone, code: code, pwd: pwd);
            if (result.ok) {
              onLoginSuccess();
            } else {
              logWarn([result.desc]);
              Future.delayed(delayDuration, () => loginPage());
            }
          } else {
            logWarn([sendres.desc]);
            Future.delayed(delayDuration, () => loginPage());
          }
        }),
        MenuItem('注册账号', () async {
          logInfo(['请输入手机号码:']);
          final phone = (await readStdinLine()).trim();
          final sendres = await _netClient.sendRandcode(phone: phone);
          if (sendres.ok) {
            logDebug([sendres.desc]);
            logInfo(['请输入验证码:']);
            final code = (await readStdinLine()).trim();
            logInfo(['请输入账号:']);
            final no = (await readStdinLine()).trim();
            logInfo(['请输入密码:']);
            final pwd = (await readStdinLine()).trim();
            final result = await _netClient.loginByPhone(phone: phone, code: code, no: no, pwd: pwd);
            if (result.ok) {
              onLoginSuccess();
            } else {
              logWarn([result.desc]);
              Future.delayed(delayDuration, () => loginPage());
            }
          } else {
            logWarn([sendres.desc]);
            Future.delayed(delayDuration, () => loginPage());
          }
        }),
      ],
    );
  }

  ///登录成功
  void onLoginSuccess() {
    _netClient.connect(onopen: () {
      _netClient.userEnter().then((value) {
        if (value.ok) {
          // navigationTo(from: loginPage, to: homePage);
          _pageRouteStack.clear(); //清空路由栈
          homePage();
        }
      });
    });
  }

  void homePage() {
    renderPage('首页', [
      MenuItem('会话模块', () {
        navigationTo(from: homePage, to: sessionsPage);
      }),
      MenuItem('好友模块', () {
        navigationTo(from: homePage, to: usershipsPage);
      }),
      MenuItem('群组模块', () {
        navigationTo(from: homePage, to: teamshipsPage);
      }),
      MenuItem('申请模块', () {
        navigationTo(from: homePage, to: waitshipsPage);
      }),
      MenuItem('我的信息', () {
        navigationTo(from: homePage, to: infomationPage);
      }),
    ]);
  }

  void sessionsPage() {
    renderPage('首页->会话模块', [
      MenuItem('发送文本消息给好友', () async {
        logInfo(['发送文本消息给好友请输入会话id:']);
        final sid = (await readStdinLine()).trim();
        logInfo(['发送文本消息给好友请输入消息内容:']);
        final body = (await readStdinLine()).trim();
        final result = await _netClient.messageSendText(sid: DbQueryField.hexstr2ObjectId(sid), from: Constant.msgFromUser, body: body);
        if (result.ok) {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => sessionsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => sessionsPage());
        }
      }),
      MenuItem('发送文本消息到群组', () async {
        logInfo(['发送文本消息到群组请输入会话id:']);
        final sid = (await readStdinLine()).trim();
        logInfo(['发送文本消息到群组请输入消息内容:']);
        final body = (await readStdinLine()).trim();
        final result = await _netClient.messageSendText(sid: DbQueryField.hexstr2ObjectId(sid), from: Constant.msgFromTeam, body: body);
        if (result.ok) {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => sessionsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => sessionsPage());
        }
      }),
      MenuItem('加载会话消息列表', () async {
        logInfo(['加载会话消息列表请输入会话序号:']);
        final no = (await readStdinLine()).trim();
        logInfo(['加载会话消息列表请输入是否重置 (true, false):']);
        final reload = (await readStdinLine()).trim();
        final ship = _netClient.sessionState.okList[int.parse(no)];
        if (ship is UserShip) {
          _netClient.messageLoad(session: _netClient.createSession(usership: ship), reload: reload == 'true');
          _netClient.messageLoad(session: _netClient.createSession(usership: ship), reload: reload == 'true');
          _netClient.messageLoad(session: _netClient.createSession(usership: ship), reload: reload == 'true');
          _netClient.messageLoad(session: _netClient.createSession(usership: ship), reload: reload == 'true');
          final result = await _netClient.messageLoad(session: _netClient.createSession(usership: ship), reload: reload == 'true');
          if (result.ok) {
            for (var message in ship.msgcache) {
              logDebug(['sender(${message.displayNick})', message.body, ComTools.formatDateTime(message.time, yyMMdd: true, hhmmss: true)]);
            }
            Future.delayed(delayDuration, () => sessionsPage());
          } else {
            logWarn([result.desc]);
            Future.delayed(delayDuration, () => sessionsPage());
          }
        } else if (ship is TeamShip) {
          _netClient.messageLoad(session: _netClient.createSession(teamship: ship), reload: reload == 'true');
          _netClient.messageLoad(session: _netClient.createSession(teamship: ship), reload: reload == 'true');
          _netClient.messageLoad(session: _netClient.createSession(teamship: ship), reload: reload == 'true');
          _netClient.messageLoad(session: _netClient.createSession(teamship: ship), reload: reload == 'true');
          final result = await _netClient.messageLoad(session: _netClient.createSession(teamship: ship), reload: reload == 'true');
          if (result.ok) {
            for (var message in ship.msgcache) {
              logDebug(['sender(${message.displayNick})', message.body, ComTools.formatDateTime(message.time, yyMMdd: true, hhmmss: true)]);
            }
            Future.delayed(delayDuration, () => sessionsPage());
          } else {
            logWarn([result.desc]);
            Future.delayed(delayDuration, () => sessionsPage());
          }
        }
      }),
      MenuItem('打印会话列表', () {
        final okList = _netClient.sessionState.okList;
        final unread = _netClient.sessionState.unread;
        logDebug(['共$unread条未读消息:']);
        int no = 0;
        for (var element in okList) {
          if (element is UserShip) {
            logDebug([
              no++,
              'uid(${element.rid.toHexString()})',
              'sid(${element.sid.toHexString()})',
              'nick(${element.displayNick})',
              'unread(${element.unread})',
              'recent(${element.recent})',
              'top(${element.top})',
              ComTools.formatDateTime(
                element.update,
                yyMMdd: true,
                hhmmss: true,
              )
            ]);
          } else if (element is TeamShip) {
            logDebug([
              no++,
              'tid(${element.rid.toHexString()})',
              'sid(${element.sid.toHexString()})',
              'nick(${element.displayNick})',
              'unread(${element.unread})',
              'recent(${element.recent})',
              'top(${element.top})',
              ComTools.formatDateTime(
                element.update,
                yyMMdd: true,
                hhmmss: true,
              )
            ]);
          }
        }
        Future.delayed(delayDuration, () => sessionsPage());
      }),
    ]);
  }

  void usershipsPage() {
    renderPage('首页->好友模块', [
      MenuItem('批量拉取用户', () async {
        logInfo(['批量拉取用户请输入用户id（多个id用","隔开）:']);
        final uids = (await readStdinLine()).trim();
        final result = await _netClient.userFetch(uids: uids.split(',').map((e) => DbQueryField.hexstr2ObjectId(e)).toList());
        if (result.ok) {
          logDebug(['共${result.extra?.length ?? 0}条用户信息拉取结果:']);
          result.extra?.forEach((element) => logDebug([element]));
          Future.delayed(delayDuration, () => usershipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => usershipsPage());
        }
      }),
      MenuItem('搜索用户信息', () async {
        logInfo(['搜索用户信息请输入关键词（账号、手机号）:']);
        final keywords = (await readStdinLine()).trim();
        final result = await _netClient.userSearch(keywords: keywords);
        if (result.ok) {
          logDebug(['共${result.extra?.length ?? 0}条用户信息搜索结果:']);
          result.extra?.forEach((element) => logDebug([element]));
          Future.delayed(delayDuration, () => usershipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => usershipsPage());
        }
      }),
      MenuItem('搜索好友关系', () async {
        logInfo(['搜索好友关系请输入用户id:']);
        final uid = (await readStdinLine()).trim();
        final result = await _netClient.userShipQuery(uid: DbQueryField.hexstr2ObjectId(uid), from: Constant.shipFromSearch);
        if (result.ok) {
          logDebug(['好友关系搜索结果:']);
          logDebug([result.extra, readConstMap(result.extra!.state)]);
          Future.delayed(delayDuration, () => usershipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => usershipsPage());
        }
      }),
      MenuItem('发起好友申请', () async {
        logInfo(['发起好友申请请输入用户id:']);
        final uid = (await readStdinLine()).trim();
        logInfo(['发起好友申请请输入申请描述:']);
        final apply = (await readStdinLine()).trim();
        final result = await _netClient.userShipApply(uid: DbQueryField.hexstr2ObjectId(uid), from: Constant.shipFromSearch, apply: apply);
        if (result.ok) {
          logDebug([result.desc]);
          Future.delayed(delayDuration, () => usershipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => usershipsPage());
        }
      }),
      MenuItem('解除好友关系', () async {
        logInfo(['解除好友关系请输入用户id:']);
        final uid = (await readStdinLine()).trim();
        final result = await _netClient.userShipNone(uid: DbQueryField.hexstr2ObjectId(uid));
        if (result.ok) {
          logDebug([result.desc]);
          Future.delayed(delayDuration, () => usershipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => usershipsPage());
        }
      }),
      MenuItem('修改好友备注名', () async {
        logInfo(['修改好友备注名请输入关系id:']);
        final id = (await readStdinLine()).trim();
        logInfo(['修改好友备注名请输入新昵称:']);
        final alias = (await readStdinLine()).trim();
        final dirty = UserShipDirty()..alias = alias;
        final result = await _netClient.userShipUpdate(id: DbQueryField.hexstr2ObjectId(id), fields: dirty.data);
        if (result.ok) {
          logDebug([result.desc]);
          Future.delayed(delayDuration, () => usershipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => usershipsPage());
        }
      }),
      MenuItem('打印好友列表', () {
        final azList = _netClient.usershipState.azList;
        logDebug(['共${azList.last}个好友信息:']);
        for (var element in azList) {
          if (element is UserShip) {
            logDebug([
              'id(${element.id.toHexString()})',
              'uid(${element.rid.toHexString()})',
              element.displayNick,
              readConstMap(element.state),
              ComTools.formatDateTime(
                element.time,
                yyMMdd: true,
                hhmmss: true,
              )
            ]);
          } else {
            logDebug([element]);
          }
        }
        Future.delayed(delayDuration, () => usershipsPage());
      }),
    ]);
  }

  void teamshipsPage() {
    renderPage('首页->群组模块', [
      MenuItem('批量拉取群组', () async {
        logInfo(['批量拉取群组请输入群组id（多个id用","隔开）:']);
        final tids = (await readStdinLine()).trim();
        final result = await _netClient.teamFetch(tids: tids.split(',').map((e) => DbQueryField.hexstr2ObjectId(e)).toList());
        if (result.ok) {
          logDebug(['共${result.extra?.length ?? 0}条群组信息拉取结果:']);
          result.extra?.forEach((element) => logDebug([element]));
          Future.delayed(delayDuration, () => teamshipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        }
      }),
      MenuItem('搜索群组信息', () async {
        logInfo(['搜索群组信息请输入关键词（账号、名称）:']);
        final keywords = (await readStdinLine()).trim();
        final result = await _netClient.teamSearch(keywords: keywords);
        if (result.ok) {
          logDebug(['共${result.extra?.length ?? 0}条群组信息搜索结果:']);
          result.extra?.forEach((element) => logDebug([element]));
          Future.delayed(delayDuration, () => teamshipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        }
      }),
      MenuItem('搜索群组关系', () async {
        logInfo(['搜索群组关系请输入群组id:']);
        final tid = (await readStdinLine()).trim();
        final result = await _netClient.teamShipQuery(tid: DbQueryField.hexstr2ObjectId(tid), from: Constant.shipFromSearch);
        if (result.ok) {
          logDebug(['群组关系搜索结果:']);
          logDebug([result.extra, readConstMap(result.extra!.state)]);
          Future.delayed(delayDuration, () => teamshipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        }
      }),
      MenuItem('创建新的群组', () async {
        logInfo(['创建新的群组请输入用户id（多个id用","隔开）:']);
        final uids = (await readStdinLine()).trim();
        final result = await _netClient.teamCreate(uids: uids.split(',').map((e) => DbQueryField.hexstr2ObjectId(e)).toList());
        if (result.ok) {
          logDebug([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        }
      }),
      MenuItem('主动加入群组', () async {
        logInfo(['主动加入群组请输入群组id:']);
        final tid = (await readStdinLine()).trim();
        logInfo(['主动加入群组请输入加入描述:']);
        final apply = (await readStdinLine()).trim();
        final result = await _netClient.teamShipApply(tid: DbQueryField.hexstr2ObjectId(tid), from: Constant.shipFromSearch, apply: apply);
        if (result.ok) {
          logDebug([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        }
      }),
      MenuItem('获取群组成员', () async {
        logInfo(['获取群组成员请输入群组id:']);
        final tid = (await readStdinLine()).trim();
        final result = await _netClient.teamMember(tid: DbQueryField.hexstr2ObjectId(tid));
        if (result.ok) {
          final azList = _netClient.getTeamuserState(DbQueryField.hexstr2ObjectId(tid)).azList;
          logDebug(['共${azList.last}个群组成员:']);
          for (var element in azList) {
            if (element is TeamShip) {
              logDebug([
                'id(${element.id.toHexString()})',
                'uid(${element.uid.toHexString()})',
                element.displayNick,
                readConstMap(element.state),
                element.apply,
                ComTools.formatDateTime(
                  element.time,
                  yyMMdd: true,
                  hhmmss: true,
                )
              ]);
            } else {
              logDebug([element]);
            }
          }
          Future.delayed(delayDuration, () => teamshipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        }
      }),
      MenuItem('解除群组关系', () async {
        logInfo(['解除群组关系请输入群组id:']);
        final tid = (await readStdinLine()).trim();
        logInfo(['解除群组关系请输入用户id:']);
        final uid = (await readStdinLine()).trim();
        final result = await _netClient.teamShipNone(tid: DbQueryField.hexstr2ObjectId(tid), uid: DbQueryField.hexstr2ObjectId(uid));
        if (result.ok) {
          logDebug([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        }
      }),
      MenuItem('拉人进入群组', () async {
        logInfo(['拉人进入群组请输入群组id:']);
        final tid = (await readStdinLine()).trim();
        logInfo(['拉人进入群组请输入用户id（多个id用","隔开）:']);
        final uids = (await readStdinLine()).trim();
        final result = await _netClient.teamShipPass(tid: DbQueryField.hexstr2ObjectId(tid), uids: uids.split(',').map((e) => DbQueryField.hexstr2ObjectId(e)).toList());
        if (result.ok) {
          logDebug([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        }
      }),
      MenuItem('修改群组名称', () async {
        logInfo(['修改群组名称请输入群组id:']);
        final tid = (await readStdinLine()).trim();
        logInfo(['修改群组名称请输入新昵称:']);
        final nick = (await readStdinLine()).trim();
        final dirty = TeamDirty()..nick = nick;
        final result = await _netClient.teamUpdate(tid: DbQueryField.hexstr2ObjectId(tid), fields: dirty.data);
        if (result.ok) {
          logDebug([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        }
      }),
      MenuItem('修改我的群昵称', () async {
        logInfo(['修改我的群昵称请输入关系id:']);
        final id = (await readStdinLine()).trim();
        logInfo(['修改我的群昵称请输入新昵称:']);
        final alias = (await readStdinLine()).trim();
        final dirty = TeamShipDirty()..alias = alias;
        final result = await _netClient.teamShipUpdate(id: DbQueryField.hexstr2ObjectId(id), fields: dirty.data);
        if (result.ok) {
          logDebug([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => teamshipsPage());
        }
      }),
      MenuItem('打印群组列表', () {
        final azList = _netClient.teamshipState.azList;
        logDebug(['共${azList.last}个群组信息:']);
        for (var element in azList) {
          if (element is TeamShip) {
            logDebug([
              'id(${element.id.toHexString()})',
              'tid(${element.rid.toHexString()})',
              element.displayNick,
              readConstMap(element.state),
              element.apply,
              ComTools.formatDateTime(
                element.time,
                yyMMdd: true,
                hhmmss: true,
              )
            ]);
          } else {
            logDebug([element]);
          }
        }
        Future.delayed(delayDuration, () => teamshipsPage());
      }),
    ]);
  }

  void waitshipsPage() {
    renderPage('首页->申请模块', [
      MenuItem('拒绝好友申请', () async {
        logInfo(['拒绝好友申请请输入用户id:']);
        final uid = (await readStdinLine()).trim();
        final result = await _netClient.userShipNone(uid: DbQueryField.hexstr2ObjectId(uid));
        if (result.ok) {
          logDebug([result.desc]);
          Future.delayed(delayDuration, () => waitshipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => waitshipsPage());
        }
      }),
      MenuItem('同意好友申请', () async {
        logInfo(['同意好友申请请输入用户id:']);
        final uid = (await readStdinLine()).trim();
        final result = await _netClient.userShipPass(uid: DbQueryField.hexstr2ObjectId(uid));
        if (result.ok) {
          logDebug([result.desc]);
          Future.delayed(delayDuration, () => waitshipsPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => waitshipsPage());
        }
      }),
      MenuItem('打印申请列表', () {
        final okList = _netClient.waitshipState.okList;
        final unread = _netClient.waitshipState.unread;
        logDebug(['共$unread条好友申请信息:']);
        for (var element in okList) {
          if (element is UserShip) {
            logDebug(['uid(${element.uid.toHexString()})', element.displayNick, readConstMap(element.state), element.apply, ComTools.formatDateTime(element.time, yyMMdd: true, hhmmss: true)]);
          } else {
            logDebug([element]);
          }
        }
        Future.delayed(delayDuration, () => waitshipsPage());
      }),
    ]);
  }

  void infomationPage() {
    renderPage('首页->我的信息', [
      MenuItem('修改我的昵称', () async {
        logInfo(['修改我的昵称请输入新昵称:']);
        final nick = (await readStdinLine()).trim();
        final dirty = UserDirty()..nick = nick;
        final result = await _netClient.userUpdate(uid: _netClient.user.id, fields: dirty.data);
        if (result.ok) {
          logDebug([result.desc]);
          Future.delayed(delayDuration, () => infomationPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => infomationPage());
        }
      }),
      MenuItem('批量上传图片', () async {
        logInfo(['图片上传中...']);
        final filepath = '${Directory.current.path}/example/icon.png';
        final result = await _netClient.attachUpload(
          type: Constant.metaTypeForever,
          fileBytes: [
            File(filepath).readAsBytesSync(),
            File(filepath).readAsBytesSync(),
            File(filepath).readAsBytesSync(),
          ],
          mediaType: MediaType.parse('image/png'),
        );
        if (result.ok) {
          logDebug([result.extra]);
          Future.delayed(delayDuration, () => infomationPage());
        } else {
          logWarn([result.desc]);
          Future.delayed(delayDuration, () => infomationPage());
        }
      }),
      MenuItem('打印我的信息', () {
        logDebug(['我的信息: ']);
        logDebug([_netClient.user]);
        Future.delayed(delayDuration, () => infomationPage());
      }),
    ]);
  }
  /* **************** 工具函数 **************** */

  ///渲染页面
  void renderPage(String title, List<MenuItem> menuItems) async {
    if (autoClear) clearConsole();
    //打印标题
    logInfo(['---------------- ${ComTools.formatUserNick(_netClient.user)} $title ----------------\n']);
    logInfo(['r、刷新页面   b、返回上级   q、退出程序\n']);
    //打印菜单
    final cmdMap = <String, MenuItem>{};
    for (var i = 0; i < menuItems.length; i++) {
      logInfo(['$i、${menuItems[i].title}']);
      cmdMap['$i'] = menuItems[i];
    }
    print('');
    //等待输入
    logInfo(['请输入命令选项:']);
    final key = (await readStdinLine()).trim();
    //处理输入
    if (key == 'r') {
      clearConsole();
      renderPage(title, menuItems);
    } else if (key == 'b') {
      if (_pageRouteStack.isEmpty) {
        logDebug(['程序已完成']);
        Future.delayed(delayDuration, () => exit(0));
      } else {
        _pageRouteStack.removeLast()();
      }
    } else if (key == 'q') {
      logDebug(['程序已完成']);
      Future.delayed(delayDuration, () => exit(0));
    } else {
      if (!cmdMap.containsKey(key)) {
        logWarn(['没有这个选项!']);
        Future.delayed(delayDuration, () => renderPage(title, menuItems));
      } else {
        cmdMap[key]!.execute();
      }
    }
  }

  ///从[stdin]中异步读取数据，避免阻塞进程
  Future<String> readStdinLine() async {
    final lineCompleter = Completer<String>();
    final listener = _stdinLineStreamBroadcaster.listen((line) {
      if (!lineCompleter.isCompleted) {
        lineCompleter.complete(line);
      }
    });
    return lineCompleter.future.then((line) {
      listener.cancel();
      return line;
    });
  }

  ///清空整个控制台，将光标移动到0;0
  void clearConsole() => print("\x1B[2J\x1B[0;0H");

  ///常量读取
  String readConstMap(int key) => Constant.constMap['zh']![key]!;
}

class MenuItem {
  ///菜单项名成
  final String title;

  ///菜单项执行函数
  final Function execute;

  MenuItem(this.title, this.execute);
}
