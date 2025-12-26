// FileName: lib/features/hr/presentation/screens/employee/employee_profile_screen.dart
// Description: شاشة الملف الشخصي للموظف (Employee 360 View)
// Version: 1.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // لتنسيق التواريخ
import 'package:mokaab/features/hr/data/models/employee_model.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';

class EmployeeProfileScreen extends StatefulWidget {
  final String employeeId; // يمكن تمرير ID لجلب البيانات، هنا سنستخدم بيانات وهمية للعرض

  const EmployeeProfileScreen({super.key, this.employeeId = 'EMP-001'});

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Employee _employee; // كائن الموظف

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadMockEmployeeData(); // تحميل بيانات تجريبية
  }

  // --- محاكاة جلب بيانات موظف كاملة ---
  void _loadMockEmployeeData() {
    _employee = Employee(
      id: 'EMP-101',
      employeeCode: '2024-055',
      fullNameAr: 'أحمد محمد عبد الله',
      fullNameEn: 'Ahmad M. Abdullah',
      gender: 'Male',
      dateOfBirth: DateTime(1990, 5, 20),
      nationalityId: 'Jordanian',
      nationalIdNumber: '9901051234',
      mobileNumber: '0791234567',
      email: 'ahmad.m@mokaab.com',
      address: 'عمان - شارع الجامعة - بناية 15',
      emergencyContactName: 'محمد عبد الله (الأب)',
      emergencyContactPhone: '0771234567',
      
      // معلومات العمل (IDs مطابقة لـ seed_data)
      contractId: 'CONT-2024-001',
      joinDate: DateTime(2023, 1, 15),
      departmentId: 'DEP-PROD', // إدارة الإنتاج
      sectionId: 'SEC-CNC',     // قسم CNC
      unitId: 'UNT-CNC-OP',     // وحدة التشغيل
      jobTitleId: 'JOB-OP-CNC', // مشغل CNC
      jobLevelId: 'LVL-04',     // الدرجة الرابعة
      workLocationId: 'L1',     // المصنع الرئيسي
      shiftId: 'SHIFT-MORNING', // وردية صباحية
      directManagerId: 'م. خالد (مدير الإنتاج)', 
      
      // معلومات مالية
      basicSalary: 450.0,
      allowances: {
        'ALL-TRANS': 30.0, // بدل مواصلات
        'ALL-RISK': 25.0,  // بدل خطورة
      },
      paymentMethodId: 'PAY-BANK',
      bankName: 'البنك العربي',
      ibanNumber: 'JO12 ARAB 0010 0000 1234 5678',
      socialSecurityNumber: '12345678',

      // قوائم فرعية
      documents: [
        EmployeeDocument(id: 'D1', documentTypeId: 'DOC-ID', documentNumber: '9901051234', expiryDate: DateTime(2028, 5, 20), isVerified: true),
        EmployeeDocument(id: 'D2', documentTypeId: 'DOC-CONT', documentNumber: 'CN-2023-55', expiryDate: DateTime(2024, 1, 14), isVerified: true), // ينتهي قريباً
      ],
      custodies: [
        EmployeeCustody(id: 'C1', custodyTypeId: 'CUST-UNIFORM', itemName: 'زي سلامة كامل', receivedDate: DateTime(2023, 1, 15)),
        EmployeeCustody(id: 'C2', custodyTypeId: 'CUST-TOOLS', itemName: 'طقم مفاتيح CNC', receivedDate: DateTime(2023, 2, 1)),
      ],
      status: EmployeeStatus.active,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildSliverAppBar(),
          ];
        },
        body: Column(
          children: [
            // شريط التبويبات
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: const Color(0xFF00897B),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF00897B),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                tabs: const [
                  Tab(text: "المعلومات الشخصية"),
                  Tab(text: "معلومات العمل"),
                  Tab(text: "المالية والراتب"),
                  Tab(text: "الوثائق والمستندات"),
                  Tab(text: "العهد والأصول"),
                ],
              ),
            ),
            // محتوى التبويبات
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPersonalInfoTab(),
                  _buildWorkInfoTab(),
                  _buildFinancialTab(),
                  _buildDocumentsTab(),
                  _buildCustodyTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // إجراءات سريعة (تعديل، طباعة، إنهاء خدمات)
          _showActionsBottomSheet(context);
        },
        backgroundColor: const Color(0xFF00897B),
        child: const Icon(Icons.edit_note),
      ),
    );
  }

  // --- 1. الترويسة (Header) ---
  SliverAppBar _buildSliverAppBar() {
    // جلب اسم الوظيفة والقسم من القوائم
    final jobTitle = _getNameFromLookup(LookupCategory.jobTitles, _employee.jobTitleId);
    final department = _getNameFromLookup(LookupCategory.departments, _employee.departmentId);

    return SliverAppBar(
      expandedHeight: 240.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF263238),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF37474F), Color(0xFF263238)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _employee.profilePictureUrl != null 
                          ? NetworkImage(_employee.profilePictureUrl!) 
                          : null,
                      child: _employee.profilePictureUrl == null 
                          ? const Icon(Icons.person, size: 50, color: Colors.grey) 
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      child: const Icon(Icons.check, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _employee.fullNameAr,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "$jobTitle | $department",
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "رقم الموظف: ${_employee.employeeCode}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.phone), onPressed: () {}),
        IconButton(icon: const Icon(Icons.email), onPressed: () {}),
      ],
    );
  }

  // --- 2. التبويب الأول: شخصي ---
  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCard(
            title: "البيانات الأساسية",
            icon: Icons.person_outline,
            children: [
              _buildInfoRow("الاسم بالإنجليزية", _employee.fullNameEn),
              _buildInfoRow("تاريخ الميلاد", DateFormat('yyyy/MM/dd').format(_employee.dateOfBirth)),
              _buildInfoRow("الجنس", _employee.gender == 'Male' ? 'ذكر' : 'أنثى'),
              _buildInfoRow("الجنسية", _employee.nationalityId),
              _buildInfoRow("الرقم الوطني/الإقامة", _employee.nationalIdNumber),
            ],
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "معلومات الاتصال",
            icon: Icons.contact_phone_outlined,
            children: [
              _buildInfoRow("رقم الهاتف", _employee.mobileNumber, isPhone: true),
              _buildInfoRow("البريد الإلكتروني", _employee.email, isEmail: true),
              _buildInfoRow("العنوان", _employee.address),
            ],
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "جهة اتصال الطوارئ",
            icon: Icons.emergency_outlined,
            iconColor: Colors.red,
            children: [
              _buildInfoRow("الاسم", _employee.emergencyContactName),
              _buildInfoRow("الهاتف", _employee.emergencyContactPhone, isPhone: true),
            ],
          ),
        ],
      ),
    );
  }

  // --- 3. التبويب الثاني: العمل ---
  Widget _buildWorkInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCard(
            title: "التفاصيل الوظيفية",
            icon: Icons.work_outline,
            children: [
              _buildInfoRow("تاريخ التعيين", DateFormat('yyyy/MM/dd').format(_employee.joinDate)),
              _buildInfoRow("الدرجة الوظيفية", _getNameFromLookup(LookupCategory.jobLevels, _employee.jobLevelId)),
              _buildInfoRow("نوع العقد", "عقد محدد المدة (FIXED)"), // يحتاج جلب من العقد
              _buildInfoRow("المدير المباشر", _employee.directManagerId ?? "-"),
            ],
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "الموقع والهيكل",
            icon: Icons.apartment_outlined,
            children: [
              _buildInfoRow("الدائرة", _getNameFromLookup(LookupCategory.departments, _employee.departmentId)),
              _buildInfoRow("القسم", _getNameFromLookup(LookupCategory.sections, _employee.sectionId)),
              _buildInfoRow("الوحدة", _getNameFromLookup(LookupCategory.units, _employee.unitId ?? "")),
              _buildInfoRow("موقع العمل", _getNameFromLookup(LookupCategory.locations, _employee.workLocationId)),
            ],
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "الدوام والورديات",
            icon: Icons.access_time,
            children: [
              _buildInfoRow("الوردية الحالية", _getNameFromLookup(LookupCategory.shifts, _employee.shiftId)),
              _buildInfoRow("نظام الحضور", "بصمة (Fingerprint)"),
            ],
          ),
        ],
      ),
    );
  }

  // --- 4. التبويب الثالث: المالي ---
  Widget _buildFinancialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCard(
            title: "الراتب والمستحقات",
            icon: Icons.monetization_on_outlined,
            children: [
              _buildInfoRow("الراتب الأساسي", "${_employee.basicSalary.toStringAsFixed(2)} د.أ", isBold: true),
              ..._employee.allowances.entries.map((e) {
                final name = _getNameFromLookup(LookupCategory.allowanceTypes, e.key);
                return _buildInfoRow(name, "${e.value.toStringAsFixed(2)} د.أ");
              }),
              const Divider(),
              _buildInfoRow("إجمالي الراتب", "${_employee.totalSalary.toStringAsFixed(2)} د.أ", isBold: true, valueColor: Colors.green),
            ],
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "المعلومات البنكية والضمان",
            icon: Icons.account_balance_outlined,
            children: [
              _buildInfoRow("طريقة الدفع", _getNameFromLookup(LookupCategory.paymentMethods, _employee.paymentMethodId)),
              _buildInfoRow("اسم البنك", _employee.bankName ?? "-"),
              _buildInfoRow("رقم الآيبان (IBAN)", _employee.ibanNumber ?? "-", isBold: true),
              _buildInfoRow("رقم الضمان الاجتماعي", _employee.socialSecurityNumber ?? "-"),
            ],
          ),
        ],
      ),
    );
  }

  // --- 5. التبويب الرابع: الوثائق ---
  Widget _buildDocumentsTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _employee.documents.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final doc = _employee.documents[index];
        final typeName = _getNameFromLookup(LookupCategory.documentTypes, doc.documentTypeId);
        
        // التحقق من الانتهاء
        final isExpired = doc.isExpired;
        final isSoon = doc.isExpiringSoon;
        
        Color statusColor = Colors.green;
        String statusText = "ساري المفعول";
        
        if (isExpired) {
          statusColor = Colors.red;
          statusText = "منتهي الصلاحية";
        } else if (isSoon) {
          statusColor = Colors.orange;
          statusText = "ينتهي قريباً";
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.description, color: Colors.blue[800]),
            ),
            title: Text(typeName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("رقم: ${doc.documentNumber}"),
                if (doc.expiryDate != null)
                  Text("ينتهي في: ${DateFormat('yyyy/MM/dd').format(doc.expiryDate!)}", style: TextStyle(color: statusColor, fontSize: 12)),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (doc.isVerified) const Icon(Icons.verified, size: 16, color: Colors.teal),
                const SizedBox(height: 4),
                Icon(Icons.remove_red_eye, color: Colors.grey[600]),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- 6. التبويب الخامس: العهد ---
  Widget _buildCustodyTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _employee.custodies.length,
      itemBuilder: (context, index) {
        final custody = _employee.custodies[index];
        final typeName = _getNameFromLookup(LookupCategory.custodyTypes, custody.custodyTypeId);

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.brown[50],
              child: Icon(Icons.handyman, color: Colors.brown[700]),
            ),
            title: Text(typeName),
            subtitle: Text("${custody.itemName}\nتاريخ الاستلام: ${DateFormat('yyyy/MM/dd').format(custody.receivedDate)}"),
            isThreeLine: true,
            trailing: Chip(
              label: Text(custody.condition),
              backgroundColor: Colors.grey[200],
            ),
          ),
        );
      },
    );
  }

  // --- Widgets مساعدة ---
  Widget _buildCard({required String title, required IconData icon, required List<Widget> children, Color iconColor = Colors.teal}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, bool isPhone = false, bool isEmail = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                  color: valueColor ?? Colors.black87,
                ),
              ),
              if (isPhone) ...[const SizedBox(width: 8), const Icon(Icons.phone_in_talk, size: 16, color: Colors.green)],
              if (isEmail) ...[const SizedBox(width: 8), const Icon(Icons.email_outlined, size: 16, color: Colors.blue)],
            ],
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لترجمة الـ IDs إلى أسماء باستخدام seed_data
  String _getNameFromLookup(LookupCategory category, String? id) {
    if (id == null) return "-";
    final list = masterLookups[category] ?? [];
    try {
      return list.firstWhere((e) => e.id == id).name;
    } catch (e) {
      return id; // إذا لم يجد الاسم يعيد الكود كما هو
    }
  }

  void _showActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(leading: const Icon(Icons.edit), title: const Text("تعديل البيانات"), onTap: () {}),
          ListTile(leading: const Icon(Icons.print), title: const Text("طباعة ملف الموظف"), onTap: () {}),
          ListTile(leading: const Icon(Icons.money), title: const Text("تعديل الراتب/العقد"), onTap: () {}),
          ListTile(leading: const Icon(Icons.block, color: Colors.red), title: const Text("إنهاء الخدمات", style: TextStyle(color: Colors.red)), onTap: () {}),
        ],
      ),
    );
  }
}