// FileName: lib/features/hr/org_structure/screens/departments_screen.dart
import 'package:flutter/material.dart';

// --- (1) استيراد البيانات (لحل مشكلة mockDepartments) ---
import 'package:mokaab/features/hr/org_structure/data/mock_departments.dart';

// --- (2) استيراد الويدجت (المهام) ---
import 'package:mokaab/features/hr/org_structure/widgets/dynamic_task_list.dart';

// --- (3) استيراد الشاشات المرتبطة ---
import 'package:mokaab/features/hr/org_structure/screens/org_chart_screen.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/employee_list_screen.dart';

// --- 1. الشاشة الرئيسية (Dashboard) ---
class DepartmentsDashboard extends StatefulWidget {
  const DepartmentsDashboard({super.key});

  @override
  State<DepartmentsDashboard> createState() => _DepartmentsDashboardState();
}

class _DepartmentsDashboardState extends State<DepartmentsDashboard> {
  bool isKanban = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildBrandingHeader(), 
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isKanban ? _buildKanbanView() : _buildListView(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('قسم جديد'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF00897B),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("الهيكل التنظيمي"),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.account_tree_outlined),
          tooltip: "المخطط الهيكلي",
          onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const OrgChartScreen()));
          },
        ),
        IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.grid_view, color: isKanban ? Colors.black : Colors.grey),
                onPressed: () => setState(() => isKanban = true),
                tooltip: "عرض كانبان",
              ),
              IconButton(
                icon: Icon(Icons.list, color: !isKanban ? Colors.black : Colors.grey),
                onPressed: () => setState(() => isKanban = false),
                tooltip: "عرض قائمة",
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBrandingHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "شركة مكعب للحجر الصناعي",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
          ),
          Text(
            "لملفات المحاكة والمخططات",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      // الآن mockDepartments ستعمل بشكل صحيح
      itemCount: mockDepartments.length,
      itemBuilder: (context, index) {
        final dept = mockDepartments[index];
        return _DepartmentCard(
          department: dept,
          onTap: () => _navigateToDetails(dept),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: mockDepartments.length,
      itemBuilder: (context, index) {
        final dept = mockDepartments[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300)
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: dept.color.withOpacity(0.2),
              child: Icon(Icons.apartment, color: dept.color),
            ),
            title: Text(dept.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("المدير: ${dept.managerName} | يتبع لـ: ${dept.parentDept ?? '-'}"),
            trailing: Chip(
              label: Text("${dept.employeeCount} موظف"),
              backgroundColor: Colors.grey[100],
            ),
            onTap: () => _navigateToDetails(dept),
          ),
        );
      },
    );
  }

  void _navigateToDetails(Department dept) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DepartmentDetailsScreen(department: dept)),
    );
  }
}

// --- 2. شاشة التفاصيل (Form View) ---
class DepartmentDetailsScreen extends StatelessWidget {
  final Department department;

  const DepartmentDetailsScreen({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(department.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Row(
                children: [
                  _SmartButton(
                    label: "الموظفين",
                    value: "${department.employeeCount}",
                    icon: Icons.people,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeListScreen()));
                    },
                  ),
                  const SizedBox(width: 8),
                  _SmartButton(
                    label: "وظائف شاغرة",
                    value: "${department.openJobs}",
                    icon: Icons.work,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SmartButton(
                      label: "تكاليف شهرية",
                      value: "${department.totalExpenses} د.أ",
                      icon: Icons.attach_money,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormHeader(),
                  const SizedBox(height: 20),
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        const TabBar(
                          labelColor: Colors.teal,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.teal,
                          tabs: [
                            Tab(text: "معلومات عامة"),
                            Tab(text: "المالية"),
                            Tab(text: "ملاحظات"),
                          ],
                        ),
                        SizedBox(
                          height: 500,
                          child: TabBarView(
                            children: [
                              _buildGeneralInfoTab(),
                              _buildFinancialTab(),
                              const Center(child: Text("مساحة للملاحظات الإدارية")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _buildChatterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: department.color,
          child: const Icon(Icons.apartment, size: 30, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(department.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("يتبع لـ: ${department.parentDept ?? 'لا يوجد'}", style: const TextStyle(color: Colors.grey)),
          ],
        )
      ],
    );
  }

  Widget _buildGeneralInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          _buildReadOnlyField("مدير القسم", department.managerName),
          _buildReadOnlyField("نوع القسم", "تشغيلي"),
          const Divider(height: 30),
          
          DynamicTaskList(departmentCode: department.id == '2' ? 'PROD' : 'HQ'), 
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFinancialTab() {
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        _buildReadOnlyField("مركز التكلفة", "CC-${department.id}00"),
        _buildReadOnlyField("الميزانية السنوية", "100,000 د.أ"),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildChatterSection() {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("سجل النشاطات (Chatter)", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              const CircleAvatar(radius: 12, backgroundColor: Colors.teal, child: Text("HR", style: TextStyle(fontSize: 10))),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: const Text("تم تحديث مدير القسم بتاريخ 2025-12-26", style: TextStyle(fontSize: 12)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _SmartButton extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onPressed;

  const _SmartButton({required this.label, required this.value, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.teal),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _DepartmentCard extends StatelessWidget {
  final Department department;
  final VoidCallback onTap;

  const _DepartmentCard({required this.department, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: department.color, width: 4)),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(department.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(department.managerName, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBadge("${department.employeeCount} موظف"),
                if (department.openJobs > 0)
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontSize: 10)),
    );
  }
}