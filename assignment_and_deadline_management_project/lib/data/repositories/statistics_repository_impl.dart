import 'package:dio/dio.dart';
import 'package:fe_admin_web/core/api_client.dart';
import 'package:fe_admin_web/domain/entities/dashboard_statistics.dart';
import 'package:fe_admin_web/domain/repositories/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final Dio _dio = ApiClient().dio;

  @override
  Future<DashboardStatistics> getDashboardStatistics() async {
    final response = await _dio.get('/statistics/dashboard');
    return DashboardStatistics.fromJson(response.data);
  }
}
