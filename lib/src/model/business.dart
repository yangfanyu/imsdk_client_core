import 'package:shelf_easy/shelf_easy.dart';

///
///商户
///
class Business extends DbBaseModel {
  ///唯一id
  ObjectId _id;

  ///创建时间
  int _time;

  ///账号
  String no;

  ///密码
  String pwd;

  ///昵称
  String nick;

  ///描述
  String desc;

  ///图标
  String icon;

  ///手机
  String phone;

  ///邮箱
  String email;

  ///SDK加解密密钥
  String secret;

  ///定制登录验证url
  String customLoginValidUrl;

  ///定制订单验证url
  String customPaymentValidUrl;

  ///微信配置
  String wechatAppId;

  ///微信配置
  String wechatAppSecret;

  ///微信配置
  String wechatMchId;

  ///微信配置
  String wechatMchSecret;

  ///支付宝配置
  String alipayPid;

  ///支付宝配置
  String alipayAppId;

  ///支付宝配置
  String alipayPrivateKey;

  ///支付宝配置
  String alipayPublicKey;

  ///阿里短信配置
  String alismsAccessKeyId;

  ///阿里短信配置
  String alismsAccessKeySecret;

  ///阿里短信配置
  String alismsEndpoint;

  ///阿里短信配置
  String alismsApiVersion;

  ///阿里短信配置
  String alismsSignName;

  ///阿里短信配置
  String alismsTemplateCode;

  ///苹果配置
  String appleKeyP8;

  ///苹果配置
  ///生成方法: openssl ec -in appleKey.p8 -pubout -out appleKey_public.p8 
  String appleKeyP8Public;

  ///苹果配置
  String appleAuthClientId;

  ///苹果配置
  String appleAuthTeamId;

  ///苹果配置
  String appleAuthKeyId;

  ///苹果配置
  String appleAuthRedirectUri;

  ///苹果配置
  String appleAppSiteAssociation;

  ///唯一id
  ObjectId get id => _id;

  ///创建时间
  int get time => _time;

  Business({
    ObjectId? id,
    int? time,
    String? no,
    String? pwd,
    String? nick,
    String? desc,
    String? icon,
    String? phone,
    String? email,
    String? secret,
    String? customLoginValidUrl,
    String? customPaymentValidUrl,
    String? wechatAppId,
    String? wechatAppSecret,
    String? wechatMchId,
    String? wechatMchSecret,
    String? alipayPid,
    String? alipayAppId,
    String? alipayPrivateKey,
    String? alipayPublicKey,
    String? alismsAccessKeyId,
    String? alismsAccessKeySecret,
    String? alismsEndpoint,
    String? alismsApiVersion,
    String? alismsSignName,
    String? alismsTemplateCode,
    String? appleKeyP8,
    String? appleKeyP8Public,
    String? appleAuthClientId,
    String? appleAuthTeamId,
    String? appleAuthKeyId,
    String? appleAuthRedirectUri,
    String? appleAppSiteAssociation,
  })  : _id = id ?? ObjectId(),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        no = no ?? '',
        pwd = pwd ?? '',
        nick = nick ?? '',
        desc = desc ?? '',
        icon = icon ?? '',
        phone = phone ?? '',
        email = email ?? '',
        secret = secret ?? '',
        customLoginValidUrl = customLoginValidUrl ?? '',
        customPaymentValidUrl = customPaymentValidUrl ?? '',
        wechatAppId = wechatAppId ?? '',
        wechatAppSecret = wechatAppSecret ?? '',
        wechatMchId = wechatMchId ?? '',
        wechatMchSecret = wechatMchSecret ?? '',
        alipayPid = alipayPid ?? '',
        alipayAppId = alipayAppId ?? '',
        alipayPrivateKey = alipayPrivateKey ?? '',
        alipayPublicKey = alipayPublicKey ?? '',
        alismsAccessKeyId = alismsAccessKeyId ?? '',
        alismsAccessKeySecret = alismsAccessKeySecret ?? '',
        alismsEndpoint = alismsEndpoint ?? '',
        alismsApiVersion = alismsApiVersion ?? '',
        alismsSignName = alismsSignName ?? '',
        alismsTemplateCode = alismsTemplateCode ?? '',
        appleKeyP8 = appleKeyP8 ?? '',
        appleKeyP8Public = appleKeyP8Public ?? '',
        appleAuthClientId = appleAuthClientId ?? '',
        appleAuthTeamId = appleAuthTeamId ?? '',
        appleAuthKeyId = appleAuthKeyId ?? '',
        appleAuthRedirectUri = appleAuthRedirectUri ?? '',
        appleAppSiteAssociation = appleAppSiteAssociation ?? '';

  factory Business.fromJson(Map<String, dynamic> map) {
    return Business(
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      time: map['_time'],
      no: map['no'],
      pwd: map['pwd'],
      nick: map['nick'],
      desc: map['desc'],
      icon: map['icon'],
      phone: map['phone'],
      email: map['email'],
      secret: map['secret'],
      customLoginValidUrl: map['customLoginValidUrl'],
      customPaymentValidUrl: map['customPaymentValidUrl'],
      wechatAppId: map['wechatAppId'],
      wechatAppSecret: map['wechatAppSecret'],
      wechatMchId: map['wechatMchId'],
      wechatMchSecret: map['wechatMchSecret'],
      alipayPid: map['alipayPid'],
      alipayAppId: map['alipayAppId'],
      alipayPrivateKey: map['alipayPrivateKey'],
      alipayPublicKey: map['alipayPublicKey'],
      alismsAccessKeyId: map['alismsAccessKeyId'],
      alismsAccessKeySecret: map['alismsAccessKeySecret'],
      alismsEndpoint: map['alismsEndpoint'],
      alismsApiVersion: map['alismsApiVersion'],
      alismsSignName: map['alismsSignName'],
      alismsTemplateCode: map['alismsTemplateCode'],
      appleKeyP8: map['appleKeyP8'],
      appleKeyP8Public: map['appleKeyP8Public'],
      appleAuthClientId: map['appleAuthClientId'],
      appleAuthTeamId: map['appleAuthTeamId'],
      appleAuthKeyId: map['appleAuthKeyId'],
      appleAuthRedirectUri: map['appleAuthRedirectUri'],
      appleAppSiteAssociation: map['appleAppSiteAssociation'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': DbQueryField.convertToBaseType(_id),
      '_time': DbQueryField.convertToBaseType(_time),
      'no': DbQueryField.convertToBaseType(no),
      'pwd': DbQueryField.convertToBaseType(pwd),
      'nick': DbQueryField.convertToBaseType(nick),
      'desc': DbQueryField.convertToBaseType(desc),
      'icon': DbQueryField.convertToBaseType(icon),
      'phone': DbQueryField.convertToBaseType(phone),
      'email': DbQueryField.convertToBaseType(email),
      'secret': DbQueryField.convertToBaseType(secret),
      'customLoginValidUrl': DbQueryField.convertToBaseType(customLoginValidUrl),
      'customPaymentValidUrl': DbQueryField.convertToBaseType(customPaymentValidUrl),
      'wechatAppId': DbQueryField.convertToBaseType(wechatAppId),
      'wechatAppSecret': DbQueryField.convertToBaseType(wechatAppSecret),
      'wechatMchId': DbQueryField.convertToBaseType(wechatMchId),
      'wechatMchSecret': DbQueryField.convertToBaseType(wechatMchSecret),
      'alipayPid': DbQueryField.convertToBaseType(alipayPid),
      'alipayAppId': DbQueryField.convertToBaseType(alipayAppId),
      'alipayPrivateKey': DbQueryField.convertToBaseType(alipayPrivateKey),
      'alipayPublicKey': DbQueryField.convertToBaseType(alipayPublicKey),
      'alismsAccessKeyId': DbQueryField.convertToBaseType(alismsAccessKeyId),
      'alismsAccessKeySecret': DbQueryField.convertToBaseType(alismsAccessKeySecret),
      'alismsEndpoint': DbQueryField.convertToBaseType(alismsEndpoint),
      'alismsApiVersion': DbQueryField.convertToBaseType(alismsApiVersion),
      'alismsSignName': DbQueryField.convertToBaseType(alismsSignName),
      'alismsTemplateCode': DbQueryField.convertToBaseType(alismsTemplateCode),
      'appleKeyP8': DbQueryField.convertToBaseType(appleKeyP8),
      'appleKeyP8Public': DbQueryField.convertToBaseType(appleKeyP8Public),
      'appleAuthClientId': DbQueryField.convertToBaseType(appleAuthClientId),
      'appleAuthTeamId': DbQueryField.convertToBaseType(appleAuthTeamId),
      'appleAuthKeyId': DbQueryField.convertToBaseType(appleAuthKeyId),
      'appleAuthRedirectUri': DbQueryField.convertToBaseType(appleAuthRedirectUri),
      'appleAppSiteAssociation': DbQueryField.convertToBaseType(appleAppSiteAssociation),
    };
  }

  @override
  Map<String, dynamic> toKValues() {
    return {
      '_id': _id,
      '_time': _time,
      'no': no,
      'pwd': pwd,
      'nick': nick,
      'desc': desc,
      'icon': icon,
      'phone': phone,
      'email': email,
      'secret': secret,
      'customLoginValidUrl': customLoginValidUrl,
      'customPaymentValidUrl': customPaymentValidUrl,
      'wechatAppId': wechatAppId,
      'wechatAppSecret': wechatAppSecret,
      'wechatMchId': wechatMchId,
      'wechatMchSecret': wechatMchSecret,
      'alipayPid': alipayPid,
      'alipayAppId': alipayAppId,
      'alipayPrivateKey': alipayPrivateKey,
      'alipayPublicKey': alipayPublicKey,
      'alismsAccessKeyId': alismsAccessKeyId,
      'alismsAccessKeySecret': alismsAccessKeySecret,
      'alismsEndpoint': alismsEndpoint,
      'alismsApiVersion': alismsApiVersion,
      'alismsSignName': alismsSignName,
      'alismsTemplateCode': alismsTemplateCode,
      'appleKeyP8': appleKeyP8,
      'appleKeyP8Public': appleKeyP8Public,
      'appleAuthClientId': appleAuthClientId,
      'appleAuthTeamId': appleAuthTeamId,
      'appleAuthKeyId': appleAuthKeyId,
      'appleAuthRedirectUri': appleAuthRedirectUri,
      'appleAppSiteAssociation': appleAppSiteAssociation,
    };
  }

  @override
  void updateByJson(Map<String, dynamic> map, {Business? parser}) {
    parser = parser ?? Business.fromJson(map);
    if (map.containsKey('_id')) _id = parser._id;
    if (map.containsKey('_time')) _time = parser._time;
    if (map.containsKey('no')) no = parser.no;
    if (map.containsKey('pwd')) pwd = parser.pwd;
    if (map.containsKey('nick')) nick = parser.nick;
    if (map.containsKey('desc')) desc = parser.desc;
    if (map.containsKey('icon')) icon = parser.icon;
    if (map.containsKey('phone')) phone = parser.phone;
    if (map.containsKey('email')) email = parser.email;
    if (map.containsKey('secret')) secret = parser.secret;
    if (map.containsKey('customLoginValidUrl')) customLoginValidUrl = parser.customLoginValidUrl;
    if (map.containsKey('customPaymentValidUrl')) customPaymentValidUrl = parser.customPaymentValidUrl;
    if (map.containsKey('wechatAppId')) wechatAppId = parser.wechatAppId;
    if (map.containsKey('wechatAppSecret')) wechatAppSecret = parser.wechatAppSecret;
    if (map.containsKey('wechatMchId')) wechatMchId = parser.wechatMchId;
    if (map.containsKey('wechatMchSecret')) wechatMchSecret = parser.wechatMchSecret;
    if (map.containsKey('alipayPid')) alipayPid = parser.alipayPid;
    if (map.containsKey('alipayAppId')) alipayAppId = parser.alipayAppId;
    if (map.containsKey('alipayPrivateKey')) alipayPrivateKey = parser.alipayPrivateKey;
    if (map.containsKey('alipayPublicKey')) alipayPublicKey = parser.alipayPublicKey;
    if (map.containsKey('alismsAccessKeyId')) alismsAccessKeyId = parser.alismsAccessKeyId;
    if (map.containsKey('alismsAccessKeySecret')) alismsAccessKeySecret = parser.alismsAccessKeySecret;
    if (map.containsKey('alismsEndpoint')) alismsEndpoint = parser.alismsEndpoint;
    if (map.containsKey('alismsApiVersion')) alismsApiVersion = parser.alismsApiVersion;
    if (map.containsKey('alismsSignName')) alismsSignName = parser.alismsSignName;
    if (map.containsKey('alismsTemplateCode')) alismsTemplateCode = parser.alismsTemplateCode;
    if (map.containsKey('appleKeyP8')) appleKeyP8 = parser.appleKeyP8;
    if (map.containsKey('appleKeyP8Public')) appleKeyP8Public = parser.appleKeyP8Public;
    if (map.containsKey('appleAuthClientId')) appleAuthClientId = parser.appleAuthClientId;
    if (map.containsKey('appleAuthTeamId')) appleAuthTeamId = parser.appleAuthTeamId;
    if (map.containsKey('appleAuthKeyId')) appleAuthKeyId = parser.appleAuthKeyId;
    if (map.containsKey('appleAuthRedirectUri')) appleAuthRedirectUri = parser.appleAuthRedirectUri;
    if (map.containsKey('appleAppSiteAssociation')) appleAppSiteAssociation = parser.appleAppSiteAssociation;
  }

  @override
  void updateByKValues(Map<String, dynamic> map) {
    if (map.containsKey('_id')) _id = map['_id'];
    if (map.containsKey('_time')) _time = map['_time'];
    if (map.containsKey('no')) no = map['no'];
    if (map.containsKey('pwd')) pwd = map['pwd'];
    if (map.containsKey('nick')) nick = map['nick'];
    if (map.containsKey('desc')) desc = map['desc'];
    if (map.containsKey('icon')) icon = map['icon'];
    if (map.containsKey('phone')) phone = map['phone'];
    if (map.containsKey('email')) email = map['email'];
    if (map.containsKey('secret')) secret = map['secret'];
    if (map.containsKey('customLoginValidUrl')) customLoginValidUrl = map['customLoginValidUrl'];
    if (map.containsKey('customPaymentValidUrl')) customPaymentValidUrl = map['customPaymentValidUrl'];
    if (map.containsKey('wechatAppId')) wechatAppId = map['wechatAppId'];
    if (map.containsKey('wechatAppSecret')) wechatAppSecret = map['wechatAppSecret'];
    if (map.containsKey('wechatMchId')) wechatMchId = map['wechatMchId'];
    if (map.containsKey('wechatMchSecret')) wechatMchSecret = map['wechatMchSecret'];
    if (map.containsKey('alipayPid')) alipayPid = map['alipayPid'];
    if (map.containsKey('alipayAppId')) alipayAppId = map['alipayAppId'];
    if (map.containsKey('alipayPrivateKey')) alipayPrivateKey = map['alipayPrivateKey'];
    if (map.containsKey('alipayPublicKey')) alipayPublicKey = map['alipayPublicKey'];
    if (map.containsKey('alismsAccessKeyId')) alismsAccessKeyId = map['alismsAccessKeyId'];
    if (map.containsKey('alismsAccessKeySecret')) alismsAccessKeySecret = map['alismsAccessKeySecret'];
    if (map.containsKey('alismsEndpoint')) alismsEndpoint = map['alismsEndpoint'];
    if (map.containsKey('alismsApiVersion')) alismsApiVersion = map['alismsApiVersion'];
    if (map.containsKey('alismsSignName')) alismsSignName = map['alismsSignName'];
    if (map.containsKey('alismsTemplateCode')) alismsTemplateCode = map['alismsTemplateCode'];
    if (map.containsKey('appleKeyP8')) appleKeyP8 = map['appleKeyP8'];
    if (map.containsKey('appleKeyP8Public')) appleKeyP8Public = map['appleKeyP8Public'];
    if (map.containsKey('appleAuthClientId')) appleAuthClientId = map['appleAuthClientId'];
    if (map.containsKey('appleAuthTeamId')) appleAuthTeamId = map['appleAuthTeamId'];
    if (map.containsKey('appleAuthKeyId')) appleAuthKeyId = map['appleAuthKeyId'];
    if (map.containsKey('appleAuthRedirectUri')) appleAuthRedirectUri = map['appleAuthRedirectUri'];
    if (map.containsKey('appleAppSiteAssociation')) appleAppSiteAssociation = map['appleAppSiteAssociation'];
  }
}

class BusinessDirty {
  final Map<String, dynamic> data = {};

  ///唯一id
  set id(ObjectId value) => data['_id'] = DbQueryField.convertToBaseType(value);

  ///创建时间
  set time(int value) => data['_time'] = DbQueryField.convertToBaseType(value);

  ///账号
  set no(String value) => data['no'] = DbQueryField.convertToBaseType(value);

  ///密码
  set pwd(String value) => data['pwd'] = DbQueryField.convertToBaseType(value);

  ///昵称
  set nick(String value) => data['nick'] = DbQueryField.convertToBaseType(value);

  ///描述
  set desc(String value) => data['desc'] = DbQueryField.convertToBaseType(value);

  ///图标
  set icon(String value) => data['icon'] = DbQueryField.convertToBaseType(value);

  ///手机
  set phone(String value) => data['phone'] = DbQueryField.convertToBaseType(value);

  ///邮箱
  set email(String value) => data['email'] = DbQueryField.convertToBaseType(value);

  ///SDK加解密密钥
  set secret(String value) => data['secret'] = DbQueryField.convertToBaseType(value);

  ///定制登录验证url
  set customLoginValidUrl(String value) => data['customLoginValidUrl'] = DbQueryField.convertToBaseType(value);

  ///定制订单验证url
  set customPaymentValidUrl(String value) => data['customPaymentValidUrl'] = DbQueryField.convertToBaseType(value);

  ///微信配置
  set wechatAppId(String value) => data['wechatAppId'] = DbQueryField.convertToBaseType(value);

  ///微信配置
  set wechatAppSecret(String value) => data['wechatAppSecret'] = DbQueryField.convertToBaseType(value);

  ///微信配置
  set wechatMchId(String value) => data['wechatMchId'] = DbQueryField.convertToBaseType(value);

  ///微信配置
  set wechatMchSecret(String value) => data['wechatMchSecret'] = DbQueryField.convertToBaseType(value);

  ///支付宝配置
  set alipayPid(String value) => data['alipayPid'] = DbQueryField.convertToBaseType(value);

  ///支付宝配置
  set alipayAppId(String value) => data['alipayAppId'] = DbQueryField.convertToBaseType(value);

  ///支付宝配置
  set alipayPrivateKey(String value) => data['alipayPrivateKey'] = DbQueryField.convertToBaseType(value);

  ///支付宝配置
  set alipayPublicKey(String value) => data['alipayPublicKey'] = DbQueryField.convertToBaseType(value);

  ///阿里短信配置
  set alismsAccessKeyId(String value) => data['alismsAccessKeyId'] = DbQueryField.convertToBaseType(value);

  ///阿里短信配置
  set alismsAccessKeySecret(String value) => data['alismsAccessKeySecret'] = DbQueryField.convertToBaseType(value);

  ///阿里短信配置
  set alismsEndpoint(String value) => data['alismsEndpoint'] = DbQueryField.convertToBaseType(value);

  ///阿里短信配置
  set alismsApiVersion(String value) => data['alismsApiVersion'] = DbQueryField.convertToBaseType(value);

  ///阿里短信配置
  set alismsSignName(String value) => data['alismsSignName'] = DbQueryField.convertToBaseType(value);

  ///阿里短信配置
  set alismsTemplateCode(String value) => data['alismsTemplateCode'] = DbQueryField.convertToBaseType(value);

  ///苹果配置
  set appleKeyP8(String value) => data['appleKeyP8'] = DbQueryField.convertToBaseType(value);

  ///苹果配置
  ///生成方法: openssl ec -in appleKey.p8 -pubout -out appleKey_public.p8 
  set appleKeyP8Public(String value) => data['appleKeyP8Public'] = DbQueryField.convertToBaseType(value);

  ///苹果配置
  set appleAuthClientId(String value) => data['appleAuthClientId'] = DbQueryField.convertToBaseType(value);

  ///苹果配置
  set appleAuthTeamId(String value) => data['appleAuthTeamId'] = DbQueryField.convertToBaseType(value);

  ///苹果配置
  set appleAuthKeyId(String value) => data['appleAuthKeyId'] = DbQueryField.convertToBaseType(value);

  ///苹果配置
  set appleAuthRedirectUri(String value) => data['appleAuthRedirectUri'] = DbQueryField.convertToBaseType(value);

  ///苹果配置
  set appleAppSiteAssociation(String value) => data['appleAppSiteAssociation'] = DbQueryField.convertToBaseType(value);
}
