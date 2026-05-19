import 'package:fe_admin_web/domain/entities/dashboard_statistics.dart';

abstract class StatisticsRepository {
  Future<DashboardStatistics> getDashboardStatistics();
}
