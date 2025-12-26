// FileName: lib/features/hr/presentation/screens/employee/employee_list_screen.dart
import 'package:flutter/material.dart';
// تأكد من وجود ملف mock_employees.dart أو قم بإنشائه في data/models
// سنستخدم هنا بيانات وهمية محلية مؤقتاً لتجنب أخطاء الاستيراد
class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("دليل الموظفين")),
      body: const Center(child: Text("قائمة الموظفين")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}