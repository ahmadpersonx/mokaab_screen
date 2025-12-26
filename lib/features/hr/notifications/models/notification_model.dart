// FileName: lib/features/hr/notifications/models/notification_model.dart
import 'package:flutter/material.dart';

enum NotificationType { system, memo, alert, success }
enum NotificationPriority { low, normal, high, critical }

class HrNotification {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final NotificationType type;
  final NotificationPriority priority;
  final String senderName; // مثلاً: إدارة الموارد البشرية
  final bool isRead;
  final String? actionLink; // رابط للذهاب لشاشة معينة (مثلاً الموافقة على طلب)

  HrNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.type = NotificationType.system,
    this.priority = NotificationPriority.normal,
    this.senderName = "System",
    this.isRead = false,
    this.actionLink,
  });

  // Helper للحصول على الألوان والأيقونات
  Color get color {
    switch (type) {
      case NotificationType.success: return Colors.green;
      case NotificationType.alert: return Colors.red;
      case NotificationType.memo: return Colors.purple;
      default: return Colors.blue;
    }
  }

  IconData get icon {
    switch (type) {
      case NotificationType.success: return Icons.check_circle;
      case NotificationType.alert: return Icons.warning_amber;
      case NotificationType.memo: return Icons.campaign; // بوق إعلان
      default: return Icons.notifications;
    }
  }
}