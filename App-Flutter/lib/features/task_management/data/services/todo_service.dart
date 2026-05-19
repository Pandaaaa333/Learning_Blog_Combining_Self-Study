import 'package:fe_mobile/core/network/api_client.dart';
import 'package:fe_mobile/features/task_management/presentation/viewmodels/todo_viewmodel.dart';
import 'package:intl/intl.dart';

class TodoService {
  final ApiClient _apiClient = ApiClient();

  Future<List<TaskModel>> getTodos({DateTime? date}) async {
    try {
      String path = '/Todos';
      if (date != null) {
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        path += '?date=$dateStr';
      }

      final response = await _apiClient.dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TaskModel.fromJson(json)).toList();
      }
      throw Exception('Failed to load todos');
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskModel> createTodo(String title, DateTime startTime, DateTime? endTime) async {
    try {
      final response = await _apiClient.dio.post('/Todos', data: {
        'title': title,
        'startTime': startTime.toUtc().toIso8601String(),
        'endTime': endTime?.toUtc().toIso8601String(),
      });

      if (response.statusCode == 201) {
        return TaskModel.fromJson(response.data);
      }
      throw Exception('Failed to create todo');
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskModel> toggleTodoStatus(String id) async {
    try {
      final response = await _apiClient.dio.patch('/Todos/$id/toggle');

      if (response.statusCode == 200) {
        return TaskModel.fromJson(response.data);
      }
      throw Exception('Failed to toggle todo status');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteTodo(String id) async {
    try {
      final response = await _apiClient.dio.delete('/Todos/$id');
      return response.statusCode == 204;
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskModel> updateTodo(String id, String title, DateTime startTime, DateTime? endTime, bool isCompleted) async {
    try {
      final response = await _apiClient.dio.put('/Todos/$id', data: {
        'title': title,
        'startTime': startTime.toUtc().toIso8601String(),
        'endTime': endTime?.toUtc().toIso8601String(),
        'isCompleted': isCompleted,
      });

      if (response.statusCode == 200) {
        return TaskModel.fromJson(response.data);
      }
      throw Exception('Failed to update todo');
    } catch (e) {
      rethrow;
    }
  }
}
