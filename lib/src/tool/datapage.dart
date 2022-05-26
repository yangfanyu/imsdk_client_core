import '../model/customx.dart';
import '../model/validator.dart';

///
///数据分页
///
class DataPage {
  ///集合分类序号
  final int no;

  ///分页加载序号
  int pgasync = 0;

  ///分页缓存列表
  final List<CustomX> pgcache = [];

  DataPage(this.no);

  ///先排重再插入到缓存列表末尾
  bool append(CustomX customx) {
    int index = -1;
    for (int i = pgcache.length - 1, n = 0; i >= 0 && n < Validator.pageItemMax; i--, n++) {
      final item = pgcache[i];
      if (item.id == customx.id) {
        index = i;
        break;
      }
    }
    if (index < 0) {
      pgcache.add(customx);
      return true;
    }
    return false;
  }
}
