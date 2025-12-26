// FileName: lib/features/hr/org_structure/screens/departments_screen.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart'; // المودل الأساسي
import 'package:mokaab/features/system_config/data/seed_data.dart'; // مصدر البيانات الحقيقي
import 'package:mokaab/features/hr/org_structure/widgets/dynamic_task_list.dart';
import 'package:mokaab/features/hr/org_structure/screens/org_chart_screen.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/employee_list_screen.dart';

// تعريف كلاس Department محلياً (أو يمكن فصله) لسهولة التعامل داخل الشاشة
class Department {
  final String id;
  final String name;
  final String managerName;
  final int employeeCount;
  final int openJobs;
  final double totalExpenses;
  final Color color;
  final String? parentDept;

  Department({
    required this.id,
    required this.name,
    required this.managerName,
    required this.employeeCount,
    required this.openJobs,
    required this.totalExpenses,
    required this.color,
    this.parentDept,
  });
}

class DepartmentsDashboard extends StatefulWidget {
  const DepartmentsDashboard({super.key});

  @override
  State<DepartmentsDashboard> createState() => _DepartmentsDashboardState();
}

class _DepartmentsDashboardState extends State<DepartmentsDashboard> {
  bool isKanban = true;
  List<Department> departments = [];

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  // --- دالة تحويل البيانات من القوائم (LookupItem) إلى (Department) ---
  void _loadDepartments() {
    final rawDepts = masterLookups[LookupCategory.departments] ?? [];
    
    setState(() {
      departments = rawDepts.map((item) {
        // قراءة البيانات الذكية من metaData
        final manager = item.metaData?['manager'] ?? 'غير محدد';
        final budget = double.tryParse(item.metaData?['budget'] ?? '0') ?? 0.0;
        
        // محاكاة لأرقام الموظفين (لاحقاً ستربط بجدول الموظفين الفعلي)
        final empCount = (item.id.hashCode % 50) + 5; 
        final jobs = (item.id.hashCode % 5);

        return Department(
          id: item.id,
          name: item.name,
          managerName: manager,
          employeeCount: empCount,
          openJobs: jobs,
          totalExpenses: budget * 0.8, // افتراض المصروف الفعلي
          color: item.color ?? Colors.blue,
          parentDept: item.metaData?['type'] ?? 'GEN', // مؤقتاً نعرض النوع
        );
      }).toList();
    });
  }

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
              child: departments.isEmpty 
                  ? const Center(child: Text("لا توجد إدارات معرفة في النظام"))
                  : (isKanban ? _buildKanbanView() : _buildListView()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
            // هنا يمكن فتح شاشة "إدارة القوائم" لإضافة قسم جديد
            // Navigator.push...
        },
        label: const Text('إدارة الهيكل'),
        icon: const Icon(Icons.settings),
        backgroundColor: const Color(0xFF00897B),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("الهيكل التنظيمي (Departments)"),
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
            "لملفات المحاكة والمخططات - الإدارات",
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
      itemCount: departments.length,
      itemBuilder: (context, index) {
        final dept = departments[index];
        return _DepartmentCard(
          department: dept,
          onTap: () => _navigateToDetails(dept),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: departments.length,
      itemBuilder: (context, index) {
        final dept = departments[index];
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
            subtitle: Text("المدير: ${dept.managerName} | النوع: ${dept.parentDept ?? '-'}"),
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
                      label: "المصروفات (YTD)",
                      value: "${(department.totalExpenses/1000).toStringAsFixed(1)}k د.أ",
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
                            Tab(text: "المالية والموازنة"),
                            Tab(text: "ملاحظات"),
                          ],
                        ),
                        SizedBox(
                          height: 500,
                          child: TabBarView(
                            children: [
                              _buildGeneralInfoTab(),
                              _buildFinancialTab(),
                              const Center(child: Text("لا توجد ملاحظات إدارية مسجلة")),
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
            Text("نوع الإدارة: ${department.parentDept ?? 'عام'}", style: const TextStyle(color: Colors.grey)),
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
          _buildReadOnlyField("مدير الإدارة", department.managerName),
          _buildReadOnlyField("عدد الموظفين", "${department.employeeCount}"),
          const Divider(height: 30),
          // ربط المهام: إذا كانت إنتاج اعرض PROD وإلا HQ
          DynamicTaskList(departmentCode: department.name.contains("الإنتاج") ? 'PROD' : 'HQ'), 
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFinancialTab() {
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        _buildReadOnlyField("مركز التكلفة", "CC-${department.id.substring(4)}"), // محاكاة من الـ ID
        _buildReadOnlyField("الميزانية السنوية", "${(department.totalExpenses * 1.25).toStringAsFixed(0)} د.أ"),
        _buildReadOnlyField("المصروف الفعلي", "${department.totalExpenses.toStringAsFixed(0)} د.أ"),
        const SizedBox(height: 10),
        const Text("نسبة استهلاك الموازنة:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        LinearProgressIndicator(value: 0.8, color: Colors.teal, backgroundColor: Colors.grey[200]),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
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
              const CircleAvatar(radius: 12, backgroundColor: Colors.teal, child: Text("SYS", style: TextStyle(fontSize: 10, color: Colors.white))),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: const Text("تم تحديث بيانات الموازنة تلقائياً من النظام المالي", style: TextStyle(fontSize: 12)),
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
                Expanded(child: Text(department.managerName, style: const TextStyle(fontSize: 11, color: Colors.grey), overflow: TextOverflow.ellipsis)),
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