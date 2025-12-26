// FileName: lib/features/hr/presentation/screens/employee/employee_form_screen.dart
// Description: شاشة تفاصيل الموظف (Form View) مع التبويبات والـ Chatter

import 'package:flutter/material.dart';
import 'mock_employees.dart';

class EmployeeFormScreen extends StatelessWidget {
  final Employee? employee; // إذا كان null يعني وضع إنشاء جديد

  const EmployeeFormScreen({super.key, this.employee});

  @override
  Widget build(BuildContext context) {
    final isEditing = employee != null;
    final name = isEditing ? employee!.name : "موظف جديد";

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Smart Buttons Area
            if (isEditing) _buildSmartButtons(employee!),

            const Divider(height: 1),

            // 2. Header Info (Avatar & Main Details)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? employee!.name : "اسم الموظف",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEditing ? employee!.jobTitle : "المسمى الوظيفي",
                          style: const TextStyle(fontSize: 16, color: Colors.teal),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildTag("القسم: ${isEditing ? employee!.department : 'غير محدد'}"),
                            _buildTag("المدير: ${isEditing ? employee!.managerName : 'غير محدد'}"),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            // 3. Tabs (Notebook)
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.teal,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.teal,
                    tabs: [
                      Tab(text: "معلومات العمل"),
                      Tab(text: "معلومات خاصة"),
                      Tab(text: "إعدادات HR"),
                    ],
                  ),
                  Container(
                    height: 300, // ارتفاع ثابت للمحتوى
                    padding: const EdgeInsets.all(16),
                    child: const TabBarView(
                      children: [
                        Center(child: Text("الموقع، ساعات العمل، الموافقات...")),
                        Center(child: Text("الجنسية، العنوان، الحساب البنكي...")),
                        Center(child: Text("كود البصمة، نوع العقد، المستخدم...")),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 4. Chatter (Log & Messages)
            _buildChatter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartButtons(Employee emp) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _SmartButton(
            icon: Icons.description,
            label: "العقود",
            value: "${emp.contractCount}",
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _SmartButton(
            icon: Icons.beach_access,
            label: "رصيد إجازات",
            value: "${emp.leaveBalance}",
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _SmartButton(
            icon: Icons.attach_money,
            label: "قسائم راتب",
            value: "12",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
    );
  }

  Widget _buildChatter() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const Text("السجل والملاحظات (Chatter)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(radius: 16, backgroundColor: Colors.teal, child: Text("HR", style: TextStyle(fontSize: 12, color: Colors.white))),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "أرسل رسالة أو سجل ملاحظة...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ),
              IconButton(icon: const Icon(Icons.send, color: Colors.teal), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 20),
          // Mock Log Entry
          const ListTile(
            leading: Icon(Icons.info_outline, color: Colors.grey),
            title: Text("تم إنشاء الموظف", style: TextStyle(fontSize: 13)),
            subtitle: Text("بواسطة Admin - منذ يومين", style: TextStyle(fontSize: 11)),
          )
        ],
      ),
    );
  }
}

class _SmartButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SmartButton({required this.icon, required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      icon: Icon(icon, size: 18, color: Colors.teal),
      label: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}