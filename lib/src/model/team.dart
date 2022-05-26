import 'package:shelf_easy/shelf_easy.dart';

///
///群组
///
class Team extends DbBaseModel {
  ///唯一id
  ObjectId _id;

  ///商户id
  ObjectId _bsid;

  ///创建时间
  int _time;

  ///自定义数据
  DbJsonWraper _extra;

  ///创建者用户id
  ObjectId owner;

  ///管理员用户id
  List<ObjectId> admin;

  ///群组成员总数量
  int member;

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
  DbJsonWraper get extra => _extra;

  Team({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    DbJsonWraper? extra,
    ObjectId? owner,
    List<ObjectId>? admin,
    int? member,
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
        _bsid = bsid ?? ObjectId.fromHexString('000000000000000000000000'),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? DbJsonWraper(),
        owner = owner ?? ObjectId.fromHexString('000000000000000000000000'),
        admin = admin ?? [],
        member = member ?? 0,
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

  factory Team.fromString(String data) {
    return Team.fromJson(jsonDecode(data.substring(data.indexOf('(') + 1, data.lastIndexOf(')'))));
  }

  factory Team.fromJson(Map<String, dynamic> map) {
    return Team(
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      bsid: map['_bsid'] is String ? ObjectId.fromHexString(map['_bsid']) : map['_bsid'],
      time: map['_time'],
      extra: map['_extra'] is Map ? DbJsonWraper.fromJson(map['_extra']) : map['_extra'],
      owner: map['owner'] is String ? ObjectId.fromHexString(map['owner']) : map['owner'],
      admin: (map['admin'] as List?)?.map((v) => v is String ? ObjectId.fromHexString(v) : v as ObjectId).toList(),
      member: map['member'],
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
  String toString() {
    return 'Team(${jsonEncode(toJson())})';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': DbQueryField.convertToBaseType(_id),
      '_bsid': DbQueryField.convertToBaseType(_bsid),
      '_time': DbQueryField.convertToBaseType(_time),
      '_extra': DbQueryField.convertToBaseType(_extra),
      'owner': DbQueryField.convertToBaseType(owner),
      'admin': DbQueryField.convertToBaseType(admin),
      'member': DbQueryField.convertToBaseType(member),
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
      'owner': owner,
      'admin': admin,
      'member': member,
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

  @override
  void updateByJson(Map<String, dynamic> map, {Team? parser}) {
    parser = parser ?? Team.fromJson(map);
    if (map.containsKey('_id')) _id = parser._id;
    if (map.containsKey('_bsid')) _bsid = parser._bsid;
    if (map.containsKey('_time')) _time = parser._time;
    if (map.containsKey('_extra')) _extra = parser._extra;
    if (map.containsKey('owner')) owner = parser.owner;
    if (map.containsKey('admin')) admin = parser.admin;
    if (map.containsKey('member')) member = parser.member;
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

  @override
  void updateByKValues(Map<String, dynamic> map) {
    if (map.containsKey('_id')) _id = map['_id'];
    if (map.containsKey('_bsid')) _bsid = map['_bsid'];
    if (map.containsKey('_time')) _time = map['_time'];
    if (map.containsKey('_extra')) _extra = map['_extra'];
    if (map.containsKey('owner')) owner = map['owner'];
    if (map.containsKey('admin')) admin = map['admin'];
    if (map.containsKey('member')) member = map['member'];
    if (map.containsKey('no')) no = map['no'];
    if (map.containsKey('pwd')) pwd = map['pwd'];
    if (map.containsKey('nick')) nick = map['nick'];
    if (map.containsKey('desc')) desc = map['desc'];
    if (map.containsKey('icon')) icon = map['icon'];
    if (map.containsKey('head')) head = map['head'];
    if (map.containsKey('byfind')) byfind = map['byfind'];
    if (map.containsKey('bycode')) bycode = map['bycode'];
    if (map.containsKey('bycard')) bycard = map['bycard'];
    if (map.containsKey('byteam')) byteam = map['byteam'];
    if (map.containsKey('notice')) notice = map['notice'];
    if (map.containsKey('silent')) silent = map['silent'];
    if (map.containsKey('deny')) deny = map['deny'];
  }
}

class TeamDirty {
  final Map<String, dynamic> data = {};

  ///唯一id
  set id(ObjectId value) => data['_id'] = DbQueryField.convertToBaseType(value);

  ///商户id
  set bsid(ObjectId value) => data['_bsid'] = DbQueryField.convertToBaseType(value);

  ///创建时间
  set time(int value) => data['_time'] = DbQueryField.convertToBaseType(value);

  ///自定义数据
  set extra(DbJsonWraper value) => data['_extra'] = DbQueryField.convertToBaseType(value);

  ///创建者用户id
  set owner(ObjectId value) => data['owner'] = DbQueryField.convertToBaseType(value);

  ///管理员用户id
  set admin(List<ObjectId> value) => data['admin'] = DbQueryField.convertToBaseType(value);

  ///群组成员总数量
  set member(int value) => data['member'] = DbQueryField.convertToBaseType(value);

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
