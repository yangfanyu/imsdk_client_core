import 'package:shelf_easy/shelf_easy.dart';
import 'cusmark.dart';

///
///自定义数据
///
class CustomX extends DbBaseModel {
  ///唯一id
  ObjectId _id;

  ///商户id
  ObjectId _bsid;

  ///创建时间
  int _time;

  ///自定义数据
  DbJsonWraper _extra;

  ///创建者标志
  ObjectId uid;

  ///整数索引1
  int int1;

  ///整数索引2
  int int2;

  ///整数索引3
  int int3;

  ///字符串索引1
  String str1;

  ///字符串索引2
  String str2;

  ///字符串索引3
  String str3;

  ///关联标志索引1
  ObjectId rid1;

  ///关联标志索引2
  ObjectId rid2;

  ///关联标志索引3
  ObjectId rid3;

  ///整数增减量1（增减单位为1）
  int hot1;

  ///整数增减量2（增减单位为1）
  int hot2;

  ///整数增减量x（增减单位为x）
  int hotx;

  ///数据内容
  DbJsonWraper body;

  ///最近更新时间
  int update;

  ///平局得分（每个用户打分一次）
  double score;

  ///总标记数（每个用户标记一次）
  int mark;

  ///唯一id
  ObjectId get id => _id;

  ///商户id
  ObjectId get bsid => _bsid;

  ///创建时间
  int get time => _time;

  ///自定义数据
  DbJsonWraper get extra => _extra;

  ///
  ///消息发送者展示的头像
  ///
  Cusmark? cusmark;

  CustomX({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    DbJsonWraper? extra,
    ObjectId? uid,
    int? int1,
    int? int2,
    int? int3,
    String? str1,
    String? str2,
    String? str3,
    ObjectId? rid1,
    ObjectId? rid2,
    ObjectId? rid3,
    int? hot1,
    int? hot2,
    int? hotx,
    DbJsonWraper? body,
    int? update,
    double? score,
    int? mark,
  })  : _id = id ?? ObjectId(),
        _bsid = bsid ?? ObjectId.fromHexString('000000000000000000000000'),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? DbJsonWraper(),
        uid = uid ?? ObjectId.fromHexString('000000000000000000000000'),
        int1 = int1 ?? 0,
        int2 = int2 ?? 0,
        int3 = int3 ?? 0,
        str1 = str1 ?? '',
        str2 = str2 ?? '',
        str3 = str3 ?? '',
        rid1 = rid1 ?? ObjectId.fromHexString('000000000000000000000000'),
        rid2 = rid2 ?? ObjectId.fromHexString('000000000000000000000000'),
        rid3 = rid3 ?? ObjectId.fromHexString('000000000000000000000000'),
        hot1 = hot1 ?? 0,
        hot2 = hot2 ?? 0,
        hotx = hotx ?? 0,
        body = body ?? DbJsonWraper(),
        update = update ?? DateTime.now().millisecondsSinceEpoch,
        score = score ?? 0,
        mark = mark ?? 0;

  factory CustomX.fromString(String data) {
    return CustomX.fromJson(jsonDecode(data.substring(data.indexOf('(') + 1, data.lastIndexOf(')'))));
  }

  factory CustomX.fromJson(Map<String, dynamic> map) {
    return CustomX(
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      bsid: map['_bsid'] is String ? ObjectId.fromHexString(map['_bsid']) : map['_bsid'],
      time: map['_time'],
      extra: map['_extra'] is Map ? DbJsonWraper.fromJson(map['_extra']) : map['_extra'],
      uid: map['uid'] is String ? ObjectId.fromHexString(map['uid']) : map['uid'],
      int1: map['int1'],
      int2: map['int2'],
      int3: map['int3'],
      str1: map['str1'],
      str2: map['str2'],
      str3: map['str3'],
      rid1: map['rid1'] is String ? ObjectId.fromHexString(map['rid1']) : map['rid1'],
      rid2: map['rid2'] is String ? ObjectId.fromHexString(map['rid2']) : map['rid2'],
      rid3: map['rid3'] is String ? ObjectId.fromHexString(map['rid3']) : map['rid3'],
      hot1: map['hot1'],
      hot2: map['hot2'],
      hotx: map['hotx'],
      body: map['body'] is Map ? DbJsonWraper.fromJson(map['body']) : map['body'],
      update: map['update'],
      score: map['score'],
      mark: map['mark'],
    );
  }

  @override
  String toString() {
    return 'CustomX(${jsonEncode(toJson())})';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': DbQueryField.convertToBaseType(_id),
      '_bsid': DbQueryField.convertToBaseType(_bsid),
      '_time': DbQueryField.convertToBaseType(_time),
      '_extra': DbQueryField.convertToBaseType(_extra),
      'uid': DbQueryField.convertToBaseType(uid),
      'int1': DbQueryField.convertToBaseType(int1),
      'int2': DbQueryField.convertToBaseType(int2),
      'int3': DbQueryField.convertToBaseType(int3),
      'str1': DbQueryField.convertToBaseType(str1),
      'str2': DbQueryField.convertToBaseType(str2),
      'str3': DbQueryField.convertToBaseType(str3),
      'rid1': DbQueryField.convertToBaseType(rid1),
      'rid2': DbQueryField.convertToBaseType(rid2),
      'rid3': DbQueryField.convertToBaseType(rid3),
      'hot1': DbQueryField.convertToBaseType(hot1),
      'hot2': DbQueryField.convertToBaseType(hot2),
      'hotx': DbQueryField.convertToBaseType(hotx),
      'body': DbQueryField.convertToBaseType(body),
      'update': DbQueryField.convertToBaseType(update),
      'score': DbQueryField.convertToBaseType(score),
      'mark': DbQueryField.convertToBaseType(mark),
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
      'int1': int1,
      'int2': int2,
      'int3': int3,
      'str1': str1,
      'str2': str2,
      'str3': str3,
      'rid1': rid1,
      'rid2': rid2,
      'rid3': rid3,
      'hot1': hot1,
      'hot2': hot2,
      'hotx': hotx,
      'body': body,
      'update': update,
      'score': score,
      'mark': mark,
    };
  }

  @override
  void updateByJson(Map<String, dynamic> map, {CustomX? parser}) {
    parser = parser ?? CustomX.fromJson(map);
    if (map.containsKey('_id')) _id = parser._id;
    if (map.containsKey('_bsid')) _bsid = parser._bsid;
    if (map.containsKey('_time')) _time = parser._time;
    if (map.containsKey('_extra')) _extra = parser._extra;
    if (map.containsKey('uid')) uid = parser.uid;
    if (map.containsKey('int1')) int1 = parser.int1;
    if (map.containsKey('int2')) int2 = parser.int2;
    if (map.containsKey('int3')) int3 = parser.int3;
    if (map.containsKey('str1')) str1 = parser.str1;
    if (map.containsKey('str2')) str2 = parser.str2;
    if (map.containsKey('str3')) str3 = parser.str3;
    if (map.containsKey('rid1')) rid1 = parser.rid1;
    if (map.containsKey('rid2')) rid2 = parser.rid2;
    if (map.containsKey('rid3')) rid3 = parser.rid3;
    if (map.containsKey('hot1')) hot1 = parser.hot1;
    if (map.containsKey('hot2')) hot2 = parser.hot2;
    if (map.containsKey('hotx')) hotx = parser.hotx;
    if (map.containsKey('body')) body = parser.body;
    if (map.containsKey('update')) update = parser.update;
    if (map.containsKey('score')) score = parser.score;
    if (map.containsKey('mark')) mark = parser.mark;
  }

  @override
  void updateByKValues(Map<String, dynamic> map) {
    if (map.containsKey('_id')) _id = map['_id'];
    if (map.containsKey('_bsid')) _bsid = map['_bsid'];
    if (map.containsKey('_time')) _time = map['_time'];
    if (map.containsKey('_extra')) _extra = map['_extra'];
    if (map.containsKey('uid')) uid = map['uid'];
    if (map.containsKey('int1')) int1 = map['int1'];
    if (map.containsKey('int2')) int2 = map['int2'];
    if (map.containsKey('int3')) int3 = map['int3'];
    if (map.containsKey('str1')) str1 = map['str1'];
    if (map.containsKey('str2')) str2 = map['str2'];
    if (map.containsKey('str3')) str3 = map['str3'];
    if (map.containsKey('rid1')) rid1 = map['rid1'];
    if (map.containsKey('rid2')) rid2 = map['rid2'];
    if (map.containsKey('rid3')) rid3 = map['rid3'];
    if (map.containsKey('hot1')) hot1 = map['hot1'];
    if (map.containsKey('hot2')) hot2 = map['hot2'];
    if (map.containsKey('hotx')) hotx = map['hotx'];
    if (map.containsKey('body')) body = map['body'];
    if (map.containsKey('update')) update = map['update'];
    if (map.containsKey('score')) score = map['score'];
    if (map.containsKey('mark')) mark = map['mark'];
  }
}

class CustomXDirty {
  final Map<String, dynamic> data = {};

  ///唯一id
  set id(ObjectId value) => data['_id'] = DbQueryField.convertToBaseType(value);

  ///商户id
  set bsid(ObjectId value) => data['_bsid'] = DbQueryField.convertToBaseType(value);

  ///创建时间
  set time(int value) => data['_time'] = DbQueryField.convertToBaseType(value);

  ///自定义数据
  set extra(DbJsonWraper value) => data['_extra'] = DbQueryField.convertToBaseType(value);

  ///创建者标志
  set uid(ObjectId value) => data['uid'] = DbQueryField.convertToBaseType(value);

  ///整数索引1
  set int1(int value) => data['int1'] = DbQueryField.convertToBaseType(value);

  ///整数索引2
  set int2(int value) => data['int2'] = DbQueryField.convertToBaseType(value);

  ///整数索引3
  set int3(int value) => data['int3'] = DbQueryField.convertToBaseType(value);

  ///字符串索引1
  set str1(String value) => data['str1'] = DbQueryField.convertToBaseType(value);

  ///字符串索引2
  set str2(String value) => data['str2'] = DbQueryField.convertToBaseType(value);

  ///字符串索引3
  set str3(String value) => data['str3'] = DbQueryField.convertToBaseType(value);

  ///关联标志索引1
  set rid1(ObjectId value) => data['rid1'] = DbQueryField.convertToBaseType(value);

  ///关联标志索引2
  set rid2(ObjectId value) => data['rid2'] = DbQueryField.convertToBaseType(value);

  ///关联标志索引3
  set rid3(ObjectId value) => data['rid3'] = DbQueryField.convertToBaseType(value);

  ///整数增减量1（增减单位为1）
  set hot1(int value) => data['hot1'] = DbQueryField.convertToBaseType(value);

  ///整数增减量2（增减单位为1）
  set hot2(int value) => data['hot2'] = DbQueryField.convertToBaseType(value);

  ///整数增减量x（增减单位为x）
  set hotx(int value) => data['hotx'] = DbQueryField.convertToBaseType(value);

  ///数据内容
  set body(DbJsonWraper value) => data['body'] = DbQueryField.convertToBaseType(value);

  ///最近更新时间
  set update(int value) => data['update'] = DbQueryField.convertToBaseType(value);

  ///平局得分（每个用户打分一次）
  set score(double value) => data['score'] = DbQueryField.convertToBaseType(value);

  ///总标记数（每个用户标记一次）
  set mark(int value) => data['mark'] = DbQueryField.convertToBaseType(value);
}
