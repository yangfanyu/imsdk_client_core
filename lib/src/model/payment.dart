import 'package:shelf_easy/shelf_easy.dart';

///
///订单
///
class Payment extends DbBaseModel {
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

  ///订单类型
  int type;

  ///RMB金额（分）
  int rmbfen;

  ///商品信息
  String goods;

  ///第三方充值下单请求的数据
  String thirdSendData;

  ///第三方充值下单请求的结果
  String thirdSendResult;

  ///第三方充值成功收到的通知数据
  String thirdNotify;

  ///苹果内购充值的订单号
  String appleOrderNo;

  ///苹果内购充值验证凭据
  String appleSendData;

  ///苹果内购充值验证结果
  String appleSendResult;

  ///苹果内购充值验证次数
  int appleSendCount;

  ///发送红包、抢到红包、退回红包订单关联的聊天消息id
  ObjectId redpackMsgId;

  ///抢到红包关联的发送红包订单id、退回红包关联的发送红包订单id
  ObjectId redpackPayId;

  ///发送红包订单是否已完成退回检测
  bool redpackReturned;

  ///自定义的订单类型
  int customType;

  ///自定义订单验证数据
  String customValidData;

  ///自定义订单验证结果
  String customValidResult;

  ///自定义订单验证次数
  int customValidCount;

  ///订单完成时间
  int finishedTime;

  ///订单是否完成
  bool finished;

  ///唯一id
  ObjectId get id => _id;

  ///商户id
  ObjectId get bsid => _bsid;

  ///创建时间
  int get time => _time;

  ///自定义数据
  DbJsonWraper get extra => _extra;

  Payment({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    DbJsonWraper? extra,
    ObjectId? uid,
    int? type,
    int? rmbfen,
    String? goods,
    String? thirdSendData,
    String? thirdSendResult,
    String? thirdNotify,
    String? appleOrderNo,
    String? appleSendData,
    String? appleSendResult,
    int? appleSendCount,
    ObjectId? redpackMsgId,
    ObjectId? redpackPayId,
    bool? redpackReturned,
    int? customType,
    String? customValidData,
    String? customValidResult,
    int? customValidCount,
    int? finishedTime,
    bool? finished,
  })  : _id = id ?? ObjectId(),
        _bsid = bsid ?? ObjectId.fromHexString('000000000000000000000000'),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? DbJsonWraper(),
        uid = uid ?? ObjectId.fromHexString('000000000000000000000000'),
        type = type ?? 0,
        rmbfen = rmbfen ?? 0,
        goods = goods ?? '',
        thirdSendData = thirdSendData ?? '',
        thirdSendResult = thirdSendResult ?? '',
        thirdNotify = thirdNotify ?? '',
        appleOrderNo = appleOrderNo ?? '',
        appleSendData = appleSendData ?? '',
        appleSendResult = appleSendResult ?? '',
        appleSendCount = appleSendCount ?? 0,
        redpackMsgId = redpackMsgId ?? ObjectId.fromHexString('000000000000000000000000'),
        redpackPayId = redpackPayId ?? ObjectId.fromHexString('000000000000000000000000'),
        redpackReturned = redpackReturned ?? false,
        customType = customType ?? 0,
        customValidData = customValidData ?? '',
        customValidResult = customValidResult ?? '',
        customValidCount = customValidCount ?? 0,
        finishedTime = finishedTime ?? 0,
        finished = finished ?? false;

  factory Payment.fromString(String data) {
    return Payment.fromJson(jsonDecode(data.substring(data.indexOf('(') + 1, data.lastIndexOf(')'))));
  }

  factory Payment.fromJson(Map<String, dynamic> map) {
    return Payment(
      id: DbQueryField.tryParseObjectId(map['_id']),
      bsid: DbQueryField.tryParseObjectId(map['_bsid']),
      time: DbQueryField.tryParseInt(map['_time']),
      extra: map['_extra'] is Map ? DbJsonWraper.fromJson(map['_extra']) : map['_extra'],
      uid: DbQueryField.tryParseObjectId(map['uid']),
      type: DbQueryField.tryParseInt(map['type']),
      rmbfen: DbQueryField.tryParseInt(map['rmbfen']),
      goods: DbQueryField.tryParseString(map['goods']),
      thirdSendData: DbQueryField.tryParseString(map['thirdSendData']),
      thirdSendResult: DbQueryField.tryParseString(map['thirdSendResult']),
      thirdNotify: DbQueryField.tryParseString(map['thirdNotify']),
      appleOrderNo: DbQueryField.tryParseString(map['appleOrderNo']),
      appleSendData: DbQueryField.tryParseString(map['appleSendData']),
      appleSendResult: DbQueryField.tryParseString(map['appleSendResult']),
      appleSendCount: DbQueryField.tryParseInt(map['appleSendCount']),
      redpackMsgId: DbQueryField.tryParseObjectId(map['redpackMsgId']),
      redpackPayId: DbQueryField.tryParseObjectId(map['redpackPayId']),
      redpackReturned: DbQueryField.tryParseBool(map['redpackReturned']),
      customType: DbQueryField.tryParseInt(map['customType']),
      customValidData: DbQueryField.tryParseString(map['customValidData']),
      customValidResult: DbQueryField.tryParseString(map['customValidResult']),
      customValidCount: DbQueryField.tryParseInt(map['customValidCount']),
      finishedTime: DbQueryField.tryParseInt(map['finishedTime']),
      finished: DbQueryField.tryParseBool(map['finished']),
    );
  }

  @override
  String toString() {
    return 'Payment(${jsonEncode(toJson())})';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': DbQueryField.toBaseType(_id),
      '_bsid': DbQueryField.toBaseType(_bsid),
      '_time': DbQueryField.toBaseType(_time),
      '_extra': DbQueryField.toBaseType(_extra),
      'uid': DbQueryField.toBaseType(uid),
      'type': DbQueryField.toBaseType(type),
      'rmbfen': DbQueryField.toBaseType(rmbfen),
      'goods': DbQueryField.toBaseType(goods),
      'thirdSendData': DbQueryField.toBaseType(thirdSendData),
      'thirdSendResult': DbQueryField.toBaseType(thirdSendResult),
      'thirdNotify': DbQueryField.toBaseType(thirdNotify),
      'appleOrderNo': DbQueryField.toBaseType(appleOrderNo),
      'appleSendData': DbQueryField.toBaseType(appleSendData),
      'appleSendResult': DbQueryField.toBaseType(appleSendResult),
      'appleSendCount': DbQueryField.toBaseType(appleSendCount),
      'redpackMsgId': DbQueryField.toBaseType(redpackMsgId),
      'redpackPayId': DbQueryField.toBaseType(redpackPayId),
      'redpackReturned': DbQueryField.toBaseType(redpackReturned),
      'customType': DbQueryField.toBaseType(customType),
      'customValidData': DbQueryField.toBaseType(customValidData),
      'customValidResult': DbQueryField.toBaseType(customValidResult),
      'customValidCount': DbQueryField.toBaseType(customValidCount),
      'finishedTime': DbQueryField.toBaseType(finishedTime),
      'finished': DbQueryField.toBaseType(finished),
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
      'type': type,
      'rmbfen': rmbfen,
      'goods': goods,
      'thirdSendData': thirdSendData,
      'thirdSendResult': thirdSendResult,
      'thirdNotify': thirdNotify,
      'appleOrderNo': appleOrderNo,
      'appleSendData': appleSendData,
      'appleSendResult': appleSendResult,
      'appleSendCount': appleSendCount,
      'redpackMsgId': redpackMsgId,
      'redpackPayId': redpackPayId,
      'redpackReturned': redpackReturned,
      'customType': customType,
      'customValidData': customValidData,
      'customValidResult': customValidResult,
      'customValidCount': customValidCount,
      'finishedTime': finishedTime,
      'finished': finished,
    };
  }

  @override
  void updateByJson(Map<String, dynamic> map, {Payment? parser}) {
    parser = parser ?? Payment.fromJson(map);
    if (map.containsKey('_id')) _id = parser._id;
    if (map.containsKey('_bsid')) _bsid = parser._bsid;
    if (map.containsKey('_time')) _time = parser._time;
    if (map.containsKey('_extra')) _extra = parser._extra;
    if (map.containsKey('uid')) uid = parser.uid;
    if (map.containsKey('type')) type = parser.type;
    if (map.containsKey('rmbfen')) rmbfen = parser.rmbfen;
    if (map.containsKey('goods')) goods = parser.goods;
    if (map.containsKey('thirdSendData')) thirdSendData = parser.thirdSendData;
    if (map.containsKey('thirdSendResult')) thirdSendResult = parser.thirdSendResult;
    if (map.containsKey('thirdNotify')) thirdNotify = parser.thirdNotify;
    if (map.containsKey('appleOrderNo')) appleOrderNo = parser.appleOrderNo;
    if (map.containsKey('appleSendData')) appleSendData = parser.appleSendData;
    if (map.containsKey('appleSendResult')) appleSendResult = parser.appleSendResult;
    if (map.containsKey('appleSendCount')) appleSendCount = parser.appleSendCount;
    if (map.containsKey('redpackMsgId')) redpackMsgId = parser.redpackMsgId;
    if (map.containsKey('redpackPayId')) redpackPayId = parser.redpackPayId;
    if (map.containsKey('redpackReturned')) redpackReturned = parser.redpackReturned;
    if (map.containsKey('customType')) customType = parser.customType;
    if (map.containsKey('customValidData')) customValidData = parser.customValidData;
    if (map.containsKey('customValidResult')) customValidResult = parser.customValidResult;
    if (map.containsKey('customValidCount')) customValidCount = parser.customValidCount;
    if (map.containsKey('finishedTime')) finishedTime = parser.finishedTime;
    if (map.containsKey('finished')) finished = parser.finished;
  }

  @override
  void updateByKValues(Map<String, dynamic> map) {
    if (map.containsKey('_id')) _id = map['_id'];
    if (map.containsKey('_bsid')) _bsid = map['_bsid'];
    if (map.containsKey('_time')) _time = map['_time'];
    if (map.containsKey('_extra')) _extra = map['_extra'];
    if (map.containsKey('uid')) uid = map['uid'];
    if (map.containsKey('type')) type = map['type'];
    if (map.containsKey('rmbfen')) rmbfen = map['rmbfen'];
    if (map.containsKey('goods')) goods = map['goods'];
    if (map.containsKey('thirdSendData')) thirdSendData = map['thirdSendData'];
    if (map.containsKey('thirdSendResult')) thirdSendResult = map['thirdSendResult'];
    if (map.containsKey('thirdNotify')) thirdNotify = map['thirdNotify'];
    if (map.containsKey('appleOrderNo')) appleOrderNo = map['appleOrderNo'];
    if (map.containsKey('appleSendData')) appleSendData = map['appleSendData'];
    if (map.containsKey('appleSendResult')) appleSendResult = map['appleSendResult'];
    if (map.containsKey('appleSendCount')) appleSendCount = map['appleSendCount'];
    if (map.containsKey('redpackMsgId')) redpackMsgId = map['redpackMsgId'];
    if (map.containsKey('redpackPayId')) redpackPayId = map['redpackPayId'];
    if (map.containsKey('redpackReturned')) redpackReturned = map['redpackReturned'];
    if (map.containsKey('customType')) customType = map['customType'];
    if (map.containsKey('customValidData')) customValidData = map['customValidData'];
    if (map.containsKey('customValidResult')) customValidResult = map['customValidResult'];
    if (map.containsKey('customValidCount')) customValidCount = map['customValidCount'];
    if (map.containsKey('finishedTime')) finishedTime = map['finishedTime'];
    if (map.containsKey('finished')) finished = map['finished'];
  }
}

class PaymentDirty {
  final Map<String, dynamic> data = {};

  ///唯一id
  set id(ObjectId value) => data['_id'] = DbQueryField.toBaseType(value);

  ///商户id
  set bsid(ObjectId value) => data['_bsid'] = DbQueryField.toBaseType(value);

  ///创建时间
  set time(int value) => data['_time'] = DbQueryField.toBaseType(value);

  ///自定义数据
  set extra(DbJsonWraper value) => data['_extra'] = DbQueryField.toBaseType(value);

  ///所属用户id
  set uid(ObjectId value) => data['uid'] = DbQueryField.toBaseType(value);

  ///订单类型
  set type(int value) => data['type'] = DbQueryField.toBaseType(value);

  ///RMB金额（分）
  set rmbfen(int value) => data['rmbfen'] = DbQueryField.toBaseType(value);

  ///商品信息
  set goods(String value) => data['goods'] = DbQueryField.toBaseType(value);

  ///第三方充值下单请求的数据
  set thirdSendData(String value) => data['thirdSendData'] = DbQueryField.toBaseType(value);

  ///第三方充值下单请求的结果
  set thirdSendResult(String value) => data['thirdSendResult'] = DbQueryField.toBaseType(value);

  ///第三方充值成功收到的通知数据
  set thirdNotify(String value) => data['thirdNotify'] = DbQueryField.toBaseType(value);

  ///苹果内购充值的订单号
  set appleOrderNo(String value) => data['appleOrderNo'] = DbQueryField.toBaseType(value);

  ///苹果内购充值验证凭据
  set appleSendData(String value) => data['appleSendData'] = DbQueryField.toBaseType(value);

  ///苹果内购充值验证结果
  set appleSendResult(String value) => data['appleSendResult'] = DbQueryField.toBaseType(value);

  ///苹果内购充值验证次数
  set appleSendCount(int value) => data['appleSendCount'] = DbQueryField.toBaseType(value);

  ///发送红包、抢到红包、退回红包订单关联的聊天消息id
  set redpackMsgId(ObjectId value) => data['redpackMsgId'] = DbQueryField.toBaseType(value);

  ///抢到红包关联的发送红包订单id、退回红包关联的发送红包订单id
  set redpackPayId(ObjectId value) => data['redpackPayId'] = DbQueryField.toBaseType(value);

  ///发送红包订单是否已完成退回检测
  set redpackReturned(bool value) => data['redpackReturned'] = DbQueryField.toBaseType(value);

  ///自定义的订单类型
  set customType(int value) => data['customType'] = DbQueryField.toBaseType(value);

  ///自定义订单验证数据
  set customValidData(String value) => data['customValidData'] = DbQueryField.toBaseType(value);

  ///自定义订单验证结果
  set customValidResult(String value) => data['customValidResult'] = DbQueryField.toBaseType(value);

  ///自定义订单验证次数
  set customValidCount(int value) => data['customValidCount'] = DbQueryField.toBaseType(value);

  ///订单完成时间
  set finishedTime(int value) => data['finishedTime'] = DbQueryField.toBaseType(value);

  ///订单是否完成
  set finished(bool value) => data['finished'] = DbQueryField.toBaseType(value);
}
