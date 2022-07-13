import 'package:shelf_easy/shelf_easy.dart';

///
///异常日志
///
class LogError extends DbBaseModel {
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

  ///客户端版本号
  int clientVersion;

  ///设备系统类型
  String deviceType;

  ///设备系统版本
  String deviceVersion;

  ///设备详细信息
  DbJsonWraper deviceDetail;

  ///异常详细信息
  DbJsonWraper errorDetail;

  ///异常产生时间
  int errorTime;

  ///异常是否解决
  bool finished;

  ///唯一id
  ObjectId get id => _id;

  ///商户id
  ObjectId get bsid => _bsid;

  ///创建时间
  int get time => _time;

  ///自定义数据
  DbJsonWraper get extra => _extra;

  LogError({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    DbJsonWraper? extra,
    ObjectId? uid,
    int? clientVersion,
    String? deviceType,
    String? deviceVersion,
    DbJsonWraper? deviceDetail,
    DbJsonWraper? errorDetail,
    int? errorTime,
    bool? finished,
  })  : _id = id ?? ObjectId(),
        _bsid = bsid ?? ObjectId.fromHexString('000000000000000000000000'),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? DbJsonWraper(),
        uid = uid ?? ObjectId.fromHexString('000000000000000000000000'),
        clientVersion = clientVersion ?? 0,
        deviceType = deviceType ?? '',
        deviceVersion = deviceVersion ?? '',
        deviceDetail = deviceDetail ?? DbJsonWraper(),
        errorDetail = errorDetail ?? DbJsonWraper(),
        errorTime = errorTime ?? 0,
        finished = finished ?? false;

  factory LogError.fromString(String data) {
    return LogError.fromJson(jsonDecode(data.substring(data.indexOf('(') + 1, data.lastIndexOf(')'))));
  }

  factory LogError.fromJson(Map<String, dynamic> map) {
    return LogError(
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      bsid: map['_bsid'] is String ? ObjectId.fromHexString(map['_bsid']) : map['_bsid'],
      time: map['_time'],
      extra: map['_extra'] is Map ? DbJsonWraper.fromJson(map['_extra']) : map['_extra'],
      uid: map['uid'] is String ? ObjectId.fromHexString(map['uid']) : map['uid'],
      clientVersion: map['clientVersion'],
      deviceType: map['deviceType'],
      deviceVersion: map['deviceVersion'],
      deviceDetail: map['deviceDetail'] is Map ? DbJsonWraper.fromJson(map['deviceDetail']) : map['deviceDetail'],
      errorDetail: map['errorDetail'] is Map ? DbJsonWraper.fromJson(map['errorDetail']) : map['errorDetail'],
      errorTime: map['errorTime'],
      finished: map['finished'],
    );
  }

  @override
  String toString() {
    return 'LogError(${jsonEncode(toJson())})';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': DbQueryField.convertToBaseType(_id),
      '_bsid': DbQueryField.convertToBaseType(_bsid),
      '_time': DbQueryField.convertToBaseType(_time),
      '_extra': DbQueryField.convertToBaseType(_extra),
      'uid': DbQueryField.convertToBaseType(uid),
      'clientVersion': DbQueryField.convertToBaseType(clientVersion),
      'deviceType': DbQueryField.convertToBaseType(deviceType),
      'deviceVersion': DbQueryField.convertToBaseType(deviceVersion),
      'deviceDetail': DbQueryField.convertToBaseType(deviceDetail),
      'errorDetail': DbQueryField.convertToBaseType(errorDetail),
      'errorTime': DbQueryField.convertToBaseType(errorTime),
      'finished': DbQueryField.convertToBaseType(finished),
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
      'clientVersion': clientVersion,
      'deviceType': deviceType,
      'deviceVersion': deviceVersion,
      'deviceDetail': deviceDetail,
      'errorDetail': errorDetail,
      'errorTime': errorTime,
      'finished': finished,
    };
  }

  @override
  void updateByJson(Map<String, dynamic> map, {LogError? parser}) {
    parser = parser ?? LogError.fromJson(map);
    if (map.containsKey('_id')) _id = parser._id;
    if (map.containsKey('_bsid')) _bsid = parser._bsid;
    if (map.containsKey('_time')) _time = parser._time;
    if (map.containsKey('_extra')) _extra = parser._extra;
    if (map.containsKey('uid')) uid = parser.uid;
    if (map.containsKey('clientVersion')) clientVersion = parser.clientVersion;
    if (map.containsKey('deviceType')) deviceType = parser.deviceType;
    if (map.containsKey('deviceVersion')) deviceVersion = parser.deviceVersion;
    if (map.containsKey('deviceDetail')) deviceDetail = parser.deviceDetail;
    if (map.containsKey('errorDetail')) errorDetail = parser.errorDetail;
    if (map.containsKey('errorTime')) errorTime = parser.errorTime;
    if (map.containsKey('finished')) finished = parser.finished;
  }

  @override
  void updateByKValues(Map<String, dynamic> map) {
    if (map.containsKey('_id')) _id = map['_id'];
    if (map.containsKey('_bsid')) _bsid = map['_bsid'];
    if (map.containsKey('_time')) _time = map['_time'];
    if (map.containsKey('_extra')) _extra = map['_extra'];
    if (map.containsKey('uid')) uid = map['uid'];
    if (map.containsKey('clientVersion')) clientVersion = map['clientVersion'];
    if (map.containsKey('deviceType')) deviceType = map['deviceType'];
    if (map.containsKey('deviceVersion')) deviceVersion = map['deviceVersion'];
    if (map.containsKey('deviceDetail')) deviceDetail = map['deviceDetail'];
    if (map.containsKey('errorDetail')) errorDetail = map['errorDetail'];
    if (map.containsKey('errorTime')) errorTime = map['errorTime'];
    if (map.containsKey('finished')) finished = map['finished'];
  }
}

class LogErrorDirty {
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

  ///客户端版本号
  set clientVersion(int value) => data['clientVersion'] = DbQueryField.convertToBaseType(value);

  ///设备系统类型
  set deviceType(String value) => data['deviceType'] = DbQueryField.convertToBaseType(value);

  ///设备系统版本
  set deviceVersion(String value) => data['deviceVersion'] = DbQueryField.convertToBaseType(value);

  ///设备详细信息
  set deviceDetail(DbJsonWraper value) => data['deviceDetail'] = DbQueryField.convertToBaseType(value);

  ///异常详细信息
  set errorDetail(DbJsonWraper value) => data['errorDetail'] = DbQueryField.convertToBaseType(value);

  ///异常产生时间
  set errorTime(int value) => data['errorTime'] = DbQueryField.convertToBaseType(value);

  ///异常是否解决
  set finished(bool value) => data['finished'] = DbQueryField.convertToBaseType(value);
}
