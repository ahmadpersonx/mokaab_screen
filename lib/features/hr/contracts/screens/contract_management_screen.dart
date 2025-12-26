// FileName: lib/features/hr/contracts/screens/contract_management_screen.dart
// Description: شاشة إنشاء العقود (Strict Workflow: File First)
// Version: 2.0 (Enforced Employee Selection)

import 'package:flutter/material.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';
import 'package:mokaab/features/hr/contracts/services/contract_pdf_service.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/quick_add_employee_screen.dart'; // للربط السريع

// نموذج مبسط للعقد
class EmploymentContract {
  String? employeeName;
  String? employeeId; // إضافة ID الموظف للربط
  String? contractType;
  DateTime? startDate;
  DateTime? endDate;
  String? departmentId;
  String? sectionId;
  String? jobTitleId;
  String? jobLevelId;
  double basicSalary;
  Map<String, double> allowances; 
  String? shiftId;
  int probationMonths;
  int noticePeriodMonths;
  String? status;

  EmploymentContract({
    this.employeeName,
    this.employeeId,
    this.contractType,
    this.startDate,
    this.endDate,
    this.departmentId,
    this.sectionId,
    this.jobTitleId,
    this.jobLevelId,
    this.basicSalary = 0.0,
    Map<String, double>? allowances,
    this.shiftId,
    this.probationMonths = 3,
    this.noticePeriodMonths = 1,
    this.status = 'Draft',
  }) : allowances = allowances ?? {};
}

class ContractManagementScreen extends StatefulWidget {
  const ContractManagementScreen({super.key});

  @override
  State<ContractManagementScreen> createState() => _ContractManagementScreenState();
}

class _ContractManagementScreenState extends State<ContractManagementScreen> {
  final EmploymentContract _contract = EmploymentContract();
  
  // بيانات وهمية للموظفين الذين تم فتح ملفاتهم ولكن ليس لديهم عقود بعد (Pending Contracts)
  final List<Map<String, String>> _pendingEmployees = [
    {'id': 'EMP-102', 'name': 'سالم علي يوسف', 'nid': '9950000000', 'job': 'مشغل آليات'},
    {'id': 'EMP-103', 'name': 'محمود حسن', 'nid': '9960000000', 'job': 'فني صيانة'},
    {'id': 'EMP-104', 'name': 'رنا خالد', 'nid': '9980000000', 'job': 'سكرتارية'},
  ];

  // قوائم البيانات
  List<LookupItem> get _departments => masterLookups[LookupCategory.departments] ?? [];
  List<LookupItem> get _sections => masterLookups[LookupCategory.sections] ?? [];
  List<LookupItem> get _jobTitles => masterLookups[LookupCategory.jobTitles] ?? [];
  List<LookupItem> get _jobLevels => masterLookups[LookupCategory.jobLevels] ?? [];
  List<LookupItem> get _contractTypes => masterLookups[LookupCategory.contractTypes] ?? [];
  List<LookupItem> get _shifts => masterLookups[LookupCategory.shifts] ?? [];
  List<LookupItem> get _allowances => masterLookups[LookupCategory.allowanceTypes] ?? [];

  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("إنشاء عقد تعيين جديد"),
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          // القائمة الجانبية
          Container(
            width: 250,
            color: Colors.white,
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepTapped: (index) {
                // منع الانتقال إذا لم يتم اختيار موظف في الخطوة الأولى
                if (index > 0 && _contract.employeeId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يجب اختيار الموظف أولاً"), backgroundColor: Colors.red));
                  return;
                }
                setState(() => _currentStep = index);
              },
              controlsBuilder: (context, details) => const SizedBox(),
              steps: const [
                Step(title: Text("اختيار الموظف ونوع العقد"), content: SizedBox(), isActive: true),
                Step(title: Text("الموقع والهيكل الوظيفي"), content: SizedBox()),
                Step(title: Text("الراتب والمزايا المالية"), content: SizedBox()),
                Step(title: Text("الدوام والإجازات"), content: SizedBox()),
                Step(title: Text("الشروط والأحكام"), content: SizedBox()),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          
          // المحتوى
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
          
          // الملخص
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

  // --- 1. الخطوة الأولى المعدلة (إجبارية الملف) ---
  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("1. اختيار الموظف (الملف الشخصي)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
        const SizedBox(height: 8),
        const Text(
          "يجب أن يكون للموظف ملف مفتوح في النظام قبل إنشاء العقد.",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 16),
        
        // مربع اختيار الموظف
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blue.shade200),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "اختر الموظف (الذين ليس لديهم عقود سارية)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_search),
                  filled: true,
                  fillColor: Colors.white,
                ),
                value: _contract.employeeId, // الربط بالمتغير
                items: _pendingEmployees.map((e) => DropdownMenuItem(
                  value: e['id'], 
                  child: Text("${e['name']} (${e['job']})")
                )).toList(),
                onChanged: (val) {
                  setState(() {
                    final emp = _pendingEmployees.firstWhere((e) => e['id'] == val);
                    _contract.employeeId = emp['id'];
                    _contract.employeeName = emp['name'];
                    // هنا يمكن جلب المسمى الوظيفي المقترح من ملف الموظف وتعبئته تلقائياً
                  });
                },
                validator: (val) => val == null ? "يجب اختيار موظف للمتابعة" : null,
              ),
              
              const SizedBox(height: 12),
              
              // رابط سريع لفتح ملف جديد إذا لم يجد الاسم
              InkWell(
                onTap: () async {
                  // فتح شاشة الإضافة السريعة التي أنشأناها سابقاً
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const QuickAddEmployeeScreen()));
                  // بعد العودة يمكن تحديث القائمة (في الوضع الحقيقي)
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم تحديث القائمة (محاكاة)")));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(Icons.add_circle_outline, size: 16, color: Colors.blue),
                    SizedBox(width: 4),
                    Text("الموظف غير موجود؟ اضغط هنا لفتح ملف جديد", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  ],
                ),
              )
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        const Text("2. تفاصيل العقد", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "نوع العقد", border: OutlineInputBorder(), prefixIcon: Icon(Icons.description)),
          value: _contractTypes.any((e) => e.id == _contract.contractType) ? _contract.contractType : null,
          items: _contractTypes.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
          onChanged: (val) {
            setState(() {
              _contract.contractType = val;
              final selected = _contractTypes.firstWhere((e) => e.id == val);
              if (selected.metaData != null) {
                _contract.probationMonths = int.tryParse(selected.metaData!['probation'] ?? '3') ?? 3;
                _contract.noticePeriodMonths = int.tryParse(selected.metaData!['notice'] ?? '1') ?? 1;
              }
            });
          },
          validator: (val) => val == null ? "مطلوب" : null,
        ),
        
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
                validator: (val) => val!.isEmpty ? "مطلوب" : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "تاريخ الانتهاء", border: OutlineInputBorder(), suffixIcon: Icon(Icons.event_busy)),
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

  // ... باقي الخطوات (JobInfo, Financial, Attendance, Terms) تبقى كما هي تماماً ...
  // (قم بنسخ الدوال _buildJobInfoStep, _buildFinancialStep, ... من الكود السابق، لا تغيير عليها)
  
  // 2. الهيكل الوظيفي (نفس السابق)
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
                onChanged: (val) => setState(() => _contract.jobTitleId = val),
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

  // 3. المالية (نفس السابق)
  Widget _buildFinancialStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("حزمة التعويضات (Compensation Package)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(labelText: "الراتب الأساسي (Basic Salary)", border: OutlineInputBorder(), suffixText: "د.أ"),
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: _contract.basicSalary > 0 ? _contract.basicSalary.toString() : ""),
          onChanged: (val) => setState(() => _contract.basicSalary = double.tryParse(val) ?? 0.0),
        ),
        const SizedBox(height: 24),
        const Text("البدلات والعلاوات (Allowances)", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300), 
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            children: _allowances.map((allowance) {
              final bool isSelected = _contract.allowances.containsKey(allowance.id);
              final TextEditingController valController = TextEditingController(
                text: isSelected ? _contract.allowances[allowance.id].toString() : ""
              );

              return Column(
                children: [
                  CheckboxListTile(
                    title: Text(allowance.name, style: const TextStyle(fontSize: 14)),
                    subtitle: Text(allowance.metaData?['type'] == 'FIXED' ? 'مبلغ ثابت' : 'نسبة مئوية من الأساسي', style: const TextStyle(fontSize: 11)),
                    secondary: CircleAvatar(backgroundColor: allowance.color?.withOpacity(0.1), child: Icon(Icons.monetization_on, color: allowance.color, size: 18)),
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _contract.allowances[allowance.id] = 0.0;
                        } else {
                          _contract.allowances.remove(allowance.id);
                        }
                      });
                    },
                  ),
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 72, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: valController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: allowance.metaData?['type'] == 'FIXED' ? "القيمة (د.أ)" : "النسبة (%)",
                                isDense: true,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _contract.allowances[allowance.id] = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                          ),
                          if (allowance.metaData?['type'] == 'PERCENT')
                             Padding(
                               padding: const EdgeInsets.only(right: 8.0),
                               child: Text("= ${(_contract.basicSalary * (_contract.allowances[allowance.id] ?? 0) / 100).toStringAsFixed(1)} د.أ", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                             ),
                        ],
                      ),
                    ),
                  const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // 4. الدوام (نفس السابق)
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

  // 5. الشروط (نفس السابق)
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
        SwitchListTile(title: const Text("خاضع للضمان الاجتماعي"), value: true, onChanged: (val) {}),
        SwitchListTile(title: const Text("تأمين صحي"), value: true, onChanged: (val) {}),
      ],
    );
  }

  // --- الملخص (كما هو) ---
  Widget _buildContractSummary() {
    double totalSalary = _contract.basicSalary;
    double totalAllowances = 0; 

    _contract.allowances.forEach((id, value) {
      final allowance = _allowances.firstWhere((e) => e.id == id, orElse: () => LookupItem(id: '', name: '', code: ''));
      if (allowance.metaData?['type'] == 'PERCENT') {
        totalAllowances += (_contract.basicSalary * value / 100);
      } else {
        totalAllowances += value;
      }
    });

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
        _summaryRow("الأساسي:", "${_contract.basicSalary.toStringAsFixed(0)} د.أ"),
        
        if (_contract.allowances.isNotEmpty) ...[
          const SizedBox(height: 4),
          const Text("البدلات:", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ..._contract.allowances.entries.map((entry) {
             final allowance = _allowances.firstWhere((e) => e.id == entry.key);
             double val = entry.value;
             if (allowance.metaData?['type'] == 'PERCENT') val = (_contract.basicSalary * val / 100);
             return Padding(
               padding: const EdgeInsets.only(right: 8.0),
               child: _summaryRow("- ${allowance.name}", "${val.toStringAsFixed(0)} د.أ", fontSize: 11),
             );
          }).toList(),
        ],

        _summaryRow("مجموع البدلات:", "${totalAllowances.toStringAsFixed(0)} د.أ"),
        const Divider(thickness: 2),
        _summaryRow("الإجمالي:", "${grandTotal.toStringAsFixed(0)} د.أ", isBold: true, color: Colors.green[800]),
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

  Widget _summaryRow(String label, String value, {bool isBold = false, Color? color, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: fontSize)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color ?? Colors.black, fontSize: isBold ? 16 : fontSize)),
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
            if (_currentStep == 0) {
              if (_formKey.currentState!.validate()) {
                 setState(() => _currentStep++);
              }
            } else if (_currentStep < 4) {
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