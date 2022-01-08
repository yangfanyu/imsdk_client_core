import 'package:shelf_easy/shelf_easy.dart';

///
///文件信息
///
class Metadata extends DbBaseModel {
  ///唯一id
  ObjectId _id;

  ///商户id
  ObjectId _bsid;

  ///创建时间
  int _time;

  ///自定义数据
  Map<String, String> _extra;

  ///上传者的用户id
  ObjectId uid;

  ///文件类型
  int type;

  ///文件保存的路径
  String path;

  ///文件的字节大小
  int size;

  ///文件是否已经删除
  bool removed;

  ///唯一id
  ObjectId get id => _id;

  ///商户id
  ObjectId get bsid => _bsid;

  ///创建时间
  int get time => _time;

  ///自定义数据
  Map<String, String> get extra => _extra;

  Metadata({
    ObjectId? id,
    ObjectId? bsid,
    int? time,
    Map<String, String>? extra,
    ObjectId? uid,
    int? type,
    String? path,
    int? size,
    bool? removed,
  })  : _id = id ?? ObjectId(),
        _bsid = bsid ?? ObjectId(),
        _time = time ?? DateTime.now().millisecondsSinceEpoch,
        _extra = extra ?? {},
        uid = uid ?? ObjectId(),
        type = type ?? 0,
        path = path ?? '',
        size = size ?? 0,
        removed = removed ?? false;

  factory Metadata.fromJson(Map<String, dynamic> map) {
    return Metadata(
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      bsid: map['_bsid'] is String ? ObjectId.fromHexString(map['_bsid']) : map['_bsid'],
      time: map['_time'],
      extra: (map['_extra'] as Map?)?.map((k, v) => MapEntry(k as String, v as String)),
      uid: map['uid'] is String ? ObjectId.fromHexString(map['uid']) : map['uid'],
      type: map['type'],
      path: map['path'],
      size: map['size'],
      removed: map['removed'],
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
      'type': DbQueryField.convertToBaseType(type),
      'path': DbQueryField.convertToBaseType(path),
      'size': DbQueryField.convertToBaseType(size),
      'removed': DbQueryField.convertToBaseType(removed),
    };
  }

  void updateFields(Map<String, dynamic> map, {Metadata? parser}) {
    parser = parser ?? Metadata.fromJson(map);
    if (map.containsKey('_id')) _id = parser._id;
    if (map.containsKey('_bsid')) _bsid = parser._bsid;
    if (map.containsKey('_time')) _time = parser._time;
    if (map.containsKey('_extra')) _extra = parser._extra;
    if (map.containsKey('uid')) uid = parser.uid;
    if (map.containsKey('type')) type = parser.type;
    if (map.containsKey('path')) path = parser.path;
    if (map.containsKey('size')) size = parser.size;
    if (map.containsKey('removed')) removed = parser.removed;
  }
}

class MetadataDirty {
  final Map<String, dynamic> data = {};

  ///唯一id
  set id(ObjectId value) => data['_id'] = DbQueryField.convertToBaseType(value);

  ///商户id
  set bsid(ObjectId value) => data['_bsid'] = DbQueryField.convertToBaseType(value);

  ///创建时间
  set time(int value) => data['_time'] = DbQueryField.convertToBaseType(value);

  ///自定义数据
  set extra(Map<String, String> value) => data['_extra'] = DbQueryField.convertToBaseType(value);

  ///上传者的用户id
  set uid(ObjectId value) => data['uid'] = DbQueryField.convertToBaseType(value);

  ///文件类型
  set type(int value) => data['type'] = DbQueryField.convertToBaseType(value);

  ///文件保存的路径
  set path(String value) => data['path'] = DbQueryField.convertToBaseType(value);

  ///文件的字节大小
  set size(int value) => data['size'] = DbQueryField.convertToBaseType(value);

  ///文件是否已经删除
  set removed(bool value) => data['removed'] = DbQueryField.convertToBaseType(value);
}
