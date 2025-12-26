// FileName: lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/hr/org_structure/screens/departments_screen.dart';
import 'package:mokaab/features/system_config/screens/lookups_management_screen.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/employee_list_screen.dart';
// استيراد شاشة العقود الجديدة
import 'package:mokaab/features/hr/contracts/screens/contract_management_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Mokaab ERP - الرئيسية"),
        centerTitle: true,
        backgroundColor: const Color(0xFF263238),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "تطبيقات النظام",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, // عمودين في الشبكة
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.3,
              children: [
                // 1. الموارد البشرية (الهيكل)
                _buildModuleCard(
                  context,
                  title: "الموارد البشرية",
                  subtitle: "الهيكل، الموظفين، المهام",
                  icon: Icons.people_alt,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DepartmentsDashboard()));
                  },
                ),

                // 2. دليل الموظفين
                _buildModuleCard(
                  context,
                  title: "دليل الموظفين",
                  subtitle: "سجلات، ملفات، وثائق",
                  icon: Icons.badge,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeeListScreen()));
                  },
                ),

                // 3. إدارة العقود (الجديد)
                _buildModuleCard(
                  context,
                  title: "إدارة العقود",
                  subtitle: "إنشاء، تجديد، إنهاء",
                  icon: Icons.gavel, // أيقونة تعبر عن القانون/العقود
                  color: const Color(0xFF00897B), // لون مميز (Teal)
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ContractManagementScreen()));
                  },
                ),

                // 4. إعدادات النظام
                _buildModuleCard(
                  context,
                  title: "إعدادات النظام",
                  subtitle: "القوائم، الثوابت، SOPs",
                  icon: Icons.settings_applications,
                  color: Colors.blueGrey,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LookupsManagementScreen()));
                  },
                ),

                // 5. المالية (قريباً)
                _buildModuleCard(
                  context,
                  title: "المالية",
                  subtitle: "قريباً...",
                  icon: Icons.attach_money,
                  color: Colors.grey,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}