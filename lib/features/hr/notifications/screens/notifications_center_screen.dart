// FileName: lib/features/hr/notifications/screens/notifications_center_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // تأكد من وجود مكتبة intl في pubspec.yaml
import 'package:mokaab/features/hr/notifications/models/notification_model.dart';

class NotificationsCenterScreen extends StatefulWidget {
  const NotificationsCenterScreen({super.key});

  @override
  State<NotificationsCenterScreen> createState() => _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState extends State<NotificationsCenterScreen> {
  // بيانات وهمية
  final List<HrNotification> _notifications = [
    HrNotification(
      id: '1', title: 'تم إيداع الراتب', 
      body: 'تم تحويل راتب شهر يونيو إلى حسابك البنكي.', 
      date: DateTime.now().subtract(const Duration(hours: 2)), 
      type: NotificationType.success,
      senderName: "الإدارة المالية"
    ),
    HrNotification(
      id: '2', title: 'تعميم إداري: عطلة العيد', 
      body: 'تقرر تعطيل العمل اعتباراً من صباح يوم الأحد ولغاية مساء الثلاثاء.', 
      date: DateTime.now().subtract(const Duration(days: 1)), 
      type: NotificationType.memo, 
      priority: NotificationPriority.high,
      senderName: "الموارد البشرية"
    ),
    HrNotification(
      id: '3', title: 'تذكير: تحديث الوثائق', 
      body: 'يرجى تجديد تصريح العمل قبل تاريخ 20/12 لتجنب الغرامات.', 
      date: DateTime.now().subtract(const Duration(days: 3)), 
      type: NotificationType.alert, 
      priority: NotificationPriority.critical,
      senderName: "نظام التنبيهات"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("مركز الإشعارات والتعاميم"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                // منطق تحديد الكل كمقروء
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم تحديد الكل كمقروء")));
            },
            icon: const Icon(Icons.done_all, size: 18),
            label: const Text("قراءة الكل"),
          )
        ],
      ),
      body: _notifications.isEmpty 
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _notifications.length,
              itemBuilder: (context, index) => _buildNotificationCard(_notifications[index]),
            ),
    );
  }

  Widget _buildNotificationCard(HrNotification notif) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: notif.isRead ? 0 : 2,
      color: notif.isRead ? Colors.grey[50] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: notif.isRead ? Colors.transparent : notif.color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الأيقونة
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: notif.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(notif.icon, color: notif.color, size: 24),
                ),
                const SizedBox(width: 12),
                
                // المحتوى
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(notif.title, style: TextStyle(fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold, fontSize: 16)),
                          if (notif.priority == NotificationPriority.critical)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.red[100], borderRadius: BorderRadius.circular(4)),
                              child: const Text("هام جداً", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(notif.body, style: TextStyle(color: Colors.grey[800], fontSize: 13, height: 1.4)),
                      const SizedBox(height: 8),
                      
                      // التذييل (المرسل والتاريخ)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("من: ${notif.senderName}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          Text(DateFormat('yyyy/MM/dd HH:mm').format(notif.date), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text("لا توجد إشعارات جديدة", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}