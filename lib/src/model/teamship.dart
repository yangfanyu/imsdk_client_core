import 'package:shelf_easy/shelf_easy.dart';
import 'message.dart';

///
///群组关系
///
class TeamShip extends DbBaseModel {
  ///唯一id
  ObjectId _id;

  ///商户id
  ObjectId _bsid;

  ///创建时间
  int _time;

  ///自定义数据
  Map<String, String> _extra;

  ///用户id
  ObjectId uid;

  ///会话id
  ObjectId sid;

  ///关联目标id（用户id或群组id）
  ObjectId rid;

  ///关系来源id（用户id或群组id）
  ObjectId fid;

  ///关系来源
  int from;

  ///关系状态
  int state;

  ///申请描述
  String apply;

  ///好友备注名 或 群昵称
  String alias;

  ///是否处于对话状态
  bool dialog;

  ///消息是否显示通知
  bool notice;

  ///是否置顶聊天
  bool top;

  ///未读消息数量
  int unread;

  ///最近消息缩写
  String recent;

  ///最近消息时间
  int update;

  ///对话激活时间
  int active;

  ///唯一id
  ObjectId get id => _id;

  ///商户id
  ObjectId get bsid => _bsid;

  ///创建时间
  int get time => _time;

  ///自定义数据
  Map<String, String> get extra => _extra;

  ///
  ///展示的名称
  ///
  String displayNick = '';

  ///
  ///展示的图标
  ///
  String displayIcon = '';

  ///
  ///展示的头像
  ///
  List<String> displayHead = [];

  ///
  ///展示的名称对应的拼音
  ///
  String displayPinyin = '';

  ///
  ///消息加载序号
  ///
  int msgasync = 0;

  ///
  ///消息缓存列表
  ///
  List<Message> msgcache = [];

  TeamShip({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    Map<String, String>? extra,
    ObjectId? uid,
    ObjectId? sid,
    ObjectId? rid,
    ObjectId? fid,
    int? from,
    int? state,
    String? apply,
    String? alias,
    bool? dialog,
    bool? notice,
    bool? top,
    int? unread,
    String? recent,
    int? update,
    int? active,
  })  : _id = id ?? ObjectId(),
        _bsid = bsid ?? ObjectId(),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? {},
        uid = uid ?? ObjectId(),
        sid = sid ?? ObjectId(),
        rid = rid ?? ObjectId(),
        fid = fid ?? ObjectId(),
        from = from ?? 0,
        state = state ?? 0,
        apply = apply ?? '',
        alias = alias ?? '',
        dialog = dialog ?? true,
        notice = notice ?? true,
        top = top ?? false,
        unread = unread ?? 0,
        recent = recent ?? '',
        update = update ?? DateTime.now().millisecondsSinceEpoch,
        active = active ?? DateTime.now().millisecondsSinceEpoch;

  factory TeamShip.fromJson(Map<String, dynamic> map) {
    return TeamShip(
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      bsid: map['_bsid'] is String ? ObjectId.fromHexString(map['_bsid']) : map['_bsid'],
      time: map['_time'],
      extra: (map['_extra'] as Map?)?.map((k, v) => MapEntry(k as String, v as String)),
      uid: map['uid'] is String ? ObjectId.fromHexString(map['uid']) : map['uid'],
      sid: map['sid'] is String ? ObjectId.fromHexString(map['sid']) : map['sid'],
      rid: map['rid'] is String ? ObjectId.fromHexString(map['rid']) : map['rid'],
      fid: map['fid'] is String ? ObjectId.fromHexString(map['fid']) : map['fid'],
      from: map['from'],
      state: map['state'],
      apply: map['apply'],
      alias: map['alias'],
      dialog: map['dialog'],
      notice: map['notice'],
      top: map['top'],
      unread: map['unread'],
      recent: map['recent'],
      update: map['update'],
      active: map['active'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': DbQueryField.convertToBaseType(_id),
      '_bsid': DbQueryField.convertToBaseType(_bsid),
      '_time': DbQueryField.convertToBaseType(_time),
      '_extra': DbQueryField.convertToBaseType(_extra),
      'uid': DbQueryField.convertToBaseType(uid),
      'sid': DbQueryField.convertToBaseType(sid),
      'rid': DbQueryField.convertToBaseType(rid),
      'fid': DbQueryField.convertToBaseType(fid),
      'from': DbQueryField.convertToBaseType(from),
      'state': DbQueryField.convertToBaseType(state),
      'apply': DbQueryField.convertToBaseType(apply),
      'alias': DbQueryField.convertToBaseType(alias),
      'dialog': DbQueryField.convertToBaseType(dialog),
      'notice': DbQueryField.convertToBaseType(notice),
      'top': DbQueryField.convertToBaseType(top),
      'unread': DbQueryField.convertToBaseType(unread),
      'recent': DbQueryField.convertToBaseType(recent),
      'update': DbQueryField.convertToBaseType(update),
      'active': DbQueryField.convertToBaseType(active),
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
      'sid': sid,
      'rid': rid,
      'fid': fid,
      'from': from,
      'state': state,
      'apply': apply,
      'alias': alias,
      'dialog': dialog,
      'notice': notice,
      'top': top,
      'unread': unread,
      'recent': recent,
      'update': update,
      'active': active,
    };
  }

  @override
  void updateByJson(Map<String, dynamic> map, {TeamShip? parser}) {
    parser = parser ?? TeamShip.fromJson(map);
    if (map.containsKey('_id')) _id = parser._id;
    if (map.containsKey('_bsid')) _bsid = parser._bsid;
    if (map.containsKey('_time')) _time = parser._time;
    if (map.containsKey('_extra')) _extra = parser._extra;
    if (map.containsKey('uid')) uid = parser.uid;
    if (map.containsKey('sid')) sid = parser.sid;
    if (map.containsKey('rid')) rid = parser.rid;
    if (map.containsKey('fid')) fid = parser.fid;
    if (map.containsKey('from')) from = parser.from;
    if (map.containsKey('state')) state = parser.state;
    if (map.containsKey('apply')) apply = parser.apply;
    if (map.containsKey('alias')) alias = parser.alias;
    if (map.containsKey('dialog')) dialog = parser.dialog;
    if (map.containsKey('notice')) notice = parser.notice;
    if (map.containsKey('top')) top = parser.top;
    if (map.containsKey('unread')) unread = parser.unread;
    if (map.containsKey('recent')) recent = parser.recent;
    if (map.containsKey('update')) update = parser.update;
    if (map.containsKey('active')) active = parser.active;
  }

  @override
  void updateByKValues(Map<String, dynamic> map) {
    if (map.containsKey('_id')) _id = map['_id'];
    if (map.containsKey('_bsid')) _bsid = map['_bsid'];
    if (map.containsKey('_time')) _time = map['_time'];
    if (map.containsKey('_extra')) _extra = map['_extra'];
    if (map.containsKey('uid')) uid = map['uid'];
    if (map.containsKey('sid')) sid = map['sid'];
    if (map.containsKey('rid')) rid = map['rid'];
    if (map.containsKey('fid')) fid = map['fid'];
    if (map.containsKey('from')) from = map['from'];
    if (map.containsKey('state')) state = map['state'];
    if (map.containsKey('apply')) apply = map['apply'];
    if (map.containsKey('alias')) alias = map['alias'];
    if (map.containsKey('dialog')) dialog = map['dialog'];
    if (map.containsKey('notice')) notice = map['notice'];
    if (map.containsKey('top')) top = map['top'];
    if (map.containsKey('unread')) unread = map['unread'];
    if (map.containsKey('recent')) recent = map['recent'];
    if (map.containsKey('update')) update = map['update'];
    if (map.containsKey('active')) active = map['active'];
  }
}

class TeamShipDirty {
  final Map<String, dynamic> data = {};

  ///唯一id
  set id(ObjectId value) => data['_id'] = DbQueryField.convertToBaseType(value);

  ///商户id
  set bsid(ObjectId value) => data['_bsid'] = DbQueryField.convertToBaseType(value);

  ///创建时间
  set time(int value) => data['_time'] = DbQueryField.convertToBaseType(value);

  ///自定义数据
  set extra(Map<String, String> value) => data['_extra'] = DbQueryField.convertToBaseType(value);

  ///用户id
  set uid(ObjectId value) => data['uid'] = DbQueryField.convertToBaseType(value);

  ///会话id
  set sid(ObjectId value) => data['sid'] = DbQueryField.convertToBaseType(value);

  ///关联目标id（用户id或群组id）
  set rid(ObjectId value) => data['rid'] = DbQueryField.convertToBaseType(value);

  ///关系来源id（用户id或群组id）
  set fid(ObjectId value) => data['fid'] = DbQueryField.convertToBaseType(value);

  ///关系来源
  set from(int value) => data['from'] = DbQueryField.convertToBaseType(value);

  ///关系状态
  set state(int value) => data['state'] = DbQueryField.convertToBaseType(value);

  ///申请描述
  set apply(String value) => data['apply'] = DbQueryField.convertToBaseType(value);

  ///好友备注名 或 群昵称
  set alias(String value) => data['alias'] = DbQueryField.convertToBaseType(value);

  ///是否处于对话状态
  set dialog(bool value) => data['dialog'] = DbQueryField.convertToBaseType(value);

  ///消息是否显示通知
  set notice(bool value) => data['notice'] = DbQueryField.convertToBaseType(value);

  ///是否置顶聊天
  set top(bool value) => data['top'] = DbQueryField.convertToBaseType(value);

  ///未读消息数量
  set unread(int value) => data['unread'] = DbQueryField.convertToBaseType(value);

  ///最近消息缩写
  set recent(String value) => data['recent'] = DbQueryField.convertToBaseType(value);

  ///最近消息时间
  set update(int value) => data['update'] = DbQueryField.convertToBaseType(value);

  ///对话激活时间
  set active(int value) => data['active'] = DbQueryField.convertToBaseType(value);
}
