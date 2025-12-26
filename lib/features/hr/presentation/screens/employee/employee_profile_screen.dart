// FileName: lib/features/hr/presentation/screens/employee/employee_profile_screen.dart
// Description: شاشة الملف الشخصي للموظف (Employee 360 View) with Validation
// Version: 1.2 (Added Alert System)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:mokaab/features/hr/data/models/employee_model.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';

class EmployeeProfileScreen extends StatefulWidget {
  final String employeeId; 

  const EmployeeProfileScreen({super.key, this.employeeId = 'EMP-001'});

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Employee _employee; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadMockEmployeeData(); 
  }

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
      
      // معلومات العمل
      contractId: 'CONT-2024-001',
      joinDate: DateTime(2023, 1, 15),
      departmentId: 'DEP-PROD', 
      sectionId: 'SEC-CNC',     
      unitId: 'UNT-CNC-OP',     
      jobTitleId: 'JOB-OP-CNC', 
      jobLevelId: 'LVL-04',     
      workLocationId: 'L1',     
      shiftId: 'SHIFT-MORNING', 
      directManagerId: 'م. خالد (مدير الإنتاج)', 
      
      // معلومات مالية (نقص في الآيبان للتجربة)
      basicSalary: 450.0,
      allowances: {
        'ALL-TRANS': 30.0, 
        'ALL-RISK': 25.0,  
      },
      paymentMethodId: 'PAY-BANK',
      bankName: 'البنك العربي',
      ibanNumber: '', // فارغ لتجربة التنبيه
      socialSecurityNumber: '12345678',

      // وثائق (وثيقة منتهية للتجربة)
      documents: [
        EmployeeDocument(id: 'D1', documentTypeId: 'DOC-ID', documentNumber: '9901051234', expiryDate: DateTime(2028, 5, 20), isVerified: true),
        EmployeeDocument(id: 'D2', documentTypeId: 'DOC-CONT', documentNumber: 'CN-2023-55', expiryDate: DateTime(2023, 12, 30), isVerified: true), // منتهي
      ],
      custodies: [
        EmployeeCustody(id: 'C1', custodyTypeId: 'CUST-UNIFORM', itemName: 'زي سلامة كامل', receivedDate: DateTime(2023, 1, 15)),
      ],
      status: EmployeeStatus.active,
    );
  }

  // --- دالة فحص النواقص (Validation Engine) ---
  List<String> _checkMissingData() {
    List<String> missingItems = [];

    // 1. فحص الوثائق الإلزامية
    final allDocTypes = masterLookups[LookupCategory.documentTypes] ?? [];
    final mandatoryDocTypes = allDocTypes.where((d) => d.metaData?['mandatory'] == true).toList();

    for (var docType in mandatoryDocTypes) {
      bool hasDoc = _employee.documents.any((d) => d.documentTypeId == docType.id);
      if (!hasDoc) {
        missingItems.add("وثيقة مفقودة: ${docType.name}");
      }
    }

    // 2. فحص صلاحية الوثائق الموجودة
    for (var doc in _employee.documents) {
      if (doc.isExpired) {
        final docName = _getNameFromLookup(LookupCategory.documentTypes, doc.documentTypeId);
        missingItems.add("منتهي الصلاحية: $docName");
      }
    }

    // 3. فحص البيانات المالية والأساسية
    if (_employee.ibanNumber == null || _employee.ibanNumber!.isEmpty) {
      missingItems.add("بيانات ناقصة: رقم الآيبان (IBAN)");
    }
    if (_employee.socialSecurityNumber == null || _employee.socialSecurityNumber!.isEmpty) {
      missingItems.add("بيانات ناقصة: رقم الضمان الاجتماعي");
    }
    if (_employee.emergencyContactPhone.isEmpty) {
      missingItems.add("بيانات ناقصة: هاتف الطوارئ");
    }

    return missingItems;
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
        onPressed: () => _showActionsBottomSheet(context),
        backgroundColor: const Color(0xFF00897B),
        child: const Icon(Icons.edit_note),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
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

  // --- التبويب الأول: شخصي (مع التنبيهات) ---
  Widget _buildPersonalInfoTab() {
    final warnings = _checkMissingData();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // عرض بطاقة التنبيهات في الأعلى
          _buildAlertCard(warnings),

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

  Widget _buildAlertCard(List<String> warnings) {
    if (warnings.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                "تنبيه: ملف الموظف غير مكتمل (${warnings.length})",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14),
              ),
            ],
          ),
          const Divider(color: Colors.redAccent),
          ...warnings.map((w) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 6, color: Colors.red),
                const SizedBox(width: 8),
                Text(w, style: TextStyle(fontSize: 12, color: Colors.red[900])),
              ],
            ),
          )),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _tabController.animateTo(3); // الانتقال لتبويب الوثائق
              },
              icon: const Icon(Icons.upload_file, size: 16),
              label: const Text("استكمال البيانات والوثائق"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- التبويب الثاني: العمل ---
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
              _buildInfoRow("نوع العقد", "عقد محدد المدة (FIXED)"),
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
              _buildInfoRow("الوحدة", _getNameFromLookup(LookupCategory.units, _employee.unitId)),
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

  // --- التبويب الثالث: المالي ---
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

  // --- التبويب الرابع: الوثائق ---
  Widget _buildDocumentsTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _employee.documents.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final doc = _employee.documents[index];
        final typeName = _getNameFromLookup(LookupCategory.documentTypes, doc.documentTypeId);
        
        final isExpired = doc.isExpired;
        final isSoon = doc.isExpiringSoon;
        
        Color statusColor = Colors.green;
        
        if (isExpired) {
          statusColor = Colors.red;
        } else if (isSoon) {
          statusColor = Colors.orange;
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

  // --- التبويب الخامس: العهد ---
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

  String _getNameFromLookup(LookupCategory category, String? id) {
    if (id == null) return "-";
    final list = masterLookups[category] ?? [];
    try {
      return list.firstWhere((e) => e.id == id).name;
    } catch (e) {
      return id; 
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