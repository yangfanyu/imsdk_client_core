import 'package:shelf_easy/shelf_easy.dart';
import 'location.dart';

///
///聊天消息
///
class Message extends DbBaseModel {
  ///唯一id
  ObjectId _id;

  ///商户id
  ObjectId _bsid;

  ///创建时间
  int _time;

  ///自定义数据
  DbJsonWraper _extra;

  ///聊天会话id
  ObjectId sid;

  ///发送者的id
  ObjectId uid;

  ///消息来源
  int from;

  ///消息类型
  int type;

  ///消息标题
  String title;

  ///消息主体
  String body;

  ///消息缩写
  String short;

  ///媒体的开始时间
  int mediaTimeS;

  ///媒体的结束时间
  int mediaTimeE;

  ///媒体正在进行中
  bool mediaGoing;

  ///媒体读取或参与过的用户id
  List<ObjectId> mediaJoined;

  ///RMB金额总数
  int rmbfenTotal;

  ///RMB已经被抢次数
  int rmbfenCount;

  ///RMB金额分配情况
  List<int> rmbfenEvery;

  ///RMB金额对应的幸运用户id
  List<ObjectId> rmbfenLuckly;

  ///分享名片的目标id（用户id或群组id）
  ObjectId shareCardId;

  ///分享名片的图标url
  String shareIconUrl;

  ///分享名片的头像url
  List<String> shareHeadUrl;

  ///分享网址url、媒体附件url
  String shareLinkUrl;

  ///位置分享消息的数据
  Location? shareLocation;

  ///本条是否已撤销
  bool revoked;

  ///唯一id
  ObjectId get id => _id;

  ///商户id
  ObjectId get bsid => _bsid;

  ///创建时间
  int get time => _time;

  ///自定义数据
  DbJsonWraper get extra => _extra;

  ///
  ///消息发送者展示的名称
  ///
  String displayNick = '';

  ///
  ///消息发送者展示的图标
  ///
  String displayIcon = '';

  ///
  ///消息发送者展示的头像
  ///
  List<String> displayHead = [];

  Message({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    DbJsonWraper? extra,
    ObjectId? sid,
    ObjectId? uid,
    int? from,
    int? type,
    String? title,
    String? body,
    String? short,
    int? mediaTimeS,
    int? mediaTimeE,
    bool? mediaGoing,
    List<ObjectId>? mediaJoined,
    int? rmbfenTotal,
    int? rmbfenCount,
    List<int>? rmbfenEvery,
    List<ObjectId>? rmbfenLuckly,
    ObjectId? shareCardId,
    String? shareIconUrl,
    List<String>? shareHeadUrl,
    String? shareLinkUrl,
    this.shareLocation,
    bool? revoked,
  })  : _id = id ?? ObjectId(),
        _bsid = bsid ?? ObjectId.fromHexString('000000000000000000000000'),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? DbJsonWraper(),
        sid = sid ?? ObjectId.fromHexString('000000000000000000000000'),
        uid = uid ?? ObjectId.fromHexString('000000000000000000000000'),
        from = from ?? 0,
        type = type ?? 0,
        title = title ?? '',
        body = body ?? '',
        short = short ?? '',
        mediaTimeS = mediaTimeS ?? 0,
        mediaTimeE = mediaTimeE ?? 0,
        mediaGoing = mediaGoing ?? false,
        mediaJoined = mediaJoined ?? [],
        rmbfenTotal = rmbfenTotal ?? 0,
        rmbfenCount = rmbfenCount ?? 0,
        rmbfenEvery = rmbfenEvery ?? [],
        rmbfenLuckly = rmbfenLuckly ?? [],
        shareCardId = shareCardId ?? ObjectId.fromHexString('000000000000000000000000'),
        shareIconUrl = shareIconUrl ?? '',
        shareHeadUrl = shareHeadUrl ?? [],
        shareLinkUrl = shareLinkUrl ?? '',
        revoked = revoked ?? false;

  factory Message.fromString(String data) {
    return Message.fromJson(jsonDecode(data.substring(data.indexOf('(') + 1, data.lastIndexOf(')'))));
  }

  factory Message.fromJson(Map<String, dynamic> map) {
    return Message(
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      bsid: map['_bsid'] is String ? ObjectId.fromHexString(map['_bsid']) : map['_bsid'],
      time: map['_time'],
      extra: map['_extra'] is Map ? DbJsonWraper.fromJson(map['_extra']) : map['_extra'],
      sid: map['sid'] is String ? ObjectId.fromHexString(map['sid']) : map['sid'],
      uid: map['uid'] is String ? ObjectId.fromHexString(map['uid']) : map['uid'],
      from: map['from'],
      type: map['type'],
      title: map['title'],
      body: map['body'],
      short: map['short'],
      mediaTimeS: map['mediaTimeS'],
      mediaTimeE: map['mediaTimeE'],
      mediaGoing: map['mediaGoing'],
      mediaJoined: (map['mediaJoined'] as List?)?.map((v) => v is String ? ObjectId.fromHexString(v) : v as ObjectId).toList(),
      rmbfenTotal: map['rmbfenTotal'],
      rmbfenCount: map['rmbfenCount'],
      rmbfenEvery: (map['rmbfenEvery'] as List?)?.map((v) => v as int).toList(),
      rmbfenLuckly: (map['rmbfenLuckly'] as List?)?.map((v) => v is String ? ObjectId.fromHexString(v) : v as ObjectId).toList(),
      shareCardId: map['shareCardId'] is String ? ObjectId.fromHexString(map['shareCardId']) : map['shareCardId'],
      shareIconUrl: map['shareIconUrl'],
      shareHeadUrl: (map['shareHeadUrl'] as List?)?.map((v) => v as String).toList(),
      shareLinkUrl: map['shareLinkUrl'],
      shareLocation: map['shareLocation'] is Map ? Location.fromJson(map['shareLocation']) : map['shareLocation'],
      revoked: map['revoked'],
    );
  }

  @override
  String toString() {
    return 'Message(${jsonEncode(toJson())})';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': DbQueryField.convertToBaseType(_id),
      '_bsid': DbQueryField.convertToBaseType(_bsid),
      '_time': DbQueryField.convertToBaseType(_time),
      '_extra': DbQueryField.convertToBaseType(_extra),
      'sid': DbQueryField.convertToBaseType(sid),
      'uid': DbQueryField.convertToBaseType(uid),
      'from': DbQueryField.convertToBaseType(from),
      'type': DbQueryField.convertToBaseType(type),
      'title': DbQueryField.convertToBaseType(title),
      'body': DbQueryField.convertToBaseType(body),
      'short': DbQueryField.convertToBaseType(short),
      'mediaTimeS': DbQueryField.convertToBaseType(mediaTimeS),
      'mediaTimeE': DbQueryField.convertToBaseType(mediaTimeE),
      'mediaGoing': DbQueryField.convertToBaseType(mediaGoing),
      'mediaJoined': DbQueryField.convertToBaseType(mediaJoined),
      'rmbfenTotal': DbQueryField.convertToBaseType(rmbfenTotal),
      'rmbfenCount': DbQueryField.convertToBaseType(rmbfenCount),
      'rmbfenEvery': DbQueryField.convertToBaseType(rmbfenEvery),
      'rmbfenLuckly': DbQueryField.convertToBaseType(rmbfenLuckly),
      'shareCardId': DbQueryField.convertToBaseType(shareCardId),
      'shareIconUrl': DbQueryField.convertToBaseType(shareIconUrl),
      'shareHeadUrl': DbQueryField.convertToBaseType(shareHeadUrl),
      'shareLinkUrl': DbQueryField.convertToBaseType(shareLinkUrl),
      'shareLocation': DbQueryField.convertToBaseType(shareLocation),
      'revoked': DbQueryField.convertToBaseType(revoked),
    };
  }

  @override
  Map<String, dynamic> toKValues() {
    return {
      '_id': _id,
      '_bsid': _bsid,
      '_time': _time,
      '_extra': _extra,
      'sid': sid,
      'uid': uid,
      'from': from,
      'type': type,
      'title': title,
      'body': body,
      'short': short,
      'mediaTimeS': mediaTimeS,
      'mediaTimeE': mediaTimeE,
      'mediaGoing': mediaGoing,
      'mediaJoined': mediaJoined,
      'rmbfenTotal': rmbfenTotal,
      'rmbfenCount': rmbfenCount,
      'rmbfenEvery': rmbfenEvery,
      'rmbfenLuckly': rmbfenLuckly,
      'shareCardId': shareCardId,
      'shareIconUrl': shareIconUrl,
      'shareHeadUrl': shareHeadUrl,
      'shareLinkUrl': shareLinkUrl,
      'shareLocation': shareLocation,
      'revoked': revoked,
    };
  }

  @override
  void updateByJson(Map<String, dynamic> map, {Message? parser}) {
    parser = parser ?? Message.fromJson(map);
    if (map.containsKey('_id')) _id = parser._id;
    if (map.containsKey('_bsid')) _bsid = parser._bsid;
    if (map.containsKey('_time')) _time = parser._time;
    if (map.containsKey('_extra')) _extra = parser._extra;
    if (map.containsKey('sid')) sid = parser.sid;
    if (map.containsKey('uid')) uid = parser.uid;
    if (map.containsKey('from')) from = parser.from;
    if (map.containsKey('type')) type = parser.type;
    if (map.containsKey('title')) title = parser.title;
    if (map.containsKey('body')) body = parser.body;
    if (map.containsKey('short')) short = parser.short;
    if (map.containsKey('mediaTimeS')) mediaTimeS = parser.mediaTimeS;
    if (map.containsKey('mediaTimeE')) mediaTimeE = parser.mediaTimeE;
    if (map.containsKey('mediaGoing')) mediaGoing = parser.mediaGoing;
    if (map.containsKey('mediaJoined')) mediaJoined = parser.mediaJoined;
    if (map.containsKey('rmbfenTotal')) rmbfenTotal = parser.rmbfenTotal;
    if (map.containsKey('rmbfenCount')) rmbfenCount = parser.rmbfenCount;
    if (map.containsKey('rmbfenEvery')) rmbfenEvery = parser.rmbfenEvery;
    if (map.containsKey('rmbfenLuckly')) rmbfenLuckly = parser.rmbfenLuckly;
    if (map.containsKey('shareCardId')) shareCardId = parser.shareCardId;
    if (map.containsKey('shareIconUrl')) shareIconUrl = parser.shareIconUrl;
    if (map.containsKey('shareHeadUrl')) shareHeadUrl = parser.shareHeadUrl;
    if (map.containsKey('shareLinkUrl')) shareLinkUrl = parser.shareLinkUrl;
    if (map.containsKey('shareLocation')) shareLocation = parser.shareLocation;
    if (map.containsKey('revoked')) revoked = parser.revoked;
  }

  @override
  void updateByKValues(Map<String, dynamic> map) {
    if (map.containsKey('_id')) _id = map['_id'];
    if (map.containsKey('_bsid')) _bsid = map['_bsid'];
    if (map.containsKey('_time')) _time = map['_time'];
    if (map.containsKey('_extra')) _extra = map['_extra'];
    if (map.containsKey('sid')) sid = map['sid'];
    if (map.containsKey('uid')) uid = map['uid'];
    if (map.containsKey('from')) from = map['from'];
    if (map.containsKey('type')) type = map['type'];
    if (map.containsKey('title')) title = map['title'];
    if (map.containsKey('body')) body = map['body'];
    if (map.containsKey('short')) short = map['short'];
    if (map.containsKey('mediaTimeS')) mediaTimeS = map['mediaTimeS'];
    if (map.containsKey('mediaTimeE')) mediaTimeE = map['mediaTimeE'];
    if (map.containsKey('mediaGoing')) mediaGoing = map['mediaGoing'];
    if (map.containsKey('mediaJoined')) mediaJoined = map['mediaJoined'];
    if (map.containsKey('rmbfenTotal')) rmbfenTotal = map['rmbfenTotal'];
    if (map.containsKey('rmbfenCount')) rmbfenCount = map['rmbfenCount'];
    if (map.containsKey('rmbfenEvery')) rmbfenEvery = map['rmbfenEvery'];
    if (map.containsKey('rmbfenLuckly')) rmbfenLuckly = map['rmbfenLuckly'];
    if (map.containsKey('shareCardId')) shareCardId = map['shareCardId'];
    if (map.containsKey('shareIconUrl')) shareIconUrl = map['shareIconUrl'];
    if (map.containsKey('shareHeadUrl')) shareHeadUrl = map['shareHeadUrl'];
    if (map.containsKey('shareLinkUrl')) shareLinkUrl = map['shareLinkUrl'];
    if (map.containsKey('shareLocation')) shareLocation = map['shareLocation'];
    if (map.containsKey('revoked')) revoked = map['revoked'];
  }
}

class MessageDirty {
  final Map<String, dynamic> data = {};

  ///唯一id
  set id(ObjectId value) => data['_id'] = DbQueryField.convertToBaseType(value);

  ///商户id
  set bsid(ObjectId value) => data['_bsid'] = DbQueryField.convertToBaseType(value);

  ///创建时间
  set time(int value) => data['_time'] = DbQueryField.convertToBaseType(value);

  ///自定义数据
  set extra(DbJsonWraper value) => data['_extra'] = DbQueryField.convertToBaseType(value);

  ///聊天会话id
  set sid(ObjectId value) => data['sid'] = DbQueryField.convertToBaseType(value);

  ///发送者的id
  set uid(ObjectId value) => data['uid'] = DbQueryField.convertToBaseType(value);

  ///消息来源
  set from(int value) => data['from'] = DbQueryField.convertToBaseType(value);

  ///消息类型
  set type(int value) => data['type'] = DbQueryField.convertToBaseType(value);

  ///消息标题
  set title(String value) => data['title'] = DbQueryField.convertToBaseType(value);

  ///消息主体
  set body(String value) => data['body'] = DbQueryField.convertToBaseType(value);

  ///消息缩写
  set short(String value) => data['short'] = DbQueryField.convertToBaseType(value);

  ///媒体的开始时间
  set mediaTimeS(int value) => data['mediaTimeS'] = DbQueryField.convertToBaseType(value);

  ///媒体的结束时间
  set mediaTimeE(int value) => data['mediaTimeE'] = DbQueryField.convertToBaseType(value);

  ///媒体正在进行中
  set mediaGoing(bool value) => data['mediaGoing'] = DbQueryField.convertToBaseType(value);

  ///媒体读取或参与过的用户id
  set mediaJoined(List<ObjectId> value) => data['mediaJoined'] = DbQueryField.convertToBaseType(value);

  ///RMB金额总数
  set rmbfenTotal(int value) => data['rmbfenTotal'] = DbQueryField.convertToBaseType(value);

  ///RMB已经被抢次数
  set rmbfenCount(int value) => data['rmbfenCount'] = DbQueryField.convertToBaseType(value);

  ///RMB金额分配情况
  set rmbfenEvery(List<int> value) => data['rmbfenEvery'] = DbQueryField.convertToBaseType(value);

  ///RMB金额对应的幸运用户id
  set rmbfenLuckly(List<ObjectId> value) => data['rmbfenLuckly'] = DbQueryField.convertToBaseType(value);

  ///分享名片的目标id（用户id或群组id）
  set shareCardId(ObjectId value) => data['shareCardId'] = DbQueryField.convertToBaseType(value);

  ///分享名片的图标url
  set shareIconUrl(String value) => data['shareIconUrl'] = DbQueryField.convertToBaseType(value);

  ///分享名片的头像url
  set shareHeadUrl(List<String> value) => data['shareHeadUrl'] = DbQueryField.convertToBaseType(value);

  ///分享网址url、媒体附件url
  set shareLinkUrl(String value) => data['shareLinkUrl'] = DbQueryField.convertToBaseType(value);

  ///位置分享消息的数据
  set shareLocation(Location value) => data['shareLocation'] = DbQueryField.convertToBaseType(value);

  ///本条是否已撤销
  set revoked(bool value) => data['revoked'] = DbQueryField.convertToBaseType(value);
}
