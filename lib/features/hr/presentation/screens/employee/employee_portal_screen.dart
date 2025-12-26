// FileName: lib/features/hr/presentation/screens/employee/employee_portal_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/employee_requests_screen.dart'; // شاشة الطلبات السابقة
import 'package:mokaab/features/hr/presentation/screens/employee/requests/request_forms.dart'; // النماذج

// نموذج التبليغ
class HrNotification {
  final String title;
  final String body;
  final DateTime date;
  final String type; // info, success, warning, alert
  final bool isRead;

  HrNotification(this.title, this.body, this.date, this.type, {this.isRead = false});
}

class EmployeePortalScreen extends StatefulWidget {
  const EmployeePortalScreen({super.key});

  @override
  State<EmployeePortalScreen> createState() => _EmployeePortalScreenState();
}

class _EmployeePortalScreenState extends State<EmployeePortalScreen> {
  // بيانات وهمية للتبليغات
  final List<HrNotification> _notifications = [
    HrNotification("تم إيداع الراتب", "تم تحويل راتب شهر يونيو إلى حسابك البنكي.", DateTime.now().subtract(const Duration(days: 2)), "success"),
    HrNotification("تذكير: تحديث البيانات", "يرجى تحديث صورة الهوية الشخصية قبل انتهاء الصلاحية.", DateTime.now().subtract(const Duration(days: 5)), "warning"),
    HrNotification("تعميم إداري", "سيتم تعطيل العمل يوم الخميس بمناسبة العيد.", DateTime.now().subtract(const Duration(days: 7)), "info"),
    HrNotification("تمت الموافقة على الإجازة", "وافق المدير المباشر على طلب الإجازة المقدم.", DateTime.now().subtract(const Duration(days: 10)), "success"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("بوابتي (خدمات الموظف)"),
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              // فتح مركز التنبيهات الكامل
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildWelcomeHeader(),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. قسم الإجراءات السريعة
                  const Text("الخدمات السريعة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildQuickActionsGrid(),

                  const SizedBox(height: 24),

                  // 2. قسم التبليغات (آخر التحديثات)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("آخر التبليغات & التعاميم", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(onPressed: () {}, child: const Text("عرض الكل")),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildNotificationsList(),

                  const SizedBox(height: 24),

                  // 3. ملخص الرصيد (إجازات)
                  _buildLeaveBalanceSummary(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- الترويسة الترحيبية ---
  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
      decoration: BoxDecoration(
        color: Colors.indigo[800],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.indigo),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("مرحباً، أحمد عبد الله", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Text("مشغل CNC - إدارة الإنتاج", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                child: const Text("نشط (Active)", style: TextStyle(color: Colors.white, fontSize: 10)),
              )
            ],
          )
        ],
      ),
    );
  }

  // --- شبكة الخدمات ---
  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.1,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _buildActionCard(Icons.assignment, "طلباتي", Colors.blue, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeRequestsScreen()));
        }),
        _buildActionCard(Icons.date_range, "طلب إجازة", Colors.purple, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveRequestScreen()));
        }),
        _buildActionCard(Icons.access_time, "مغادرة", Colors.orange, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const HourlyPermissionScreen()));
        }),
        _buildActionCard(Icons.attach_money, "قسيمة الراتب", Colors.green, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPayslipScreen())); // شاشة جديدة
        }),
        _buildActionCard(Icons.fingerprint, "سجل دوامي", Colors.redAccent, () {
          // يمكن فتح شاشة تعرض سجل الحضور الخاص بالموظف فقط
        }),
        _buildActionCard(Icons.description, "الوثائق", Colors.teal, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentRequestScreen()));
        }),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String label, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // --- قائمة التبليغات ---
  Widget _buildNotificationsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notif = _notifications[index];
        Color iconColor = Colors.blue;
        IconData icon = Icons.info;

        if (notif.type == 'success') { iconColor = Colors.green; icon = Icons.check_circle; }
        if (notif.type == 'warning') { iconColor = Colors.orange; icon = Icons.warning; }

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            leading: Icon(icon, color: iconColor),
            title: Text(notif.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif.body, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Text(DateFormat('yyyy/MM/dd HH:mm').format(notif.date), style: TextStyle(fontSize: 10, color: Colors.grey[500])),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  // --- ملخص رصيد الإجازات المصغر ---
  Widget _buildLeaveBalanceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF263238), Color(0xFF37474F)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBalanceItem("رصيد سنوي", "14", "يوم"),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildBalanceItem("مستهلك", "5", "أيام"),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildBalanceItem("المتبقي", "9", "أيام"),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, String val, String unit) {
    return Column(
      children: [
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text("$label ($unit)", style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

// --- شاشة فرعية: قسيمة الراتب (Payslip) ---
class MyPayslipScreen extends StatelessWidget {
  const MyPayslipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("قسائم الراتب"), backgroundColor: Colors.green),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.attach_money, color: Colors.white)),
              title: Text("راتب شهر ${6 - index} / 2024"),
              subtitle: const Text("الصافي: 450.00 د.أ"),
              trailing: const Icon(Icons.download),
              onTap: () {
                // فتح تفاصيل الراتب أو تحميل PDF
              },
            ),
          );
        },
      ),
    );
  }
}