// FileName: lib/features/hr/contracts/screens/contract_management_screen.dart
// Description: شاشة إنشاء وإدارة عقود التعيين (The Core Linker)
// Version: 1.3 (Fix Dropdown Value Error)

import 'package:flutter/material.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';
import 'package:mokaab/features/hr/contracts/services/contract_pdf_service.dart'; // استيراد خدمة الطباعة

// نموذج مبسط للعقد (يفضل فصله لاحقاً في ملف models)
class EmploymentContract {
  String? employeeName;
  String? contractType;
  DateTime? startDate;
  DateTime? endDate;
  String? departmentId;
  String? sectionId;
  String? jobTitleId;
  String? jobLevelId;
  double basicSalary;
  List<String> allowanceIds;
  String? shiftId;
  int probationMonths;
  int noticePeriodMonths;
  String? status; // Draft, Active, Terminated

  EmploymentContract({
    this.employeeName,
    this.contractType,
    this.startDate,
    this.endDate,
    this.departmentId,
    this.sectionId,
    this.jobTitleId,
    this.jobLevelId,
    this.basicSalary = 0.0,
    this.allowanceIds = const [],
    this.shiftId,
    this.probationMonths = 3,
    this.noticePeriodMonths = 1,
    this.status = 'Draft',
  });
}

class ContractManagementScreen extends StatefulWidget {
  const ContractManagementScreen({super.key});

  @override
  State<ContractManagementScreen> createState() => _ContractManagementScreenState();
}

class _ContractManagementScreenState extends State<ContractManagementScreen> {
  // حالة العقد الحالي
  final EmploymentContract _contract = EmploymentContract();
  
  // قوائم البيانات (من الذاكرة الحية Seed Data)
  List<LookupItem> get _departments => masterLookups[LookupCategory.departments] ?? [];
  List<LookupItem> get _sections => masterLookups[LookupCategory.sections] ?? [];
  List<LookupItem> get _jobTitles => masterLookups[LookupCategory.jobTitles] ?? [];
  List<LookupItem> get _jobLevels => masterLookups[LookupCategory.jobLevels] ?? [];
  List<LookupItem> get _contractTypes => masterLookups[LookupCategory.contractTypes] ?? [];
  List<LookupItem> get _shifts => masterLookups[LookupCategory.shifts] ?? [];
  List<LookupItem> get _allowances => masterLookups[LookupCategory.allowanceTypes] ?? [];

  // تحكم بالواجهة
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("إنشاء عقد تعيين جديد"),
        actions: [
          TextButton.icon(
            onPressed: () {
              // منطق الحفظ
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم حفظ مسودة العقد بنجاح")));
            },
            icon: const Icon(Icons.save_as, color: Colors.white),
            label: const Text("حفظ مسودة", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Row(
        children: [
          // 1. القائمة الجانبية (خطوات المعالج)
          Container(
            width: 250,
            color: Colors.white,
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepTapped: (index) => setState(() => _currentStep = index),
              controlsBuilder: (context, details) => const SizedBox(), // إخفاء الأزرار الافتراضية
              steps: const [
                Step(title: Text("بيانات العقد الأساسية"), content: SizedBox(), isActive: true),
                Step(title: Text("الموقع والهيكل الوظيفي"), content: SizedBox()),
                Step(title: Text("الراتب والمزايا المالية"), content: SizedBox()),
                Step(title: Text("الدوام والإجازات"), content: SizedBox()),
                Step(title: Text("الشروط والأحكام"), content: SizedBox()),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          
          // 2. محتوى النموذج
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildStepContent(),
                      const SizedBox(height: 30),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // 3. لوحة الملخص (Live Summary)
          Container(
            width: 300,
            color: Colors.grey[50],
            padding: const EdgeInsets.all(16),
            child: _buildContractSummary(),
          ),
        ],
      ),
    );
  }

  // --- محتوى الخطوات ---
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0: return _buildBasicInfoStep();
      case 1: return _buildJobInfoStep();
      case 2: return _buildFinancialStep();
      case 3: return _buildAttendanceStep();
      case 4: return _buildTermsStep();
      default: return const Text("Unknown Step");
    }
  }

  // 1. الخطوة الأولى: البيانات الأساسية
  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("تفاصيل التعاقد", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(labelText: "اسم الموظف (المرشح)", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
          onChanged: (val) => setState(() => _contract.employeeName = val),
        ),
        const SizedBox(height: 16),
        
        // --- التصحيح هنا ---
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "نوع العقد", border: OutlineInputBorder(), prefixIcon: Icon(Icons.description)),
          // التأكد من أن القيمة المختارة موجودة فعلياً في القائمة
          value: _contractTypes.any((e) => e.id == _contract.contractType) ? _contract.contractType : null,
          items: _contractTypes.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
          onChanged: (val) {
            setState(() {
              _contract.contractType = val;
              // ذكاء النظام: تعبئة القيم الافتراضية من الميتا داتا
              final selected = _contractTypes.firstWhere((e) => e.id == val);
              if (selected.metaData != null) {
                _contract.probationMonths = int.tryParse(selected.metaData!['probation'] ?? '3') ?? 3;
                _contract.noticePeriodMonths = int.tryParse(selected.metaData!['notice'] ?? '1') ?? 1;
              }
            });
          },
          validator: (value) => value == null ? 'يرجى اختيار نوع العقد' : null,
        ),
        // --------------------

        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "تاريخ المباشرة", border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
                  if (date != null) setState(() => _contract.startDate = date);
                },
                controller: TextEditingController(text: _contract.startDate != null ? "${_contract.startDate!.toLocal()}".split(' ')[0] : ""),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "تاريخ الانتهاء (للعقود المحددة)", border: OutlineInputBorder(), suffixIcon: Icon(Icons.event_busy)),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 365)), firstDate: DateTime(2000), lastDate: DateTime(2030));
                  if (date != null) setState(() => _contract.endDate = date);
                },
                controller: TextEditingController(text: _contract.endDate != null ? "${_contract.endDate!.toLocal()}".split(' ')[0] : ""),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. الخطوة الثانية: الهيكل الوظيفي
  Widget _buildJobInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("الموقع في الهيكل التنظيمي", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "الدائرة / الإدارة", border: OutlineInputBorder()),
          value: _departments.any((e) => e.id == _contract.departmentId) ? _contract.departmentId : null,
          items: _departments.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
          onChanged: (val) => setState(() => _contract.departmentId = val),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "القسم", border: OutlineInputBorder()),
          // ذكاء النظام: فلترة الأقسام بناءً على الدائرة المختارة
          value: _sections.any((e) => e.id == _contract.sectionId) ? _contract.sectionId : null,
          items: _sections
              .where((s) => _contract.departmentId == null || s.metaData?['parentId'] == _contract.departmentId)
              .map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
          onChanged: (val) => setState(() => _contract.sectionId = val),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "المسمى الوظيفي", border: OutlineInputBorder()),
                value: _jobTitles.any((e) => e.id == _contract.jobTitleId) ? _contract.jobTitleId : null,
                items: _jobTitles.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                onChanged: (val) {
                  setState(() {
                    _contract.jobTitleId = val;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "الدرجة الوظيفية", border: OutlineInputBorder()),
                value: _jobLevels.any((e) => e.id == _contract.jobLevelId) ? _contract.jobLevelId : null,
                items: _jobLevels.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                onChanged: (val) {
                   setState(() {
                     _contract.jobLevelId = val;
                     // ذكاء النظام: اقتراح الراتب بناءً على الحد الأدنى للدرجة
                     final level = _jobLevels.firstWhere((e) => e.id == val);
                     if (level.metaData != null && level.metaData!.containsKey('minSalary')) {
                        _contract.basicSalary = double.tryParse(level.metaData!['minSalary']) ?? 0.0;
                     }
                   });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 3. الخطوة الثالثة: المالية
  Widget _buildFinancialStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("حزمة التعويضات (Compensation Package)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(labelText: "الراتب الأساسي (Basic Salary)", border: OutlineInputBorder(), suffixText: "د.أ"),
          keyboardType: TextInputType.number,
          // عرض الراتب المقترح من الدرجة
          controller: TextEditingController(text: _contract.basicSalary > 0 ? _contract.basicSalary.toString() : ""),
          onChanged: (val) => setState(() => _contract.basicSalary = double.tryParse(val) ?? 0.0),
        ),
        const SizedBox(height: 24),
        const Text("البدلات والعلاوات (Allowances)", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: _allowances.map((allowance) {
              final bool isSelected = _contract.allowanceIds.contains(allowance.id);
              return CheckboxListTile(
                title: Text(allowance.name),
                subtitle: Text(allowance.metaData?['type'] == 'FIXED' ? 'مبلغ ثابت' : 'نسبة مئوية'),
                secondary: CircleAvatar(backgroundColor: allowance.color?.withOpacity(0.2), child: Icon(Icons.monetization_on, color: allowance.color, size: 20)),
                value: isSelected,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _contract.allowanceIds.add(allowance.id);
                    } else {
                      _contract.allowanceIds.remove(allowance.id);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // 4. الخطوة الرابعة: الدوام
  Widget _buildAttendanceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("نظام العمل والورديات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "الوردية الافتراضية", border: OutlineInputBorder(), prefixIcon: Icon(Icons.access_time)),
          value: _shifts.any((e) => e.id == _contract.shiftId) ? _contract.shiftId : null,
          items: _shifts.map((e) => DropdownMenuItem(value: e.id, child: Text("${e.name} (${e.metaData?['start']} - ${e.metaData?['end']})"))).toList(),
          onChanged: (val) => setState(() => _contract.shiftId = val),
        ),
        const SizedBox(height: 16),
        const ListTile(
          leading: Icon(Icons.beach_access, color: Colors.orange),
          title: Text("رصيد الإجازات السنوية"),
          trailing: Text("21 يوم (حسب الدرجة)", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // 5. الخطوة الخامسة: الشروط
  Widget _buildTermsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("الشروط التعاقدية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "فترة التجربة (أشهر)", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: _contract.probationMonths.toString()),
                onChanged: (val) => _contract.probationMonths = int.tryParse(val) ?? 3,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "فترة الإشعار (أشهر)", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: _contract.noticePeriodMonths.toString()),
                onChanged: (val) => _contract.noticePeriodMonths = int.tryParse(val) ?? 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text("خاضع للضمان الاجتماعي"),
          value: true, 
          onChanged: (val) {},
        ),
        SwitchListTile(
          title: const Text("تأمين صحي"),
          value: true, 
          onChanged: (val) {},
        ),
      ],
    );
  }

  // --- لوحة الملخص الجانبية (Smart Summary) ---
  Widget _buildContractSummary() {
    double totalSalary = _contract.basicSalary;
    double totalAllowances = 0; 
    for (var id in _contract.allowanceIds) {
      totalAllowances += 50; 
    }
    double grandTotal = totalSalary + totalAllowances;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("ملخص العقد", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Divider(),
        _summaryRow("الاسم:", _contract.employeeName ?? "-"),
        _summaryRow("الوظيفة:", _jobTitles.firstWhere((e) => e.id == _contract.jobTitleId, orElse: () => LookupItem(id: '', name: '-', code: '')).name),
        _summaryRow("القسم:", _sections.firstWhere((e) => e.id == _contract.sectionId, orElse: () => LookupItem(id: '', name: '-', code: '')).name),
        const Divider(),
        const Text("الملخص المالي (الشهري)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
        const SizedBox(height: 10),
        _summaryRow("الأساسي:", "${_contract.basicSalary} د.أ"),
        _summaryRow("مجموع البدلات:", "$totalAllowances د.أ"),
        const Divider(thickness: 2),
        _summaryRow("الإجمالي:", "$grandTotal د.أ", isBold: true, color: Colors.green[800]),
        const Spacer(),
        if (_contract.contractType != null)
           Container(
             padding: const EdgeInsets.all(8),
             color: Colors.blue[50],
             child: Row(children: [
               const Icon(Icons.info_outline, size: 16, color: Colors.blue),
               const SizedBox(width: 8),
               Expanded(child: Text("نوع العقد: ${_contractTypes.firstWhere((e) => e.id == _contract.contractType).name}", style: const TextStyle(fontSize: 12))),
             ]),
           )
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color ?? Colors.black, fontSize: isBold ? 16 : 14)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_currentStep > 0)
          OutlinedButton(
            onPressed: () => setState(() => _currentStep--),
            child: const Text("السابق"),
          ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            if (_currentStep < 4) {
              setState(() => _currentStep++);
            } else {
              _saveAndPrintContract();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00897B),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: Row(
            children: [
              if (_currentStep == 4) const Icon(Icons.print, size: 18),
              if (_currentStep == 4) const SizedBox(width: 8),
              Text(_currentStep == 4 ? "اعتماد وطباعة العقد" : "التالي"),
            ],
          ),
        ),
      ],
    );
  }

  void _saveAndPrintContract() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم حفظ العقد وجاري إنشاء ملف PDF..."))
    );

    try {
      await ContractPdfService.printContract(_contract);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ في الطباعة: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(radius: 24, backgroundColor: Colors.teal, child: Icon(Icons.gavel, color: Colors.white)),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("نظام إدارة العقود الذكي", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("يربط تلقائياً الهيكل التنظيمي بسلم الرواتب", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}