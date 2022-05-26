import 'package:shelf_easy/shelf_easy.dart';

///
///验证码
///
class Randcode extends DbBaseModel {
  ///唯一id
  ObjectId _id;

  ///商户id
  ObjectId _bsid;

  ///创建时间
  int _time;

  ///自定义数据
  DbJsonWraper _extra;

  ///手机号码
  String phone;

  ///验证码
  String code;

  ///是否已失效
  bool expired;

  ///过期时间
  int timeout;

  ///检测次数
  int testcnt;

  ///唯一id
  ObjectId get id => _id;

  ///商户id
  ObjectId get bsid => _bsid;

  ///创建时间
  int get time => _time;

  ///自定义数据
  DbJsonWraper get extra => _extra;

  Randcode({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    DbJsonWraper? extra,
    String? phone,
    String? code,
    bool? expired,
    int? timeout,
    int? testcnt,
  })  : _id = id ?? ObjectId(),
        _bsid = bsid ?? ObjectId.fromHexString('000000000000000000000000'),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? DbJsonWraper(),
        phone = phone ?? '',
        code = code ?? '',
        expired = expired ?? false,
        timeout = timeout ?? 0,
        testcnt = testcnt ?? 0;

  factory Randcode.fromString(String data) {
    return Randcode.fromJson(jsonDecode(data.substring(data.indexOf('(') + 1, data.lastIndexOf(')'))));
  }

  factory Randcode.fromJson(Map<String, dynamic> map) {
    return Randcode(
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      bsid: map['_bsid'] is String ? ObjectId.fromHexString(map['_bsid']) : map['_bsid'],
      time: map['_time'],
      extra: map['_extra'] is Map ? DbJsonWraper.fromJson(map['_extra']) : map['_extra'],
      phone: map['phone'],
      code: map['code'],
      expired: map['expired'],
      timeout: map['timeout'],
      testcnt: map['testcnt'],
    );
  }

  @override
  String toString() {
    return 'Randcode(${jsonEncode(toJson())})';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': DbQueryField.convertToBaseType(_id),
      '_bsid': DbQueryField.convertToBaseType(_bsid),
      '_time': DbQueryField.convertToBaseType(_time),
      '_extra': DbQueryField.convertToBaseType(_extra),
      'phone': DbQueryField.convertToBaseType(phone),
      'code': DbQueryField.convertToBaseType(code),
      'expired': DbQueryField.convertToBaseType(expired),
      'timeout': DbQueryField.convertToBaseType(timeout),
      'testcnt': DbQueryField.convertToBaseType(testcnt),
    };
  }

  @override
  Map<String, dynamic> toKValues() {
    return {
      '_id': _id,
      '_bsid': _bsid,
      '_time': _time,
      '_extra': _extra,
      'phone': phone,
      'code': code,
      'expired': expired,
      'timeout': timeout,
      'testcnt': testcnt,
    };
  }

  @override
  void updateByJson(Map<String, dynamic> map, {Randcode? parser}) {
    parser = parser ?? Randcode.fromJson(map);
    if (map.containsKey('_id')) _id = parser._id;
    if (map.containsKey('_bsid')) _bsid = parser._bsid;
    if (map.containsKey('_time')) _time = parser._time;
    if (map.containsKey('_extra')) _extra = parser._extra;
    if (map.containsKey('phone')) phone = parser.phone;
    if (map.containsKey('code')) code = parser.code;
    if (map.containsKey('expired')) expired = parser.expired;
    if (map.containsKey('timeout')) timeout = parser.timeout;
    if (map.containsKey('testcnt')) testcnt = parser.testcnt;
  }

  @override
  void updateByKValues(Map<String, dynamic> map) {
    if (map.containsKey('_id')) _id = map['_id'];
    if (map.containsKey('_bsid')) _bsid = map['_bsid'];
    if (map.containsKey('_time')) _time = map['_time'];
    if (map.containsKey('_extra')) _extra = map['_extra'];
    if (map.containsKey('phone')) phone = map['phone'];
    if (map.containsKey('code')) code = map['code'];
    if (map.containsKey('expired')) expired = map['expired'];
    if (map.containsKey('timeout')) timeout = map['timeout'];
    if (map.containsKey('testcnt')) testcnt = map['testcnt'];
  }
}

class RandcodeDirty {
  final Map<String, dynamic> data = {};

  ///唯一id
  set id(ObjectId value) => data['_id'] = DbQueryField.convertToBaseType(value);

  ///商户id
  set bsid(ObjectId value) => data['_bsid'] = DbQueryField.convertToBaseType(value);

  ///创建时间
  set time(int value) => data['_time'] = DbQueryField.convertToBaseType(value);

  ///自定义数据
  set extra(DbJsonWraper value) => data['_extra'] = DbQueryField.convertToBaseType(value);

  ///手机号码
  set phone(String value) => data['phone'] = DbQueryField.convertToBaseType(value);

  ///验证码
  set code(String value) => data['code'] = DbQueryField.convertToBaseType(value);

  ///是否已失效
  set expired(bool value) => data['expired'] = DbQueryField.convertToBaseType(value);

  ///过期时间
  set timeout(int value) => data['timeout'] = DbQueryField.convertToBaseType(value);

  ///检测次数
  set testcnt(int value) => data['testcnt'] = DbQueryField.convertToBaseType(value);
}
