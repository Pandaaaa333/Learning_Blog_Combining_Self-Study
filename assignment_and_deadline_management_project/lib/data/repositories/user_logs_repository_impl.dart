import 'package:dio/dio.dart';
import 'package:fe_admin_web/core/api_client.dart';
import 'package:fe_admin_web/domain/entities/user_activity_log_statistics.dart';
import 'package:fe_admin_web/domain/entities/user_activity_log.dart';
import 'package:fe_admin_web/domain/repositories/user_logs_repository.dart';

class UserLogsRepositoryImpl implements UserLogsRepository {
  final Dio _dio = ApiClient().dio;

  @override
  Future<List<UserActivityLogStatistics>> getStatistics({DateTime? startDate, DateTime? endDate}) async {
    final Map<String, dynamic> queryParameters = {};
    if (startDate != null) {
      queryParameters['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParameters['endDate'] = endDate.toIso8601String();
    }

    final response = await _dio.get('/user-logs/statistics', queryParameters: queryParameters);
    final List<dynamic> data = response.data;
    return data.map((json) => UserActivityLogStatistics.fromJson(json)).toList();
  }

  @override
  Future<List<UserActivityLog>> getLogs({String? userId, int limit = 10}) async {
    final Map<String, dynamic> queryParameters = {'limit': limit};
    if (userId != null) {
      queryParameters['userId'] = userId;
    }

    final response = await _dio.get('/user-logs', queryParameters: queryParameters);
    final List<dynamic> data = response.data;
    return data.map((json) => UserActivityLog.fromJson(json)).toList();
  }
}
