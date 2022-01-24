import 'package:lpinyin/lpinyin.dart';
import 'package:shelf_easy/shelf_easy.dart';

import 'model/constant.dart';
import 'model/location.dart';
import 'model/message.dart';
import 'model/metadata.dart';
import 'model/team.dart';
import 'model/teamship.dart';
import 'model/user.dart';
import 'model/usership.dart';
import 'tool/comtools.dart';

class NetClient {
  ///日志输出级别
  final EasyLogLevel logLevel;

  ///服务器地址，格式：http://hostname:port
  final String host;

  ///商户唯一标志
  final String bsid;

  ///商户通讯密钥
  final String secret;

  ///是否用二进制收发数据，需要与服务端保持一致
  final bool binary;

  ///登录凭据回调
  final void Function(String nick, String? credentials) onCredentials;

  ///当前用户信息
  final User user;

  ///激活会话状态
  final NetClientAzState _sessionState;

  ///好友申请状态
  final NetClientAzState _waitshipState;

  ///好友关系状态
  final NetClientAzState _usershipState;

  ///群组关系状态
  final NetClientAzState _teamshipState;

  ///群组成员状态，key为群组id
  final Map<String, NetClientAzState> _teamuserStateMap;

  ///用户信息，key为用户id
  final Map<String, User> _userMap;

  ///群组信息，key为群组id
  final Map<String, Team> _teamMap;

  ///好友申请，key为用户id
  final Map<String, UserShip> _waitships;

  ///好友关系，key为用户id
  final Map<String, UserShip> _userships;

  ///群组关系，key为群组id
  final Map<String, TeamShip> _teamships;

  ///群组成员，key为群组id，子级key为用户id
  final Map<String, Map<String, TeamShip>> _teamusersMap;

  ///未登录web客户端
  final EasyClient _guestClient;

  ///已登录wss客户端
  EasyClient _aliveClient;

  ///标记[_sessionState]是否需要重新构建
  bool _dirtySessionState;

  ///标记[_waitshipState]是否需要重新构建
  bool _dirtyWaitshipState;

  ///标记[_usershipState]是否需要重新构建
  bool _dirtyUsershipState;

  ///标记[_teamshipState]是否需要重新构建
  bool _dirtyTeamshipState;

  ///标记[_teamuserStateMap]是否需要重新构建，key为群组id
  final Map<String, bool> _dirtyTeamuserStateMap;

  NetClient({this.logLevel = EasyLogLevel.debug, required this.host, required this.bsid, required this.secret, this.binary = true, required this.onCredentials})
      : user = User(id: DbQueryField.hexstr2ObjectId('000000000000000000000000')),
        _sessionState = NetClientAzState(),
        _waitshipState = NetClientAzState(),
        _usershipState = NetClientAzState(),
        _teamshipState = NetClientAzState(),
        _teamuserStateMap = {},
        _userMap = {},
        _teamMap = {},
        _waitships = {},
        _userships = {},
        _teamships = {},
        _teamusersMap = {},
        _guestClient = EasyClient(config: EasyClientConfig(logLevel: logLevel, url: host, binary: binary))..bindUser(bsid, token: secret),
        _aliveClient = EasyClient(config: EasyClientConfig(logLevel: logLevel, url: host, binary: binary)),
        _dirtySessionState = true,
        _dirtyWaitshipState = true,
        _dirtyUsershipState = true,
        _dirtyTeamshipState = true,
        _dirtyTeamuserStateMap = {};

  /* **************** http请求 **************** */

  ///使用[User.id]和[User.token]进行登录
  Future<EasyPacket<void>> loginByToken({required ObjectId uid, required String token}) async {
    final response = await _guestClient.httpRequest('$host/loginByToken', data: {'bsid': bsid, 'uid': uid, 'token': token});
    if (response.ok) {
      user.updateFields(response.data!['user']);
      _resetAliveClient(response.data!['url'], response.data!['pwd']);
      onCredentials(ComTools.formatUserNick(user), encryptCredentials(user, secret));
    } else if (response.code == 401) {
      onCredentials(ComTools.formatUserNick(user), null);
    }
    return response;
  }

  ///使用[User.no]和[User.pwd]进行登录
  Future<EasyPacket<void>> loginByNoPwd({required String no, required String pwd}) async {
    final response = await _guestClient.httpRequest('$host/loginByNoPwd', data: {'bsid': bsid, 'no': no, 'pwd': pwd});
    if (response.ok) {
      user.updateFields(response.data!['user']);
      _resetAliveClient(response.data!['url'], response.data!['pwd']);
      onCredentials(ComTools.formatUserNick(user), encryptCredentials(user, secret));
    } else if (response.code == 401) {
      onCredentials(ComTools.formatUserNick(user), null);
    }
    return response;
  }

  ///使用[phone]和验证码[code]进行登录。分为三种场景：
  /// * 新账号注册：当[no]非null且[pwd]非null时，服务端会对[phone]与[no]的重复注册情况进行验证，然后注册新账号并登录。
  /// * 忘记了密码：当[no]为null但[pwd]非null时，服务端会对[phone]对应的账号的进行密码重置，然后登录。
  /// * 手机号登录：不满足上面两种情况时，直接使用[phone]对应的账号的进行登录，如果不存在[phone]对应的账号则创建一个新账号之后再登录。
  Future<EasyPacket<void>> loginByPhone({required String phone, required String code, String? no, String? pwd}) async {
    final response = await _guestClient.httpRequest('$host/loginByPhone', data: {'bsid': bsid, 'phone': phone, 'code': code, 'no': no, 'pwd': pwd});
    if (response.ok) {
      user.updateFields(response.data!['user']);
      _resetAliveClient(response.data!['url'], response.data!['pwd']);
      onCredentials(ComTools.formatUserNick(user), encryptCredentials(user, secret));
    } else if (response.code == 401) {
      onCredentials(ComTools.formatUserNick(user), null);
    }
    return response;
  }

  ///发送验证码到[phone]
  Future<EasyPacket<void>> sendRandcode({required String phone}) async {
    final response = await _guestClient.httpRequest('$host/sendRandcode', data: {'bsid': bsid, 'phone': phone});
    return response;
  }

  ///文件上传，[type]为[Constant.metaTypeMessage]或[Constant.metaTypeForever]
  Future<EasyPacket<List<Metadata>>> attachUpload({required int type, required List<List<int>> fileBytes, required MediaType mediaType}) async {
    final response = await _aliveClient.httpRequest('$host/attachUpload', data: {'bsid': bsid, 'uid': user.id, 'type': type}, fileBytes: fileBytes, mediaType: mediaType);
    if (response.ok) {
      final metaList = response.data!['metaList'] as List;
      return response.cloneExtra(metaList.map((e) => Metadata.fromJson(e)).toList());
    } else {
      return response.cloneExtra(null);
    }
  }

  /* **************** websocket请求 **************** */

  ///登录后连接到服务器，请确保在登录之后再调用这个方法
  void connect({void Function()? onopen, void Function(int code, String reason)? onclose, void Function(String error)? onerror, void Function(int count)? onretry, void Function(int second, int delay)? onheart}) {
    _aliveClient.connect(
      onopen: onopen,
      onclose: (code, reason) {
        _aliveClient.unbindUser(); //立即解绑口令信息
        if (onclose != null) onclose(code, reason);
      },
      onerror: onerror,
      onretry: onretry,
      onheart: onheart,
    );
  }

  ///websocket长连接登入
  Future<EasyPacket<void>> userEnter() async {
    final mill = DateTime.now().millisecondsSinceEpoch;
    final sign = ComTools.generateUserEnterSign(secret, user.token, user.id.toHexString(), mill);
    final response = await _aliveClient.websocketRequest('userEnter', data: {'bsid': bsid, 'uid': user.id, 'mill': mill, 'sign': sign});
    if (response.ok) {
      //更新用户缓存
      user.updateFields(response.data!['user']);
      _aliveClient.bindUser(user.id.toHexString(), token: user.token); //立即绑定口令信息
      onCredentials(ComTools.formatUserNick(user), encryptCredentials(user, secret));
      //更新其他缓存
      final waitshipsKeys = <String>{};
      final usershipsKeys = <String>{};
      final teamshipsKeys = <String>{};
      _cacheUserShipList(response.data!['waitships'], saveKeys: waitshipsKeys);
      _cacheUserShipList(response.data!['userships'], saveKeys: usershipsKeys);
      _cacheTeamShipList(response.data!['teamships'], saveKeys: teamshipsKeys);
      _cacheUserList(response.data!['userList']);
      _cacheTeamList(response.data!['teamList']);
      //清除废弃数据
      _waitships.removeWhere((key, value) => !waitshipsKeys.contains(key));
      _userships.removeWhere((key, value) => !usershipsKeys.contains(key));
      _teamships.removeWhere((key, value) => !teamshipsKeys.contains(key));
      //清除废弃数据-群组成员相关
      _teamuserStateMap.removeWhere((key, value) => !teamshipsKeys.contains(key));
      _teamusersMap.removeWhere((key, value) => !teamshipsKeys.contains(key));
      _dirtyTeamuserStateMap.removeWhere((key, value) => !teamshipsKeys.contains(key));
    } else if (response.code == 401) {
      onCredentials(ComTools.formatUserNick(user), null);
    }
    return response;
  }

  ///websocket长连接登出
  Future<EasyPacket<void>> userLeave() async {
    final response = await _aliveClient.websocketRequest('userLeave', data: {'bsid': bsid});
    if (response.ok) {
      _aliveClient.unbindUser();
    }
    return response;
  }

  ///批量获取用户
  Future<EasyPacket<List<User>>> userFetch({required List<ObjectId> uids}) async {
    final response = await _aliveClient.websocketRequest('userFetch', data: {'bsid': bsid, 'uids': uids});
    if (response.ok) {
      return response.cloneExtra(_cacheUserList(response.data!['userList']));
    } else {
      return response.cloneExtra(null);
    }
  }

  ///获取[User.no]为[keywords] 或 [User.phone]为[keywords]的用户列表
  Future<EasyPacket<List<User>>> userSearch({required String keywords}) async {
    final response = await _aliveClient.websocketRequest('userSearch', data: {'bsid': bsid, 'keywords': keywords});
    if (response.ok) {
      return response.cloneExtra(_cacheUserList(response.data!['userList']));
    } else {
      return response.cloneExtra(null);
    }
  }

  ///更新我的信息
  Future<EasyPacket<void>> userUpdate({required ObjectId uid, required Map<String, dynamic> fields, String? code, String? newcode}) async {
    final response = await _aliveClient.websocketRequest('userUpdate', data: {'bsid': bsid, 'uid': uid, 'fields': fields, 'code': code, 'newcode': newcode});
    return response;
  }

  ///查询好友关系
  Future<EasyPacket<UserShip>> userShipQuery({required ObjectId uid, ObjectId? fid, required int from}) async {
    final response = await _aliveClient.websocketRequest('userShipQuery', data: {'bsid': bsid, 'uid': uid, 'fid': fid ?? user.id, 'from': from});
    if (response.ok) {
      _cacheUser(response.data!['user']);
      return response.cloneExtra(_cacheUserShip(response.data!['ship']));
    } else {
      return response.cloneExtra(null);
    }
  }

  ///发起好友申请
  Future<EasyPacket<void>> userShipApply({required ObjectId uid, ObjectId? fid, required int from, String apply = ''}) async {
    final response = await _aliveClient.websocketRequest('userShipApply', data: {'bsid': bsid, 'uid': uid, 'fid': fid ?? user.id, 'from': from, 'apply': apply});
    return response;
  }

  ///拒绝好友申请 或 解除好友关系
  Future<EasyPacket<void>> userShipNone({required ObjectId uid}) async {
    final response = await _aliveClient.websocketRequest('userShipNone', data: {'bsid': bsid, 'uid': uid});
    return response;
  }

  ///同意好友申请
  Future<EasyPacket<void>> userShipPass({required ObjectId uid}) async {
    final response = await _aliveClient.websocketRequest('userShipPass', data: {'bsid': bsid, 'uid': uid});
    return response;
  }

  ///更新用户关系
  Future<EasyPacket<void>> userShipUpdate({required ObjectId id, required Map<String, dynamic> fields}) async {
    final response = await _aliveClient.websocketRequest('userShipUpdate', data: {'bsid': bsid, 'id': id, 'fields': fields});
    return response;
  }

  ///创建新的群组
  Future<EasyPacket<void>> teamCreate({required List<ObjectId> uids}) async {
    final response = await _aliveClient.websocketRequest('teamCreate', data: {'bsid': bsid, 'uids': uids});
    return response;
  }

  ///获取群组成员
  Future<EasyPacket<List<TeamShip>>> teamMember({required ObjectId tid}) async {
    final response = await _aliveClient.websocketRequest('teamMember', data: {'bsid': bsid, 'tid': tid});
    if (response.ok) {
      _cacheUserList(response.data!['userList']);
      //更新成员缓存
      final teamKey = tid.toHexString();
      final teamusersKeys = <String>{};
      final teamshipList = _cacheTeamUserList(teamKey, response.data!['shipList'], saveKeys: teamusersKeys);
      //清除废弃数据
      _teamusersMap[teamKey]?.removeWhere((key, value) => !teamusersKeys.contains(key));
      return response.cloneExtra(teamshipList);
    } else {
      return response.cloneExtra(null);
    }
  }

  ///批量获取群组
  Future<EasyPacket<List<Team>>> teamFetch({required List<ObjectId> tids}) async {
    final response = await _aliveClient.websocketRequest('teamFetch', data: {'bsid': bsid, 'tids': tids});
    if (response.ok) {
      return response.cloneExtra(_cacheTeamList(response.data!['teamList']));
    } else {
      return response.cloneExtra(null);
    }
  }

  ///获取[Team.no]为[keywords] 或 [Team.nick]为[keywords]的群组列表
  Future<EasyPacket<List<Team>>> teamSearch({required String keywords}) async {
    final response = await _aliveClient.websocketRequest('teamSearch', data: {'bsid': bsid, 'keywords': keywords});
    if (response.ok) {
      return response.cloneExtra(_cacheTeamList(response.data!['teamList']));
    } else {
      return response.cloneExtra(null);
    }
  }

  ///更新群组信息
  Future<EasyPacket<void>> teamUpdate({required ObjectId tid, required Map<String, dynamic> fields}) async {
    final response = await _aliveClient.websocketRequest('teamUpdate', data: {'bsid': bsid, 'tid': tid, 'fields': fields});
    return response;
  }

  ///查询群组关系
  Future<EasyPacket<TeamShip>> teamShipQuery({required ObjectId tid, ObjectId? fid, required int from}) async {
    final response = await _aliveClient.websocketRequest('teamShipQuery', data: {'bsid': bsid, 'tid': tid, 'fid': fid ?? user.id, 'from': from});
    if (response.ok) {
      _cacheTeam(response.data!['team']);
      return response.cloneExtra(_cacheTeamShip(response.data!['ship']));
    } else {
      return response.cloneExtra(null);
    }
  }

  ///主动加入群组
  Future<EasyPacket<void>> teamShipApply({required ObjectId tid, ObjectId? fid, required int from, String apply = ''}) async {
    final response = await _aliveClient.websocketRequest('teamShipApply', data: {'bsid': bsid, 'tid': tid, 'fid': fid ?? user.id, 'from': from, 'apply': apply});
    return response;
  }

  ///主动退出群组 或 将成员移除群组
  Future<EasyPacket<void>> teamShipNone({required Object tid, required ObjectId uid}) async {
    final response = await _aliveClient.websocketRequest('teamShipNone', data: {'bsid': bsid, 'tid': tid, 'uid': uid});
    return response;
  }

  ///拉人进入群组
  Future<EasyPacket<void>> teamShipPass({required Object tid, required List<ObjectId> uids}) async {
    final response = await _aliveClient.websocketRequest('teamShipPass', data: {'bsid': bsid, 'tid': tid, 'uids': uids});
    return response;
  }

  ///更新群组关系
  Future<EasyPacket<void>> teamShipUpdate({required ObjectId id, required Map<String, dynamic> fields}) async {
    final response = await _aliveClient.websocketRequest('teamShipUpdate', data: {'bsid': bsid, 'id': id, 'fields': fields});
    return response;
  }

  ///发送消息-文本消息
  Future<EasyPacket<void>> messageSendText({required ObjectId sid, required int from, required String body}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeText, 'body': body});
    return response;
  }

  ///发送消息-图片消息
  Future<EasyPacket<void>> messageSendImage({required ObjectId sid, required int from, int mediaTimeE = 0, required String shareLinkUrl}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeImage, 'mediaTimeS': 0, 'mediaTimeE': mediaTimeE, 'shareLinkUrl': shareLinkUrl});
    return response;
  }

  ///发送消息-语音消息
  Future<EasyPacket<void>> messageSendVoice({required ObjectId sid, required int from, int mediaTimeE = 0, required String shareLinkUrl}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeVoice, 'mediaTimeS': 0, 'mediaTimeE': mediaTimeE, 'shareLinkUrl': shareLinkUrl});
    return response;
  }

  ///发送消息-视频消息
  Future<EasyPacket<void>> messageSendVideo({required ObjectId sid, required int from, int mediaTimeE = 0, required String shareLinkUrl}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeVideo, 'mediaTimeS': 0, 'mediaTimeE': mediaTimeE, 'shareLinkUrl': shareLinkUrl});
    return response;
  }

  ///发送消息-网页分享
  Future<EasyPacket<void>> messageSendShareHtmlPage({required ObjectId sid, required int from, required String title, required String body, required String shareIconUrl, required String shareLinkUrl}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeShareHtmlPage, 'title': title, 'body': body, 'shareIconUrl': shareIconUrl, 'shareLinkUrl': shareLinkUrl});
    return response;
  }

  ///发送消息-位置分享
  Future<EasyPacket<void>> messageSendShareLocation({required ObjectId sid, required int from, required Location location}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeShareLocation, 'location': location.toJson()});
    return response;
  }

  ///发送消息-用户名片
  Future<EasyPacket<void>> messageSendShareCardUser({required ObjectId sid, required int from, required ObjectId shareCardId, required String shareIconUrl, required List<String> shareHeadUrl}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeShareCardUser, 'shareCardId': shareCardId, 'shareIconUrl': shareIconUrl, 'shareHeadUrl': shareHeadUrl});
    return response;
  }

  ///发送消息-群组名片
  Future<EasyPacket<void>> messageSendShareCardTeam({required ObjectId sid, required int from, required ObjectId shareCardId, required String shareIconUrl, required List<String> shareHeadUrl}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeShareCardTeam, 'shareCardId': shareCardId, 'shareIconUrl': shareIconUrl, 'shareHeadUrl': shareHeadUrl});
    return response;
  }

  ///加载消息-好友消息，[reload]为true时清除缓存重新加载，[EasyPacket.extra]字段为true时表示已加载全部数据
  Future<EasyPacket<bool>> messageLoadForUserShip({required UserShip ship, bool reload = false}) async {
    if (reload) ship.msgcache.clear(); //清除缓存
    final last = ship.msgcache.isEmpty ? 3742732800000 : ship.msgcache.last.time; //2088-08-08 00:00:00 毫秒值 3742732800000
    final nin = <ObjectId>[]; //排除重复
    for (int i = ship.msgcache.length - 1; i >= 0; i--) {
      final item = ship.msgcache[i];
      if (item.time != last) break;
      nin.add(item.id);
    }
    ship.msgasync = DateTime.now().microsecondsSinceEpoch; //设置最近一次异步加载的识别号（防止并发加载导致数据混乱）
    final response = await _aliveClient.websocketRequest('messageLoad', data: {'bsid': bsid, 'sid': ship.sid, 'from': Constant.msgFromUser, 'last': last, 'nin': nin, 'msgasync': ship.msgasync});
    if (response.ok) {
      final msgasync = response.data!['msgasync'] as int;
      final msgcache = response.data!['msgcache'] as List;
      if (msgasync == ship.msgasync) {
        for (var data in msgcache) {
          ship.msgcache.add(Message.fromJson(data));
        }
        return response.cloneExtra(msgcache.isEmpty); //是否已加载全部数据
      } else {
        _aliveClient.logError(['messageLoad =>', '远程响应号已过期 $msgasync']);
        return response.requestTimeoutError().cloneExtra(null); //说明本次响应不是最近一次异步加载，直接遗弃数据，当成超时错误处理
      }
    } else {
      return response.cloneExtra(null);
    }
  }

  ///加载消息-群组消息，[reload]为true时清除缓存重新加载，[EasyPacket.extra]字段为true时表示已加载全部数据
  Future<EasyPacket<bool>> messageLoadForTeamShip({required TeamShip ship, bool reload = false}) async {
    if (reload) ship.msgcache.clear(); //清除缓存
    final last = ship.msgcache.isEmpty ? 3742732800000 : ship.msgcache.last.time; //2088-08-08 00:00:00 毫秒值 3742732800000
    final nin = <ObjectId>[]; //排除重复
    for (int i = ship.msgcache.length - 1; i >= 0; i--) {
      final item = ship.msgcache[i];
      if (item.time != last) break;
      nin.add(item.id);
    }
    ship.msgasync = DateTime.now().microsecondsSinceEpoch; //设置最近一次异步加载的识别号（防止并发加载导致数据混乱）
    final response = await _aliveClient.websocketRequest('messageLoad', data: {'bsid': bsid, 'sid': ship.sid, 'from': Constant.msgFromTeam, 'last': last, 'nin': nin, 'msgasync': ship.msgasync});
    if (response.ok) {
      final msgasync = response.data!['msgasync'] as int;
      final msgcache = response.data!['msgcache'] as List;
      if (msgasync == ship.msgasync) {
        for (var data in msgcache) {
          ship.msgcache.add(Message.fromJson(data));
        }
        return response.cloneExtra(msgcache.isEmpty); //是否已加载全部数据
      } else {
        _aliveClient.logError(['messageLoad =>', '远程响应号已过期 $msgasync']);
        return response.requestTimeoutError().cloneExtra(null); //说明本次响应不是最近一次异步加载，直接遗弃数据，当成超时错误处理
      }
    } else {
      return response.cloneExtra(null);
    }
  }

  /* **************** 工具方法 **************** */

  ///读取用户
  User getUser(ObjectId uid) {
    var item = _userMap[uid.toHexString()];
    if (item == null) {
      //创建一个临时用户实例
      item = User(bsid: DbQueryField.hexstr2ObjectId(bsid), id: uid);
      //获取未缓存的用户信息
      userFetch(uids: [uid]).then((result) {
        if (result.ok) _aliveClient.triggerEvent(EasyPacket.pushdata(route: 'userFetchedEvent', data: result.data));
      });
    }
    return item;
  }

  ///读取群组
  Team getTeam(ObjectId tid) {
    var item = _teamMap[tid.toHexString()];
    if (item == null) {
      //创建一个临时群组实例
      item = Team(bsid: DbQueryField.hexstr2ObjectId(bsid), id: tid);
      //获取未缓存的群组信息
      teamFetch(tids: [tid]).then((result) {
        if (result.ok) _aliveClient.triggerEvent(EasyPacket.pushdata(route: 'teamFetchedEvent', data: result.data));
      });
    }
    return item;
  }

  ///读取激活会话状态
  NetClientAzState get sessionState {
    if (_dirtySessionState) {
      //构建列表
      final okList = <Object>[];
      int unread = 0;
      _userships.forEach((key, value) {
        if (value.dialog) {
          okList.add(value);
          unread += value.unread;
        }
      });
      _teamships.forEach((key, value) {
        if (value.dialog) {
          okList.add(value);
          unread += value.unread;
        }
      });
      //按最近消息时间降序排列（注意使用的是动态类型）
      okList.sort((dynamic a, dynamic b) {
        if (a.top && !b.top) {
          return -1;
        } else if (!a.top && b.top) {
          return 1;
        } else {
          return a.update > b.update ? -1 : 1;
        }
      });
      //更新状态
      _sessionState.update(okList: okList, unread: unread);
      _dirtySessionState = false;
    }
    return _sessionState;
  }

  ///读取好友申请状态
  NetClientAzState get waitshipState {
    if (_dirtyWaitshipState) {
      //构建列表
      final okList = <UserShip>[];
      _waitships.forEach((key, value) => okList.add(value));
      //按发起申请时间降序排列
      okList.sort((a, b) => a.time > b.time ? -1 : 1);
      //更新状态
      _waitshipState.update(okList: okList, unread: okList.length);
      _dirtyWaitshipState = false;
    }
    return _waitshipState;
  }

  ///读取好友关系状态
  NetClientAzState get usershipState {
    if (_dirtyUsershipState) {
      //构建列表
      final azList = <Object>[...NetClientAzState.letters];
      _userships.forEach((key, value) => azList.add(value));
      //字母列表排序
      azList.sort((a, b) {
        String pyA = a is UserShip ? PinyinHelper.getPinyinE(ComTools.formatUserShipNick(a, getUser(a.rid)), separator: '', defPinyin: '#', format: PinyinFormat.WITHOUT_TONE).toUpperCase() : (a as String);
        String pyB = b is UserShip ? PinyinHelper.getPinyinE(ComTools.formatUserShipNick(b, getUser(b.rid)), separator: '', defPinyin: '#', format: PinyinFormat.WITHOUT_TONE).toUpperCase() : (b as String);
        if (pyA.isEmpty || !NetClientAzState.letters.contains(pyA[0])) pyA = '#' + pyA;
        if (pyB.isEmpty || !NetClientAzState.letters.contains(pyB[0])) pyB = '#' + pyB;
        if (pyA.startsWith('#') && !pyB.startsWith('#')) {
          return 1;
        } else if (!pyA.startsWith('#') && pyB.startsWith('#')) {
          return -1;
        } else {
          return Comparable.compare(pyA, pyB);
        }
      });
      //生成字母索引
      final azMap = <String, int>{};
      for (int i = 0; i < azList.length;) {
        final item = azList[i];
        if (item is String) {
          if (i == azList.length - 1) {
            azList.removeAt(i); //此字母分组无内容，索引i无需自增
          } else {
            final nextItem = azList[i + 1];
            if (nextItem is String) {
              azList.removeAt(i); //此字母分组无内容，索引i无需自增
            } else {
              azMap[item] = i;
              i++;
            }
          }
        } else {
          i++;
        }
      }
      //最后插入数量
      azList.add(_userships.length);
      //更新状态
      _usershipState.update(azMap: azMap, azList: azList);
      _dirtyUsershipState = false;
    }
    return _usershipState;
  }

  ///读取群组关系状态
  NetClientAzState get teamshipState {
    if (_dirtyTeamshipState) {
      //构建列表
      final azList = <Object>[...NetClientAzState.letters];
      _teamships.forEach((key, value) => azList.add(value));
      //字母列表排序
      azList.sort((a, b) {
        String pyA = a is TeamShip ? PinyinHelper.getPinyinE(ComTools.formatTeamNick(getTeam(a.rid)), separator: '', defPinyin: '#', format: PinyinFormat.WITHOUT_TONE).toUpperCase() : (a as String);
        String pyB = b is TeamShip ? PinyinHelper.getPinyinE(ComTools.formatTeamNick(getTeam(b.rid)), separator: '', defPinyin: '#', format: PinyinFormat.WITHOUT_TONE).toUpperCase() : (b as String);
        if (pyA.isEmpty || !NetClientAzState.letters.contains(pyA[0])) pyA = '#' + pyA;
        if (pyB.isEmpty || !NetClientAzState.letters.contains(pyB[0])) pyB = '#' + pyB;
        if (pyA.startsWith('#') && !pyB.startsWith('#')) {
          return 1;
        } else if (!pyA.startsWith('#') && pyB.startsWith('#')) {
          return -1;
        } else {
          return Comparable.compare(pyA, pyB);
        }
      });
      //生成字母索引
      final azMap = <String, int>{};
      for (int i = 0; i < azList.length;) {
        final item = azList[i];
        if (item is String) {
          if (i == azList.length - 1) {
            azList.removeAt(i); //此字母分组无内容，索引i无需自增
          } else {
            final nextItem = azList[i + 1];
            if (nextItem is String) {
              azList.removeAt(i); //此字母分组无内容，索引i无需自增
            } else {
              azMap[item] = i;
              i++;
            }
          }
        } else {
          i++;
        }
      }
      //最后插入数量
      azList.add(_teamships.length);
      //更新状态
      _teamshipState.update(azMap: azMap, azList: azList);
      _dirtyTeamshipState = false;
    }
    return _teamshipState;
  }

  ///读取群组成员状态
  NetClientAzState getTeamuserState(ObjectId tid) {
    final _teamKey = tid.toHexString();
    final _teamuserState = _teamuserStateMap[_teamKey];
    final _teamusers = _teamusersMap[_teamKey];
    final _dirtyTeamuserState = _dirtyTeamuserStateMap[_teamKey];
    if (_teamuserState == null || _teamusers == null || _dirtyTeamuserState == null) {
      return NetClientAzState()..update(azList: [0]); //这种情况说明没有加入这个群组
    }
    if (_dirtyTeamuserState) {
      //构建列表
      final team = getTeam(tid);
      final admins = <Object>[];
      final azList = <Object>[...NetClientAzState.letters];
      _teamusers.forEach((key, value) {
        if (ComTools.isTeamSuperAdmin(team, value.uid)) {
          admins.insert(0, value);
        } else if (ComTools.isTeamNormalAdmin(team, value.uid)) {
          admins.add(value);
        } else {
          azList.add(value);
        }
      });
      //字母列表排序
      azList.sort((a, b) {
        String pyA = a is TeamShip ? PinyinHelper.getPinyinE(ComTools.formatTeamUserNick(a, getUser(a.uid)), separator: '', defPinyin: '#', format: PinyinFormat.WITHOUT_TONE).toUpperCase() : (a as String);
        String pyB = b is TeamShip ? PinyinHelper.getPinyinE(ComTools.formatTeamUserNick(b, getUser(b.uid)), separator: '', defPinyin: '#', format: PinyinFormat.WITHOUT_TONE).toUpperCase() : (b as String);
        if (pyA.isEmpty || !NetClientAzState.letters.contains(pyA[0])) pyA = '#' + pyA;
        if (pyB.isEmpty || !NetClientAzState.letters.contains(pyB[0])) pyB = '#' + pyB;
        if (pyA.startsWith('#') && !pyB.startsWith('#')) {
          return 1;
        } else if (!pyA.startsWith('#') && pyB.startsWith('#')) {
          return -1;
        } else {
          return Comparable.compare(pyA, pyB);
        }
      });
      //生成字母索引
      final azMap = <String, int>{};
      for (int i = 0; i < azList.length;) {
        final item = azList[i];
        if (item is String) {
          if (i == azList.length - 1) {
            azList.removeAt(i); //此字母分组无内容，索引i无需自增
          } else {
            final nextItem = azList[i + 1];
            if (nextItem is String) {
              azList.removeAt(i); //此字母分组无内容，索引i无需自增
            } else {
              azMap[item] = i;
              i++;
            }
          }
        } else {
          i++;
        }
      }
      //插入管理员
      admins.insert(0, NetClientAzState.header);
      azMap.forEach((key, value) => azMap[key] = value + admins.length);
      azMap[NetClientAzState.header] = 0;
      azList.insertAll(0, admins);
      //最后插入数量
      azList.add(_teamusers.length);
      //更新状态
      _teamuserState.update(azMap: azMap, azList: azList);
      _dirtyTeamuserStateMap[_teamKey] = false;
    }
    return _teamuserState;
  }

  ///设置用户信息获取完成的监听器---此事件由本地触发
  void setUserFetchedWatcher(void Function(EasyPacket packet) ondata, {required bool remove}) {
    if (remove) {
      _aliveClient.removeListener('userFetchedEvent', ondata: ondata);
    } else {
      _aliveClient.addListener('userFetchedEvent', ondata);
    }
  }

  ///设置群组信息获取完成的监听器---此事件由本地触发
  void setTeamFetchedWatcher(void Function(EasyPacket packet) ondata, {required bool remove}) {
    if (remove) {
      _aliveClient.removeListener('teamFetchedEvent', ondata: ondata);
    } else {
      _aliveClient.addListener('teamFetchedEvent', ondata);
    }
  }

  ///设置我的信息发生变化的监听器
  void setOnUserUpdateListener(void Function(EasyPacket packet) ondata, {required bool remove}) {
    if (remove) {
      _aliveClient.removeListener('onUserUpdate', ondata: ondata);
    } else {
      _aliveClient.addListener('onUserUpdate', ondata);
    }
  }

  ///设置群组信息发生变化的监听器
  void setOnTeamUpdateListener(void Function(EasyPacket packet) ondata, {required bool remove}) {
    if (remove) {
      _aliveClient.removeListener('onTeamUpdate', ondata: ondata);
    } else {
      _aliveClient.addListener('onTeamUpdate', ondata);
    }
  }

  ///设置好友申请发生变化的监听器
  void setOnWaitShipUpdateListener(void Function(EasyPacket packet) ondata, {required bool remove}) {
    if (remove) {
      _aliveClient.removeListener('onWaitShipUpdate', ondata: ondata);
    } else {
      _aliveClient.addListener('onWaitShipUpdate', ondata);
    }
  }

  ///设置用户关系发生变化的监听器
  void setOnUserShipUpdateListener(void Function(EasyPacket packet) ondata, {required bool remove}) {
    if (remove) {
      _aliveClient.removeListener('onUserShipUpdate', ondata: ondata);
    } else {
      _aliveClient.addListener('onUserShipUpdate', ondata);
    }
  }

  ///设置群组关系发生变化的监听器
  void setOnTeamShipUpdateListener(void Function(EasyPacket packet) ondata, {required bool remove}) {
    if (remove) {
      _aliveClient.removeListener('onTeamShipUpdate', ondata: ondata);
    } else {
      _aliveClient.addListener('onTeamShipUpdate', ondata);
    }
  }

  ///设置收到新的聊天消息的监听器
  void setOnMessageSendListener(void Function(EasyPacket packet) ondata, {required bool remove}) {
    if (remove) {
      _aliveClient.removeListener('onMessageSend', ondata: ondata);
    } else {
      _aliveClient.addListener('onMessageSend', ondata);
    }
  }

  /* **************** 缓存方法 **************** */

  ///重新创建已登陆wss客户端
  void _resetAliveClient(String url, String? pwd) {
    _aliveClient.destroy(); //先销毁旧的
    _aliveClient = EasyClient(config: EasyClientConfig(logLevel: logLevel, url: url, pwd: pwd, binary: binary)); //创建新的
    _aliveClient.addListener('onUserUpdate', (packet) => user.updateFields(packet.data!));
    _aliveClient.addListener('onTeamUpdate', (packet) => _cacheTeam(packet.data));
    _aliveClient.addListener('onWaitShipUpdate', (packet) => _cacheUserShip(packet.data));
    _aliveClient.addListener('onUserShipUpdate', (packet) => _cacheUserShip(packet.data));
    _aliveClient.addListener('onTeamShipUpdate', (packet) => _cacheTeamShip(packet.data));
    _aliveClient.addListener('onMessageSend', (packet) {
      final message = Message.fromJson(packet.data!['message']);
      if (message.from == Constant.msgFromUser) {
        _cacheUserShip(packet.data!['ship'], message: message);
      } else if (message.from == Constant.msgFromTeam) {
        _cacheTeamShip(packet.data!['ship'], message: message);
      }
    });
  }

  ///更新[_userMap]缓存
  User _cacheUser(dynamic data) {
    final item = User.fromJson(data);
    //更新用户缓存
    final key = item.id.toHexString(); //uid is key
    if (_userMap.containsKey(key)) {
      _userMap[key]?.updateFields(data, parser: item);
    } else {
      _userMap[key] = item;
    }
    //标记要刷新的状态
    if (_userships.containsKey(key)) {
      _dirtySessionState = true;
      _dirtyUsershipState = true;
    }
    return item;
  }

  ///更新[_teamMap]缓存
  Team _cacheTeam(dynamic data) {
    final item = Team.fromJson(data);
    //更新群组缓存
    final key = item.id.toHexString(); //tid is key
    if (_teamMap.containsKey(key)) {
      _teamMap[key]?.updateFields(data, parser: item);
    } else {
      _teamMap[key] = item;
    }
    //标记要刷新的状态
    if (_teamships.containsKey(key)) {
      _dirtySessionState = true;
      _dirtyTeamshipState = true;
    }
    return item;
  }

  ///更新[_waitships] 或 [_userships]缓存，如果数据仍然被缓存则将key放入[saveKeys]中。如果[message]不为空则添加到[UserShip.msgcache]中
  UserShip _cacheUserShip(dynamic data, {Set<String>? saveKeys, Message? message}) {
    final item = UserShip.fromJson(data);
    if (item.rid == user.id) {
      //更新好友申请缓存
      final key = item.uid.toHexString(); //uid is key
      if (item.state == Constant.shipStateWait) {
        if (_waitships.containsKey(key)) {
          _waitships[key]?.updateFields(data, parser: item);
        } else {
          _waitships[key] = item;
        }
        saveKeys?.add(key);
      } else {
        _waitships.remove(key);
      }
      //标记要刷新的状态
      _dirtySessionState = true;
      _dirtyWaitshipState = true;
    } else if (item.uid == user.id) {
      //更新好友关系缓存
      final key = item.rid.toHexString(); //rid is key
      if (item.state == Constant.shipStatePass) {
        if (_userships.containsKey(key)) {
          _userships[key]?.updateFields(data, parser: item);
        } else {
          _userships[key] = item;
        }
        saveKeys?.add(key);
        if (message != null) _userships[key]?.msgcache.add(message); //缓存消息
      } else {
        _userships.remove(key);
      }
      //标记要刷新的状态
      _dirtySessionState = true;
      _dirtyUsershipState = true;
    }
    return item;
  }

  ///更新[_teamships]缓存，如果数据仍然被缓存则将key放入[saveKeys]中。如果[message]不为空则添加到[TeamShip.msgcache]中
  TeamShip _cacheTeamShip(dynamic data, {Set<String>? saveKeys, Message? message}) {
    final item = TeamShip.fromJson(data);
    //更新群组关系缓存
    final key = item.rid.toHexString(); //rid is key
    if (item.state == Constant.shipStatePass) {
      if (_teamships.containsKey(key)) {
        _teamships[key]?.updateFields(data, parser: item);
      } else {
        _teamships[key] = item;
      }
      saveKeys?.add(key);
      if (message != null) _teamships[key]?.msgcache.add(message); //缓存消息
      //添加群组成员相关
      _teamuserStateMap[key] = _teamuserStateMap[key] ?? NetClientAzState();
      _teamusersMap[key] = _teamusersMap[key] ?? {};
      _dirtyTeamuserStateMap[key] = _dirtyTeamuserStateMap[key] ?? true;
    } else {
      _teamships.remove(key);
      //移除群组成员相关
      _teamuserStateMap.remove(key);
      _teamusersMap.remove(key);
      _dirtyTeamuserStateMap.remove(key);
    }
    //标记要刷新的状态
    _dirtySessionState = true;
    _dirtyTeamshipState = true;
    return item;
  }

  ///更新[_teamusersMap]的[teamKey]子项缓存，如果数据仍然被缓存则将key放入[saveKeys]中
  TeamShip _cacheTeamUser(String teamKey, dynamic data, {Set<String>? saveKeys}) {
    final _teamusers = _teamusersMap[teamKey];
    final item = TeamShip.fromJson(data);
    if (_teamusers != null && item.rid.toHexString() == teamKey) {
      //更新群组成员缓存
      final key = item.uid.toHexString(); //uid is key
      if (item.state == Constant.shipStatePass) {
        if (_teamusers.containsKey(key)) {
          _teamusers[key]?.updateFields(data, parser: item);
        } else {
          _teamusers[key] = item;
        }
        saveKeys?.add(key);
      } else {
        _teamusers.remove(key);
      }
      //标记要刷新的状态
      _dirtyTeamuserStateMap[teamKey] = true;
    }
    return item;
  }

  ///批量更新[_userMap]缓存
  List<User> _cacheUserList(List dataList) => dataList.map((e) => _cacheUser(e)).toList();

  ///批量更新[_teamMap]缓存
  List<Team> _cacheTeamList(List dataList) => dataList.map((e) => _cacheTeam(e)).toList();

  ///批量更新[_waitships] 或 [_userships]缓存，如果数据仍然被缓存则将key放入[saveKeys]中
  List<UserShip> _cacheUserShipList(List dataList, {Set<String>? saveKeys}) => dataList.map((e) => _cacheUserShip(e, saveKeys: saveKeys)).toList();

  ///批量更新[_teamships]缓存，如果数据仍然被缓存则将key放入[saveKeys]中
  List<TeamShip> _cacheTeamShipList(List dataList, {Set<String>? saveKeys}) => dataList.map((e) => _cacheTeamShip(e, saveKeys: saveKeys)).toList();

  ///批量更新[_teamusersMap]的[teamKey]子项缓存，如果数据仍然被缓存则将key放入[saveKeys]中
  List<TeamShip> _cacheTeamUserList(String teamKey, List dataList, {Set<String>? saveKeys}) => dataList.map((e) => _cacheTeamUser(teamKey, e, saveKeys: saveKeys)).toList();

  /* **************** 静态方法 **************** */

  ///加密登录凭据
  static String? encryptCredentials(User user, String secret) {
    final packet = EasyPacket.pushdata(route: 'credentials', data: {'user': user});
    return EasySecurity.encrypt(packet, secret, false);
  }

  ///解密登录凭据
  static User? decryptCredentials(String data, String secret) {
    final packet = EasySecurity.decrypt(data, secret);
    if (packet == null || packet.data == null || !packet.data!.containsKey('user')) return null;
    return User.fromJson(packet.data!['user']);
  }
}

///
///字母索引列表状态
///
class NetClientAzState {
  static const header = '↑';
  static const letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '#'];

  ///字母索引映射
  final Map<String, int> azMap;

  ///字母索引列表，示例数据: [ String A, Object, Object, ... , String B, Object, Object, ... , String Z, Object, Object, ... , int total ]
  final List<Object> azList;

  ///定制数据列表
  final List<Object> okList;

  ///未读消息数量 或 未处理申请数量
  int _unread;

  int get unread => _unread;

  NetClientAzState()
      : azMap = {},
        azList = [],
        okList = [],
        _unread = 0;

  void update({Map<String, int>? azMap, List<Object>? azList, List<Object>? okList, int? unread}) {
    if (azMap != null) {
      this.azMap.clear();
      this.azMap.addAll(azMap);
    }
    if (azList != null) {
      this.azList.clear();
      this.azList.addAll(azList);
    }
    if (okList != null) {
      this.okList.clear();
      this.okList.addAll(okList);
    }
    if (unread != null) {
      _unread = unread;
    }
  }
}
