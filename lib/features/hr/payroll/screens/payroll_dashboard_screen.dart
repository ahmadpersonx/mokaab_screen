// FileName: lib/features/hr/payroll/screens/payroll_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/hr/payroll/models/payroll_models.dart';

class PayrollDashboardScreen extends StatefulWidget {
  const PayrollDashboardScreen({super.key});

  @override
  State<PayrollDashboardScreen> createState() => _PayrollDashboardScreenState();
}

class _PayrollDashboardScreenState extends State<PayrollDashboardScreen> {
  // قائمة المسيرات السابقة (بيانات وهمية)
  List<PayrollRun> _history = [
    PayrollRun(id: 'PY-2025-11', monthName: 'November 2025', date: DateTime(2025, 11, 25), totalEmployees: 124, totalAmount: 64500, status: PayrollStatus.paid),
    PayrollRun(id: 'PY-2025-10', monthName: 'October 2025', date: DateTime(2025, 10, 25), totalEmployees: 122, totalAmount: 63200, status: PayrollStatus.paid),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("إدارة الرواتب والأجور (Payroll)"),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. بطاقة الملخص المالي
            _buildSummaryCard(),
            const SizedBox(height: 24),

            // 2. زر إنشاء مسير جديد
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => _showGenerateDialog(),
                icon: const Icon(Icons.play_circle_fill, size: 28),
                label: const Text("إنشاء مسير رواتب جديد", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
              ),
            ),
            const SizedBox(height: 24),

            // 3. سجل المسيرات السابقة
            const Text("سجل الرواتب (History)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.teal[700]!, Colors.teal[900]!]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("إجمالي الرواتب المصروفة (2025)", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 8),
                  Text("768,450 د.أ", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.bar_chart, color: Colors.white, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              const Text("آخر تحديث: 25 نوفمبر 2025", style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final run = _history[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Colors.teal[50],
              child: const Icon(Icons.receipt_long, color: Colors.teal),
            ),
            title: Text(run.monthName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${run.totalEmployees} موظف  •  ${NumberFormat('#,###').format(run.totalAmount)} د.أ"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: run.statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Text(run.statusText, style: TextStyle(color: run.statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            onTap: () {
              // فتح تفاصيل المسير (قائمة الموظفين)
              _openPayrollDetails(run);
            },
          ),
        );
      },
    );
  }

  // --- نافذة إنشاء المسير (The Engine Logic) ---
  void _showGenerateDialog() {
    DateTime selectedMonth = DateTime.now();
    bool isCalculating = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("إنشاء مسير رواتب"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("سيقوم النظام باحتساب الرواتب بناءً على العقود الفعالة وسجلات الحضور.", style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 20),
                ListTile(
                  title: const Text("الشهر المستحق"),
                  subtitle: Text(DateFormat('MMMM yyyy').format(selectedMonth)),
                  trailing: const Icon(Icons.calendar_today),
                  tileColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onTap: () async {
                    // اختيار الشهر (مبسط)
                  },
                ),
                const SizedBox(height: 20),
                if (isCalculating)
                  Column(
                    children: const [
                      LinearProgressIndicator(color: Colors.teal),
                      SizedBox(height: 10),
                      Text("جاري معالجة 125 موظف...", style: TextStyle(fontSize: 12, color: Colors.teal)),
                    ],
                  ),
              ],
            ),
            actions: [
              if (!isCalculating) ...[
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
                ElevatedButton(
                  onPressed: () async {
                    setDialogState(() => isCalculating = true);
                    
                    // --- محاكاة عملية الحساب (The Engine) ---
                    await Future.delayed(const Duration(seconds: 3));
                    
                    // توليد بيانات وهمية للمسير الجديد
                    final newRun = PayrollRun(
                      id: 'PY-${DateFormat('yyyy-MM').format(selectedMonth)}',
                      monthName: DateFormat('MMMM yyyy').format(selectedMonth),
                      date: DateTime.now(),
                      totalEmployees: 125, // محاكاة: عدد العقود النشطة
                      totalAmount: 65120, // محاكاة: مجموع الرواتب
                      status: PayrollStatus.draft,
                    );

                    setState(() {
                      _history.insert(0, newRun);
                    });

                    Navigator.pop(context); // إغلاق الديالوج
                    _openPayrollDetails(newRun); // الذهاب للتفاصيل
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text("بدء الاحتساب"),
                ),
              ]
            ],
          );
        }
      ),
    );
  }

  void _openPayrollDetails(PayrollRun run) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PayrollDetailsScreen(run: run)));
  }
}

// --- شاشة تفاصيل المسير (قائمة الموظفين) ---
class PayrollDetailsScreen extends StatelessWidget {
  final PayrollRun run;
  const PayrollDetailsScreen({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
    // محاكاة لبيانات القسائم (هذا ما ينتجه المحرك لكل موظف)
    final List<SalarySlip> slips = [
      SalarySlip(
        employeeId: '101', employeeName: 'أحمد محمد', jobTitle: 'مشغل CNC',
        basicSalary: 500, housingAllowance: 50, transportAllowance: 30, overtimeAmount: 45,
        socialSecurity: 42.5, tax: 5, absenceDeduction: 0
      ),
      SalarySlip(
        employeeId: '102', employeeName: 'سالم علي', jobTitle: 'فني صيانة',
        basicSalary: 450, housingAllowance: 50, transportAllowance: 30,
        socialSecurity: 38.25, absenceDeduction: 15 // خصم غياب يوم
      ),
      SalarySlip(
        employeeId: '103', employeeName: 'خالد يوسف', jobTitle: 'مدير إنتاج',
        basicSalary: 1200, housingAllowance: 100, transportAllowance: 100,
        socialSecurity: 100, tax: 25
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text("تفاصيل مسير ${run.monthName}"),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.print), onPressed: () {}),
          IconButton(icon: const Icon(Icons.check), tooltip: "اعتماد المسير", onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: slips.length,
        itemBuilder: (context, index) {
          final slip = slips[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: CircleAvatar(child: Text(slip.employeeName[0])),
              title: Text(slip.employeeName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(slip.jobTitle),
              trailing: Text("${slip.netSalary.toStringAsFixed(2)} د.أ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800], fontSize: 16)),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[50],
                  child: Column(
                    children: [
                      _row("الراتب الأساسي", slip.basicSalary),
                      _row("بدل سكن", slip.housingAllowance),
                      _row("بدل مواصلات", slip.transportAllowance),
                      if (slip.overtimeAmount > 0) _row("عمل إضافي", slip.overtimeAmount, isAddition: true),
                      const Divider(),
                      if (slip.absenceDeduction > 0) _row("خصم غياب", slip.absenceDeduction, isDeduction: true),
                      _row("الضمان الاجتماعي", slip.socialSecurity, isDeduction: true),
                      if (slip.tax > 0) _row("ضريبة الدخل", slip.tax, isDeduction: true),
                      const Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("صافي الراتب", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${slip.netSalary.toStringAsFixed(2)} د.أ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _row(String label, double value, {bool isDeduction = false, bool isAddition = false}) {
    Color color = Colors.black87;
    String prefix = "";
    if (isDeduction) { color = Colors.red; prefix = "- "; }
    if (isAddition) { color = Colors.green; prefix = "+ "; }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text("$prefix${value.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}