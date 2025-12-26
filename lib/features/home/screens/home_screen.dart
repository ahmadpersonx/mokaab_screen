// FileName: lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/hr/presentation/screens/hr_dashboard_screen.dart'; // استيراد الشاشة الجديدة
import 'package:mokaab/features/hr/presentation/screens/employee/employee_requests_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Mokaab ERP"),
        centerTitle: true,
        backgroundColor: const Color(0xFF263238),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 2;
          if (constraints.maxWidth > 1200) crossAxisCount = 6;
          else if (constraints.maxWidth > 800) crossAxisCount = 4;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "تطبيقات النظام",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 30),
                
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                  children: [
                    // --- الزر الرئيسي الجديد ---
                    _buildCompactCard(
                      context,
                      title: "الموارد البشرية (HR)",
                      icon: Icons.groups, // أيقونة تعبر عن المجموع
                      color: Colors.orange[800]!,
                      onTap: () {
                        // الانتقال للوحة تحكم الـ HR
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const HrDashboardScreen()));
                      },
                    ),
// زر "طلباتي" (الجديد)
     _buildCompactCard(
                      context,
                      title: "طلباتي (Self Service)",
                      icon: Icons.assignment_ind, // <<--- التعديل هنا (assignment_ind بدلاً من assignment_user)
                      color: Colors.blueAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeRequestsScreen())),
                    ),
                    
                    // --- باقي الأقسام (محاكاة) ---
                    _buildCompactCard(context, title: "الإدارة المالية", icon: Icons.account_balance_wallet, color: Colors.green, onTap: () {}),
                    _buildCompactCard(context, title: "المبيعات والعملاء", icon: Icons.shopping_cart, color: Colors.blue, onTap: () {}),
                    _buildCompactCard(context, title: "إدارة الإنتاج", icon: Icons.factory, color: Colors.brown, onTap: () {}),
                    _buildCompactCard(context, title: "سلسلة الإمداد", icon: Icons.local_shipping, color: Colors.teal, onTap: () {}),
                    _buildCompactCard(context, title: "إدارة المخزون", icon: Icons.inventory_2, color: Colors.indigo, onTap: () {}),
                    _buildCompactCard(context, title: "التقارير الذكية", icon: Icons.pie_chart, color: Colors.purple, onTap: () {}),
                    _buildCompactCard(context, title: "المهام والمتابعات", icon: Icons.task_alt, color: Colors.redAccent, badgeCount: 3, onTap: () {}),
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: color.withOpacity(0.05),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 32, color: color),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (badgeCount != null && badgeCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                  child: Text("$badgeCount", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}