// FileName: lib/features/hr/presentation/screens/hr_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/hr/org_structure/screens/departments_screen.dart';
import 'package:mokaab/features/system_config/screens/lookups_management_screen.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/employee_list_screen.dart';
import 'package:mokaab/features/hr/contracts/screens/contract_management_screen.dart';

class HrDashboardScreen extends StatelessWidget {
  const HrDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("الموارد البشرية (HR)"),
        centerTitle: true,
        backgroundColor: Colors.orange[800], // لون مميز لقسم الـ HR
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
              children: [
                const Text(
                  "لوحة تحكم الموارد البشرية",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
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
                    // 1. الهيكل التنظيمي
                    _buildCompactCard(
                      context,
                      title: "الهيكل التنظيمي",
                      icon: Icons.account_tree,
                      color: Colors.orange,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DepartmentsDashboard())),
                    ),

                    // 2. دليل الموظفين
                    _buildCompactCard(
                      context,
                      title: "دليل الموظفين",
                      icon: Icons.badge,
                      color: Colors.blue,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeListScreen())),
                    ),

                    // 3. إدارة العقود
                    _buildCompactCard(
                      context,
                      title: "إدارة العقود",
                      icon: Icons.gavel,
                      color: const Color(0xFF00897B),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContractManagementScreen())),
                    ),

                    // 4. القوائم والإعدادات
                    _buildCompactCard(
                      context,
                      title: "إعدادات الـ HR",
                      icon: Icons.settings_applications,
                      color: Colors.blueGrey,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LookupsManagementScreen())),
                    ),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}