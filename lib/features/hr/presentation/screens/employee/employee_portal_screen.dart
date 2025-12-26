// FileName: lib/features/hr/presentation/screens/employee/employee_portal_screen.dart
// Description: Employee Portal (ESS) - Activated Sub-screens (Payslip, Policies, Contact)
// Version: 7.1

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/employee_requests_screen.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/requests/request_forms.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/my_attendance_screen.dart';
import 'package:mokaab/features/hr/notifications/screens/notifications_center_screen.dart';
import 'package:mokaab/features/hr/notifications/models/notification_model.dart';

// --- نموذج المهمة ---
class EmployeeAction {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;
  final Color color;

  EmployeeAction({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
    this.color = Colors.orange,
  });
}

class EmployeePortalScreen extends StatefulWidget {
  const EmployeePortalScreen({super.key});

  @override
  State<EmployeePortalScreen> createState() => _EmployeePortalScreenState();
}

class _EmployeePortalScreenState extends State<EmployeePortalScreen> {
  bool _hideSalary = true;
  List<EmployeeAction> _pendingActions = [];

  final List<HrNotification> _previewNotifications = [
    HrNotification(
      id: '101', title: "تم إيداع الراتب", 
      body: "تم تحويل راتب شهر يونيو إلى حسابك البنكي.", 
      date: DateTime.now().subtract(const Duration(days: 2)), type: NotificationType.success
    ),
    HrNotification(
      id: '102', title: "تذكير: تحديث البيانات", 
      body: "يرجى تحديث صورة الهوية الشخصية.", 
      date: DateTime.now().subtract(const Duration(days: 5)), type: NotificationType.alert
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkPendingActions();
  }

  void _checkPendingActions() {
    List<EmployeeAction> actions = [];
    bool isIdExpired = true; 
    if (isIdExpired) {
      actions.add(EmployeeAction(
        title: "تحديث وثائق",
        description: "الهوية الوطنية منتهية الصلاحية.",
        buttonText: "تحديث",
        color: Colors.redAccent,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentRequestScreen())),
      ));
    }
    setState(() => _pendingActions = actions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("بوابتي (الخدمة الذاتية)"),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsCenterScreen())),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildWelcomeBanner(),
            const SizedBox(height: 24),

            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  // Desktop Layout
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_pendingActions.isNotEmpty) ...[
                              _buildActionRequiredSection(),
                              const SizedBox(height: 24),
                            ],
                            _buildAttendanceCard(),
                            const SizedBox(height: 24),
                            _buildSummarySection(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("الخدمات الإلكترونية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(height: 16),
                            _buildQuickActionsGrid(isWide: true),
                            const SizedBox(height: 32),
                            _buildNotificationsSection(),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  // Mobile Layout
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_pendingActions.isNotEmpty) ...[
                        _buildActionRequiredSection(),
                        const SizedBox(height: 24),
                      ],
                      _buildAttendanceCard(),
                      const SizedBox(height: 24),
                      _buildSummarySection(),
                      const SizedBox(height: 24),
                      const Text("الخدمات الإلكترونية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 16),
                      _buildQuickActionsGrid(isWide: false),
                      const SizedBox(height: 32),
                      _buildNotificationsSection(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildWelcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.indigo[50],
            child: Icon(Icons.person, size: 40, color: Colors.indigo[800]),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("مرحباً، أحمد عبد الله", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.work_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text("مشغل CNC | إدارة الإنتاج", style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(4)),
                    child: Text("نشط", style: TextStyle(color: Colors.green[800], fontSize: 11, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.indigo[700]!, Colors.indigo[500]!]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("حالة الدوام اليوم", style: TextStyle(color: Colors.white70, fontSize: 14)),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyAttendanceScreen())),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                  child: const Text("سجل الحضور", style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.greenAccent, size: 28),
              SizedBox(width: 12),
              Text("حاضر (On Duty)", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.login, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text("وقت الدخول: 07:55 ص", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Column(
      children: [
        _buildInfoCard(
          "رصيد الإجازات", 
          "9 أيام", 
          "متبقي من 14 يوم", 
          Icons.beach_access, 
          Colors.orange,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveRequestScreen())),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          "الراتب الشهري", 
          _hideSalary ? "****" : "450 د.أ", 
          "آخر إيداع: 25/06", 
          Icons.monetization_on, 
          Colors.green,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPayslipScreen())),
          trailing: IconButton(
            icon: Icon(_hideSalary ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
            onPressed: () => setState(() => _hideSalary = !_hideSalary),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, String sub, IconData icon, Color color, VoidCallback onTap, {Widget? trailing}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1, 
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  // --- 4. شبكة الخدمات (تفعيل الأزرار المطلوبة) ---
  Widget _buildQuickActionsGrid({required bool isWide}) {
    final services = [
      {'icon': Icons.add_box, 'label': 'طلب إجازة', 'color': Colors.purple, 'page': const LeaveRequestScreen()},
      {'icon': Icons.timer, 'label': 'مغادرة', 'color': Colors.orange, 'page': const HourlyPermissionScreen()},
      {'icon': Icons.description, 'label': 'وثيقة', 'color': Colors.blue, 'page': const DocumentRequestScreen()},
      {'icon': Icons.assignment, 'label': 'طلباتي', 'color': Colors.teal, 'page': const EmployeeRequestsScreen()},
      
      // --- تفعيل الروابط هنا ---
      {'icon': Icons.receipt_long, 'label': 'قسائم', 'color': Colors.green, 'page': const MyPayslipScreen()},
      {'icon': Icons.fingerprint, 'label': 'سجل الدوام', 'color': Colors.redAccent, 'page': const MyAttendanceScreen()},
      {'icon': Icons.policy, 'label': 'السياسات', 'color': Colors.blueGrey, 'page': const CompanyPoliciesScreen()},
      {'icon': Icons.headset_mic, 'label': 'تواصل', 'color': Colors.indigo, 'page': const ContactHrScreen()},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : 3, 
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final item = services[index];
        return _buildServiceCard(item);
      },
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> item) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1, 
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item['page'])),
        borderRadius: BorderRadius.circular(12),
        hoverColor: (item['color'] as Color).withOpacity(0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: (item['color'] as Color).withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(item['icon'], color: item['color'], size: 32),
            ),
            const SizedBox(height: 12),
            Text(item['label'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("آخر التبليغات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsCenterScreen())),
              child: const Text("عرض الكل"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _previewNotifications.length,
          itemBuilder: (ctx, idx) {
            final notif = _previewNotifications[idx];
            return Card(
              elevation: 0, 
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade200)),
              child: ListTile(
                leading: Icon(notif.icon, color: notif.color),
                title: Text(notif.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text(notif.body, style: const TextStyle(fontSize: 12)),
                trailing: Text(DateFormat('d MMM').format(notif.date), style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionRequiredSection() {
    final action = _pendingActions.first;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.redAccent, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(action.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                Text(action.description, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: action.onTap,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red),
            child: Text(action.buttonText),
          ),
        ],
      ),
    );
  }
}

// --- 5. الشاشات المفعلة (Active Screens) ---

// 1. شاشة قسائم الراتب
class MyPayslipScreen extends StatelessWidget {
  const MyPayslipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text("قسائم الراتب"), backgroundColor: Colors.green),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) {
          final month = DateTime.now().subtract(Duration(days: 30 * index));
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.attach_money, color: Colors.white)),
              title: Text("راتب شهر ${DateFormat('MMMM yyyy', 'ar').format(month)}"),
              subtitle: const Text("الصافي: 450.00 د.أ"),
              trailing: IconButton(icon: const Icon(Icons.download), onPressed: () {}),
            ),
          );
        },
      ),
    );
  }
}

// 2. شاشة السياسات
class CompanyPoliciesScreen extends StatelessWidget {
  const CompanyPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text("السياسات واللوائح"), backgroundColor: Colors.blueGrey),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PolicyCard(title: "لائحة العمل الداخلية", date: "2024/01/01"),
          PolicyCard(title: "سياسة الإجازات", date: "2023/05/15"),
          PolicyCard(title: "مدونة السلوك المهني", date: "2023/01/01"),
          PolicyCard(title: "دليل الأمن والسلامة", date: "2024/02/10"),
        ],
      ),
    );
  }
}

class PolicyCard extends StatelessWidget {
  final String title;
  final String date;
  const PolicyCard({super.key, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.article, color: Colors.blueGrey, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("تاريخ الإصدار: $date"),
        trailing: const Icon(Icons.picture_as_pdf, color: Colors.red),
      ),
    );
  }
}

// 3. شاشة التواصل
class ContactHrScreen extends StatelessWidget {
  const ContactHrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text("تواصل معنا"), backgroundColor: Colors.indigo),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.email, color: Colors.indigo),
                title: Text("مراسلة الموارد البشرية"),
                subtitle: Text("hr@mokaab.com"),
              ),
            ),
            const SizedBox(height: 10),
            const Card(
              child: ListTile(
                leading: Icon(Icons.phone, color: Colors.indigo),
                title: Text("الدعم الفني"),
                subtitle: Text("support@mokaab.com"),
              ),
            ),
            const SizedBox(height: 10),
            const Card(
              child: ListTile(
                leading: Icon(Icons.chat, color: Colors.green),
                title: Text("واتساب مباشر"),
                subtitle: Text("+962 79 000 0000"),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: (){}, 
                icon: const Icon(Icons.message), 
                label: const Text("بدء محادثة فورية"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}