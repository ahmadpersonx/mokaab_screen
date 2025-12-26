// FileName: lib/features/home/screens/home_screen.dart
// Description: الشاشة الرئيسية (Unified & Aligned Grid) - إصلاح تنسيق الأزرار
// Version: 2.1

import 'package:flutter/material.dart';
import 'package:mokaab/features/hr/presentation/screens/hr_dashboard_screen.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/employee_portal_screen.dart';
import 'package:mokaab/features/hr/workflow/screens/pending_approvals_screen.dart';
import 'package:mokaab/features/finance/presentation/screens/financial_management_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("نظام مكعب (Mokaab ERP)"),
        centerTitle: true,
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(),
            const SizedBox(height: 24),
            
            const Text("تطبيقات النظام", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                // ضبط عدد الأعمدة ليكون متناسقاً
                int crossAxisCount = 2;
                if (constraints.maxWidth > 1200) crossAxisCount = 5;
                else if (constraints.maxWidth > 800) crossAxisCount = 4;
                else if (constraints.maxWidth > 600) crossAxisCount = 3; 

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0, // مربع تماماً
                  children: [
                    // 1. صندوق الموافقات (مع Badge)
                    _buildCompactCard(
                      context,
                      title: "صندوق الموافقات",
                      icon: Icons.approval,
                      color: Colors.redAccent,
                      badgeCount: 5, // تمرير الرقم هنا
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PendingApprovalsScreen())),
                    ),

                    // 2. الموارد البشرية
                    _buildCompactCard(
                      context,
                      title: "الموارد البشرية (HR)",
                      icon: Icons.people_alt,
                      color: Colors.orange,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HrDashboardScreen())),
                    ),

                    // 3. بوابة الموظف
                    _buildCompactCard(
                      context,
                      title: "بوابتي (ESS)",
                      icon: Icons.account_circle,
                      color: Colors.blue,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeePortalScreen())),
                    ),

                    // --- 4. الإدارة المالية (تم الربط) ---
                    _buildCompactCard(
                      context,
                      title: "الإدارة المالية",
                      icon: Icons.account_balance,
                      color: Colors.teal,
                      onTap: () {
                        // الربط بالشاشة الجديدة
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const FinancialManagementScreen()));
                      },
                    ),

                    // 5. الإنتاج
                    _buildCompactCard(
                      context,
                      title: "إدارة الإنتاج",
                      icon: Icons.precision_manufacturing,
                      color: Colors.blueGrey,
                      onTap: () {},
                    ),

                    // 6. المخازن
                    _buildCompactCard(
                      context,
                      title: "المخازن",
                      icon: Icons.inventory_2,
                      color: Colors.brown,
                      onTap: () {},
                    ),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.indigo[800]!, Colors.indigo[600]!]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 35, color: Colors.indigo),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("صباح الخير، المدير العام", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              Text("نتمنى لك يوماً منتجاً وسعيداً", style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  // --- البطاقة الموحدة (الآن تدعم Badge داخلياً) ---
  Widget _buildCompactCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    int badgeCount = 0, // معامل اختياري للعداد
  }) {
    return Stack(
      clipBehavior: Clip.none, // للسماح للشارة بالظهور على الحافة
      children: [
        // جسم البطاقة الرئيسي
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          elevation: 2,
          shadowColor: Colors.black12,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            hoverColor: color.withOpacity(0.05),
            child: Container(
              width: double.infinity, // ملء المساحة
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 36, color: color),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),

        // الشارة الحمراء (تظهر فقط إذا كان العدد > 0)
        if (badgeCount > 0)
          Positioned(
            top: 10,
            left: 10, // مكان موحد للجميع (الزاوية اليسرى العلوية)
            child: Container(
              padding: const EdgeInsets.all(6), // حجم أصغر قليلاً وأنيق
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]
              ),
              child: Center(
                child: Text(
                  "$badgeCount",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("المدير العام"),
            accountEmail: const Text("admin@mokaab.com"),
            currentAccountPicture: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.indigo)),
            decoration: BoxDecoration(color: Colors.indigo[900]),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("الرئيسية"),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("تسجيل الخروج"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}