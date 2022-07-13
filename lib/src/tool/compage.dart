///
///通用数据分页
///
class ComPage<T> {
  ///当前页码
  final int page;

  ///数据总数量
  final int total;

  ///分页缓存列表
  final List<T> pgcache = [];

  ComPage({required this.page, required this.total});
}
