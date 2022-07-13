import 'package:shelf_easy/shelf_easy.dart';

///
///整数常量
///
class Constant extends DbBaseModel {
  ///通用-未知。该值与生成代码的int默认值0对应
  static const int unknow = 0;

  ///用户或群组被永久封禁
  static const int denyForever = -1;

  ///用户已经永久注销账号
  static const int denyDestroy = -2;

  ///第三方账号类型-苹果
  static const int userThirdApple = 101001;

  ///第三方账号类型-微信
  static const int userThirdWechat = 101002;

  ///第三方账号类型-支付宝
  static const int userThirdAlipay = 101003;

  ///第三方账号类型-自定义
  static const int userThirdCustom = 101088;

  ///第三方账号类型-男
  static const int userSexMale = 102001;

  ///第三方账号类型-女
  static const int userSexFemale = 102002;

  ///关系来源-系统助手
  static const int shipFromSystemHelper = 103001;

  ///关系来源-客服助手
  static const int shipFromServiceHelper = 103002;

  ///关系来源-搜索
  static const int shipFromSearch = 103003;

  ///关系来源-二维码
  static const int shipFromQrcode = 103004;

  ///关系来源-名片
  static const int shipFromShareCard = 103005;

  ///关系来源-群组
  static const int shipFromMember = 103006;

  ///关系来源-被拉入
  static const int shipFromTeamPulledIn = 103007;

  ///关系来源-创建者
  static const int shipFromTeamCreator = 103008;

  ///关系状态-无关系
  static const int shipStateNone = 104001;

  ///关系状态-申请中
  static const int shipStateWait = 104002;

  ///关系状态-已建立
  static const int shipStatePass = 104003;

  ///消息来源-用户
  static const int msgFromUser = 105001;

  ///消息来源-群组
  static const int msgFromTeam = 105002;

  ///消息类型-系统
  static const int msgTypeSystem = 106001;

  ///消息类型-文本
  static const int msgTypeText = 106002;

  ///消息类型-图片
  static const int msgTypeImage = 106003;

  ///消息类型-语音
  static const int msgTypeVoice = 106004;

  ///消息类型-视频
  static const int msgTypeVideo = 106005;

  ///消息类型-实时语音电话
  static const int msgTypeRealtimeVoice = 106006;

  ///消息类型-实时视频电话
  static const int msgTypeRealtimeVideo = 106007;

  ///消息类型-实时屏幕共享
  static const int msgTypeRealtimeShare = 106008;

  ///消息类型-实时位置电话
  static const int msgTypeRealtimeLocal = 106009;

  ///消息类型-网页分享
  static const int msgTypeShareHtmlPage = 106010;

  ///消息类型-位置分享
  static const int msgTypeShareLocation = 106011;

  ///消息类型-用户名片
  static const int msgTypeShareCardUser = 106012;

  ///消息类型-群组名片
  static const int msgTypeShareCardTeam = 106013;

  ///消息类型-普通红包
  static const int msgTypeRedpackNormal = 106014;

  ///消息类型-幸运红包
  static const int msgTypeRedpackLuckly = 106015;

  ///消息类型-自定义
  static const int msgTypeCustom = 106088;

  ///文件类型-永久文件
  static const int metaTypeForever = 107001;

  ///文件类型-消息附件
  static const int metaTypeMessage = 107002;

  ///订单类型-微信充值
  static const int payTypeRechargeWechat = 108001;

  ///订单类型-支付宝充值
  static const int payTypeRechargeAlipay = 108002;

  ///订单类型-苹果内购充值
  static const int payTypeRechargeApple = 108003;

  ///订单类型-抢到红包获得
  static const int payTypeRecivedRedpackSnath = 108004;

  ///订单类型-退回红包获得
  static const int payTypeRecivedRedpackReturn = 108005;

  ///订单类型-发出红包消耗
  static const int payTypeConsumeRedpackSend = 108006;

  ///订单类型-提现消耗
  static const int payTypeConsumeCashout = 108007;

  ///订单类型-自定义获得
  static const int payTypeRecivedCustom = 108088;

  ///订单类型-自定义消耗
  static const int payTypeConsumeCustom = 108099;

  ///投诉类型-用户
  static const int reportTypeUser = 109001;

  ///投诉类型-群组
  static const int reportTypeTeam = 109002;

  ///投诉类型-域名
  static const int reportTypeHost = 109003;

  ///投诉类型-反馈
  static const int reportTypeAdvise = 109004;

  ///投诉类型-自定义
  static const int reportTypeCustom = 109088;

  ///投诉状态-待处理
  static const int reportStateWait = 110001;

  ///投诉状态-已拒绝
  static const int reportStateDeny = 110002;

  ///投诉状态-已通过
  static const int reportStatePass = 110003;

  static const Map<String, Map<int, String>> constMap = {
    'zh': {
      0: '未知',
      -1: '永久封禁',
      -2: '永久注销',
      101001: '苹果',
      101002: '微信',
      101003: '支付宝',
      101088: '自定义',
      102001: '男',
      102002: '女',
      103001: '系统助手',
      103002: '客服助手',
      103003: '搜索',
      103004: '二维码',
      103005: '名片',
      103006: '群组',
      103007: '被拉入',
      103008: '创建者',
      104001: '无关系',
      104002: '申请中',
      104003: '已建立',
      105001: '用户',
      105002: '群组',
      106001: '系统',
      106002: '文本',
      106003: '图片',
      106004: '语音',
      106005: '视频',
      106006: '语音电话',
      106007: '视频电话',
      106008: '屏幕共享',
      106009: '位置电话',
      106010: '网页分享',
      106011: '位置分享',
      106012: '用户名片',
      106013: '群组名片',
      106014: '普通红包',
      106015: '幸运红包',
      106088: '自定义',
      107001: '永久文件',
      107002: '消息附件',
      108001: '微信充值',
      108002: '支付宝充值',
      108003: '苹果内购充值',
      108004: '抢到红包获得',
      108005: '退回红包获得',
      108006: '发出红包消耗',
      108007: '提现消耗',
      108088: '自定义获得',
      108099: '自定义消耗',
      109001: '用户',
      109002: '群组',
      109003: '域名',
      109004: '反馈',
      109088: '自定义',
      110001: '待处理',
      110002: '已拒绝',
      110003: '已通过',
    },
    'en': {
      0: 'Unknow',
      -1: 'Permanent ban',
      -2: 'Permanent del',
      101001: 'Apple',
      101002: 'Wechat',
      101003: 'Alipay',
      101088: 'Custom',
      102001: 'Man',
      102002: 'Woman',
      103001: 'System helper',
      103002: 'Service helper',
      103003: 'Search',
      103004: 'Qrcode',
      103005: 'Share card',
      103006: 'Team member',
      103007: 'Be pulled in',
      103008: 'Team creator',
      104001: 'None',
      104002: 'Waiting',
      104003: 'Passed',
      105001: 'User',
      105002: 'Team',
      106001: 'System',
      106002: 'Text',
      106003: 'Image',
      106004: 'Voice',
      106005: 'Video',
      106006: 'Realtime voice call',
      106007: 'Realtime video call',
      106008: 'Realtime screen share',
      106009: 'Realtime location share',
      106010: 'Share web page',
      106011: 'Share location',
      106012: 'Share user card',
      106013: 'Share team card',
      106014: 'Normal red envelope',
      106015: 'Luckly red envelope',
      106088: 'Custom',
      107001: 'Forever file',
      107002: 'Message file',
      108001: 'Wechat recharged',
      108002: 'Alipay recharged',
      108003: 'Apple in app recharged',
      108004: 'Red envelope snatched',
      108005: 'Red envelope returned',
      108006: 'Red envelope sended',
      108007: 'Cash out',
      108088: 'Custom recived',
      108099: 'Custom consume',
      109001: 'User',
      109002: 'Team',
      109003: 'Host',
      109004: 'Advise',
      109088: 'Custom',
      110001: 'Waiting',
      110002: 'Denyed',
      110003: 'Passed',
    },
  };

  Constant();

  factory Constant.fromString(String data) {
    return Constant.fromJson(jsonDecode(data.substring(data.indexOf('(') + 1, data.lastIndexOf(')'))));
  }

  factory Constant.fromJson(Map<String, dynamic> map) {
    return Constant();
  }

  @override
  String toString() {
    return 'Constant(${jsonEncode(toJson())})';
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
  void updateByJson(Map<String, dynamic> map, {Constant? parser}) {}

  @override
  void updateByKValues(Map<String, dynamic> map) {}
}
