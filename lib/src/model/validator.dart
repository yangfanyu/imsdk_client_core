import 'package:shelf_easy/shelf_easy.dart';

///
///限制参数
///
class Validator extends DbBaseModel {
  ///群组头像列表最大的数量
  static const int teamHeadMax = 9;

  ///群组单次拉人最大的数量
  static const int teamPullMax = 10;

  ///实时通讯人数最大的数量
  static const int realtimeMax = 9;

  ///实时通讯人数最小的数量
  static const int realtimeMin = 2;

  ///分页查询每页最大的数量
  static const int pageItemMax = 30;

  ///WebRTC心跳发送间隔（秒）
  static const int webrtcInterval = 10;

  ///WebRTC心跳超时时间（秒）
  static const int webrtcTimeouts = 60;

  ///ID最小长度
  static const int identLenMin = 8;

  ///ID最大长度
  static const int identLenMax = 64;

  ///ID验证正则表达式
  static const String identRegExp = r'^[a-zA-Z0-9_-]+$';

  ///ID验证正则表达式介绍
  static const String identRegTip = '字母、数字、下划线、减号';

  ///口令最小长度
  static const int tokenLenMin = 8;

  ///口令最大长度
  static const int tokenLenMax = 64;

  ///口令验证正则表达式
  static const String tokenRegExp = r'^[a-zA-Z0-9_-]+$';

  ///口令验证正则表达式介绍
  static const String tokenRegTip = '字母、数字、下划线、减号';

  ///签名最小长度
  static const int signLenMin = 8;

  ///签名最大长度
  static const int signLenMax = 128;

  ///签名验证正则表达式
  static const String signRegExp = r'^[a-zA-Z0-9_-]+$';

  ///签名验证正则表达式介绍
  static const String signRegTip = '字母、数字、下划线、减号';

  ///账号最小长度
  static const int noLenMin = 8;

  ///账号最大长度
  static const int noLenMax = 32;

  ///账号验证正则表达式
  static const String noRegExp = r'^[a-zA-Z0-9_-]+$';

  ///账号验证正则表达式介绍
  static const String noRegTip = '字母、数字、下划线、减号';

  ///密码最小长度
  static const int pwdLenMin = 8;

  ///密码最大长度
  static const int pwdLenMax = 32;

  ///密码验证正则表达式
  static const String pwdRegExp = r'^[\x20-\x7E]+$';

  ///密码验证正则表达式介绍
  static const String pwdRegTip = '可显示的ASCII字符';

  ///手机号最小长度
  static const int phoneLenMin = 8;

  ///手机号最大长度
  static const int phoneLenMax = 16;

  ///手机号验证正则表达式
  static const String phoneRegExp = r'^[0-9]+$';

  ///手机号验证正则表达式介绍
  static const String phoneRegTip = '0～9的数字';

  ///验证码长度
  static const int randcodeLen = 6;

  ///验证码正则表达式
  static const String randcodeRegExp = r'^[0-9]+$';

  ///验证码正则表达式介绍
  static const String randcodeRegTip = '0～9的数字';

  ///支付密码长度
  static const int cashpwdLen = 6;

  ///支付密码正则表达式
  static const String cashpwdRegExp = r'^[0-9]+$';

  ///支付密码正则表达式介绍
  static const String cashpwdRegTip = '0～9的数字';

  ///链接最小长度
  static const int linkLenMin = 0;

  ///链接最大长度
  static const int linkLenMax = 1024;

  ///短字符串最小长度
  static const int shortTextLenMin = 0;

  ///短字符串最大长度
  static const int shortTextLenMax = 32;

  ///中等字符串最小长度
  static const int mediumTextLenMin = 0;

  ///中等字符串最大长度
  static const int mediumTextLenMax = 64;

  ///长字符串最小长度
  static const int longTextLenMin = 0;

  ///长字符串最大长度
  static const int longTextLenMax = 128;

  ///超长字符串最小长度
  static const int ultralongTextLenMin = 0;

  ///超长字符串最大长度
  static const int ultralongTextLenMax = 8192;

  Validator();

  factory Validator.fromString(String data) {
    return Validator.fromJson(jsonDecode(data.substring(data.indexOf('(') + 1, data.lastIndexOf(')'))));
  }

  factory Validator.fromJson(Map<String, dynamic> map) {
    return Validator();
  }

  @override
  String toString() {
    return 'Validator(${jsonEncode(toJson())})';
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  Map<String, dynamic> toKValues() {
    return {};
  }

  @override
  void updateByJson(Map<String, dynamic> map, {Validator? parser}) {}

  @override
  void updateByKValues(Map<String, dynamic> map) {}
}
