// FileName: lib/features/hr/presentation/screens/employee/employee_portal_screen.dart
// Version: 2.0 (Smart Widgets & Dashboard Style)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/employee_requests_screen.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/requests/request_forms.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/my_attendance_screen.dart';

class EmployeePortalScreen extends StatefulWidget {
  const EmployeePortalScreen({super.key});

  @override
  State<EmployeePortalScreen> createState() => _EmployeePortalScreenState();
}

class _EmployeePortalScreenState extends State<EmployeePortalScreen> {
  bool _hideSalary = true; // للخصوصية

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("بوابتي (ESS)"),
        backgroundColor: const Color(0xFF263238), // Dark Blue theme like SAP
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderProfile(),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. حالة الدوام (Attendance Widget)
                  _buildAttendanceStatusWidget(),
                  const SizedBox(height: 20),

                  // 2. الويدجت الذكية (Smart Stats)
                  const Text("نظرة عامة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildLeaveBalanceCard()), // رصيد الإجازات
                      const SizedBox(width: 12),
                      Expanded(child: _buildSalaryCard()),       // آخر راتب
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 3. الخدمات السريعة (Quick Actions)
                  const Text("خدمات سريعة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildQuickActionsGrid(),

                  const SizedBox(height: 20),

                  // 4. الموافقات (للمدراء) - أو التنبيهات
                  _buildApprovalsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 1. هيدر البروفايل ---
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
              const CircleAvatar(radius: 32, backgroundColor: Colors.white, child: Icon(Icons.person, size: 40)),
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

  // --- 2. ويدجت الدوام (Smart Attendance) ---
  Widget _buildAttendanceStatusWidget() {
    return Container(
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
              Row(
                children: const [
                  Icon(Icons.login, color: Colors.greenAccent, size: 14),
                  SizedBox(width: 4),
                  Text("دخول: 07:55 ص", style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              )
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
               // فتح شاشة تسجيل الدخول/الخروج
            },
            icon: const Icon(Icons.fingerprint, color: Colors.indigo),
            label: const Text("تسجيل", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: const StadiumBorder()),
          )
        ],
      ),
    );
  }

  // --- 3. بطاقة رصيد الإجازات (Visual) ---
  Widget _buildLeaveBalanceCard() {
    return Container(
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
    );
  }

  // --- 4. بطاقة الراتب (Privacy Mode) ---
  Widget _buildSalaryCard() {
    return Container(
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
    );
  }

  // --- 5. شبكة الخدمات السريعة (Icons) ---
  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4, // 4 أيقونات في الصف (أصغر)
      childAspectRatio: 0.85,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildIconAction(Icons.assignment_add, "طلب إجازة", Colors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveRequestScreen()))),
        _buildIconAction(Icons.timer, "مغادرة", Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HourlyPermissionScreen()))),
        _buildIconAction(Icons.description, "وثيقة", Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentRequestScreen()))),
        _buildIconAction(Icons.history, "سجلي", Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeRequestsScreen()))),
        _buildIconAction(Icons.receipt_long, "قسائم", Colors.green, () {}), // Payslip
        _buildIconAction(Icons.calendar_month, "الحضور", Colors.redAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyAttendanceScreen()))),
        _buildIconAction(Icons.policy, "السياسات", Colors.grey, () {}),
        _buildIconAction(Icons.question_answer, "تواصل", Colors.indigo, () {}),
      ],
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
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)]),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 1),
      ],
    );
  }

  // --- 6. قسم الموافقات والمهام (Workflow) ---
  Widget _buildApprovalsSection() {
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
              children: const [
                Text("إجراء مطلوب", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                Text("يرجى تحديث صورة الهوية الشخصية قبل 20/12", style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.amber),
        ],
      ),
    );
  }
}