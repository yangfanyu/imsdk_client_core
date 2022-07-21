import '../model/validator.dart';

///
///通用数据分页
///
class ComPage<T> {
  ///集合序号（如查询CustomX时的集合序号）
  final int no;

  ///当前页码
  int page;

  ///数据总数量
  int total;

  ///分页加载序号
  int pgasync = 0;

  ///分页缓存列表
  final List<T> pgcache = [];

  ComPage({this.no = 0, this.page = 0, this.total = 0});

  ///排重插入到缓存列表末尾
  bool append(T item, bool Function(T a, T b) isRepeat) {
    for (int i = pgcache.length - 1, n = 0; i >= 0 && n < Validator.pageItemMax; i--, n++) {
      if (isRepeat(pgcache[i], item)) return false;
    }
    pgcache.add(item);
    return true;
  }
}
