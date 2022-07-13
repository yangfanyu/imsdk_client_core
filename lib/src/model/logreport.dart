import 'package:shelf_easy/shelf_easy.dart';

///
///投诉日志
///
class LogReport extends DbBaseModel {
  ///唯一id
  ObjectId _id;

  ///商户id
  ObjectId _bsid;

  ///创建时间
  int _time;

  ///自定义数据
  DbJsonWraper _extra;

  ///所属用户id
  ObjectId uid;

  ///投诉目标id
  ObjectId rid;

  ///投诉目标类型
  int type;

  ///投诉目标截图
  String image;

  ///投诉目标域名
  String host;

  ///投诉目标网址
  String href;

  ///投诉原因
  String desc;

  ///投诉状态
  int state;

  ///自定义的投诉目标类型
  int customType;

  ///唯一id
  ObjectId get id => _id;

  ///商户id
  ObjectId get bsid => _bsid;

  ///创建时间
  int get time => _time;

  ///自定义数据
  DbJsonWraper get extra => _extra;

  LogReport({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    DbJsonWraper? extra,
    ObjectId? uid,
    ObjectId? rid,
    int? type,
    String? image,
    String? host,
    String? href,
    String? desc,
    int? state,
    int? customType,
  })  : _id = id ?? ObjectId(),
        _bsid = bsid ?? ObjectId.fromHexString('000000000000000000000000'),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? DbJsonWraper(),
        uid = uid ?? ObjectId.fromHexString('000000000000000000000000'),
        rid = rid ?? ObjectId.fromHexString('000000000000000000000000'),
        type = type ?? 0,
        image = image ?? '',
        host = host ?? '',
        href = href ?? '',
        desc = desc ?? '',
        state = state ?? 0,
        customType = customType ?? 0;

  factory LogReport.fromString(String data) {
    return LogReport.fromJson(jsonDecode(data.substring(data.indexOf('(') + 1, data.lastIndexOf(')'))));
  }

  factory LogReport.fromJson(Map<String, dynamic> map) {
    return LogReport(
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      bsid: map['_bsid'] is String ? ObjectId.fromHexString(map['_bsid']) : map['_bsid'],
      time: map['_time'],
      extra: map['_extra'] is Map ? DbJsonWraper.fromJson(map['_extra']) : map['_extra'],
      uid: map['uid'] is String ? ObjectId.fromHexString(map['uid']) : map['uid'],
      rid: map['rid'] is String ? ObjectId.fromHexString(map['rid']) : map['rid'],
      type: map['type'],
      image: map['image'],
      host: map['host'],
      href: map['href'],
      desc: map['desc'],
      state: map['state'],
      customType: map['customType'],
    );
  }

  @override
  String toString() {
    return 'LogReport(${jsonEncode(toJson())})';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': DbQueryField.convertToBaseType(_id),
      '_bsid': DbQueryField.convertToBaseType(_bsid),
      '_time': DbQueryField.convertToBaseType(_time),
      '_extra': DbQueryField.convertToBaseType(_extra),
      'uid': DbQueryField.convertToBaseType(uid),
      'rid': DbQueryField.convertToBaseType(rid),
      'type': DbQueryField.convertToBaseType(type),
      'image': DbQueryField.convertToBaseType(image),
      'host': DbQueryField.convertToBaseType(host),
      'href': DbQueryField.convertToBaseType(href),
      'desc': DbQueryField.convertToBaseType(desc),
      'state': DbQueryField.convertToBaseType(state),
      'customType': DbQueryField.convertToBaseType(customType),
    };
  }

  @override
  Map<String, dynamic> toKValues() {
    return {
      '_id': _id,
      '_bsid': _bsid,
      '_time': _time,
      '_extra': _extra,
      'uid': uid,
      'rid': rid,
      'type': type,
      'image': image,
      'host': host,
      'href': href,
      'desc': desc,
      'state': state,
      'customType': customType,
    };
  }

  @override
  void updateByJson(Map<String, dynamic> map, {LogReport? parser}) {
    parser = parser ?? LogReport.fromJson(map);
    if (map.containsKey('_id')) _id = parser._id;
    if (map.containsKey('_bsid')) _bsid = parser._bsid;
    if (map.containsKey('_time')) _time = parser._time;
    if (map.containsKey('_extra')) _extra = parser._extra;
    if (map.containsKey('uid')) uid = parser.uid;
    if (map.containsKey('rid')) rid = parser.rid;
    if (map.containsKey('type')) type = parser.type;
    if (map.containsKey('image')) image = parser.image;
    if (map.containsKey('host')) host = parser.host;
    if (map.containsKey('href')) href = parser.href;
    if (map.containsKey('desc')) desc = parser.desc;
    if (map.containsKey('state')) state = parser.state;
    if (map.containsKey('customType')) customType = parser.customType;
  }

  @override
  void updateByKValues(Map<String, dynamic> map) {
    if (map.containsKey('_id')) _id = map['_id'];
    if (map.containsKey('_bsid')) _bsid = map['_bsid'];
    if (map.containsKey('_time')) _time = map['_time'];
    if (map.containsKey('_extra')) _extra = map['_extra'];
    if (map.containsKey('uid')) uid = map['uid'];
    if (map.containsKey('rid')) rid = map['rid'];
    if (map.containsKey('type')) type = map['type'];
    if (map.containsKey('image')) image = map['image'];
    if (map.containsKey('host')) host = map['host'];
    if (map.containsKey('href')) href = map['href'];
    if (map.containsKey('desc')) desc = map['desc'];
    if (map.containsKey('state')) state = map['state'];
    if (map.containsKey('customType')) customType = map['customType'];
  }
}

class LogReportDirty {
  final Map<String, dynamic> data = {};

  ///唯一id
  set id(ObjectId value) => data['_id'] = DbQueryField.convertToBaseType(value);

  ///商户id
  set bsid(ObjectId value) => data['_bsid'] = DbQueryField.convertToBaseType(value);

  ///创建时间
  set time(int value) => data['_time'] = DbQueryField.convertToBaseType(value);

  ///自定义数据
  set extra(DbJsonWraper value) => data['_extra'] = DbQueryField.convertToBaseType(value);

  ///所属用户id
  set uid(ObjectId value) => data['uid'] = DbQueryField.convertToBaseType(value);

  ///投诉目标id
  set rid(ObjectId value) => data['rid'] = DbQueryField.convertToBaseType(value);

  ///投诉目标类型
  set type(int value) => data['type'] = DbQueryField.convertToBaseType(value);

  ///投诉目标截图
  set image(String value) => data['image'] = DbQueryField.convertToBaseType(value);

  ///投诉目标域名
  set host(String value) => data['host'] = DbQueryField.convertToBaseType(value);

  ///投诉目标网址
  set href(String value) => data['href'] = DbQueryField.convertToBaseType(value);

  ///投诉原因
  set desc(String value) => data['desc'] = DbQueryField.convertToBaseType(value);

  ///投诉状态
  set state(int value) => data['state'] = DbQueryField.convertToBaseType(value);

  ///自定义的投诉目标类型
  set customType(int value) => data['customType'] = DbQueryField.convertToBaseType(value);
}
