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
  Map<String, String> _extra;

  ///所属用户id
  ObjectId uid;

  ///订单类型
  int type;

  ///RMB金额（分）
  int rmbfen;

  ///商品信息
  Map<String, String> goods;

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
  Map<String, String> get extra => _extra;

  Payment({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    Map<String, String>? extra,
    ObjectId? uid,
    int? type,
    int? rmbfen,
    Map<String, String>? goods,
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
    String? customValidData,
    String? customValidResult,
    int? customValidCount,
    int? finishedTime,
    bool? finished,
  })  : _id = id ?? ObjectId(),
        _bsid = bsid ?? ObjectId(),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? {},
        uid = uid ?? ObjectId(),
        type = type ?? 0,
        rmbfen = rmbfen ?? 0,
        goods = goods ?? {},
        thirdSendData = thirdSendData ?? '',
        thirdSendResult = thirdSendResult ?? '',
        thirdNotify = thirdNotify ?? '',
        appleOrderNo = appleOrderNo ?? '',
        appleSendData = appleSendData ?? '',
        appleSendResult = appleSendResult ?? '',
        appleSendCount = appleSendCount ?? 0,
        redpackMsgId = redpackMsgId ?? ObjectId(),
        redpackPayId = redpackPayId ?? ObjectId(),
        redpackReturned = redpackReturned ?? false,
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
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      bsid: map['_bsid'] is String ? ObjectId.fromHexString(map['_bsid']) : map['_bsid'],
      time: map['_time'],
      extra: (map['_extra'] as Map?)?.map((k, v) => MapEntry(k as String, v as String)),
      uid: map['uid'] is String ? ObjectId.fromHexString(map['uid']) : map['uid'],
      type: map['type'],
      rmbfen: map['rmbfen'],
      goods: (map['goods'] as Map?)?.map((k, v) => MapEntry(k as String, v as String)),
      thirdSendData: map['thirdSendData'],
      thirdSendResult: map['thirdSendResult'],
      thirdNotify: map['thirdNotify'],
      appleOrderNo: map['appleOrderNo'],
      appleSendData: map['appleSendData'],
      appleSendResult: map['appleSendResult'],
      appleSendCount: map['appleSendCount'],
      redpackMsgId: map['redpackMsgId'] is String ? ObjectId.fromHexString(map['redpackMsgId']) : map['redpackMsgId'],
      redpackPayId: map['redpackPayId'] is String ? ObjectId.fromHexString(map['redpackPayId']) : map['redpackPayId'],
      redpackReturned: map['redpackReturned'],
      customValidData: map['customValidData'],
      customValidResult: map['customValidResult'],
      customValidCount: map['customValidCount'],
      finishedTime: map['finishedTime'],
      finished: map['finished'],
    );
  }

  @override
  String toString() {
    return 'Payment(${jsonEncode(toJson())})';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': DbQueryField.convertToBaseType(_id),
      '_bsid': DbQueryField.convertToBaseType(_bsid),
      '_time': DbQueryField.convertToBaseType(_time),
      '_extra': DbQueryField.convertToBaseType(_extra),
      'uid': DbQueryField.convertToBaseType(uid),
      'type': DbQueryField.convertToBaseType(type),
      'rmbfen': DbQueryField.convertToBaseType(rmbfen),
      'goods': DbQueryField.convertToBaseType(goods),
      'thirdSendData': DbQueryField.convertToBaseType(thirdSendData),
      'thirdSendResult': DbQueryField.convertToBaseType(thirdSendResult),
      'thirdNotify': DbQueryField.convertToBaseType(thirdNotify),
      'appleOrderNo': DbQueryField.convertToBaseType(appleOrderNo),
      'appleSendData': DbQueryField.convertToBaseType(appleSendData),
      'appleSendResult': DbQueryField.convertToBaseType(appleSendResult),
      'appleSendCount': DbQueryField.convertToBaseType(appleSendCount),
      'redpackMsgId': DbQueryField.convertToBaseType(redpackMsgId),
      'redpackPayId': DbQueryField.convertToBaseType(redpackPayId),
      'redpackReturned': DbQueryField.convertToBaseType(redpackReturned),
      'customValidData': DbQueryField.convertToBaseType(customValidData),
      'customValidResult': DbQueryField.convertToBaseType(customValidResult),
      'customValidCount': DbQueryField.convertToBaseType(customValidCount),
      'finishedTime': DbQueryField.convertToBaseType(finishedTime),
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
  set id(ObjectId value) => data['_id'] = DbQueryField.convertToBaseType(value);

  ///商户id
  set bsid(ObjectId value) => data['_bsid'] = DbQueryField.convertToBaseType(value);

  ///创建时间
  set time(int value) => data['_time'] = DbQueryField.convertToBaseType(value);

  ///自定义数据
  set extra(Map<String, String> value) => data['_extra'] = DbQueryField.convertToBaseType(value);

  ///所属用户id
  set uid(ObjectId value) => data['uid'] = DbQueryField.convertToBaseType(value);

  ///订单类型
  set type(int value) => data['type'] = DbQueryField.convertToBaseType(value);

  ///RMB金额（分）
  set rmbfen(int value) => data['rmbfen'] = DbQueryField.convertToBaseType(value);

  ///商品信息
  set goods(Map<String, String> value) => data['goods'] = DbQueryField.convertToBaseType(value);

  ///第三方充值下单请求的数据
  set thirdSendData(String value) => data['thirdSendData'] = DbQueryField.convertToBaseType(value);

  ///第三方充值下单请求的结果
  set thirdSendResult(String value) => data['thirdSendResult'] = DbQueryField.convertToBaseType(value);

  ///第三方充值成功收到的通知数据
  set thirdNotify(String value) => data['thirdNotify'] = DbQueryField.convertToBaseType(value);

  ///苹果内购充值的订单号
  set appleOrderNo(String value) => data['appleOrderNo'] = DbQueryField.convertToBaseType(value);

  ///苹果内购充值验证凭据
  set appleSendData(String value) => data['appleSendData'] = DbQueryField.convertToBaseType(value);

  ///苹果内购充值验证结果
  set appleSendResult(String value) => data['appleSendResult'] = DbQueryField.convertToBaseType(value);

  ///苹果内购充值验证次数
  set appleSendCount(int value) => data['appleSendCount'] = DbQueryField.convertToBaseType(value);

  ///发送红包、抢到红包、退回红包订单关联的聊天消息id
  set redpackMsgId(ObjectId value) => data['redpackMsgId'] = DbQueryField.convertToBaseType(value);

  ///抢到红包关联的发送红包订单id、退回红包关联的发送红包订单id
  set redpackPayId(ObjectId value) => data['redpackPayId'] = DbQueryField.convertToBaseType(value);

  ///发送红包订单是否已完成退回检测
  set redpackReturned(bool value) => data['redpackReturned'] = DbQueryField.convertToBaseType(value);

  ///自定义订单验证数据
  set customValidData(String value) => data['customValidData'] = DbQueryField.convertToBaseType(value);

  ///自定义订单验证结果
  set customValidResult(String value) => data['customValidResult'] = DbQueryField.convertToBaseType(value);

  ///自定义订单验证次数
  set customValidCount(int value) => data['customValidCount'] = DbQueryField.convertToBaseType(value);

  ///订单完成时间
  set finishedTime(int value) => data['finishedTime'] = DbQueryField.convertToBaseType(value);

  ///订单是否完成
  set finished(bool value) => data['finished'] = DbQueryField.convertToBaseType(value);
}
