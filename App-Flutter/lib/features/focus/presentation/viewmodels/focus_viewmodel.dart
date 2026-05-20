import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fe_mobile/core/network/api_client.dart';

class FocusViewModel extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  // =========================================
  // 1. LOGIC HẸN GIỜ (COUNTDOWN)
  // =========================================
  Duration countdownDuration = const Duration(minutes: 25);
  Duration countdownRemaining = const Duration(minutes: 25);
  Timer? _countdownTimer;
  bool isCountdownRunning = false;
  String countdownLabel = 'Focus';

  // Trạng thái Gamification
  bool hasCompletedSession = false;
  int lastXpEarned = 0;
  bool isTreeDead = false;
  double deadProgress = 0.0;
  String? selectedTaskId;

  void setCountdownDuration(Duration duration) {
    countdownDuration = duration;
    countdownRemaining = duration;
    isTreeDead = false;
    deadProgress = 0.0;
    notifyListeners();
  }

  void setCountdownLabel(String label, {String? taskId}) {
    countdownLabel = label.isEmpty ? 'Hẹn giờ' : label;
    selectedTaskId = taskId;
    notifyListeners();
  }

  void resetTree() {
    isTreeDead = false;
    deadProgress = 0.0;
    countdownRemaining = countdownDuration;
    notifyListeners();
  }

  void toggleCountdown() {
    if (isCountdownRunning) {
      isCountdownRunning = false;
      _countdownTimer?.cancel();
    } else {
      if (countdownRemaining.inSeconds == 0) return;
      isTreeDead = false;
      deadProgress = 0.0;
      isCountdownRunning = true;
      hasCompletedSession = false;
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdownRemaining.inSeconds > 0) {
          countdownRemaining -= const Duration(seconds: 1);
        } else {
          isCountdownRunning = false;
          _countdownTimer?.cancel();
          
          // Trải nghiệm Gamification
          lastXpEarned = countdownDuration.inMinutes;
          if (lastXpEarned == 0) lastXpEarned = 1; // Để dễ test 1 XP tối thiểu
          hasCompletedSession = true;
        }
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void cancelCountdown() {
    if (isCountdownRunning) {
      isTreeDead = true;
      final totalSec = countdownDuration.inSeconds;
      final remSec = countdownRemaining.inSeconds;
      deadProgress = totalSec > 0 ? (totalSec - remSec) / totalSec : 0.0;
      isCountdownRunning = false;
      _countdownTimer?.cancel();
      countdownRemaining = Duration.zero;
    } else {
      isTreeDead = false;
      deadProgress = 0.0;
      countdownRemaining = countdownDuration; 
    }
    hasCompletedSession = false;
    notifyListeners();
  }

  // Hàm gọi API lưu nhật ký học tập
  Future<Map<String, dynamic>?> saveStudyLog() async {
    try {
      int duration = countdownDuration.inMinutes;
      if (duration == 0) duration = 1; // Tối thiểu 1 phút để tích lũy XP

      await _apiClient.dio.post('/SelfLearn/logs', data: {
        'startTime': DateTime.now().subtract(countdownDuration).toIso8601String(),
        'endTime': DateTime.now().toIso8601String(),
        'duration': duration,
        'note': countdownLabel,
        'fileId': null,
      });

      // Tải lại thông tin User profile để cập nhật Level & XP mới
      final userResponse = await _apiClient.dio.get('/Auth/me');
      if (userResponse.statusCode == 200) {
        return userResponse.data;
      }
    } catch (e) {
      debugPrint('Lỗi lưu nhật ký học tập: $e');
    }
    return null;
  }

  void resetCompletionState() {
    hasCompletedSession = false;
    notifyListeners();
  }

  // =========================================
  // 2. LOGIC BẤM GIỜ (STOPWATCH)
  // =========================================
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _stopwatchTimer;
  Duration stopwatchElapsed = Duration.zero;
  bool isStopwatchRunning = false;

  void toggleStopwatch() {
    if (isStopwatchRunning) {
      _stopwatch.stop();
      _stopwatchTimer?.cancel();
      isStopwatchRunning = false;
    } else {
      _stopwatch.start();
      isStopwatchRunning = true;
      _stopwatchTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
        stopwatchElapsed = _stopwatch.elapsed;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void resetStopwatch() {
    _stopwatch.stop();
    _stopwatch.reset();
    _stopwatchTimer?.cancel();
    isStopwatchRunning = false;
    stopwatchElapsed = Duration.zero;
    notifyListeners();
  }
}