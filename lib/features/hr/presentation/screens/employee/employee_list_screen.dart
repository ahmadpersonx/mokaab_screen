// FileName: lib/features/hr/presentation/screens/employee/employee_list_screen.dart
// Description: قائمة الموظفين مع تنبيهات النواقص الذكية
// Version: 1.2

import 'package:flutter/material.dart';
import 'package:mokaab/features/hr/data/models/employee_model.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/employee_profile_screen.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';

import 'package:mokaab/features/hr/presentation/screens/employee/quick_add_employee_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  // قائمة موظفين وهمية للتجربة
  List<Employee> _employees = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // سننشئ موظفين اثنين: واحد مكتمل، وواحد لديه نواقص
    _employees = [
      // 1. موظف مثالي (مكتمل)
      Employee(
        id: 'EMP-101',
        employeeCode: '2024-001',
        fullNameAr: 'أحمد محمد عبد الله',
        fullNameEn: 'Ahmad Abdullah',
        gender: 'Male',
        dateOfBirth: DateTime(1990, 1, 1),
        nationalityId: 'Jordanian',
        nationalIdNumber: '9900000000',
        mobileNumber: '0790000000',
        email: 'ahmad@test.com',
        address: 'Amman',
        emergencyContactName: 'Father',
        emergencyContactPhone: '0770000000',
        contractId: 'C1',
        joinDate: DateTime(2020, 1, 1),
        departmentId: 'DEP-PROD',
        sectionId: 'SEC-CNC',
        jobTitleId: 'JOB-OP-CNC',
        jobLevelId: 'LVL-04',
        workLocationId: 'L1',
        shiftId: 'SHIFT-A',
        basicSalary: 500,
        paymentMethodId: 'PAY-BANK',
        ibanNumber: 'JO123456789', // موجود
        socialSecurityNumber: '12345', // موجود
        documents: [
          // لنفترض أننا أضفنا الوثائق الإلزامية هنا
          EmployeeDocument(id: 'D1', documentTypeId: 'DOC-ID', documentNumber: '123', isVerified: true),
          EmployeeDocument(id: 'D2', documentTypeId: 'DOC-CONT', documentNumber: 'C-123', isVerified: true),
        ],
      ),

      // 2. موظف جديد (لديه نواقص)
      Employee(
        id: 'EMP-102',
        employeeCode: '2024-002',
        fullNameAr: 'سالم علي يوسف',
        fullNameEn: 'Salem Ali',
        gender: 'Male',
        dateOfBirth: DateTime(1995, 5, 5),
        nationalityId: 'Jordanian',
        nationalIdNumber: '9950000000',
        mobileNumber: '0780000000',
        email: 'salem@test.com',
        address: 'Zarqa',
        emergencyContactName: 'Brother',
        emergencyContactPhone: '0790000000',
        contractId: 'C2',
        joinDate: DateTime(2024, 1, 1),
        departmentId: 'DEP-HR',
        sectionId: 'SEC-HROPS',
        jobTitleId: 'JOB-HR-OFF',
        jobLevelId: 'LVL-05',
        workLocationId: 'L1',
        shiftId: 'SHIFT-A',
        basicSalary: 400,
        paymentMethodId: 'PAY-BANK',
        ibanNumber: '', // ناقص!
        socialSecurityNumber: '', // ناقص!
        documents: [], // لا يوجد وثائق!
      ),
    ];
  }

  // --- محرك الفحص السريع (Validation Engine) ---
  // يعيد قائمة بالنواقص، إذا كانت فارغة فالملف سليم
  List<String> _getEmployeeIssues(Employee emp) {
    List<String> issues = [];

    // 1. فحص الحقول الأساسية
    if (emp.ibanNumber == null || emp.ibanNumber!.isEmpty) issues.add("الآيبان");
    if (emp.socialSecurityNumber == null || emp.socialSecurityNumber!.isEmpty) issues.add("الضمان");

    // 2. فحص الوثائق الإلزامية
    final mandatoryDocs = (masterLookups[LookupCategory.documentTypes] ?? [])
        .where((d) => d.metaData?['mandatory'] == true);
    
    for (var docType in mandatoryDocs) {
      bool exists = emp.documents.any((d) => d.documentTypeId == docType.id);
      if (!exists) issues.add(docType.name); // اسم الوثيقة الناقصة
    }

    // 3. فحص صلاحية الوثائق
    for (var doc in emp.documents) {
      if (doc.isExpired) issues.add("وثيقة منتهية");
    }

    return issues;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("دليل الموظفين"),
        centerTitle: true,
        backgroundColor: const Color(0xFF263238),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // شريط بحث وتصفية (شكلي)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "بحث عن موظف (الاسم، الرقم الوظيفي)...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
          ),
          

          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                final employee = _employees[index];
                final issues = _getEmployeeIssues(employee);
                final isComplete = issues.isEmpty;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmployeeProfileScreen(employeeId: 'EMP-101'), // في التطبيق الحقيقي مرر employee.id
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // الصورة الشخصية
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: isComplete ? Colors.blue[100] : Colors.orange[100],
                                child: Text(
                                  employee.fullNameEn.substring(0, 1),
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isComplete ? Colors.blue[800] : Colors.orange[900]),
                                ),
                              ),
                              // مؤشر الحالة (نقطة)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: isComplete ? Colors.green : Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(width: 16),
                          
                          // المعلومات
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.fullNameAr,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${_getJobName(employee.jobTitleId)} • ${_getDeptName(employee.departmentId)}",
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                
                                // --- منطقة التنبيهات الذكية ---
                                if (!isComplete) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.red),
                                        const SizedBox(width: 4),
                                        Text(
                                          "نواقص: ${issues.length} (اضغط للاستكمال)",
                                          style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
     floatingActionButton: FloatingActionButton(
        onPressed: () {
          // الانتقال لشاشة الإضافة السريعة
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuickAddEmployeeScreen()),
          );
        },
        backgroundColor: const Color(0xFF00897B),
        tooltip: "إضافة موظف جديد",
        child: const Icon(Icons.person_add),
      ),
    );
  }

  String _getJobName(String id) {
    final item = masterLookups[LookupCategory.jobTitles]?.firstWhere((e) => e.id == id, orElse: () => LookupItem(id: '', name: '', code: ''));
    return item?.name ?? id;
  }

  String _getDeptName(String id) {
    final item = masterLookups[LookupCategory.departments]?.firstWhere((e) => e.id == id, orElse: () => LookupItem(id: '', name: '', code: ''));
    return item?.name ?? id;
  }
}