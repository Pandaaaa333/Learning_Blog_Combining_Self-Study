import 'package:fe_mobile/core/network/api_client.dart';
import 'package:fe_mobile/features/notifications/data/models/notification_model.dart';

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository(this._apiClient);

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _apiClient.dio.get('/notification');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }

  Future<void> markAsRead(String id) async {
    await _apiClient.dio.patch('/notification/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _apiClient.dio.patch('/notification/read-all');
  }
}
