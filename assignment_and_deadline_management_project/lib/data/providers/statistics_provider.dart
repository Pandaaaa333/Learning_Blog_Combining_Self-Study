import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/dashboard_statistics.dart';
import 'package:fe_admin_web/domain/repositories/statistics_repository.dart';
import 'package:fe_admin_web/data/repositories/statistics_repository_impl.dart';

class StatisticsProvider with ChangeNotifier {
  final StatisticsRepository _repository = StatisticsRepositoryImpl();

  DashboardStatistics? _statistics;
  bool _isLoading = false;
  String? _errorMessage;

  DashboardStatistics? get statistics => _statistics;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDashboardStatistics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _statistics = await _repository.getDashboardStatistics();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
