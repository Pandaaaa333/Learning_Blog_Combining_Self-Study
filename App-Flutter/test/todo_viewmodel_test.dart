import 'package:flutter_test/flutter_test.dart';
import 'package:fe_mobile/features/task_management/presentation/viewmodels/todo_viewmodel.dart';
import 'package:fe_mobile/features/task_management/data/services/todo_service.dart';

class MockTodoService implements TodoService {
  List<TaskModel> todos = [];
  bool shouldThrow = false;
  String throwMessage = 'Mock error';
  
  bool getTodosCalled = false;
  bool createTodoCalled = false;
  bool toggleTodoStatusCalled = false;
  bool deleteTodoCalled = false;
  bool updateTodoCalled = false;

  @override
  Future<List<TaskModel>> getTodos({DateTime? date}) async {
    getTodosCalled = true;
    if (shouldThrow) throw Exception(throwMessage);
    return List.from(todos);
  }

  @override
  Future<TaskModel> createTodo(String title, DateTime startTime, DateTime? endTime) async {
    createTodoCalled = true;
    if (shouldThrow) throw Exception(throwMessage);
    final newTask = TaskModel(
      id: 'mock_new_id',
      title: title,
      startTime: startTime,
      endTime: endTime,
      isCompleted: false,
    );
    todos.add(newTask);
    return newTask;
  }

  @override
  Future<TaskModel> toggleTodoStatus(String id) async {
    toggleTodoStatusCalled = true;
    if (shouldThrow) throw Exception(throwMessage);
    final taskIndex = todos.indexWhere((t) => t.id == id);
    if (taskIndex != -1) {
      final task = todos[taskIndex];
      final updated = TaskModel(
        id: task.id,
        title: task.title,
        startTime: task.startTime,
        endTime: task.endTime,
        isCompleted: !task.isCompleted,
      );
      todos[taskIndex] = updated;
      return updated;
    }
    throw Exception('Task not found');
  }

  @override
  Future<bool> deleteTodo(String id) async {
    deleteTodoCalled = true;
    if (shouldThrow) throw Exception(throwMessage);
    final initialLength = todos.length;
    todos.removeWhere((t) => t.id == id);
    return todos.length < initialLength;
  }

  @override
  Future<TaskModel> updateTodo(String id, String title, DateTime startTime, DateTime? endTime, bool isCompleted) async {
    updateTodoCalled = true;
    if (shouldThrow) throw Exception(throwMessage);
    final taskIndex = todos.indexWhere((t) => t.id == id);
    if (taskIndex != -1) {
      final updated = TaskModel(
        id: id,
        title: title,
        startTime: startTime,
        endTime: endTime,
        isCompleted: isCompleted,
      );
      todos[taskIndex] = updated;
      return updated;
    }
    throw Exception('Task not found');
  }
}

void main() {
  group('TodoViewModel Unit Tests', () {
    late MockTodoService mockTodoService;
    late List<TaskModel> initialMockTasks;

    setUp(() {
      mockTodoService = MockTodoService();
      
      final today = DateTime.now();
      initialMockTasks = [
        TaskModel(
          id: 't1',
          title: 'Học lập trình Flutter',
          startTime: today,
          isCompleted: false,
        ),
        TaskModel(
          id: 't2',
          title: 'Làm bài tập C#',
          startTime: today,
          isCompleted: true,
        ),
        TaskModel(
          id: 't3',
          title: 'Đi mua đồ ăn',
          startTime: today.subtract(const Duration(days: 1)),
          isCompleted: false,
        ),
      ];
      mockTodoService.todos = initialMockTasks;
    });

    test('TODO_VM_01: Should initialize with fetched tasks successfully', () async {
      final viewModel = TodoViewModel(todoService: mockTodoService);

      // Verify immediate loading state
      expect(viewModel.isLoading, isTrue);
      expect(viewModel.allTasks, isEmpty);

      // Wait for the async constructor-triggered fetch
      await Future.delayed(Duration.zero);

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.error, isNull);
      expect(viewModel.allTasks.length, 3);
      expect(viewModel.allTasks[0].title, 'Học lập trình Flutter');
    });

    test('TODO_VM_02: Should handle fetch error gracefully', () async {
      mockTodoService.shouldThrow = true;
      mockTodoService.throwMessage = 'Lỗi kết nối database';

      final viewModel = TodoViewModel(todoService: mockTodoService);

      await Future.delayed(Duration.zero);

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.error, contains('Lỗi kết nối database'));
      expect(viewModel.allTasks, isEmpty);
    });

    test('TODO_VM_03: Should calculate correct week days starting on Monday', () async {
      // Pick a known Wednesday: 2026-05-27 (Wednesday)
      final selectedDate = DateTime(2026, 5, 27);
      
      final viewModel = TodoViewModel(todoService: mockTodoService);
      await Future.delayed(Duration.zero);

      viewModel.changeDate(selectedDate);
      
      final weekDays = viewModel.currentWeekDays;

      expect(weekDays.length, 7);
      // Monday should be 2026-05-25
      expect(weekDays[0].day, 25);
      expect(weekDays[0].month, 5);
      expect(weekDays[0].year, 2026);
      expect(weekDays[0].weekday, DateTime.monday);
      
      // Sunday should be 2026-05-31
      expect(weekDays[6].day, 31);
      expect(weekDays[6].weekday, DateTime.sunday);
    });

    test('TODO_VM_04: Should get only tasks for a specific day', () async {
      final viewModel = TodoViewModel(todoService: mockTodoService);
      await Future.delayed(Duration.zero);

      final today = DateTime.now();
      final tasksToday = viewModel.getTasksForDay(today);
      final tasksYesterday = viewModel.getTasksForDay(today.subtract(const Duration(days: 1)));

      expect(tasksToday.length, 2);
      expect(tasksToday.any((t) => t.id == 't1'), isTrue);
      expect(tasksToday.any((t) => t.id == 't2'), isTrue);

      expect(tasksYesterday.length, 1);
      expect(tasksYesterday[0].id, 't3');
    });

    test('TODO_VM_05: Should return all tasks for day when filter is All (0)', () async {
      final viewModel = TodoViewModel(todoService: mockTodoService);
      await Future.delayed(Duration.zero);

      viewModel.changeFilter(0); // All
      
      final tasks = viewModel.filteredTasks;
      expect(tasks.length, 2);
      expect(tasks.any((t) => t.id == 't1'), isTrue);
      expect(tasks.any((t) => t.id == 't2'), isTrue);
    });

    test('TODO_VM_06: Should return only uncompleted tasks for day when filter is Active (1)', () async {
      final viewModel = TodoViewModel(todoService: mockTodoService);
      await Future.delayed(Duration.zero);

      viewModel.changeFilter(1); // Active
      
      final tasks = viewModel.filteredTasks;
      expect(tasks.length, 1);
      expect(tasks[0].id, 't1');
      expect(tasks[0].isCompleted, isFalse);
    });

    test('TODO_VM_07: Should return only completed tasks for day when filter is Completed (2)', () async {
      final viewModel = TodoViewModel(todoService: mockTodoService);
      await Future.delayed(Duration.zero);

      viewModel.changeFilter(2); // Completed
      
      final tasks = viewModel.filteredTasks;
      expect(tasks.length, 1);
      expect(tasks[0].id, 't2');
      expect(tasks[0].isCompleted, isTrue);
    });

    test('TODO_VM_08: Should change selected date and trigger fetch', () async {
      final viewModel = TodoViewModel(todoService: mockTodoService);
      await Future.delayed(Duration.zero);

      mockTodoService.getTodosCalled = false;
      final newDate = DateTime.now().add(const Duration(days: 2));
      
      viewModel.changeDate(newDate);

      expect(viewModel.selectedDate, newDate);
      expect(viewModel.focusedDate, newDate);
      expect(mockTodoService.getTodosCalled, isTrue);
    });

    test('TODO_VM_09: Should toggle task status successfully', () async {
      final viewModel = TodoViewModel(todoService: mockTodoService);
      await Future.delayed(Duration.zero);

      expect(viewModel.allTasks.firstWhere((t) => t.id == 't1').isCompleted, isFalse);

      await viewModel.toggleTaskStatus('t1');

      expect(viewModel.allTasks.firstWhere((t) => t.id == 't1').isCompleted, isTrue);
      expect(mockTodoService.toggleTodoStatusCalled, isTrue);
    });

    test('TODO_VM_10: Should add new task and fetch list again', () async {
      final viewModel = TodoViewModel(todoService: mockTodoService);
      await Future.delayed(Duration.zero);

      mockTodoService.getTodosCalled = false;
      
      final startTime = DateTime.now();
      await viewModel.addTask('Học máy học', startTime, null);

      expect(mockTodoService.createTodoCalled, isTrue);
      expect(mockTodoService.getTodosCalled, isTrue); // should trigger fetch
      expect(viewModel.allTasks.any((t) => t.title == 'Học máy học'), isTrue);
    });

    test('TODO_VM_11: Should delete task successfully', () async {
      final viewModel = TodoViewModel(todoService: mockTodoService);
      await Future.delayed(Duration.zero);

      expect(viewModel.allTasks.length, 3);

      await viewModel.deleteTask('t1');

      expect(mockTodoService.deleteTodoCalled, isTrue);
      expect(viewModel.allTasks.length, 2);
      expect(viewModel.allTasks.any((t) => t.id == 't1'), isFalse);
    });
  });
}
