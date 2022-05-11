import 'package:shelf_easy/shelf_easy.dart';
import 'location.dart';

///
///用户
///
class User extends DbBaseModel {
  ///唯一id
  ObjectId _id;

  ///商户id
  ObjectId _bsid;

  ///创建时间
  int _time;

  ///自定义数据
  Map<String, String> _extra;

  ///手机号码
  String phone;

  ///加密口令
  String token;

  ///RMB支付密码
  String rmbpwd;

  ///RMB拥有数量（分）
  int rmbfen;

  ///第三方账号类型
  int thirdTp;

  ///第三方账号标志
  String thirdNo;

  ///真实姓名
  String name;

  ///身份证号
  String card;

  ///生日
  String birth;

  ///性别
  int sex;

  ///国家
  String country;

  ///省份
  String province;

  ///市
  String city;

  ///县(区)
  String district;

  ///最近定位信息
  Location location;

  ///最近登录时间
  int login;

  ///最近登录ip地址
  String ip;

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

  ///头像
  List<String> head;

  ///是否允许 通过搜索信息来 添加好友 或 加入群组
  bool byfind;

  ///是否允许 通过扫描二维码 添加好友 或 加入群组
  bool bycode;

  ///是否允许 通过分享的名片 添加好友 或 加入群组
  bool bycard;

  ///是否允许 通过群组内关系 添加好友 或 互加好友
  bool byteam;

  ///是否开启 收到消息有后台通知 或 群组资料修改后发送通知
  bool notice;

  ///是否开启 收到消息无声音提醒 或 群组管理员才能发送消息
  bool silent;

  ///被封禁时间截止时间
  int deny;

  ///唯一id
  ObjectId get id => _id;

  ///商户id
  ObjectId get bsid => _bsid;

  ///创建时间
  int get time => _time;

  ///自定义数据
  Map<String, String> get extra => _extra;

  User({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    Map<String, String>? extra,
    String? phone,
    String? token,
    String? rmbpwd,
    int? rmbfen,
    int? thirdTp,
    String? thirdNo,
    String? name,
    String? card,
    String? birth,
    int? sex,
    String? country,
    String? province,
    String? city,
    String? district,
    Location? location,
    int? login,
    String? ip,
    String? no,
    String? pwd,
    String? nick,
    String? desc,
    String? icon,
    List<String>? head,
    bool? byfind,
    bool? bycode,
    bool? bycard,
    bool? byteam,
    bool? notice,
    bool? silent,
    int? deny,
  })  : _id = id ?? ObjectId(),
        _bsid = bsid ?? ObjectId(),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? {},
        phone = phone ?? '',
        token = token ?? '',
        rmbpwd = rmbpwd ?? '',
        rmbfen = rmbfen ?? 0,
        thirdTp = thirdTp ?? 0,
        thirdNo = thirdNo ?? '',
        name = name ?? '',
        card = card ?? '',
        birth = birth ?? '',
        sex = sex ?? 0,
        country = country ?? '',
        province = province ?? '',
        city = city ?? '',
        district = district ?? '',
        location = location ?? Location(),
        login = login ?? 0,
        ip = ip ?? '',
        no = no ?? '',
        pwd = pwd ?? '',
        nick = nick ?? '',
        desc = desc ?? '',
        icon = icon ?? '',
        head = head ?? [],
        byfind = byfind ?? true,
        bycode = bycode ?? true,
        bycard = bycard ?? true,
        byteam = byteam ?? true,
        notice = notice ?? true,
        silent = silent ?? false,
        deny = deny ?? 0;

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      bsid: map['_bsid'] is String ? ObjectId.fromHexString(map['_bsid']) : map['_bsid'],
      time: map['_time'],
      extra: (map['_extra'] as Map?)?.map((k, v) => MapEntry(k as String, v as String)),
      phone: map['phone'],
      token: map['token'],
      rmbpwd: map['rmbpwd'],
      rmbfen: map['rmbfen'],
      thirdTp: map['thirdTp'],
      thirdNo: map['thirdNo'],
      name: map['name'],
      card: map['card'],
      birth: map['birth'],
      sex: map['sex'],
      country: map['country'],
      province: map['province'],
      city: map['city'],
      district: map['district'],
      location: map['location'] is Map ? Location.fromJson(map['location']) : map['location'],
      login: map['login'],
      ip: map['ip'],
      no: map['no'],
      pwd: map['pwd'],
      nick: map['nick'],
      desc: map['desc'],
      icon: map['icon'],
      head: (map['head'] as List?)?.map((v) => v as String).toList(),
      byfind: map['byfind'],
      bycode: map['bycode'],
      bycard: map['bycard'],
      byteam: map['byteam'],
      notice: map['notice'],
      silent: map['silent'],
      deny: map['deny'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': DbQueryField.convertToBaseType(_id),
      '_bsid': DbQueryField.convertToBaseType(_bsid),
      '_time': DbQueryField.convertToBaseType(_time),
      '_extra': DbQueryField.convertToBaseType(_extra),
      'phone': DbQueryField.convertToBaseType(phone),
      'token': DbQueryField.convertToBaseType(token),
      'rmbpwd': DbQueryField.convertToBaseType(rmbpwd),
      'rmbfen': DbQueryField.convertToBaseType(rmbfen),
      'thirdTp': DbQueryField.convertToBaseType(thirdTp),
      'thirdNo': DbQueryField.convertToBaseType(thirdNo),
      'name': DbQueryField.convertToBaseType(name),
      'card': DbQueryField.convertToBaseType(card),
      'birth': DbQueryField.convertToBaseType(birth),
      'sex': DbQueryField.convertToBaseType(sex),
      'country': DbQueryField.convertToBaseType(country),
      'province': DbQueryField.convertToBaseType(province),
      'city': DbQueryField.convertToBaseType(city),
      'district': DbQueryField.convertToBaseType(district),
      'location': DbQueryField.convertToBaseType(location),
      'login': DbQueryField.convertToBaseType(login),
      'ip': DbQueryField.convertToBaseType(ip),
      'no': DbQueryField.convertToBaseType(no),
      'pwd': DbQueryField.convertToBaseType(pwd),
      'nick': DbQueryField.convertToBaseType(nick),
      'desc': DbQueryField.convertToBaseType(desc),
      'icon': DbQueryField.convertToBaseType(icon),
      'head': DbQueryField.convertToBaseType(head),
      'byfind': DbQueryField.convertToBaseType(byfind),
      'bycode': DbQueryField.convertToBaseType(bycode),
      'bycard': DbQueryField.convertToBaseType(bycard),
      'byteam': DbQueryField.convertToBaseType(byteam),
      'notice': DbQueryField.convertToBaseType(notice),
      'silent': DbQueryField.convertToBaseType(silent),
      'deny': DbQueryField.convertToBaseType(deny),
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
      'token': token,
      'rmbpwd': rmbpwd,
      'rmbfen': rmbfen,
      'thirdTp': thirdTp,
      'thirdNo': thirdNo,
      'name': name,
      'card': card,
      'birth': birth,
      'sex': sex,
      'country': country,
      'province': province,
      'city': city,
      'district': district,
      'location': location,
      'login': login,
      'ip': ip,
      'no': no,
      'pwd': pwd,
      'nick': nick,
      'desc': desc,
      'icon': icon,
      'head': head,
      'byfind': byfind,
      'bycode': bycode,
      'bycard': bycard,
      'byteam': byteam,
      'notice': notice,
      'silent': silent,
      'deny': deny,
    };
  }

  void updateFields(Map<String, dynamic> map, {User? parser}) {
    parser = parser ?? User.fromJson(map);
    if (map.containsKey('_id')) _id = parser._id;
    if (map.containsKey('_bsid')) _bsid = parser._bsid;
    if (map.containsKey('_time')) _time = parser._time;
    if (map.containsKey('_extra')) _extra = parser._extra;
    if (map.containsKey('phone')) phone = parser.phone;
    if (map.containsKey('token')) token = parser.token;
    if (map.containsKey('rmbpwd')) rmbpwd = parser.rmbpwd;
    if (map.containsKey('rmbfen')) rmbfen = parser.rmbfen;
    if (map.containsKey('thirdTp')) thirdTp = parser.thirdTp;
    if (map.containsKey('thirdNo')) thirdNo = parser.thirdNo;
    if (map.containsKey('name')) name = parser.name;
    if (map.containsKey('card')) card = parser.card;
    if (map.containsKey('birth')) birth = parser.birth;
    if (map.containsKey('sex')) sex = parser.sex;
    if (map.containsKey('country')) country = parser.country;
    if (map.containsKey('province')) province = parser.province;
    if (map.containsKey('city')) city = parser.city;
    if (map.containsKey('district')) district = parser.district;
    if (map.containsKey('location')) location = parser.location;
    if (map.containsKey('login')) login = parser.login;
    if (map.containsKey('ip')) ip = parser.ip;
    if (map.containsKey('no')) no = parser.no;
    if (map.containsKey('pwd')) pwd = parser.pwd;
    if (map.containsKey('nick')) nick = parser.nick;
    if (map.containsKey('desc')) desc = parser.desc;
    if (map.containsKey('icon')) icon = parser.icon;
    if (map.containsKey('head')) head = parser.head;
    if (map.containsKey('byfind')) byfind = parser.byfind;
    if (map.containsKey('bycode')) bycode = parser.bycode;
    if (map.containsKey('bycard')) bycard = parser.bycard;
    if (map.containsKey('byteam')) byteam = parser.byteam;
    if (map.containsKey('notice')) notice = parser.notice;
    if (map.containsKey('silent')) silent = parser.silent;
    if (map.containsKey('deny')) deny = parser.deny;
  }
}

class UserDirty {
  final Map<String, dynamic> data = {};

  ///唯一id
  set id(ObjectId value) => data['_id'] = DbQueryField.convertToBaseType(value);

  ///商户id
  set bsid(ObjectId value) => data['_bsid'] = DbQueryField.convertToBaseType(value);

  ///创建时间
  set time(int value) => data['_time'] = DbQueryField.convertToBaseType(value);

  ///自定义数据
  set extra(Map<String, String> value) => data['_extra'] = DbQueryField.convertToBaseType(value);

  ///手机号码
  set phone(String value) => data['phone'] = DbQueryField.convertToBaseType(value);

  ///加密口令
  set token(String value) => data['token'] = DbQueryField.convertToBaseType(value);

  ///RMB支付密码
  set rmbpwd(String value) => data['rmbpwd'] = DbQueryField.convertToBaseType(value);

  ///RMB拥有数量（分）
  set rmbfen(int value) => data['rmbfen'] = DbQueryField.convertToBaseType(value);

  ///第三方账号类型
  set thirdTp(int value) => data['thirdTp'] = DbQueryField.convertToBaseType(value);

  ///第三方账号标志
  set thirdNo(String value) => data['thirdNo'] = DbQueryField.convertToBaseType(value);

  ///真实姓名
  set name(String value) => data['name'] = DbQueryField.convertToBaseType(value);

  ///身份证号
  set card(String value) => data['card'] = DbQueryField.convertToBaseType(value);

  ///生日
  set birth(String value) => data['birth'] = DbQueryField.convertToBaseType(value);

  ///性别
  set sex(int value) => data['sex'] = DbQueryField.convertToBaseType(value);

  ///国家
  set country(String value) => data['country'] = DbQueryField.convertToBaseType(value);

  ///省份
  set province(String value) => data['province'] = DbQueryField.convertToBaseType(value);

  ///市
  set city(String value) => data['city'] = DbQueryField.convertToBaseType(value);

  ///县(区)
  set district(String value) => data['district'] = DbQueryField.convertToBaseType(value);

  ///最近定位信息
  set location(Location value) => data['location'] = DbQueryField.convertToBaseType(value);

  ///最近登录时间
  set login(int value) => data['login'] = DbQueryField.convertToBaseType(value);

  ///最近登录ip地址
  set ip(String value) => data['ip'] = DbQueryField.convertToBaseType(value);

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

  ///头像
  set head(List<String> value) => data['head'] = DbQueryField.convertToBaseType(value);

  ///是否允许 通过搜索信息来 添加好友 或 加入群组
  set byfind(bool value) => data['byfind'] = DbQueryField.convertToBaseType(value);

  ///是否允许 通过扫描二维码 添加好友 或 加入群组
  set bycode(bool value) => data['bycode'] = DbQueryField.convertToBaseType(value);

  ///是否允许 通过分享的名片 添加好友 或 加入群组
  set bycard(bool value) => data['bycard'] = DbQueryField.convertToBaseType(value);

  ///是否允许 通过群组内关系 添加好友 或 互加好友
  set byteam(bool value) => data['byteam'] = DbQueryField.convertToBaseType(value);

  ///是否开启 收到消息有后台通知 或 群组资料修改后发送通知
  set notice(bool value) => data['notice'] = DbQueryField.convertToBaseType(value);

  ///是否开启 收到消息无声音提醒 或 群组管理员才能发送消息
  set silent(bool value) => data['silent'] = DbQueryField.convertToBaseType(value);

  ///被封禁时间截止时间
  set deny(int value) => data['deny'] = DbQueryField.convertToBaseType(value);
}
