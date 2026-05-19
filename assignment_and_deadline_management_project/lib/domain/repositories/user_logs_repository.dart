import 'package:fe_admin_web/domain/entities/user_activity_log_statistics.dart';
import 'package:fe_admin_web/domain/entities/user_activity_log.dart';

abstract class UserLogsRepository {
  Future<List<UserActivityLogStatistics>> getStatistics({DateTime? startDate, DateTime? endDate});
  Future<List<UserActivityLog>> getLogs({String? userId, int limit = 10});
}
