import 'package:shelf_easy/shelf_easy.dart';

///
///自定义标记
///
class Cusmark extends DbBaseModel {
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

  ///关联数据id
  ObjectId rid;

  ///关联数据打分
  double score;

  ///唯一id
  ObjectId get id => _id;

  ///商户id
  ObjectId get bsid => _bsid;

  ///创建时间
  int get time => _time;

  ///自定义数据
  DbJsonWraper get extra => _extra;

  Cusmark({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    DbJsonWraper? extra,
    ObjectId? uid,
    ObjectId? rid,
    double? score,
  })  : _id = id ?? ObjectId(),
        _bsid = bsid ?? ObjectId.fromHexString('000000000000000000000000'),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? DbJsonWraper(),
        uid = uid ?? ObjectId.fromHexString('000000000000000000000000'),
        rid = rid ?? ObjectId.fromHexString('000000000000000000000000'),
        score = score ?? 0;

  factory Cusmark.fromString(String data) {
    return Cusmark.fromJson(jsonDecode(data.substring(data.indexOf('(') + 1, data.lastIndexOf(')'))));
  }

  factory Cusmark.fromJson(Map<String, dynamic> map) {
    return Cusmark(
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      bsid: map['_bsid'] is String ? ObjectId.fromHexString(map['_bsid']) : map['_bsid'],
      time: map['_time'],
      extra: map['_extra'] is Map ? DbJsonWraper.fromJson(map['_extra']) : map['_extra'],
      uid: map['uid'] is String ? ObjectId.fromHexString(map['uid']) : map['uid'],
      rid: map['rid'] is String ? ObjectId.fromHexString(map['rid']) : map['rid'],
      score: map['score'],
    );
  }

  @override
  String toString() {
    return 'Cusmark(${jsonEncode(toJson())})';
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
      'score': DbQueryField.convertToBaseType(score),
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
      'score': score,
    };
  }

  @override
  void updateByJson(Map<String, dynamic> map, {Cusmark? parser}) {
    parser = parser ?? Cusmark.fromJson(map);
    if (map.containsKey('_id')) _id = parser._id;
    if (map.containsKey('_bsid')) _bsid = parser._bsid;
    if (map.containsKey('_time')) _time = parser._time;
    if (map.containsKey('_extra')) _extra = parser._extra;
    if (map.containsKey('uid')) uid = parser.uid;
    if (map.containsKey('rid')) rid = parser.rid;
    if (map.containsKey('score')) score = parser.score;
  }

  @override
  void updateByKValues(Map<String, dynamic> map) {
    if (map.containsKey('_id')) _id = map['_id'];
    if (map.containsKey('_bsid')) _bsid = map['_bsid'];
    if (map.containsKey('_time')) _time = map['_time'];
    if (map.containsKey('_extra')) _extra = map['_extra'];
    if (map.containsKey('uid')) uid = map['uid'];
    if (map.containsKey('rid')) rid = map['rid'];
    if (map.containsKey('score')) score = map['score'];
  }
}

class CusmarkDirty {
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

  ///关联数据id
  set rid(ObjectId value) => data['rid'] = DbQueryField.convertToBaseType(value);

  ///关联数据打分
  set score(double value) => data['score'] = DbQueryField.convertToBaseType(value);
}
