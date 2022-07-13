import 'package:shelf_easy/shelf_easy.dart';
import 'cusmark.dart';
import 'cusstar.dart';

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

  ///关联标志索引1
  ObjectId rid1;

  ///关联标志索引2
  ObjectId rid2;

  ///关联标志索引3
  ObjectId rid3;

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

  ///数据内容1
  DbJsonWraper body1;

  ///数据内容2
  DbJsonWraper body2;

  ///数据内容3
  DbJsonWraper body3;

  ///数据状态1
  int state1;

  ///数据状态2
  int state2;

  ///数据状态3
  int state3;

  ///最近更新时间
  int update;

  ///平局得分（每个用户打分一次）
  double score;

  ///总标记数（每个用户标记一次）
  int mark;

  ///总收藏数（每个用户收藏一次）
  int star;

  ///整数增减量1（增减单位为1）
  int hot1;

  ///整数增减量2（增减单位为1）
  int hot2;

  ///整数增减量x（增减单位为x）
  int hotx;

  ///子customx.rid1为本customx.id的子customx数量
  int cnt1;

  ///子customx.rid2为本customx.id的子customx数量
  int cnt2;

  ///子customx.rid3为本customx.id的子customx数量
  int cnt3;

  ///唯一id
  ObjectId get id => _id;

  ///商户id
  ObjectId get bsid => _bsid;

  ///创建时间
  int get time => _time;

  ///自定义数据
  DbJsonWraper get extra => _extra;

  ///
  ///关联的自定义标记对象
  ///
  Cusmark? cusmark;

  ///
  ///关联的自定义收藏对象
  ///
  Cusstar? cusstar;

  CustomX({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    DbJsonWraper? extra,
    ObjectId? uid,
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
    int? update,
    double? score,
    int? mark,
    int? star,
    int? hot1,
    int? hot2,
    int? hotx,
    int? cnt1,
    int? cnt2,
    int? cnt3,
  })  : _id = id ?? ObjectId(),
        _bsid = bsid ?? ObjectId.fromHexString('000000000000000000000000'),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? DbJsonWraper(),
        uid = uid ?? ObjectId.fromHexString('000000000000000000000000'),
        rid1 = rid1 ?? ObjectId.fromHexString('000000000000000000000000'),
        rid2 = rid2 ?? ObjectId.fromHexString('000000000000000000000000'),
        rid3 = rid3 ?? ObjectId.fromHexString('000000000000000000000000'),
        int1 = int1 ?? 0,
        int2 = int2 ?? 0,
        int3 = int3 ?? 0,
        str1 = str1 ?? '',
        str2 = str2 ?? '',
        str3 = str3 ?? '',
        body1 = body1 ?? DbJsonWraper(),
        body2 = body2 ?? DbJsonWraper(),
        body3 = body3 ?? DbJsonWraper(),
        state1 = state1 ?? 0,
        state2 = state2 ?? 0,
        state3 = state3 ?? 0,
        update = update ?? DateTime.now().millisecondsSinceEpoch,
        score = score ?? 0,
        mark = mark ?? 0,
        star = star ?? 0,
        hot1 = hot1 ?? 0,
        hot2 = hot2 ?? 0,
        hotx = hotx ?? 0,
        cnt1 = cnt1 ?? 0,
        cnt2 = cnt2 ?? 0,
        cnt3 = cnt3 ?? 0;

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
      rid1: map['rid1'] is String ? ObjectId.fromHexString(map['rid1']) : map['rid1'],
      rid2: map['rid2'] is String ? ObjectId.fromHexString(map['rid2']) : map['rid2'],
      rid3: map['rid3'] is String ? ObjectId.fromHexString(map['rid3']) : map['rid3'],
      int1: map['int1'],
      int2: map['int2'],
      int3: map['int3'],
      str1: map['str1'],
      str2: map['str2'],
      str3: map['str3'],
      body1: map['body1'] is Map ? DbJsonWraper.fromJson(map['body1']) : map['body1'],
      body2: map['body2'] is Map ? DbJsonWraper.fromJson(map['body2']) : map['body2'],
      body3: map['body3'] is Map ? DbJsonWraper.fromJson(map['body3']) : map['body3'],
      state1: map['state1'],
      state2: map['state2'],
      state3: map['state3'],
      update: map['update'],
      score: map['score'],
      mark: map['mark'],
      star: map['star'],
      hot1: map['hot1'],
      hot2: map['hot2'],
      hotx: map['hotx'],
      cnt1: map['cnt1'],
      cnt2: map['cnt2'],
      cnt3: map['cnt3'],
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
      'rid1': DbQueryField.convertToBaseType(rid1),
      'rid2': DbQueryField.convertToBaseType(rid2),
      'rid3': DbQueryField.convertToBaseType(rid3),
      'int1': DbQueryField.convertToBaseType(int1),
      'int2': DbQueryField.convertToBaseType(int2),
      'int3': DbQueryField.convertToBaseType(int3),
      'str1': DbQueryField.convertToBaseType(str1),
      'str2': DbQueryField.convertToBaseType(str2),
      'str3': DbQueryField.convertToBaseType(str3),
      'body1': DbQueryField.convertToBaseType(body1),
      'body2': DbQueryField.convertToBaseType(body2),
      'body3': DbQueryField.convertToBaseType(body3),
      'state1': DbQueryField.convertToBaseType(state1),
      'state2': DbQueryField.convertToBaseType(state2),
      'state3': DbQueryField.convertToBaseType(state3),
      'update': DbQueryField.convertToBaseType(update),
      'score': DbQueryField.convertToBaseType(score),
      'mark': DbQueryField.convertToBaseType(mark),
      'star': DbQueryField.convertToBaseType(star),
      'hot1': DbQueryField.convertToBaseType(hot1),
      'hot2': DbQueryField.convertToBaseType(hot2),
      'hotx': DbQueryField.convertToBaseType(hotx),
      'cnt1': DbQueryField.convertToBaseType(cnt1),
      'cnt2': DbQueryField.convertToBaseType(cnt2),
      'cnt3': DbQueryField.convertToBaseType(cnt3),
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
      'rid1': rid1,
      'rid2': rid2,
      'rid3': rid3,
      'int1': int1,
      'int2': int2,
      'int3': int3,
      'str1': str1,
      'str2': str2,
      'str3': str3,
      'body1': body1,
      'body2': body2,
      'body3': body3,
      'state1': state1,
      'state2': state2,
      'state3': state3,
      'update': update,
      'score': score,
      'mark': mark,
      'star': star,
      'hot1': hot1,
      'hot2': hot2,
      'hotx': hotx,
      'cnt1': cnt1,
      'cnt2': cnt2,
      'cnt3': cnt3,
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
    if (map.containsKey('rid1')) rid1 = parser.rid1;
    if (map.containsKey('rid2')) rid2 = parser.rid2;
    if (map.containsKey('rid3')) rid3 = parser.rid3;
    if (map.containsKey('int1')) int1 = parser.int1;
    if (map.containsKey('int2')) int2 = parser.int2;
    if (map.containsKey('int3')) int3 = parser.int3;
    if (map.containsKey('str1')) str1 = parser.str1;
    if (map.containsKey('str2')) str2 = parser.str2;
    if (map.containsKey('str3')) str3 = parser.str3;
    if (map.containsKey('body1')) body1 = parser.body1;
    if (map.containsKey('body2')) body2 = parser.body2;
    if (map.containsKey('body3')) body3 = parser.body3;
    if (map.containsKey('state1')) state1 = parser.state1;
    if (map.containsKey('state2')) state2 = parser.state2;
    if (map.containsKey('state3')) state3 = parser.state3;
    if (map.containsKey('update')) update = parser.update;
    if (map.containsKey('score')) score = parser.score;
    if (map.containsKey('mark')) mark = parser.mark;
    if (map.containsKey('star')) star = parser.star;
    if (map.containsKey('hot1')) hot1 = parser.hot1;
    if (map.containsKey('hot2')) hot2 = parser.hot2;
    if (map.containsKey('hotx')) hotx = parser.hotx;
    if (map.containsKey('cnt1')) cnt1 = parser.cnt1;
    if (map.containsKey('cnt2')) cnt2 = parser.cnt2;
    if (map.containsKey('cnt3')) cnt3 = parser.cnt3;
  }

  @override
  void updateByKValues(Map<String, dynamic> map) {
    if (map.containsKey('_id')) _id = map['_id'];
    if (map.containsKey('_bsid')) _bsid = map['_bsid'];
    if (map.containsKey('_time')) _time = map['_time'];
    if (map.containsKey('_extra')) _extra = map['_extra'];
    if (map.containsKey('uid')) uid = map['uid'];
    if (map.containsKey('rid1')) rid1 = map['rid1'];
    if (map.containsKey('rid2')) rid2 = map['rid2'];
    if (map.containsKey('rid3')) rid3 = map['rid3'];
    if (map.containsKey('int1')) int1 = map['int1'];
    if (map.containsKey('int2')) int2 = map['int2'];
    if (map.containsKey('int3')) int3 = map['int3'];
    if (map.containsKey('str1')) str1 = map['str1'];
    if (map.containsKey('str2')) str2 = map['str2'];
    if (map.containsKey('str3')) str3 = map['str3'];
    if (map.containsKey('body1')) body1 = map['body1'];
    if (map.containsKey('body2')) body2 = map['body2'];
    if (map.containsKey('body3')) body3 = map['body3'];
    if (map.containsKey('state1')) state1 = map['state1'];
    if (map.containsKey('state2')) state2 = map['state2'];
    if (map.containsKey('state3')) state3 = map['state3'];
    if (map.containsKey('update')) update = map['update'];
    if (map.containsKey('score')) score = map['score'];
    if (map.containsKey('mark')) mark = map['mark'];
    if (map.containsKey('star')) star = map['star'];
    if (map.containsKey('hot1')) hot1 = map['hot1'];
    if (map.containsKey('hot2')) hot2 = map['hot2'];
    if (map.containsKey('hotx')) hotx = map['hotx'];
    if (map.containsKey('cnt1')) cnt1 = map['cnt1'];
    if (map.containsKey('cnt2')) cnt2 = map['cnt2'];
    if (map.containsKey('cnt3')) cnt3 = map['cnt3'];
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

  ///关联标志索引1
  set rid1(ObjectId value) => data['rid1'] = DbQueryField.convertToBaseType(value);

  ///关联标志索引2
  set rid2(ObjectId value) => data['rid2'] = DbQueryField.convertToBaseType(value);

  ///关联标志索引3
  set rid3(ObjectId value) => data['rid3'] = DbQueryField.convertToBaseType(value);

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

  ///数据内容1
  set body1(DbJsonWraper value) => data['body1'] = DbQueryField.convertToBaseType(value);

  ///数据内容2
  set body2(DbJsonWraper value) => data['body2'] = DbQueryField.convertToBaseType(value);

  ///数据内容3
  set body3(DbJsonWraper value) => data['body3'] = DbQueryField.convertToBaseType(value);

  ///数据状态1
  set state1(int value) => data['state1'] = DbQueryField.convertToBaseType(value);

  ///数据状态2
  set state2(int value) => data['state2'] = DbQueryField.convertToBaseType(value);

  ///数据状态3
  set state3(int value) => data['state3'] = DbQueryField.convertToBaseType(value);

  ///最近更新时间
  set update(int value) => data['update'] = DbQueryField.convertToBaseType(value);

  ///平局得分（每个用户打分一次）
  set score(double value) => data['score'] = DbQueryField.convertToBaseType(value);

  ///总标记数（每个用户标记一次）
  set mark(int value) => data['mark'] = DbQueryField.convertToBaseType(value);

  ///总收藏数（每个用户收藏一次）
  set star(int value) => data['star'] = DbQueryField.convertToBaseType(value);

  ///整数增减量1（增减单位为1）
  set hot1(int value) => data['hot1'] = DbQueryField.convertToBaseType(value);

  ///整数增减量2（增减单位为1）
  set hot2(int value) => data['hot2'] = DbQueryField.convertToBaseType(value);

  ///整数增减量x（增减单位为x）
  set hotx(int value) => data['hotx'] = DbQueryField.convertToBaseType(value);

  ///子customx.rid1为本customx.id的子customx数量
  set cnt1(int value) => data['cnt1'] = DbQueryField.convertToBaseType(value);

  ///子customx.rid2为本customx.id的子customx数量
  set cnt2(int value) => data['cnt2'] = DbQueryField.convertToBaseType(value);

  ///子customx.rid3为本customx.id的子customx数量
  set cnt3(int value) => data['cnt3'] = DbQueryField.convertToBaseType(value);
}
