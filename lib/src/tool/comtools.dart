import 'package:shelf_easy/shelf_easy.dart';

import '../model/constant.dart';
import '../model/team.dart';
import '../model/teamship.dart';
import '../model/user.dart';
import '../model/usership.dart';

class ComTools {
  ///验证userEnter路由的签名
  static bool validateUserEnterSign(String secret, String token, String uid, int mill, String sign) {
    return EasySecurity.getMd5('$secret$token$uid$token$mill$token$secret') == sign;
  }

  ///生成userEnter路由的签名
  static String generateUserEnterSign(String secret, String token, String uid, int mill) {
    return EasySecurity.getMd5('$secret$token$uid$token$mill$token$secret');
  }

  ///格式化封号时间
  static String formatDenyDateTime(int deny) {
    final date = DateTime.fromMillisecondsSinceEpoch(deny);
    final yyyyMMdd = '${date.year}年${date.month.toString().padLeft(2, '0')}月${date.day.toString().padLeft(2, '0')}日';
    final hhmmss = '${date.hour.toString().padLeft(2, '0')}时${date.minute.toString().padLeft(2, '0')}分:${date.second.toString().padLeft(2, '0')}秒';
    return '$yyyyMMdd $hhmmss';
  }

  ///格式化显示时间
  static String formatDateTime(int mills, {bool yyMMdd = false, bool hhmmss = false}) {
    if (yyMMdd && hhmmss) {
      final date = DateTime.fromMillisecondsSinceEpoch(mills);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
    } else if (yyMMdd) {
      final date = DateTime.fromMillisecondsSinceEpoch(mills);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } else if (hhmmss) {
      final date = DateTime.fromMillisecondsSinceEpoch(mills);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
    } else {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 23, 59, 59, 999); //今天的结束时间点
      final date = DateTime.fromMillisecondsSinceEpoch(mills);
      final abs = today.difference(date);
      if (abs.inDays == 0) {
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
      } else if (abs.inDays == 1) {
        return '昨天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else {
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      }
    }
  }

  ///格式化用户显示账号
  static String formatUserNo(User user, {required String empty}) {
    if (user.no.isNotEmpty) return user.no;
    return empty;
  }

  ///格式化用户显示昵称
  static String formatUserNick(User user) {
    if (user.nick.isNotEmpty) return user.nick;
    if (user.no.isNotEmpty) return user.no;
    return user.id.toHexString();
  }

  ///格式化群组显示名称
  static String formatTeamNick(Team team) {
    if (team.nick.isNotEmpty) return team.nick;
    if (team.no.isNotEmpty) return team.no;
    return team.id.toHexString();
  }

  ///格式化用户显示地址
  static String formatUserShowArea(User who) {
    return '${who.province} ${who.city} ${who.district}';
  }

  ///格式化好友申请内容
  static String formatWaitShipApply(UserShip ship, {required String empty}) {
    if (ship.apply.isNotEmpty) return ship.apply;
    return empty;
  }

  ///格式化用户好友昵称
  static String formatUserShipNick(UserShip ship, User user) {
    if (ship.rid == user.id) {
      if (ship.alias.isNotEmpty) return ship.alias;
    }
    return formatUserNick(user);
  }

  ///格式化群组成员昵称
  static String formatTeamUserNick(TeamShip ship, User user) {
    if (ship.uid == user.id) {
      if (ship.alias.isNotEmpty) return ship.alias;
    }
    return formatUserNick(user);
  }

  ///截取字符串，中文算两个字符，英文算一个字符
  static String formatCNcharacters(String str, {int len = 16, String etc = '…'}) {
    for (int i = 0, subLen = 0; i < str.length; i++) {
      subLen += str.codeUnitAt(i) >= 0 && str.codeUnitAt(i) <= 255 ? 1 : 2;
      if (subLen >= len) return str.substring(0, i + 1) + (i < str.length - 1 ? etc : '');
    }
    return str.substring(0); //返回原字符串的副本
  }

  ///拥有群组超级管理权限或普通管理权限
  static bool isTeamAdmin(Team team, ObjectId uid) {
    if (uid == team.owner) return true;
    return team.admin.any((element) => element == uid);
  }

  ///拥有群组超级管理权限
  static bool isTeamSuperAdmin(Team team, ObjectId uid) {
    return uid == team.owner;
  }

  ///拥有群组普通管理权限，且无超级管理权限
  static bool isTeamNormalAdmin(Team team, ObjectId uid) {
    if (uid == team.owner) return false;
    return team.admin.any((element) => element == uid);
  }

  ///是否为来源于系统级的用户关系
  static bool isUserShipFromSystem(UserShip ship) {
    return ship.from == Constant.shipFromSystemHelper || ship.from == Constant.shipFromServiceHelper;
  }

  ///是否为来源于系统级的群组关系
  static bool isTeamShipFromSystem(TeamShip ship) {
    return ship.from == Constant.shipFromSystemHelper || ship.from == Constant.shipFromServiceHelper;
  }

  ///获取以[dateTime]为参考日期，偏移[offsetDay]天的毫秒开始时间戳
  static int getDayStartMillisByDateOffset(DateTime dateTime, {int offsetDay = 0}) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day + offsetDay).millisecondsSinceEpoch;
  }

  ///获取以[dateTime]为参考日期，偏移[offsetDay]天的毫秒结束时间戳
  static int getDayEndMillisByDateOffset(DateTime dateTime, {int offsetDay = 0}) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day + offsetDay, 23, 59, 59, 999).millisecondsSinceEpoch;
  }

  ///是否为退回红包通知消息的通知id数组
  static bool isRedpackReturnNotice(List<ObjectId> redpackNotice) => redpackNotice.length == 2;

  ///是否抢到红包通知消息的通知id数组
  static bool isRedpackSnatchNotice(List<ObjectId> redpackNotice) => redpackNotice.length == 3;

  ///创建退回红包通知消息的通知id数组
  static List<ObjectId> createRedpackNoticeForReturn({required ObjectId relationId, required ObjectId sendUserId}) => [relationId, sendUserId];

  ///创建抢到红包通知消息的通知id数组
  static List<ObjectId> createRedpackNoticeForSnatch({required ObjectId relationId, required ObjectId sendUserId, required ObjectId luckUserId}) => [relationId, sendUserId, luckUserId];

  ///从通知id数组读取原始红包消息的id
  static ObjectId getRelationIdFromRedpackNotice(List<ObjectId> redpackNotice) => redpackNotice[0];

  ///从通知id数组读取原始红包消息的id
  static ObjectId getSendUserIdFromRedpackNotice(List<ObjectId> redpackNotice) => redpackNotice[1];

  ///从通知id数组读取原始红包消息的id
  static ObjectId getLuckUserIdFromRedpackNotice(List<ObjectId> redpackNotice) => redpackNotice[2];
}
