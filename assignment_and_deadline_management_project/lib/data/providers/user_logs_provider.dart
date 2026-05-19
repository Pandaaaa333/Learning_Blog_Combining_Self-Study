import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/user_activity_log_statistics.dart';
import 'package:fe_admin_web/domain/entities/user_activity_log.dart';
import 'package:fe_admin_web/domain/repositories/user_logs_repository.dart';
import 'package:fe_admin_web/data/repositories/user_logs_repository_impl.dart';

class UserLogsProvider with ChangeNotifier {
  final UserLogsRepository _repository = UserLogsRepositoryImpl();

  List<UserActivityLogStatistics> _statistics = [];
  List<UserActivityLog> _recentLogs = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserActivityLogStatistics> get statistics => _statistics;
  List<UserActivityLog> get recentLogs => _recentLogs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchStatistics({DateTime? startDate, DateTime? endDate}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _statistics = await _repository.getStatistics(startDate: startDate, endDate: endDate);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecentLogs({int limit = 10}) async {
    try {
      _recentLogs = await _repository.getLogs(limit: limit);
      notifyListeners();
    } catch (e) {
      print('Failed to fetch recent logs: $e');
    }
  }
}
