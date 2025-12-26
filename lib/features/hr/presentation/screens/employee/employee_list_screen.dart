// FileName: lib/features/hr/presentation/screens/employee/employee_list_screen.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/employee_profile_screen.dart'; // استيراد شاشة الملف الشخصي

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("دليل الموظفين"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // عدد وهمي للتجربة
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue[100],
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              title: const Text("أحمد محمد عبد الله", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("مشغل CNC • إدارة الإنتاج"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              
              // --- الربط هنا: عند الضغط نذهب للملف الشخصي ---
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmployeeProfileScreen(employeeId: 'EMP-101'),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // يمكن ربطه بشاشة "إضافة موظف جديد" مستقبلاً
        },
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add),
      ),
    );
  }
}