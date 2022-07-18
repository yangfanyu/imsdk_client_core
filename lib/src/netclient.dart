import 'package:lpinyin/lpinyin.dart';
import 'package:shelf_easy/shelf_easy.dart';

import 'model/constant.dart';
import 'model/cusmark.dart';
import 'model/cusstar.dart';
import 'model/customx.dart';
import 'model/location.dart';
import 'model/logerror.dart';
import 'model/loglogin.dart';
import 'model/logreport.dart';
import 'model/message.dart';
import 'model/metadata.dart';
import 'model/team.dart';
import 'model/teamship.dart';
import 'model/user.dart';
import 'model/usership.dart';
import 'tool/compage.dart';
import 'tool/comtools.dart';
import 'tool/datapage.dart';
import 'tool/session.dart';

class NetClient {
  ///日志处理方法
  final EasyLogHandler logger;

  ///日志输出级别
  final EasyLogLevel logLevel;

  ///日志输出标签
  final String? logTag;

  ///服务器地址，格式：http://hostname:port
  final String host;

  ///商户唯一标志
  final String bsid;

  ///商户通讯密钥
  final String secret;

  ///是否用二进制收发数据，需要与服务端保持一致
  final bool binary;

  ///是否启用隔离线程进行数据编解码
  final bool isolate;

  ///登录凭据回调
  final void Function(String nick, String? credentials) onCredentials;

  ///定制配置信息
  final DbJsonWraper configs;

  ///管理员的标志
  final List<ObjectId> adminIds;

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
  final Map<ObjectId, NetClientAzState> _teamuserStateMap;

  ///用户信息，key为用户id
  final Map<ObjectId, User> _userMap;

  ///群组信息，key为群组id
  final Map<ObjectId, Team> _teamMap;

  ///好友申请，key为用户id
  final Map<ObjectId, UserShip> _waitshipMap;

  ///好友关系，key为用户id
  final Map<ObjectId, UserShip> _usershipMap;

  ///群组关系，key为群组id
  final Map<ObjectId, TeamShip> _teamshipMap;

  ///群组成员，key为群组id，子级key为用户id
  final Map<ObjectId, Map<ObjectId, TeamShip>> _teamuserMapMap;

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
  final Map<ObjectId, bool> _dirtyTeamuserStateMap;

  NetClient({this.logger = EasyLogger.printLogger, this.logLevel = EasyLogLevel.debug, this.logTag, required this.host, required this.bsid, required this.secret, this.binary = true, this.isolate = false, required this.onCredentials})
      : configs = DbJsonWraper(),
        adminIds = [],
        user = User(id: DbQueryField.hexstr2ObjectId('000000000000000000000000')),
        _sessionState = NetClientAzState(),
        _waitshipState = NetClientAzState(),
        _usershipState = NetClientAzState(),
        _teamshipState = NetClientAzState(),
        _teamuserStateMap = {},
        _userMap = {},
        _teamMap = {},
        _waitshipMap = {},
        _usershipMap = {},
        _teamshipMap = {},
        _teamuserMapMap = {},
        _guestClient = EasyClient(config: EasyClientConfig(logger: logger, logLevel: logLevel, logTag: logTag, url: host, binary: binary))..bindUser(bsid, token: secret),
        _aliveClient = EasyClient(config: EasyClientConfig(logger: logger, logLevel: logLevel, logTag: logTag, url: host, binary: binary)),
        _dirtySessionState = true,
        _dirtyWaitshipState = true,
        _dirtyUsershipState = true,
        _dirtyTeamshipState = true,
        _dirtyTeamuserStateMap = {};

  /* **************** http请求 **************** */

  ///获取应用程序配置信息
  Future<EasyPacket<void>> appConfigure() async {
    final response = await _guestClient.httpRequest('$host/appConfigure', data: {'bsid': bsid});
    if (response.ok) {
      final adminIdList = response.data!['adminIds'] as List;
      adminIds.clear();
      for (var element in adminIdList) {
        adminIds.add(DbQueryField.hexstr2ObjectId(element));
      }
      configs.updateByJson(response.data!['configs']);
    }
    return response;
  }

  ///使用[User.id]和[User.token]进行登录
  Future<EasyPacket<void>> loginByToken({required ObjectId uid, required String token}) async {
    final response = await _guestClient.httpRequest('$host/loginByToken', data: {'bsid': bsid, 'uid': uid, 'token': token});
    if (response.ok) {
      user.updateByJson(response.data!['user']);
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
      user.updateByJson(response.data!['user']);
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
      user.updateByJson(response.data!['user']);
      _resetAliveClient(response.data!['url'], response.data!['pwd']);
      onCredentials(ComTools.formatUserNick(user), encryptCredentials(user, secret));
    } else if (response.code == 401) {
      onCredentials(ComTools.formatUserNick(user), null);
    }
    return response;
  }

  ///通过Apple账号登录
  Future<EasyPacket<void>> loginByApple({required String appleUid, required String appleUname, required String authorizationCode, String? identityToken}) async {
    final response = await _guestClient.httpRequest('$host/loginByApple', data: {'bsid': bsid, 'appleUid': appleUid, 'appleUname': appleUname, 'authorizationCode': authorizationCode, 'identityToken': identityToken});
    if (response.ok) {
      user.updateByJson(response.data!['user']);
      _resetAliveClient(response.data!['url'], response.data!['pwd']);
      onCredentials(ComTools.formatUserNick(user), encryptCredentials(user, secret));
    } else if (response.code == 401) {
      onCredentials(ComTools.formatUserNick(user), null);
    }
    return response;
  }

  ///通过Wechat账号登录
  Future<EasyPacket<void>> loginByWechat({required String wechatCode}) async {
    final response = await _guestClient.httpRequest('$host/loginByWechat', data: {'bsid': bsid, 'wechatCode': wechatCode});
    if (response.ok) {
      user.updateByJson(response.data!['user']);
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

  /* **************** websocket请求-用户 **************** */

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

  ///销毁长连接，释放缓存
  void release() {
    //销毁长连接
    _aliveClient.destroy();
    //释放缓存
    _sessionState.clear();
    _waitshipState.clear();
    _usershipState.clear();
    _teamshipState.clear();
    _teamuserStateMap.clear();
    _userMap.clear();
    _teamMap.clear();
    _waitshipMap.clear();
    _usershipMap.clear();
    _teamshipMap.clear();
    _teamuserMapMap.clear();
    _dirtySessionState = true;
    _dirtyWaitshipState = true;
    _dirtyUsershipState = true;
    _dirtyTeamshipState = true;
    _dirtyTeamuserStateMap.clear();
  }

  ///长连接登入
  Future<EasyPacket<void>> userEnter() async {
    final mill = DateTime.now().millisecondsSinceEpoch;
    final sign = ComTools.generateUserEnterSign(secret, user.token, user.id.toHexString(), mill);
    final response = await _aliveClient.websocketRequest('userEnter', data: {'bsid': bsid, 'uid': user.id, 'mill': mill, 'sign': sign});
    if (response.ok) {
      //更新用户缓存
      user.updateByJson(response.data!['user']);
      _aliveClient.bindUser(user.id.toHexString(), token: user.token); //立即绑定口令信息
      onCredentials(ComTools.formatUserNick(user), encryptCredentials(user, secret));
      //更新其他缓存
      final waitshipKeys = <ObjectId>{};
      final usershipKeys = <ObjectId>{};
      final teamshipKeys = <ObjectId>{};
      _cacheUserShipList(response.data!['waitships'], saveKeys: waitshipKeys);
      _cacheUserShipList(response.data!['userships'], saveKeys: usershipKeys);
      _cacheTeamShipList(response.data!['teamships'], saveKeys: teamshipKeys);
      _cacheUserList(response.data!['userList']);
      _cacheTeamList(response.data!['teamList']);
      //清除废弃数据
      _waitshipMap.removeWhere((key, value) => !waitshipKeys.contains(key));
      _usershipMap.removeWhere((key, value) => !usershipKeys.contains(key));
      _teamshipMap.removeWhere((key, value) => !teamshipKeys.contains(key));
      //清除废弃数据-群组成员相关
      _teamuserStateMap.removeWhere((key, value) => !teamshipKeys.contains(key));
      _teamuserMapMap.removeWhere((key, value) => !teamshipKeys.contains(key));
      _dirtyTeamuserStateMap.removeWhere((key, value) => !teamshipKeys.contains(key));
    } else if (response.code == 401) {
      onCredentials(ComTools.formatUserNick(user), null);
    }
    return response;
  }

  ///长连接登出
  Future<EasyPacket<void>> userLeave() async {
    final response = await _aliveClient.websocketRequest('userLeave', data: {'bsid': bsid});
    if (response.ok) {
      _aliveClient.unbindUser();
    }
    return response;
  }

  ///永久注销账号
  Future<EasyPacket<void>> userDestroy() async {
    final response = await _aliveClient.websocketRequest('userDestroy', data: {'bsid': bsid});
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
      final teamuserKeys = <ObjectId>{};
      final teamshipList = _cacheTeamUserList(tid, response.data!['shipList'], saveKeys: teamuserKeys);
      //清除废弃数据
      _teamuserMapMap[tid]?.removeWhere((key, value) => !teamuserKeys.contains(key));
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

  ///发送消息-图片消息，[mediaMillis]为图片播放毫秒时长
  Future<EasyPacket<void>> messageSendImage({required ObjectId sid, required int from, required String shareLinkUrl, int mediaMillis = 0}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeImage, 'shareLinkUrl': shareLinkUrl, 'mediaMillis': mediaMillis});
    return response;
  }

  ///发送消息-语音消息，[mediaMillis]为语音播放毫秒时长
  Future<EasyPacket<void>> messageSendVoice({required ObjectId sid, required int from, required String shareLinkUrl, int mediaMillis = 0}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeVoice, 'shareLinkUrl': shareLinkUrl, 'mediaMillis': mediaMillis});
    return response;
  }

  ///发送消息-视频消息，[mediaMillis]为视频播放毫秒时长
  Future<EasyPacket<void>> messageSendVideo({required ObjectId sid, required int from, required String shareLinkUrl, int mediaMillis = 0}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeVideo, 'shareLinkUrl': shareLinkUrl, 'mediaMillis': mediaMillis});
    return response;
  }

  ///发送消息-实时语音电话
  Future<EasyPacket<void>> messageSendRealtimeVoice({required ObjectId sid, required int from, required List<ObjectId> mediaUids}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeRealtimeVoice, 'mediaUids': mediaUids});
    return response;
  }

  ///发送消息-实时视频电话
  Future<EasyPacket<void>> messageSendRealtimeVideo({required ObjectId sid, required int from, required List<ObjectId> mediaUids}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeRealtimeVideo, 'mediaUids': mediaUids});
    return response;
  }

  ///发送消息-实时屏幕共享
  Future<EasyPacket<void>> messageSendRealtimeShare({required ObjectId sid, required int from, required List<ObjectId> mediaUids}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeRealtimeShare, 'mediaUids': mediaUids});
    return response;
  }

  ///发送消息-实时位置电话
  Future<EasyPacket<void>> messageSendRealtimeLocal({required ObjectId sid, required int from, required List<ObjectId> mediaUids}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeRealtimeLocal, 'mediaUids': mediaUids});
    return response;
  }

  ///发送消息-网页分享
  Future<EasyPacket<void>> messageSendShareHtmlPage({required ObjectId sid, required int from, required String title, required String body, required String shareIconUrl, required String shareLinkUrl}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeShareHtmlPage, 'title': title, 'body': body, 'shareIconUrl': shareIconUrl, 'shareLinkUrl': shareLinkUrl});
    return response;
  }

  ///发送消息-位置分享
  Future<EasyPacket<void>> messageSendShareLocation({required ObjectId sid, required int from, required Location shareLocation}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeShareLocation, 'shareLocation': shareLocation});
    return response;
  }

  ///发送消息-用户名片
  Future<EasyPacket<void>> messageSendShareCardUser({required ObjectId sid, required int from, required String title, required String body, required ObjectId shareCardId, required String shareIconUrl, required List<String> shareHeadUrl}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeShareCardUser, 'title': title, 'body': body, 'shareCardId': shareCardId, 'shareIconUrl': shareIconUrl, 'shareHeadUrl': shareHeadUrl});
    return response;
  }

  ///发送消息-群组名片
  Future<EasyPacket<void>> messageSendShareCardTeam({required ObjectId sid, required int from, required String title, required String body, required ObjectId shareCardId, required String shareIconUrl, required List<String> shareHeadUrl}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeShareCardTeam, 'title': title, 'body': body, 'shareCardId': shareCardId, 'shareIconUrl': shareIconUrl, 'shareHeadUrl': shareHeadUrl});
    return response;
  }

  ///发送消息-普通红包，[rmbfenTotal]为红包总金额，[rmbfenCount]为红包个数
  Future<EasyPacket<void>> messageSendRedpackNormal({required ObjectId sid, required int from, required int rmbfenTotal, required int rmbfenCount, required String cashPassword}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeRedpackNormal, 'rmbfenTotal': rmbfenTotal, 'rmbfenCount': rmbfenCount, 'cashPassword': cashPassword});
    return response;
  }

  ///发送消息-幸运红包，[rmbfenTotal]为红包总金额，[rmbfenCount]为红包个数
  Future<EasyPacket<void>> messageSendRedpackLucky({required ObjectId sid, required int from, required int rmbfenTotal, required int rmbfenCount, required String cashPassword}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {'bsid': bsid, 'sid': sid, 'from': from, 'type': Constant.msgTypeRedpackLuckly, 'rmbfenTotal': rmbfenTotal, 'rmbfenCount': rmbfenCount, 'cashPassword': cashPassword});
    return response;
  }

  ///发送消息-自定义消息，[customType]为自定义类型，[customExtra]为自定义类型
  Future<EasyPacket<void>> messageSendCustom({required ObjectId sid, required int from, String? title, String? body, ObjectId? shareCardId, String? shareIconUrl, List<String>? shareHeadUrl, String? shareLinkUrl, required int customType, Map<String, dynamic>? customExtra}) async {
    final response = await _aliveClient.websocketRequest('messageSend', data: {
      'bsid': bsid,
      'sid': sid,
      'from': from,
      'type': Constant.msgTypeCustom,
      'title': title,
      'body': body,
      'shareCardId': shareCardId,
      'shareIconUrl': shareIconUrl,
      'shareHeadUrl': shareHeadUrl,
      'shareLinkUrl': shareLinkUrl,
      'customType': customType,
      'customExtra': customExtra,
    });
    return response;
  }

  ///加载会话消息列表，[reload]为true时清除缓存重新加载，返回值[EasyPacket.extra]字段为true时表示已加载全部数据
  Future<EasyPacket<bool>> messageLoad({required Session session, required bool reload}) async {
    if (reload) session.msgcache.clear(); //清除缓存
    final last = session.msgcache.isEmpty ? 3742732800000 : session.msgcache.last.time; //2088-08-08 00:00:00 毫秒值 3742732800000
    final nin = <ObjectId>[]; //排除重复
    for (int i = session.msgcache.length - 1; i >= 0; i--) {
      final item = session.msgcache[i];
      if (item.time != last) break;
      nin.add(item.id);
    }
    session.msgasync = DateTime.now().microsecondsSinceEpoch; //设置最近一次异步加载的识别号（防止并发加载导致数据混乱）
    final response = await _aliveClient.websocketRequest('messageLoad', data: {'bsid': bsid, 'sid': session.sid, 'from': session.msgfrom, 'last': last, 'nin': nin, 'msgasync': session.msgasync});
    if (response.ok) {
      final msgasync = response.data!['msgasync'] as int;
      final msgList = response.data!['msgList'] as List;
      final shipList = response.data!['shipList'] as List?;
      final userList = response.data!['userList'] as List?;
      if (shipList != null && session.msgfrom == Constant.msgFromTeam) {
        _cacheTeamUserList(session.rid, shipList);
      }
      if (userList != null) {
        _cacheUserList(userList);
      }
      if (msgasync == session.msgasync) {
        for (var data in msgList) {
          final message = Message.fromJson(data);
          _fillMessage(message);
          session.msgcache.add(message);
        }
        return response.cloneExtra(msgList.isEmpty); //是否已加载全部数据
      } else {
        _aliveClient.logError(['messageLoad =>', '远程响应号已过期 $msgasync']);
        return response.requestTimeoutError().cloneExtra(null); //说明本次响应不是最近一次异步加载，直接遗弃数据，当成超时错误处理
      }
    } else {
      return response.cloneExtra(null);
    }
  }

  ///更新消息交互数据，[mediaPlayed]为true表示标记媒体附件已播放，[redpackGrab]为true表示本次操作为抢红包，[realtimeStart]为true表示实时媒体电话开始，[realtimeEnd]为true表示实时媒体电话结束
  Future<EasyPacket<void>> messageUpdate({required ObjectId id, bool mediaPlayed = false, bool redpackGrab = false, bool realtimeStart = false, bool realtimeEnd = false}) async {
    final response = await _aliveClient.websocketRequest('messageUpdate', data: {'bsid': bsid, 'id': id, 'mediaPlayed': mediaPlayed, 'redpackGrab': redpackGrab, 'realtimeStart': realtimeStart, 'realtimeEnd': realtimeEnd});
    return response;
  }

  ///发送实时媒体信令，[toUid]为null时将信令广播给全部参与者，[toUid]不为null时将信令发送给指定参与者
  Future<EasyPacket<void>> messageWebrtc({required ObjectId id, required ObjectId? toUid, required Map<String, dynamic> signals}) async {
    final response = await _aliveClient.websocketRequest('messageWebtrc', data: {'bsid': bsid, 'id': id, 'toUid': toUid, 'signals': signals});
    return response;
  }

  ///创建自定义数据，[no]为数据集合分类序号，返回数据包含全部字段
  Future<EasyPacket<CustomX>> customXInsert({
    required int no,
    DbJsonWraper? extra,
    ObjectId? rid1,
    ObjectId? rid2,
    ObjectId? rid3,
    int? int1,
    int? int2,
    int? int3,
    String? str1,
    String? str2,
    String? str3,
    DbJsonWraper? body1,
    DbJsonWraper? body2,
    DbJsonWraper? body3,
    int? state1,
    int? state2,
    int? state3,
    int? rno1,
    int? rno2,
    int? rno3,
  }) async {
    final response = await _aliveClient.websocketRequest('customXInsert', data: {
      'bsid': bsid,
      'no': no,
      'extra': extra?.toJson(),
      'rid1': rid1,
      'rid2': rid2,
      'rid3': rid3,
      'int1': int1,
      'int2': int2,
      'int3': int3,
      'str1': str1,
      'str2': str2,
      'str3': str3,
      'body1': body1?.toJson(),
      'body2': body2?.toJson(),
      'body3': body3?.toJson(),
      'state1': state1,
      'state2': state2,
      'state3': state3,
      'rno1': rno1,
      'rno2': rno2,
      'rno3': rno3,
    });
    if (response.ok) {
      return response.cloneExtra(
        CustomX.fromJson(response.data!['customx'])
          ..cusmark = response.data!['cusmark'] == null ? null : Cusmark.fromJson(response.data!['cusmark'])
          ..cusstar = response.data!['cusstar'] == null ? null : Cusstar.fromJson(response.data!['cusstar']),
      );
    } else {
      return response.cloneExtra(null);
    }
  }

  ///删除自定义数据，[no]为数据集合分类序号，该操作是永久删除数据
  Future<EasyPacket<void>> customXDelete({required int no, required ObjectId id, int? rno1, int? rno2, int? rno3}) async {
    final response = await _aliveClient.websocketRequest('customXDelete', data: {'bsid': bsid, 'no': no, 'id': id, 'rno1': rno1, 'rno2': rno2, 'rno3': rno3});
    return response;
  }

  ///更新自定义数据，[no]为数据集合分类序号，[update]为true时，会将[CustomX.update]字段更新为当前时间
  ///
  ///[body1]为false时返回数据不包含[CustomX.body1]字段，[body2]为false时返回数据不包含[CustomX.body2]字段，[body3]为false时返回数据不包含[CustomX.body3]字段
  Future<EasyPacket<CustomX>> customXUpdate({required int no, required ObjectId id, required Map<String, dynamic> fields, bool update = true, bool body1 = false, bool body2 = false, bool body3 = false}) async {
    final response = await _aliveClient.websocketRequest('customXUpdate', data: {'bsid': bsid, 'no': no, 'id': id, 'fields': fields, 'update': update, 'body1': body1, 'body2': body2, 'body3': body3});
    if (response.ok) {
      return response.cloneExtra(
        CustomX.fromJson(response.data!['customx'])
          ..cusmark = response.data!['cusmark'] == null ? null : Cusmark.fromJson(response.data!['cusmark'])
          ..cusstar = response.data!['cusstar'] == null ? null : Cusstar.fromJson(response.data!['cusstar']),
      );
    } else {
      return response.cloneExtra(null);
    }
  }

  ///读取自定义数据，[no]为数据集合分类序号，[hot1]不为0时[CustomX.hot1]自增减1，[hot2]不为0时[CustomX.hot2]自增减1，[hotx]不为0时[CustomX.hotx]自增减[hotx]
  ///
  ///[body1]为false时返回数据不包含[CustomX.body1]字段，[body2]为false时返回数据不包含[CustomX.body2]字段，[body3]为false时返回数据不包含[CustomX.body3]字段
  Future<EasyPacket<CustomX>> customXDetail({required int no, required ObjectId id, int hot1 = 0, int hot2 = 0, hotx = 0, bool body1 = false, bool body2 = false, bool body3 = false}) async {
    final response = await _aliveClient.websocketRequest('customXDetail', data: {'bsid': bsid, 'no': no, 'id': id, 'hot1': hot1, 'hot2': hot2, 'hotx': hotx, 'body1': body1, 'body2': body2, 'body3': body3});
    if (response.ok) {
      return response.cloneExtra(
        CustomX.fromJson(response.data!['customx'])
          ..cusmark = response.data!['cusmark'] == null ? null : Cusmark.fromJson(response.data!['cusmark'])
          ..cusstar = response.data!['cusstar'] == null ? null : Cusstar.fromJson(response.data!['cusstar']),
      );
    } else {
      return response.cloneExtra(null);
    }
  }

  ///标记自定义数据，[no]为数据集合分类序号，[score]为null时存在对应标记则删除否则添加，[score]不为null时会将[Cusmark.score]字段设置为[score]
  ///
  ///[body1]为false时返回数据不包含[CustomX.body1]字段，[body2]为false时返回数据不包含[CustomX.body2]字段，[body3]为false时返回数据不包含[CustomX.body3]字段
  Future<EasyPacket<CustomX>> customXMark({required int no, required ObjectId id, double? score, bool body1 = false, bool body2 = false, bool body3 = false}) async {
    final response = await _aliveClient.websocketRequest('customXMark', data: {'bsid': bsid, 'no': no, 'id': id, 'score': score, 'body1': body1, 'body2': body2, 'body3': body3});
    if (response.ok) {
      return response.cloneExtra(
        CustomX.fromJson(response.data!['customx'])
          ..cusmark = response.data!['cusmark'] == null ? null : Cusmark.fromJson(response.data!['cusmark'])
          ..cusstar = response.data!['cusstar'] == null ? null : Cusstar.fromJson(response.data!['cusstar']),
      );
    } else {
      return response.cloneExtra(null);
    }
  }

  ///收藏自定义数据，[no]为数据集合分类序号，数据存在则删除否则添加
  ///
  ///[body1]为false时返回数据不包含[CustomX.body1]字段，[body2]为false时返回数据不包含[CustomX.body2]字段，[body3]为false时返回数据不包含[CustomX.body3]字段
  Future<EasyPacket<CustomX>> customXStar({required int no, required ObjectId id, bool body1 = false, bool body2 = false, bool body3 = false}) async {
    final response = await _aliveClient.websocketRequest('customXStar', data: {'bsid': bsid, 'no': no, 'id': id, 'body1': body1, 'body2': body2, 'body3': body3});
    if (response.ok) {
      return response.cloneExtra(
        CustomX.fromJson(response.data!['customx'])
          ..cusmark = response.data!['cusmark'] == null ? null : Cusmark.fromJson(response.data!['cusmark'])
          ..cusstar = response.data!['cusstar'] == null ? null : Cusstar.fromJson(response.data!['cusstar']),
      );
    } else {
      return response.cloneExtra(null);
    }
  }

  ///加载自定义数据列表，[reload]为true时清除缓存重新加载，返回值[EasyPacket.extra]字段为true时表示已加载全部数据。
  ///
  ///[body1]为false时返回数据不包含[CustomX.body1]字段，[body2]为false时返回数据不包含[CustomX.body2]字段，[body3]为false时返回数据不包含[CustomX.body3]字段
  Future<EasyPacket<bool>> customXLoad({required DataPage dataPage, required bool reload, Map<String, dynamic> eqFilter = const {}, Map<String, dynamic> neFilter = const {}, Map<String, dynamic> matchFilter = const {}, Map<String, dynamic> sorter = const {}, bool body1 = false, bool body2 = false, bool body3 = false}) async {
    if (reload) dataPage.pgcache.clear(); //清除缓存
    dataPage.pgasync = DateTime.now().microsecondsSinceEpoch; //设置最近一次异步加载的识别号（防止并发加载导致数据混乱）
    final response = await _aliveClient.websocketRequest('customXLoad', data: {'bsid': bsid, 'no': dataPage.no, 'skip': dataPage.pgcache.length, 'pgasync': dataPage.pgasync, 'eqFilter': eqFilter, 'neFilter': neFilter, 'matchFilter': matchFilter, 'sorter': sorter, 'body1': body1, 'body2': body2, 'body3': body3});
    if (response.ok) {
      final pgasync = response.data!['pgasync'] as int;
      final totalcnt = response.data!['totalcnt'] as int;
      final customxList = response.data!['customxList'] as List;
      final cusmarkList = response.data!['cusmarkList'] as List;
      final cusstarList = response.data!['cusstarList'] as List;
      if (pgasync == dataPage.pgasync) {
        final cusmarkMap = <ObjectId, Cusmark>{};
        for (var data in cusmarkList) {
          final cusmark = Cusmark.fromJson(data);
          cusmarkMap[cusmark.rid] = cusmark;
        }
        final cusstarMap = <ObjectId, Cusstar>{};
        for (var data in cusstarList) {
          final cusstar = Cusstar.fromJson(data);
          cusstarMap[cusstar.rid] = cusstar;
        }
        for (var data in customxList) {
          final customx = CustomX.fromJson(data);
          customx.cusmark = cusmarkMap[customx.id];
          customx.cusstar = cusstarMap[customx.id];
          dataPage.append(customx);
        }
        dataPage.total = totalcnt;
        return response.cloneExtra(customxList.isEmpty || dataPage.total == dataPage.pgcache.length); //是否已加载全部数据
      } else {
        _aliveClient.logError(['customXLoad =>', '远程响应号已过期 $pgasync']);
        return response.requestTimeoutError().cloneExtra(null); //说明本次响应不是最近一次异步加载，直接遗弃数据，当成超时错误处理
      }
    } else {
      return response.cloneExtra(null);
    }
  }

  ///加载自定义标记列表，[reload]为true时清除缓存重新加载，返回值[EasyPacket.extra]字段为true时表示已加载全部数据。
  ///
  ///[body1]为false时返回数据不包含[CustomX.body1]字段，[body2]为false时返回数据不包含[CustomX.body2]字段，[body3]为false时返回数据不包含[CustomX.body3]字段
  Future<EasyPacket<bool>> cusmarkLoad({required DataPage dataPage, required bool reload, bool body1 = false, bool body2 = false, bool body3 = false}) async {
    if (reload) dataPage.pgcache.clear(); //清除缓存
    dataPage.pgasync = DateTime.now().microsecondsSinceEpoch; //设置最近一次异步加载的识别号（防止并发加载导致数据混乱）
    final response = await _aliveClient.websocketRequest('cusmarkLoad', data: {'bsid': bsid, 'no': dataPage.no, 'skip': dataPage.pgcache.length, 'pgasync': dataPage.pgasync, 'body1': body1, 'body2': body2, 'body3': body3});
    if (response.ok) {
      final pgasync = response.data!['pgasync'] as int;
      final totalcnt = response.data!['totalcnt'] as int;
      final customxList = response.data!['customxList'] as List;
      final cusmarkList = response.data!['cusmarkList'] as List;
      final cusstarList = response.data!['cusstarList'] as List;
      if (pgasync == dataPage.pgasync) {
        final cusmarkMap = <ObjectId, Cusmark>{};
        for (var data in cusmarkList) {
          final cusmark = Cusmark.fromJson(data);
          cusmarkMap[cusmark.rid] = cusmark;
        }
        final cusstarMap = <ObjectId, Cusstar>{};
        for (var data in cusstarList) {
          final cusstar = Cusstar.fromJson(data);
          cusstarMap[cusstar.rid] = cusstar;
        }
        for (var data in customxList) {
          final customx = CustomX.fromJson(data);
          customx.cusmark = cusmarkMap[customx.id];
          customx.cusstar = cusstarMap[customx.id];
          dataPage.append(customx);
        }
        dataPage.total = totalcnt;
        return response.cloneExtra(customxList.isEmpty || dataPage.total == dataPage.pgcache.length); //是否已加载全部数据
      } else {
        _aliveClient.logError(['cusmarkLoad =>', '远程响应号已过期 $pgasync']);
        return response.requestTimeoutError().cloneExtra(null); //说明本次响应不是最近一次异步加载，直接遗弃数据，当成超时错误处理
      }
    } else {
      return response.cloneExtra(null);
    }
  }

  ///加载自定义收藏列表，[reload]为true时清除缓存重新加载，返回值[EasyPacket.extra]字段为true时表示已加载全部数据。
  ///
  ///[body1]为false时返回数据不包含[CustomX.body1]字段，[body2]为false时返回数据不包含[CustomX.body2]字段，[body3]为false时返回数据不包含[CustomX.body3]字段
  Future<EasyPacket<bool>> cusstarLoad({required DataPage dataPage, required bool reload, bool body1 = false, bool body2 = false, bool body3 = false}) async {
    if (reload) dataPage.pgcache.clear(); //清除缓存
    dataPage.pgasync = DateTime.now().microsecondsSinceEpoch; //设置最近一次异步加载的识别号（防止并发加载导致数据混乱）
    final response = await _aliveClient.websocketRequest('cusstarLoad', data: {'bsid': bsid, 'no': dataPage.no, 'skip': dataPage.pgcache.length, 'pgasync': dataPage.pgasync, 'body1': body1, 'body2': body2, 'body3': body3});
    if (response.ok) {
      final pgasync = response.data!['pgasync'] as int;
      final totalcnt = response.data!['totalcnt'] as int;
      final customxList = response.data!['customxList'] as List;
      final cusmarkList = response.data!['cusmarkList'] as List;
      final cusstarList = response.data!['cusstarList'] as List;
      if (pgasync == dataPage.pgasync) {
        final cusmarkMap = <ObjectId, Cusmark>{};
        for (var data in cusmarkList) {
          final cusmark = Cusmark.fromJson(data);
          cusmarkMap[cusmark.rid] = cusmark;
        }
        final cusstarMap = <ObjectId, Cusstar>{};
        for (var data in cusstarList) {
          final cusstar = Cusstar.fromJson(data);
          cusstarMap[cusstar.rid] = cusstar;
        }
        for (var data in customxList) {
          final customx = CustomX.fromJson(data);
          customx.cusmark = cusmarkMap[customx.id];
          customx.cusstar = cusstarMap[customx.id];
          dataPage.append(customx);
        }
        dataPage.total = totalcnt;
        return response.cloneExtra(customxList.isEmpty || dataPage.total == dataPage.pgcache.length); //是否已加载全部数据
      } else {
        _aliveClient.logError(['cusstarLoad =>', '远程响应号已过期 $pgasync']);
        return response.requestTimeoutError().cloneExtra(null); //说明本次响应不是最近一次异步加载，直接遗弃数据，当成超时错误处理
      }
    } else {
      return response.cloneExtra(null);
    }
  }

  ///记录登录日志
  Future<EasyPacket<void>> doLogLogin({int clientVersion = 0, String deviceType = 'terminal', String deviceVersion = '0.0', Map<String, dynamic> deviceDetail = const {}}) async {
    final response = await _aliveClient.websocketRequest('doLogLogin', data: {'bsid': bsid, 'clientVersion': clientVersion, 'deviceType': deviceType, 'deviceVersion': deviceVersion, 'deviceDetail': deviceDetail});
    return response;
  }

  ///记录异常日志
  Future<EasyPacket<void>> doLogError({int clientVersion = 0, String deviceType = 'terminal', String deviceVersion = '0.0', Map<String, dynamic> deviceDetail = const {}, Map<String, dynamic> errorDetail = const {}, int errorTime = 0}) async {
    final response = await _aliveClient.websocketRequest('doLogError', data: {'bsid': bsid, 'clientVersion': clientVersion, 'deviceType': deviceType, 'deviceVersion': deviceVersion, 'deviceDetail': deviceDetail, 'errorDetail': {}, 'errorTime': errorTime});
    return response;
  }

  ///记录反馈日志
  Future<EasyPacket<void>> doLogReport({ObjectId? rid, required int type, String image = '', String host = '', String href = '', String desc = '', int? customType}) async {
    final response = await _aliveClient.websocketRequest('doLogReport', data: {'bsid': bsid, 'rid': rid, 'type': type, 'image': image, 'host': host, 'href': href, 'desc': desc, 'customType': customType});
    return response;
  }

  /* **************** websocket请求-管理 **************** */

  ///管理员获取用户列表
  Future<EasyPacket<ComPage<User>>> adminUserList({required int page, int deny = 0, String keywords = ''}) async {
    final response = await _aliveClient.websocketRequest('adminUserList', data: {'bsid': bsid, 'page': page, 'deny': deny, 'keywords': keywords});
    if (response.ok) {
      final userList = response.data!['userList'] as List;
      final userCount = response.data!['userCount'] as int;
      final result = ComPage<User>(page: page, total: userCount);
      for (var element in userList) {
        result.pgcache.add(User.fromJson(element));
      }
      return response.cloneExtra(result);
    } else {
      return response.cloneExtra(null);
    }
  }

  ///管理员设置用户状态
  Future<EasyPacket<void>> adminUserDeny({required ObjectId uid, required int deny}) async {
    final response = await _aliveClient.websocketRequest('adminUserDeny', data: {'bsid': bsid, 'uid': uid, 'deny': deny});
    return response;
  }

  ///管理员获取群组列表
  Future<EasyPacket<ComPage<Team>>> adminTeamList({required int page, int deny = 0, String keywords = ''}) async {
    final response = await _aliveClient.websocketRequest('adminTeamList', data: {'bsid': bsid, 'page': page, 'deny': deny, 'keywords': keywords});
    if (response.ok) {
      final teamList = response.data!['teamList'] as List;
      final teamCount = response.data!['teamCount'] as int;
      final result = ComPage<Team>(page: page, total: teamCount);
      for (var element in teamList) {
        result.pgcache.add(Team.fromJson(element));
      }
      return response.cloneExtra(result);
    } else {
      return response.cloneExtra(null);
    }
  }

  ///管理员设置群组状态
  Future<EasyPacket<void>> adminTeamDeny({required ObjectId tid, required int deny}) async {
    final response = await _aliveClient.websocketRequest('adminTeamDeny', data: {'bsid': bsid, 'tid': tid, 'deny': deny});
    return response;
  }

  ///管理员获取登录列表
  Future<EasyPacket<ComPage<LogLogin>>> adminLoginList({required int page, required int start, required int end}) async {
    final response = await _aliveClient.websocketRequest('adminLoginList', data: {'bsid': bsid, 'page': page, 'start': start, 'end': end});
    if (response.ok) {
      final loginList = response.data!['loginList'] as List;
      final loginCount = response.data!['loginCount'] as int;
      final result = ComPage<LogLogin>(page: page, total: loginCount);
      for (var element in loginList) {
        result.pgcache.add(LogLogin.fromJson(element));
      }
      return response.cloneExtra(result);
    } else {
      return response.cloneExtra(null);
    }
  }

  ///管理员获取异常列表
  Future<EasyPacket<ComPage<LogError>>> adminErrorList({required int page, required bool finished}) async {
    final response = await _aliveClient.websocketRequest('adminErrorList', data: {'bsid': bsid, 'page': page, 'finished': finished});
    if (response.ok) {
      final errorList = response.data!['errorList'] as List;
      final errorCount = response.data!['errorCount'] as int;
      final result = ComPage<LogError>(page: page, total: errorCount);
      for (var element in errorList) {
        result.pgcache.add(LogError.fromJson(element));
      }
      return response.cloneExtra(result);
    } else {
      return response.cloneExtra(null);
    }
  }

  ///管理员设置异常状态
  Future<EasyPacket<void>> adminErrorState({required ObjectId id, required bool finished}) async {
    final response = await _aliveClient.websocketRequest('adminErrorState', data: {'bsid': bsid, 'id': id, 'finished': finished});
    return response;
  }

  ///管理员获取投诉列表
  Future<EasyPacket<ComPage<LogReport>>> adminReportList({required int page, required int type, required int state, int? customType}) async {
    final response = await _aliveClient.websocketRequest('adminReportList', data: {'bsid': bsid, 'page': page, 'type': type, 'state': state, 'customType': customType});
    if (response.ok) {
      final reportList = response.data!['reportList'] as List;
      final reportCount = response.data!['reportCount'] as int;
      final result = ComPage<LogReport>(page: page, total: reportCount);
      for (var element in reportList) {
        result.pgcache.add(LogReport.fromJson(element));
      }
      return response.cloneExtra(result);
    } else {
      return response.cloneExtra(null);
    }
  }

  ///管理员设置反馈状态
  Future<EasyPacket<void>> adminReportState({required ObjectId id, required int state}) async {
    final response = await _aliveClient.websocketRequest('adminReportState', data: {'bsid': bsid, 'id': id, 'state': state});
    return response;
  }

  ///管理员更新商户信息
  Future<EasyPacket<void>> adminBusinessUpdate({required Map<String, dynamic> fields}) async {
    final response = await _aliveClient.websocketRequest('adminBusinessUpdate', data: {'bsid': bsid, 'fields': fields});
    return response;
  }

  /* **************** 工具方法 **************** */

  ///创建会话
  Session createSession({UserShip? usership, TeamShip? teamship}) {
    if (usership != null) return Session.fromUserShip(usership, getUser(usership.rid));
    if (teamship != null) return Session.fromTeamShip(teamship, getTeam(teamship.rid));
    throw 'usership == null && teamship == null';
  }

  ///读取用户
  User getUser(ObjectId uid) {
    var item = _userMap[uid];
    if (item == null) {
      //创建一个临时用户实例
      item = User(bsid: DbQueryField.hexstr2ObjectId(bsid), id: uid);
      _userMap[uid] = item;
      //获取未缓存的用户信息
      userFetch(uids: [uid]).then((result) {
        if (result.ok) _aliveClient.triggerEvent(EasyPacket.pushdata(route: 'onUserFetchedEvent', data: result.data));
      });
    }
    return item;
  }

  ///读取群组
  Team getTeam(ObjectId tid) {
    var item = _teamMap[tid];
    if (item == null) {
      //创建一个临时群组实例
      item = Team(bsid: DbQueryField.hexstr2ObjectId(bsid), id: tid);
      _teamMap[tid] = item;
      //获取未缓存的群组信息
      teamFetch(tids: [tid]).then((result) {
        if (result.ok) _aliveClient.triggerEvent(EasyPacket.pushdata(route: 'onTeamFetchedEvent', data: result.data));
      });
    }
    return item;
  }

  ///读取好友申请
  UserShip? getWaitShip(ObjectId uid) => _waitshipMap[uid];

  ///读取好友关系
  UserShip? getUserShip(ObjectId uid) => _usershipMap[uid];

  ///读取群组关系
  TeamShip? getTeamShip(ObjectId tid) => _teamshipMap[tid];

  ///读取群组成员
  TeamShip? getTeamUser(ObjectId tid, ObjectId uid) => _teamuserMapMap[tid]?[uid];

  ///读取激活会话状态
  NetClientAzState get sessionState {
    if (_dirtySessionState) {
      //构建列表
      final okList = <Object>[];
      int unread = 0;
      _usershipMap.forEach((key, value) {
        if (value.dialog) {
          okList.add(value);
          unread += value.unread;
          //计算展示信息
          final target = getUser(value.rid);
          value.displayNick = ComTools.formatUserShipNick(value, target);
          value.displayIcon = target.icon;
          value.displayHead = target.head;
        }
      });
      _teamshipMap.forEach((key, value) {
        if (value.dialog) {
          okList.add(value);
          unread += value.unread;
          //计算展示信息
          final target = getTeam(value.rid);
          value.displayNick = ComTools.formatTeamNick(target);
          value.displayIcon = target.icon;
          value.displayHead = target.head;
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
      final okList = <Object>[];
      _waitshipMap.forEach((key, value) {
        okList.add(value);
        //计算展示信息
        final target = getUser(value.uid);
        value.displayNick = ComTools.formatUserNick(target);
        value.displayIcon = target.icon;
        value.displayHead = target.head;
      });
      //按发起申请时间降序排列
      okList.sort((a, b) => (a as UserShip).time > (b as UserShip).time ? -1 : 1);
      //最后插入数量
      okList.add(_waitshipMap.length);
      //更新状态
      _waitshipState.update(okList: okList, unread: _waitshipMap.length);
      _dirtyWaitshipState = false;
    }
    return _waitshipState;
  }

  ///读取好友关系状态
  NetClientAzState get usershipState {
    if (_dirtyUsershipState) {
      //构建列表
      final azList = <Object>[...NetClientAzState.letters];
      _usershipMap.forEach((key, value) {
        azList.add(value);
        //计算展示信息
        final target = getUser(value.rid);
        value.displayNick = ComTools.formatUserShipNick(value, target);
        value.displayIcon = target.icon;
        value.displayHead = target.head;
        value.displayPinyin = PinyinHelper.getPinyinE(value.displayNick, separator: '', defPinyin: '#', format: PinyinFormat.WITHOUT_TONE).toUpperCase();
        if (value.displayPinyin.isEmpty || !NetClientAzState.letters.contains(value.displayPinyin[0])) value.displayPinyin = '#${value.displayPinyin}';
      });
      //字母列表排序
      azList.sort((a, b) {
        final pyA = a is UserShip ? a.displayPinyin : (a as String);
        final pyB = b is UserShip ? b.displayPinyin : (b as String);
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
      azList.add(_usershipMap.length);
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
      _teamshipMap.forEach((key, value) {
        azList.add(value);
        //计算展示信息
        final target = getTeam(value.rid);
        value.displayNick = ComTools.formatTeamNick(target);
        value.displayIcon = target.icon;
        value.displayHead = target.head;
        value.displayPinyin = PinyinHelper.getPinyinE(value.displayNick, separator: '', defPinyin: '#', format: PinyinFormat.WITHOUT_TONE).toUpperCase();
        if (value.displayPinyin.isEmpty || !NetClientAzState.letters.contains(value.displayPinyin[0])) value.displayPinyin = '#${value.displayPinyin}';
      });
      //字母列表排序
      azList.sort((a, b) {
        final pyA = a is TeamShip ? a.displayPinyin : (a as String);
        final pyB = b is TeamShip ? b.displayPinyin : (b as String);
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
      azList.add(_teamshipMap.length);
      //更新状态
      _teamshipState.update(azMap: azMap, azList: azList);
      _dirtyTeamshipState = false;
    }
    return _teamshipState;
  }

  ///读取群组成员状态
  NetClientAzState getTeamuserState(ObjectId tid) {
    final teamuserState = _teamuserStateMap[tid];
    final teamuserMap = _teamuserMapMap[tid];
    final dirtyTeamuserState = _dirtyTeamuserStateMap[tid];
    if (teamuserState == null || teamuserMap == null || dirtyTeamuserState == null) {
      return NetClientAzState()..update(azList: [0]); //这种情况说明没有加入这个群组
    }
    if (dirtyTeamuserState) {
      //构建列表
      final team = getTeam(tid);
      final admins = <Object>[];
      final azList = <Object>[...NetClientAzState.letters];
      teamuserMap.forEach((key, value) {
        if (ComTools.isTeamSuperAdmin(team, value.uid)) {
          admins.insert(0, value);
        } else if (ComTools.isTeamNormalAdmin(team, value.uid)) {
          admins.add(value);
        } else {
          azList.add(value);
        }
        //计算展示信息
        final target = getUser(value.uid);
        value.displayNick = ComTools.formatTeamUserNick(value, target);
        value.displayIcon = target.icon;
        value.displayHead = target.head;
        value.displayPinyin = PinyinHelper.getPinyinE(value.displayNick, separator: '', defPinyin: '#', format: PinyinFormat.WITHOUT_TONE).toUpperCase();
        if (value.displayPinyin.isEmpty || !NetClientAzState.letters.contains(value.displayPinyin[0])) value.displayPinyin = '#${value.displayPinyin}';
      });
      //字母列表排序
      azList.sort((a, b) {
        final pyA = a is TeamShip ? a.displayPinyin : (a as String);
        final pyB = b is TeamShip ? b.displayPinyin : (b as String);
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
      azList.add(teamuserMap.length);
      //更新状态
      teamuserState.update(azMap: azMap, azList: azList);
      _dirtyTeamuserStateMap[tid] = false;
    }
    return teamuserState;
  }

  ///设置用户信息获取完成的监听器---此事件由本地触发
  void setOnUserFetchedWatcher(void Function(EasyPacket packet) ondata, {required bool remove}) {
    if (remove) {
      _aliveClient.removeListener('onUserFetchedEvent', ondata: ondata);
    } else {
      _aliveClient.addListener('onUserFetchedEvent', ondata);
    }
  }

  ///设置群组信息获取完成的监听器---此事件由本地触发
  void setOnTeamFetchedWatcher(void Function(EasyPacket packet) ondata, {required bool remove}) {
    if (remove) {
      _aliveClient.removeListener('onTeamFetchedEvent', ondata: ondata);
    } else {
      _aliveClient.addListener('onTeamFetchedEvent', ondata);
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

  ///设置消息数据发生变化的监听器
  void setOnMessageUpdateListener(void Function(EasyPacket packet) ondata, {required bool remove}) {
    if (remove) {
      _aliveClient.removeListener('onMessageUpdate', ondata: ondata);
    } else {
      _aliveClient.addListener('onMessageUpdate', ondata);
    }
  }

  ///设置收到实时媒体信令的监听器
  void setOnMessageWebrtcListener(void Function(EasyPacket packet) ondata, {required bool remove}) {
    if (remove) {
      _aliveClient.removeListener('onMessageWebrtc', ondata: ondata);
    } else {
      _aliveClient.addListener('onMessageWebrtc', ondata);
    }
  }

  ///[packet]是否为对应[session]的消息推送
  bool isMessageSendForSession(Session session, EasyPacket packet) => packet.route == 'onMessageSend' && parseMessageFromSendOrUpdate(packet).sid == session.sid;

  ///从[packet]中解析出[Message]实例
  Message parseMessageFromSendOrUpdate(EasyPacket packet) => packet.data!['_parsedMessage'] ?? Message.fromJson(packet.data!['message']);

  ///从[packet]中解析出[UserShip]实例
  UserShip parseUserShipFromSendOrUpdate(EasyPacket packet) => packet.data!['_parsedShip'] ?? UserShip.fromJson(packet.data!['ship']);

  ///从[packet]中解析出[TeamShip]实例
  TeamShip parseTeamShipFromSendOrUpdate(EasyPacket packet) => packet.data!['_parsedShip'] ?? TeamShip.fromJson(packet.data!['ship']);

  /* **************** 缓存方法 **************** */

  ///重新创建已登陆wss客户端
  void _resetAliveClient(String url, String? pwd) {
    _aliveClient.destroy(); //先销毁旧的
    _aliveClient = EasyClient(config: EasyClientConfig(logger: logger, logLevel: logLevel, logTag: logTag, url: url, pwd: pwd, binary: binary)); //创建新的
    if (isolate) _aliveClient.initThread(_isolateHandler); //启用多线程进行数据编解码
    _aliveClient.addListener('onUserUpdate', (packet) => user.updateByJson(packet.data!));
    _aliveClient.addListener('onTeamUpdate', (packet) => _cacheTeam(packet.data));
    _aliveClient.addListener('onWaitShipUpdate', (packet) => _cacheUserShip(packet.data));
    _aliveClient.addListener('onUserShipUpdate', (packet) => _cacheUserShip(packet.data));
    _aliveClient.addListener('onTeamShipUpdate', (packet) => _cacheTeamShip(packet.data));
    _aliveClient.addListener('onMessageSend', (packet) {
      final userData = packet.data!['user'];
      final shipData = packet.data!['ship'];
      final messageData = packet.data!['message'];
      //更新发送者缓存
      final user = _cacheUser(userData);
      //更新关系与消息缓存
      final message = Message.fromJson(messageData);
      if (message.from == Constant.msgFromUser) {
        final ship = _cacheUserShip(shipData);
        ship.msgcache.insert(0, message);
        _fillMessage(message);
        //保存解析结果
        packet.data!['_parsedUser'] = user;
        packet.data!['_parsedShip'] = ship;
        packet.data!['_parsedMessage'] = message;
      } else if (message.from == Constant.msgFromTeam) {
        final ship = _cacheTeamShip(shipData);
        ship.msgcache.insert(0, message);
        _fillMessage(message);
        //保存解析结果
        packet.data!['_parsedUser'] = user;
        packet.data!['_parsedShip'] = ship;
        packet.data!['_parsedMessage'] = message;
      }
    });
    _aliveClient.addListener('onMessageUpdate', (packet) {
      final userData = packet.data!['user'];
      final shipData = packet.data!['ship'];
      final messageData = packet.data!['message'];
      //更新发送者缓存
      final user = _cacheUser(userData);
      //更新关系与消息缓存
      final message = Message.fromJson(messageData);
      if (message.from == Constant.msgFromUser) {
        final ship = _cacheUserShip(shipData);
        for (var element in ship.msgcache) {
          if (element.id == message.id) {
            element.updateByJson(messageData, parser: message);
            _fillMessage(element);
            //保存解析结果
            packet.data!['_parsedUser'] = user;
            packet.data!['_parsedShip'] = ship;
            packet.data!['_parsedMessage'] = element;
            break;
          }
        }
      } else if (message.from == Constant.msgFromTeam) {
        final ship = _cacheTeamShip(shipData);
        for (var element in ship.msgcache) {
          if (element.id == message.id) {
            element.updateByJson(messageData, parser: message);
            _fillMessage(element);
            //保存解析结果
            packet.data!['_parsedUser'] = user;
            packet.data!['_parsedShip'] = ship;
            packet.data!['_parsedMessage'] = element;
            break;
          }
        }
      }
    });
  }

  ///填充消息展示字段
  void _fillMessage(Message message) {
    final target = message.uid == user.id ? user : getUser(message.uid);
    if (message.from == Constant.msgFromUser) {
      final ship = getUserShip(message.uid);
      message.displayNick = ship == null ? ComTools.formatUserNick(target) : ComTools.formatUserShipNick(ship, target);
      message.displayIcon = target.icon;
      message.displayHead = target.head;
    } else if (message.from == Constant.msgFromTeam) {
      final ship = getTeamUser(message.sid, message.uid);
      message.displayNick = ship == null ? ComTools.formatUserNick(target) : ComTools.formatTeamUserNick(ship, target);
      message.displayIcon = target.icon;
      message.displayHead = target.head;
    }
  }

  ///更新[_userMap]缓存
  User _cacheUser(dynamic data) {
    final item = User.fromJson(data);
    //更新用户缓存
    final key = item.id; //uid is key
    if (_userMap.containsKey(key)) {
      _userMap[key]?.updateByJson(data, parser: item);
    } else {
      _userMap[key] = item;
    }
    //标记要刷新的状态
    if (_waitshipMap.containsKey(key)) {
      _dirtySessionState = true;
      _dirtyWaitshipState = true;
    }
    if (_usershipMap.containsKey(key)) {
      _dirtySessionState = true;
      _dirtyUsershipState = true;
    }
    return _userMap[key] ?? item;
  }

  ///更新[_teamMap]缓存
  Team _cacheTeam(dynamic data) {
    final item = Team.fromJson(data);
    //更新群组缓存
    final key = item.id; //tid is key
    if (_teamMap.containsKey(key)) {
      _teamMap[key]?.updateByJson(data, parser: item);
    } else {
      _teamMap[key] = item;
    }
    //标记要刷新的状态
    if (_teamshipMap.containsKey(key)) {
      _dirtySessionState = true;
      _dirtyTeamshipState = true;
    }
    return _teamMap[key] ?? item;
  }

  ///更新[_waitshipMap] 或 [_usershipMap]缓存，如果数据仍然被缓存则将key放入[saveKeys]中
  UserShip _cacheUserShip(dynamic data, {Set<ObjectId>? saveKeys}) {
    final item = UserShip.fromJson(data);
    if (item.rid == user.id) {
      //更新好友申请缓存
      final key = item.uid; //uid is key
      if (item.state == Constant.shipStateWait) {
        if (_waitshipMap.containsKey(key)) {
          _waitshipMap[key]?.updateByJson(data, parser: item);
        } else {
          _waitshipMap[key] = item;
        }
        saveKeys?.add(key);
      } else {
        _waitshipMap.remove(key);
      }
      //标记要刷新的状态
      _dirtySessionState = true;
      _dirtyWaitshipState = true;
      return _waitshipMap[key] ?? item;
    } else if (item.uid == user.id) {
      //更新好友关系缓存
      final key = item.rid; //rid is key
      if (item.state == Constant.shipStatePass) {
        if (_usershipMap.containsKey(key)) {
          _usershipMap[key]?.updateByJson(data, parser: item);
        } else {
          _usershipMap[key] = item;
        }
        saveKeys?.add(key);
      } else {
        _usershipMap.remove(key);
      }
      //标记要刷新的状态
      _dirtySessionState = true;
      _dirtyUsershipState = true;
      return _usershipMap[key] ?? item;
    } else {
      return item;
    }
  }

  ///更新[_teamshipMap]缓存，如果数据仍然被缓存则将key放入[saveKeys]中
  TeamShip _cacheTeamShip(dynamic data, {Set<ObjectId>? saveKeys}) {
    final item = TeamShip.fromJson(data);
    //更新群组关系缓存
    final key = item.rid; //rid is key
    if (item.state == Constant.shipStatePass) {
      if (_teamshipMap.containsKey(key)) {
        _teamshipMap[key]?.updateByJson(data, parser: item);
      } else {
        _teamshipMap[key] = item;
      }
      saveKeys?.add(key);
      //添加群组成员相关
      _teamuserStateMap[key] = _teamuserStateMap[key] ?? NetClientAzState();
      _teamuserMapMap[key] = _teamuserMapMap[key] ?? {};
      _dirtyTeamuserStateMap[key] = _dirtyTeamuserStateMap[key] ?? true;
    } else {
      _teamshipMap.remove(key);
      //移除群组成员相关
      _teamuserStateMap.remove(key);
      _teamuserMapMap.remove(key);
      _dirtyTeamuserStateMap.remove(key);
    }
    //标记要刷新的状态
    _dirtySessionState = true;
    _dirtyTeamshipState = true;
    return _teamshipMap[key] ?? item;
  }

  ///更新[_teamuserMapMap]的[teamId]子项缓存，如果数据仍然被缓存则将key放入[saveKeys]中
  TeamShip _cacheTeamUser(ObjectId teamId, dynamic data, {Set<ObjectId>? saveKeys}) {
    final teamuserMap = _teamuserMapMap[teamId];
    final item = TeamShip.fromJson(data);
    if (teamuserMap != null && item.rid == teamId) {
      //更新群组成员缓存
      final key = item.uid; //uid is key
      if (item.state == Constant.shipStatePass) {
        if (teamuserMap.containsKey(key)) {
          teamuserMap[key]?.updateByJson(data, parser: item);
        } else {
          teamuserMap[key] = item;
        }
        saveKeys?.add(key);
      } else {
        teamuserMap.remove(key);
      }
      //标记要刷新的状态
      _dirtyTeamuserStateMap[teamId] = true;
      return teamuserMap[key] ?? item;
    } else {
      return item;
    }
  }

  ///批量更新[_userMap]缓存
  List<User> _cacheUserList(List dataList) => dataList.map((e) => _cacheUser(e)).toList();

  ///批量更新[_teamMap]缓存
  List<Team> _cacheTeamList(List dataList) => dataList.map((e) => _cacheTeam(e)).toList();

  ///批量更新[_waitshipMap] 或 [_usershipMap]缓存，如果数据仍然被缓存则将key放入[saveKeys]中
  List<UserShip> _cacheUserShipList(List dataList, {Set<ObjectId>? saveKeys}) => dataList.map((e) => _cacheUserShip(e, saveKeys: saveKeys)).toList();

  ///批量更新[_teamshipMap]缓存，如果数据仍然被缓存则将key放入[saveKeys]中
  List<TeamShip> _cacheTeamShipList(List dataList, {Set<ObjectId>? saveKeys}) => dataList.map((e) => _cacheTeamShip(e, saveKeys: saveKeys)).toList();

  ///批量更新[_teamuserMapMap]的[teamId]子项缓存，如果数据仍然被缓存则将key放入[saveKeys]中
  List<TeamShip> _cacheTeamUserList(ObjectId teamId, List dataList, {Set<ObjectId>? saveKeys}) => dataList.map((e) => _cacheTeamUser(teamId, e, saveKeys: saveKeys)).toList();

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

  static Future<dynamic> _isolateHandler(String taskType, dynamic taskData) async {
    return null;
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

  void clear() {
    azMap.clear();
    azList.clear();
    okList.clear();
    _unread = 0;
  }
}
