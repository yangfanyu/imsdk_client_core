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

  ///未完成的事务列表
  List<ObjectId> _trans;

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

  ///未完成的事务列表
  List<ObjectId> get trans => _trans;

  LogReport({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    DbJsonWraper? extra,
    List<ObjectId>? trans,
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
        _trans = trans ?? [],
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
      id: DbQueryField.tryParseObjectId(map['_id']),
      bsid: DbQueryField.tryParseObjectId(map['_bsid']),
      time: DbQueryField.tryParseInt(map['_time']),
      extra: map['_extra'] is Map ? DbJsonWraper.fromJson(map['_extra']) : map['_extra'],
      trans: (map['_trans'] as List?)?.map((v) => DbQueryField.parseObjectId(v)).toList(),
      uid: DbQueryField.tryParseObjectId(map['uid']),
      rid: DbQueryField.tryParseObjectId(map['rid']),
      type: DbQueryField.tryParseInt(map['type']),
      image: DbQueryField.tryParseString(map['image']),
      host: DbQueryField.tryParseString(map['host']),
      href: DbQueryField.tryParseString(map['href']),
      desc: DbQueryField.tryParseString(map['desc']),
      state: DbQueryField.tryParseInt(map['state']),
      customType: DbQueryField.tryParseInt(map['customType']),
    );
  }

  @override
  String toString() {
    return 'LogReport(${jsonEncode(toJson())})';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': DbQueryField.toBaseType(_id),
      '_bsid': DbQueryField.toBaseType(_bsid),
      '_time': DbQueryField.toBaseType(_time),
      '_extra': DbQueryField.toBaseType(_extra),
      '_trans': DbQueryField.toBaseType(_trans),
      'uid': DbQueryField.toBaseType(uid),
      'rid': DbQueryField.toBaseType(rid),
      'type': DbQueryField.toBaseType(type),
      'image': DbQueryField.toBaseType(image),
      'host': DbQueryField.toBaseType(host),
      'href': DbQueryField.toBaseType(href),
      'desc': DbQueryField.toBaseType(desc),
      'state': DbQueryField.toBaseType(state),
      'customType': DbQueryField.toBaseType(customType),
    };
  }

  @override
  Map<String, dynamic> toKValues() {
    return {
      '_id': _id,
      '_bsid': _bsid,
      '_time': _time,
      '_extra': _extra,
      '_trans': _trans,
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
    if (map.containsKey('_trans')) _trans = parser._trans;
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
    if (map.containsKey('_trans')) _trans = map['_trans'];
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
  set id(ObjectId value) => data['_id'] = DbQueryField.toBaseType(value);

  ///商户id
  set bsid(ObjectId value) => data['_bsid'] = DbQueryField.toBaseType(value);

  ///创建时间
  set time(int value) => data['_time'] = DbQueryField.toBaseType(value);

  ///自定义数据
  set extra(DbJsonWraper value) => data['_extra'] = DbQueryField.toBaseType(value);

  ///未完成的事务列表
  set trans(List<ObjectId> value) => data['_trans'] = DbQueryField.toBaseType(value);

  ///所属用户id
  set uid(ObjectId value) => data['uid'] = DbQueryField.toBaseType(value);

  ///投诉目标id
  set rid(ObjectId value) => data['rid'] = DbQueryField.toBaseType(value);

  ///投诉目标类型
  set type(int value) => data['type'] = DbQueryField.toBaseType(value);

  ///投诉目标截图
  set image(String value) => data['image'] = DbQueryField.toBaseType(value);

  ///投诉目标域名
  set host(String value) => data['host'] = DbQueryField.toBaseType(value);

  ///投诉目标网址
  set href(String value) => data['href'] = DbQueryField.toBaseType(value);

  ///投诉原因
  set desc(String value) => data['desc'] = DbQueryField.toBaseType(value);

  ///投诉状态
  set state(int value) => data['state'] = DbQueryField.toBaseType(value);

  ///自定义的投诉目标类型
  set customType(int value) => data['customType'] = DbQueryField.toBaseType(value);
}
