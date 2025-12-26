// FileName: lib/features/hr/presentation/screens/employee/employee_portal_screen.dart
// Description: بوابة الموظف (ESS) - النسخة النهائية الكاملة
// Version: 3.0 (Final Stable)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// استيراد الشاشات الفرعية
import 'package:mokaab/features/hr/presentation/screens/employee/employee_requests_screen.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/requests/request_forms.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/my_attendance_screen.dart';
import 'package:mokaab/features/hr/notifications/screens/notifications_center_screen.dart';
// استيراد المودل
import 'package:mokaab/features/hr/notifications/models/notification_model.dart';

class EmployeePortalScreen extends StatefulWidget {
  const EmployeePortalScreen({super.key});

  @override
  State<EmployeePortalScreen> createState() => _EmployeePortalScreenState();
}

class _EmployeePortalScreenState extends State<EmployeePortalScreen> {
  bool _hideSalary = true; // حالة إخفاء الراتب

  // بيانات وهمية للإشعارات (للعرض في الواجهة)
  final List<HrNotification> _previewNotifications = [
    HrNotification(
      id: '101',
      title: "تم إيداع الراتب", 
      body: "تم تحويل راتب شهر يونيو إلى حسابك البنكي.", 
      date: DateTime.now().subtract(const Duration(days: 2)), 
      type: NotificationType.success
    ),
    HrNotification(
      id: '102',
      title: "تذكير: تحديث البيانات", 
      body: "يرجى تحديث صورة الهوية الشخصية.", 
      date: DateTime.now().subtract(const Duration(days: 5)), 
      type: NotificationType.alert
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("بوابتي (ESS)"),
        backgroundColor: const Color(0xFF263238), // لون داكن (Dark Theme)
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            tooltip: "الإشعارات",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsCenterScreen()));
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. الترويسة الشخصية
            _buildHeaderProfile(),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. ويدجت حالة الدوام
                  _buildAttendanceStatusWidget(),
                  const SizedBox(height: 20),

                  // 3. قسم النظرة العامة (رصيد + راتب)
                  const Text("نظرة عامة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildLeaveBalanceCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSalaryCard()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 4. الخدمات السريعة (Grid)
                  const Text("خدمات سريعة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildQuickActionsGrid(),

                  const SizedBox(height: 24),

                  // 5. قسم التبليغات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("آخر التبليغات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsCenterScreen()));
                        },
                        child: const Text("عرض الأرشيف"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildNotificationsList(),

                  const SizedBox(height: 20),
                  
                  // 6. الإجراءات المطلوبة
                  _buildActionRequiredSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets البناء ---

  Widget _buildHeaderProfile() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF263238),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(radius: 32, backgroundColor: Colors.white, child: Icon(Icons.person, size: 40, color: Colors.grey)),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                ),
              )
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("مرحباً، أحمد", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Text("مشغل CNC | الإدارة الهندسية", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStatusWidget() {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyAttendanceScreen())),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF3949AB)]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("حالة اليوم", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                const Text("حاضر (On Duty)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                // (تم إزالة const لتجنب الخطأ)
                Row(
                  children: const [
                    Icon(Icons.login, color: Colors.greenAccent, size: 14),
                    SizedBox(width: 4),
                    Text("دخول: 07:55 ص", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: const Text("سجل الدوام", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceCard() {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveRequestScreen())),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.beach_access, color: Colors.orange, size: 20),
                Text("9 أيام", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange[800], fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            const Text("رصيد الإجازات", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: 0.65, backgroundColor: Colors.orange[50], color: Colors.orange, minHeight: 6, borderRadius: BorderRadius.circular(3)),
            const SizedBox(height: 4),
            const Text("متبقي من 14 يوم", style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryCard() {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPayslipScreen())),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.green, size: 20),
                InkWell(
                  onTap: () => setState(() => _hideSalary = !_hideSalary),
                  child: Icon(_hideSalary ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 18),
                )
              ],
            ),
            const SizedBox(height: 8),
            const Text("آخر راتب (يونيو)", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              _hideSalary ? "**** د.أ" : "450.00 د.أ", 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)
            ),
            const SizedBox(height: 4),
            Text("تم الإيداع 25/06", style: TextStyle(fontSize: 10, color: Colors.green[700])),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (constraints.maxWidth > 800) crossAxisCount = 6;
        if (constraints.maxWidth < 400) crossAxisCount = 3;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.85,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            _buildIconAction(Icons.assignment_add, "طلب إجازة", Colors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveRequestScreen()))),
            _buildIconAction(Icons.timer, "مغادرة", Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HourlyPermissionScreen()))),
            _buildIconAction(Icons.description, "وثيقة", Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentRequestScreen()))),
            _buildIconAction(Icons.history, "طلباتي", Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeRequestsScreen()))),
            _buildIconAction(Icons.receipt_long, "قسائم", Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPayslipScreen()))),
            _buildIconAction(Icons.fingerprint, "سجل الدوام", Colors.redAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyAttendanceScreen()))),
            _buildIconAction(Icons.policy, "السياسات", Colors.grey, () {}),
            _buildIconAction(Icons.question_answer, "تواصل", Colors.indigo, () {}),
          ],
        );
      }
    );
  }

  Widget _buildIconAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(12), 
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)]
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 1),
      ],
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _previewNotifications.length,
      itemBuilder: (context, index) {
        final notif = _previewNotifications[index];
        Color iconColor = Colors.blue;
        IconData icon = Icons.info;

        if (notif.type == NotificationType.success) { iconColor = Colors.green; icon = Icons.check_circle; }
        if (notif.type == NotificationType.alert) { iconColor = Colors.orange; icon = Icons.warning; }

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade200)),
          child: ListTile(
            leading: Icon(icon, color: iconColor),
            title: Text(notif.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif.body, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(DateFormat('yyyy/MM/dd HH:mm').format(notif.date), style: TextStyle(fontSize: 10, color: Colors.grey[500])),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsCenterScreen()));
            },
          ),
        );
      },
    );
  }

  Widget _buildActionRequiredSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.amber[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber.shade200)),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // (تم إزالة const لتجنب الخطأ)
              children: const [
                Text("إجراء مطلوب", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                Text("يرجى تحديث صورة الهوية الشخصية قبل 20/12 لتجنب وقف الراتب.", style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.amber),
        ],
      ),
    );
  }
}

// --- شاشة فرعية: قسيمة الراتب (Payslip) ---
class MyPayslipScreen extends StatelessWidget {
  const MyPayslipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("قسائم الراتب"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3, // عدد وهمي للتجربة
        itemBuilder: (context, index) {
          // بيانات وهمية
          final month = DateTime.now().subtract(Duration(days: 30 * index));
          final monthName = DateFormat('MMMM yyyy', 'ar').format(month);
          
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                child: const Icon(Icons.attach_money, color: Colors.green),
              ),
              title: Text("راتب شهر $monthName", style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("الصافي: 450.00 د.أ"),
              trailing: IconButton(
                icon: const Icon(Icons.download_rounded, color: Colors.grey),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("جاري تحميل قسيمة الراتب PDF..."))
                  );
                },
              ),
              onTap: () {
                // هنا يمكن فتح تفاصيل القسيمة
              },
            ),
          );
        },
      ),
    );
  }
}