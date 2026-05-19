import 'package:flutter/material.dart';
import 'package:fe_mobile/features/task_management/data/services/todo_service.dart';

// 1. Cập nhật Model: Dùng DateTime cho cả bắt đầu và kết thúc
class TaskModel {
  final String id;
  final String title;
  bool isCompleted;
  final DateTime startTime; // Ngày & Giờ bắt đầu
  final DateTime? endTime;  // Ngày & Giờ kết thúc (Có thể null)

  TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.startTime,
    this.endTime,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      startTime: DateTime.parse(json['startTime']).toLocal(),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']).toLocal() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }
}

class TodoViewModel extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  
  DateTime _selectedDate = DateTime.now(); 
  DateTime _focusedDate = DateTime.now();
  int _selectedFilterIndex = 0; 
  bool _isLoading = false;
  String? _error;

  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;
  int get selectedFilterIndex => _selectedFilterIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Expose toàn bộ tasks để phục vụ tính năng Tìm kiếm toàn cục
  List<TaskModel> get allTasks => _allTasks; 

  List<TaskModel> _allTasks = [];

  TodoViewModel() {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch toàn bộ để có thể hiển thị trên lịch cho tất cả các ngày
      _allTasks = await _todoService.getTodos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<DateTime> get currentWeekDays {
    int currentWeekday = _selectedDate.weekday; 
    DateTime monday = _selectedDate.subtract(Duration(days: currentWeekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<TaskModel> getTasksForDay(DateTime day) {
    return _allTasks.where((t) => _isSameDay(t.startTime, day)).toList();
  }

  List<TaskModel> get filteredTasks {
    var tasksForDay = getTasksForDay(_selectedDate);
    
    if (_selectedFilterIndex == 1) return tasksForDay.where((t) => !t.isCompleted).toList();
    if (_selectedFilterIndex == 2) return tasksForDay.where((t) => t.isCompleted).toList();
    return tasksForDay;
  }

  void changeDate(DateTime date) {
    _selectedDate = date;
    _focusedDate = date; // Also update focused date to stay in sync
    fetchTasks(); // Tải lại dữ liệu cho ngày mới
  }

  void changeFocusedDate(DateTime date) {
    _focusedDate = date;
    notifyListeners();
  }

  void changeFilter(int index) {
    _selectedFilterIndex = index;
    notifyListeners();
  }

  Future<void> toggleTaskStatus(String taskId) async {
    try {
      final updatedTask = await _todoService.toggleTodoStatus(taskId);
      final index = _allTasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _allTasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // --- TÍNH NĂNG MỚI: Thêm công việc ---
  Future<void> addTask(String title, DateTime start, DateTime? end) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _todoService.createTodo(title, start, end);
      await fetchTasks(); // Tải lại toàn bộ list cho ngày đang chọn để đảm bảo đồng bộ
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final success = await _todoService.deleteTodo(taskId);
      if (success) {
        _allTasks.removeWhere((t) => t.id == taskId);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}