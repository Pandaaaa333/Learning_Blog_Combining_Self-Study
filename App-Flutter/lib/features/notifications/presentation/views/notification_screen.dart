import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fe_mobile/features/notifications/presentation/providers/notification_provider.dart';
import 'package:fe_mobile/features/notifications/data/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<NotificationProvider>().fetchNotifications(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.read<NotificationProvider>().markAllAsRead(),
            icon: const Icon(Icons.done_all, color: Color(0xFF6366F1)),
            tooltip: 'Đánh dấu tất cả là đã đọc',
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)));
          }

          if (provider.error != null) {
            return Center(child: Text('Lỗi: ${provider.error}'));
          }

          if (provider.notifications.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: provider.fetchNotifications,
            color: const Color(0xFF6366F1),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: provider.notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 1),
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];
                return _NotificationItem(notification: notification);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có thông báo nào',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !notification.isRead;

    return InkWell(
      onTap: () {
        if (isUnread) {
          context.read<NotificationProvider>().markAsRead(notification.id);
        }
        // TODO: Navigate based on notification type
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isUnread ? const Color(0xFFEEF2FF) : Colors.white,
          border: Border(
            left: BorderSide(
              color: isUnread ? const Color(0xFF6366F1) : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeadingIcon(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                          fontSize: 15,
                          color: const Color(0xFF1E1E1E),
                        ),
                      ),
                      Text(
                        _formatDate(notification.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    IconData iconData;
    Color color;

    switch (notification.type) {
      case 'Follow':
        iconData = Icons.person_add_rounded;
        color = const Color(0xFF10B981);
        break;
      case 'Like':
        iconData = Icons.favorite_rounded;
        color = const Color(0xFFEF4444);
        break;
      case 'Comment':
        iconData = Icons.comment_rounded;
        color = const Color(0xFF3B82F6);
        break;
      case 'DeadlineApproaching':
        iconData = Icons.timer_rounded;
        color = const Color(0xFFF59E0B);
        break;
      case 'DeadlineExpired':
        iconData = Icons.event_busy_rounded;
        color = const Color(0xFFDC2626);
        break;
      default:
        iconData = Icons.notifications_rounded;
        color = const Color(0xFF6366F1);
    }

    if (notification.actorAvatar != null) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(notification.actorAvatar!),
        backgroundColor: color.withOpacity(0.1),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 24),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else {
      return DateFormat('dd/MM').format(date);
    }
  }
}
