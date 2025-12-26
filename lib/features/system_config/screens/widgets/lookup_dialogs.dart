// FileName: lib/features/system_config/screens/widgets/lookup_dialogs.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';
import 'lookup_utils.dart'; // تأكد من وجود هذا الملف

class LookupDialogs {
  
  // --- نافذة إضافة/تعديل عنصر (الكاملة والشاملة لجميع القوائم) ---
  static Future<void> showAddEditItemDialog(
    BuildContext context, 
    CategoryDescriptor selectedCategory, 
    Function(LookupItem) onSave, 
    {LookupItem? item}
  ) async {
    final isEdit = item != null;
    final nameController = TextEditingController(text: isEdit ? item.name : "");
    final codeController = TextEditingController(text: isEdit ? item.code : "");

    // ---------------------------------------------------------
    // 1. تعريف جميع المتغيرات لجميع القوائم (Metadata Variables)
    // ---------------------------------------------------------
    
// متغيرات الدوائر (جديد)
    String? selectedDeptType;
    final costCenterController = TextEditingController();
    final managerNameController = TextEditingController();
    final budgetController = TextEditingController();

// متغيرات الأقسام (جديد)
    final sectionHeadController = TextEditingController();
    final headcountController = TextEditingController();
    String? selectedSectionType;

    // متغيرات الوحدات (جديد)
    final foremanController = TextEditingController();
    final capacityController = TextEditingController();
    String? selectedUnitType;

    // أ. المكافآت (Rewards)
    String? selectedRewardType;
    String? selectedKPIType;
    final rewardBasisController = TextEditingController();
    bool isRewardTaxable = true;

    // ب. الدفع (Payment)
    bool requiresAccount = true;
    final bankCodeController = TextEditingController();
    String? defaultCurrency;

    // ج. الخصومات (Deductions)
    String? selectedDeductionType;
    final maxDeductionController = TextEditingController();
    final glAccountController = TextEditingController();
    bool isSystemAuto = false;

    // د. البدلات (Allowances)
    String? selectedAllowanceType;
    String? selectedAllowanceFreq;
    bool isTaxable = true;
    bool isAttendanceLinked = false;

    // هـ. الحضور والغياب (Attendance)
    String? selectedPayrollImpact;
    final multiplierController = TextEditingController();
    bool approvalRequired = false;

    // و. الإجازات (Leaves)
    bool isPaidLeave = true;
    bool deductFromBalance = true;
    bool requiresAttachment = false;
    final maxDaysController = TextEditingController();

    // ز. الورديات (Shifts)
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();
    final breakDurationController = TextEditingController();
    final gracePeriodController = TextEditingController();
    bool isNightShift = false;

    // ح. إنهاء الخدمة (Termination)
    bool isSeverancePayable = true;
    bool requireAssetReturn = true;
    bool isRehireEligible = true;
    bool requiresNotice = true;

    // ط. العقود (Contracts)
    String? selectedPaymentBasis;
    final probationController = TextEditingController();
    final noticePeriodController = TextEditingController();
    bool hasSocialSecurity = true;
    bool hasPaidLeave = true;

    // ي. الدرجات الوظيفية (Job Levels)
    final minSalaryController = TextEditingController();
    final maxSalaryController = TextEditingController();
    final leaveDaysController = TextEditingController();
    bool isOvertimeEligible = true;

    // ك. الوظائف (Job Titles)
    String? selectedJobLevel;
    String? selectedRiskLevel;
    bool isManagerial = false;

    // ل. الربط الهيكلي (Parent Link)
    String? selectedParentId; 
    
    // م. المهام (SOPs)
    final roleController = TextEditingController();
    final freqController = TextEditingController();
    final targetController = TextEditingController();
    final unitController = TextEditingController();

    // ن. المواقع (Locations)
    final addressController = TextEditingController();
    final managerController = TextEditingController();
    String? selectedLocationType;

    // متغيرات الوثائق (جديد)
    bool hasExpiryDate = false;
    final alertDaysController = TextEditingController();
    bool isDocMandatory = false;
    bool requiresUpload = true;

// متغيرات التأشيرات (جديد)
    final visaDurationController = TextEditingController();
    final visaCostController = TextEditingController();
    bool medicalCheckRequired = true;
    bool bankGuaranteeRequired = false;

// متغيرات المهارات (جديد)
    String? selectedSkillCategory;
    bool isCertRequired = false;
    final renewalYearsController = TextEditingController(text: "0");

    // متغيرات أدوات السلامة (جديد)
    final lifespanController = TextEditingController();
    bool isReturnableAsset = false;
    String? selectedMandatoryZone;

// متغيرات العُهد (جديد)
    bool requiresSerial = true;
    bool isCustodyReturnable = true;
    bool requiresCheck = true;
    final estimatedValueController = TextEditingController();

    // متغيرات المخالفات (جديد)
    final penaltyValueController = TextEditingController();
    bool isProgressive = true;
    final resetDaysController = TextEditingController();
    bool requiresInvestigation = false;

// متغيرات التقييم (جديد)
    final weightController = TextEditingController();
    String? selectedTargetRole;
    String? selectedLinkedKPI;

    // ---------------------------------------------------------
    // 2. تعبئة البيانات عند التعديل (Populate Data)
    // ---------------------------------------------------------
    if (isEdit && item.metaData != null) {
      final m = item.metaData!;
      
      // عام (Type) - مشترك بين عدة قوائم
      if (m.containsKey('type')) {
         if (selectedCategory.systemEnum == LookupCategory.rewardTypes) selectedRewardType = m['type'];
         else if (selectedCategory.systemEnum == LookupCategory.deductionTypes) selectedDeductionType = m['type'];
         else if (selectedCategory.systemEnum == LookupCategory.allowanceTypes) selectedAllowanceType = m['type'];
         else if (selectedCategory.systemEnum == LookupCategory.locations) selectedLocationType = m['type'];
      }
      
// أقسام
      if (m.containsKey('head')) sectionHeadController.text = m['head'];
      if (m.containsKey('count')) headcountController.text = m['count'];
      if (m.containsKey('type') && selectedCategory.systemEnum == LookupCategory.sections) selectedSectionType = m['type'];
      // ...

      // وحدات
      if (m.containsKey('foreman')) foremanController.text = m['foreman'];
      if (m.containsKey('capacity')) capacityController.text = m['capacity'];
      if (m.containsKey('type') && selectedCategory.systemEnum == LookupCategory.units) selectedUnitType = m['type'];
      // ...

      // مكافآت
      if (m.containsKey('kpi')) selectedKPIType = m['kpi'];
      if (m.containsKey('basis')) {
         if (selectedCategory.systemEnum == LookupCategory.rewardTypes) rewardBasisController.text = m['basis'];
         else if (selectedCategory.systemEnum == LookupCategory.contractTypes) selectedPaymentBasis = m['basis'];
      }
      if (m.containsKey('taxable')) {
         if (selectedCategory.systemEnum == LookupCategory.rewardTypes) isRewardTaxable = m['taxable'];
         else isTaxable = m['taxable'];
      }

      // دوائر
      if (m.containsKey('type') && selectedCategory.systemEnum == LookupCategory.departments) selectedDeptType = m['type'];
      if (m.containsKey('costCenter')) costCenterController.text = m['costCenter'];
      if (m.containsKey('manager')) managerNameController.text = m['manager'];
      if (m.containsKey('budget')) budgetController.text = m['budget'];
      // ...

      // دفع
      if (m.containsKey('requireAccount')) requiresAccount = m['requireAccount'];
      if (m.containsKey('bankCode')) bankCodeController.text = m['bankCode'];
      if (m.containsKey('currency')) defaultCurrency = m['currency'];

      // خصومات وبدلات
      if (m.containsKey('maxLimit')) maxDeductionController.text = m['maxLimit'];
      if (m.containsKey('glAccount')) glAccountController.text = m['glAccount'];
      if (m.containsKey('auto')) isSystemAuto = m['auto'];
      if (m.containsKey('freq')) selectedAllowanceFreq = m['freq'];
      if (m.containsKey('linked')) isAttendanceLinked = m['linked'];

      // حضور
      if (m.containsKey('impact')) selectedPayrollImpact = m['impact'];
      if (m.containsKey('factor')) multiplierController.text = m['factor'];
      if (m.containsKey('approval')) approvalRequired = m['approval'];

      // إجازات
      if (m.containsKey('paid')) isPaidLeave = m['paid'];
      if (m.containsKey('deduct')) deductFromBalance = m['deduct'];
      if (m.containsKey('attachment')) requiresAttachment = m['attachment'];
      if (m.containsKey('maxDays')) maxDaysController.text = m['maxDays'].toString();

      // ورديات
      if (m.containsKey('start')) startTimeController.text = m['start'];
      if (m.containsKey('end')) endTimeController.text = m['end'];
      if (m.containsKey('break')) breakDurationController.text = m['break'];
      if (m.containsKey('grace')) gracePeriodController.text = m['grace'];
      if (m.containsKey('night')) isNightShift = m['night'];

      // إنهاء خدمة
      if (m.containsKey('severance')) isSeverancePayable = m['severance'];
      if (m.containsKey('assets')) requireAssetReturn = m['assets'];
      if (m.containsKey('rehire')) isRehireEligible = m['rehire'];
      if (m.containsKey('noticeReq')) requiresNotice = m['noticeReq'];

      // عقود
      if (m.containsKey('probation')) probationController.text = m['probation'];
      if (m.containsKey('notice')) noticePeriodController.text = m['notice'];
      if (m.containsKey('socialSecurity')) hasSocialSecurity = m['socialSecurity'];
      if (m.containsKey('paidLeave')) hasPaidLeave = m['paidLeave'];

      // درجات
      if (m.containsKey('minSalary')) minSalaryController.text = m['minSalary'];
      if (m.containsKey('maxSalary')) maxSalaryController.text = m['maxSalary'];
      if (m.containsKey('leaveDays')) leaveDaysController.text = m['leaveDays'];
      if (m.containsKey('overtime')) isOvertimeEligible = m['overtime'];

      // هيكل ومهام ومواقع
      if (m.containsKey('parentId')) selectedParentId = m['parentId'];
      if (m.containsKey('role')) roleController.text = m['role'];
      if (m.containsKey('freq')) freqController.text = m['freq'];
      if (m.containsKey('target')) targetController.text = m['target'].toString();
      if (m.containsKey('unit')) unitController.text = m['unit'];
      if (m.containsKey('address')) addressController.text = m['address'];
      if (m.containsKey('manager')) managerController.text = m['manager'];
      
      // وظائف
      if (m.containsKey('jobLevel')) selectedJobLevel = m['jobLevel'];
      if (m.containsKey('riskLevel')) selectedRiskLevel = m['riskLevel'];
      if (m.containsKey('isManager')) isManagerial = m['isManager'];

      // وثائق
  if (m.containsKey('expiry')) hasExpiryDate = m['expiry'];
  if (m.containsKey('alert')) alertDaysController.text = m['alert'].toString();
  if (m.containsKey('mandatory')) isDocMandatory = m['mandatory'];
  if (m.containsKey('upload')) requiresUpload = m['upload'];

// تأشيرات
      if (m.containsKey('duration')) visaDurationController.text = m['duration'];
      if (m.containsKey('cost')) visaCostController.text = m['cost'];
      if (m.containsKey('medical')) medicalCheckRequired = m['medical'];
      if (m.containsKey('guarantee')) bankGuaranteeRequired = m['guarantee'];

// مهارات
      if (m.containsKey('cat') && selectedCategory.systemEnum == LookupCategory.skillTypes) selectedSkillCategory = m['cat'];
      if (m.containsKey('cert')) isCertRequired = m['cert'];
      if (m.containsKey('renewal')) renewalYearsController.text = m['renewal'];
      // ...
    // أدوات السلامة
      if (m.containsKey('lifespan')) lifespanController.text = m['lifespan'];
      if (m.containsKey('returnable')) isReturnableAsset = m['returnable'];
      if (m.containsKey('zone')) selectedMandatoryZone = m['zone'];
// عهد
      if (m.containsKey('serial')) requiresSerial = m['serial'];
      if (m.containsKey('returnable') && selectedCategory.systemEnum == LookupCategory.custodyTypes) isCustodyReturnable = m['returnable'];
      if (m.containsKey('check')) requiresCheck = m['check'];
      if (m.containsKey('value')) estimatedValueController.text = m['value'];
      // ...

   
      // مخالفات
      if (m.containsKey('penalty')) penaltyValueController.text = m['penalty'];
      if (m.containsKey('progressive')) isProgressive = m['progressive'];
      if (m.containsKey('reset')) resetDaysController.text = m['reset'];
      if (m.containsKey('investigation')) requiresInvestigation = m['investigation'];
      // ...

      // تقييم
      if (m.containsKey('weight')) weightController.text = m['weight'];
      if (m.containsKey('role')) selectedTargetRole = m['role'];
      if (m.containsKey('kpi') && selectedCategory.systemEnum == LookupCategory.evaluationCriteria) selectedLinkedKPI = m['kpi'];
      // ...

   
    }

    // ---------------------------------------------------------
    // 3. تحديد الأعلام (Flags) لمعرفة الحقول المطلوبة
    // ---------------------------------------------------------
    bool isDept = selectedCategory.systemEnum == LookupCategory.departments;
    bool isSection = selectedCategory.systemEnum == LookupCategory.sections;
    bool isDoc = selectedCategory.systemEnum == LookupCategory.documentTypes;
    bool isReward = selectedCategory.systemEnum == LookupCategory.rewardTypes;
    bool isPayment = selectedCategory.systemEnum == LookupCategory.paymentMethods;
    bool isDeduction = selectedCategory.systemEnum == LookupCategory.deductionTypes;
    bool isAllowance = selectedCategory.systemEnum == LookupCategory.allowanceTypes;
    bool isAttendance = selectedCategory.systemEnum == LookupCategory.attendanceStatus;
    bool isLeave = selectedCategory.systemEnum == LookupCategory.leaveTypes;
    bool isShift = selectedCategory.systemEnum == LookupCategory.shifts;
    bool isTermination = selectedCategory.systemEnum == LookupCategory.terminationReasons;
    bool isContract = selectedCategory.systemEnum == LookupCategory.contractTypes;
    bool isJobLevel = selectedCategory.systemEnum == LookupCategory.jobLevels;
    bool isJobTitle = selectedCategory.systemEnum == LookupCategory.jobTitles;
    bool isUnit = selectedCategory.systemEnum == LookupCategory.units;
    bool isTask = selectedCategory.systemEnum == LookupCategory.standardTasks;
    bool isLocation = selectedCategory.systemEnum == LookupCategory.locations;
    bool isVisa = selectedCategory.systemEnum == LookupCategory.visaTypes;
    bool isSkill = selectedCategory.systemEnum == LookupCategory.skillTypes;
bool isPPE = selectedCategory.systemEnum == LookupCategory.safetyTools;
bool isCustody = selectedCategory.systemEnum == LookupCategory.custodyTypes;
bool isViolation = selectedCategory.systemEnum == LookupCategory.violationTypes;
bool isEval = selectedCategory.systemEnum == LookupCategory.evaluationCriteria;


    bool needsParentLink = isSection || isUnit;
    List<LookupItem> parentList = [];
    String parentLabel = "";

    if (isSection) {
      parentList = masterLookups[LookupCategory.departments] ?? [];
      parentLabel = "تابع للدائرة/الإدارة";
    } else if (isUnit) {
      parentList = masterLookups[LookupCategory.sections] ?? [];
      parentLabel = "تابع للقسم";
    }

    // ---------------------------------------------------------
    // 4. بناء الواجهة (Dialog UI)
    // ---------------------------------------------------------
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(isEdit ? "تعديل عنصر" : "إضافة عنصر جديد"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: "الاسم (عربي)")),
                  const SizedBox(height: 12),
                  TextField(controller: codeController, decoration: const InputDecoration(labelText: "الكود المرجعي")),

// --- (21) حقول الدوائر والإدارات ---
                  if (isDept) ...[
                     const SizedBox(height: 16),
                     const Text("الهيكل التنظيمي والمالي", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     DropdownButtonFormField<String>(
                       value: selectedDeptType,
                       decoration: const InputDecoration(labelText: "نوع الإدارة", border: OutlineInputBorder()),
                       items: const [
                         DropdownMenuItem(value: "OPS", child: Text("تشغيلية (Operations)")),
                         DropdownMenuItem(value: "ADMIN", child: Text("إدارية (Administration)")),
                         DropdownMenuItem(value: "SUPPORT", child: Text("مساندة (Support)")),
                         DropdownMenuItem(value: "PROFIT", child: Text("ربحية (Profit Center)")),
                       ],
                       onChanged: (val) => selectedDeptType = val,
                     ),
                     const SizedBox(height: 8),
                     TextField(
                       controller: costCenterController,
                       decoration: const InputDecoration(labelText: "رمز مركز التكلفة (Cost Center)", hintText: "CC-101"),
                     ),
                     const SizedBox(height: 8),
                     TextField(
                       controller: managerNameController,
                       decoration: const InputDecoration(labelText: "المدير المسؤول", hintText: "المسمى الوظيفي"),
                     ),
                     const SizedBox(height: 8),
                     TextField(
                       controller: budgetController,
                       keyboardType: TextInputType.number,
                       decoration: const InputDecoration(labelText: "الموازنة السنوية التقديرية", suffixText: "د.أ"),
                     ),
                  ],

                  // --- (22) حقول الأقسام ---
                  if (isSection) ...[
                     const SizedBox(height: 16),
                     const Text("الهيكل التنظيمي للقسم", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     TextField(
                       controller: sectionHeadController,
                       decoration: const InputDecoration(labelText: "رئيس القسم (Section Head)", hintText: "المسمى الوظيفي"),
                     ),
                     const SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(child: TextField(controller: headcountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "عدد الموظفين المخطط (HC)", hintText: "10"))),
                         const SizedBox(width: 8),
                         Expanded(child: DropdownButtonFormField<String>(
                           value: selectedSectionType,
                           decoration: const InputDecoration(labelText: "نوع النشاط"),
                           items: const [
                             DropdownMenuItem(value: "DIRECT", child: Text("إنتاجي مباشر")),
                             DropdownMenuItem(value: "INDIRECT", child: Text("خدمي/إداري")),
                           ],
                           onChanged: (val) => selectedSectionType = val,
                         )),
                       ],
                     ),
                  ],

                  // --- (23) حقول الوحدات ---
                  if (isUnit) ...[
                     const SizedBox(height: 16),
                     const Text("تفاصيل الوحدة التشغيلية", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     TextField(
                       controller: foremanController,
                       decoration: const InputDecoration(labelText: "المشرف الميداني (Foreman)", hintText: "اسم المشرف"),
                     ),
                     const SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(child: DropdownButtonFormField<String>(
                           value: selectedUnitType,
                           decoration: const InputDecoration(labelText: "نوع الوحدة"),
                           items: const [
                             DropdownMenuItem(value: "PRODUCTION", child: Text("خط إنتاج")),
                             DropdownMenuItem(value: "WORKSHOP", child: Text("ورشة فنية")),
                             DropdownMenuItem(value: "WAREHOUSE", child: Text("مستودع")),
                             DropdownMenuItem(value: "OFFICE", child: Text("مكتب إداري")),
                             DropdownMenuItem(value: "YARD", child: Text("ساحة خارجية")),
                           ],
                           onChanged: (val) => selectedUnitType = val,
                         )),
                         const SizedBox(width: 8),
                         Expanded(child: TextField(controller: capacityController, decoration: const InputDecoration(labelText: "القدرة (Capacity)", hintText: "500 pcs/day"))),
                       ],
                     ),
                  ],

                  // --- (1) حقول المكافآت ---
                  if (isReward) ...[
                     const SizedBox(height: 16),
                     const Text("إعدادات الحوافز (Performance & Rewards)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     DropdownButtonFormField<String>(
                       value: selectedRewardType,
                       decoration: const InputDecoration(labelText: "نوع المكافأة", border: OutlineInputBorder()),
                       items: const [
                         DropdownMenuItem(value: "CASH", child: Text("مكافأة نقدية (Cash)")),
                         DropdownMenuItem(value: "GIFT", child: Text("هدية عينية (Gift)")),
                         DropdownMenuItem(value: "LEAVE", child: Text("رصيد إجازة (Leave)")),
                       ],
                       onChanged: (val) => selectedRewardType = val,
                     ),
                     const SizedBox(height: 8),
                     DropdownButtonFormField<String>(
                       value: selectedKPIType,
                       decoration: const InputDecoration(labelText: "معيار الأداء (KPI)", border: OutlineInputBorder()),
                       items: const [
                         DropdownMenuItem(value: "PRODUCTION", child: Text("حجم الإنتاج")),
                         DropdownMenuItem(value: "SALES", child: Text("حجم المبيعات")),
                         DropdownMenuItem(value: "ATTENDANCE", child: Text("الالتزام بالدوام")),
                         DropdownMenuItem(value: "SAFETY", child: Text("الالتزام بالسلامة")),
                         DropdownMenuItem(value: "GENERAL", child: Text("أداء عام")),
                       ],
                       onChanged: (val) => selectedKPIType = val,
                     ),
                     const SizedBox(height: 8),
                     TextField(controller: rewardBasisController, decoration: const InputDecoration(labelText: "أساس الاحتساب")),
                     const SizedBox(height: 8),
                     SwitchListTile(
                       title: const Text("خاضع للضمان والضريبة"),
                       value: isRewardTaxable,
                       activeColor: Colors.teal,
                       onChanged: (val) => setStateDialog(() => isRewardTaxable = val),
                     ),
                  ],

                  // --- (2) حقول الدفع ---
                  if (isPayment) ...[
                     const SizedBox(height: 16),
                     const Text("إعدادات الدفع", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     SwitchListTile(
                       title: const Text("يتطلب حساب بنكي"),
                       value: requiresAccount,
                       activeColor: Colors.teal,
                       onChanged: (val) => setStateDialog(() => requiresAccount = val),
                     ),
                     const SizedBox(height: 8),
                     DropdownButtonFormField<String>(
                       value: defaultCurrency,
                       decoration: const InputDecoration(labelText: "العملة", border: OutlineInputBorder()),
                       items: const [
                         DropdownMenuItem(value: "JOD", child: Text("JOD")),
                         DropdownMenuItem(value: "USD", child: Text("USD")),
                         DropdownMenuItem(value: "EUR", child: Text("EUR")),
                       ],
                       onChanged: (val) => defaultCurrency = val,
                     ),
                     const SizedBox(height: 8),
                     TextField(controller: bankCodeController, decoration: const InputDecoration(labelText: "رمز التصدير للبنك")),
                  ],

                  // --- (3) حقول الخصومات ---
                  if (isDeduction) ...[
                     const SizedBox(height: 16),
                     const Text("إعدادات الاقتطاع", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     DropdownButtonFormField<String>(
                       value: selectedDeductionType,
                       decoration: const InputDecoration(labelText: "نوع الاحتساب", border: OutlineInputBorder()),
                       items: const [
                         DropdownMenuItem(value: "FIXED", child: Text("مبلغ ثابت")),
                         DropdownMenuItem(value: "PERCENT_BASIC", child: Text("نسبة من الأساسي")),
                         DropdownMenuItem(value: "PERCENT_GROSS", child: Text("نسبة من الإجمالي")),
                       ],
                       onChanged: (val) => selectedDeductionType = val,
                     ),
                     const SizedBox(height: 8),
                     TextField(controller: glAccountController, decoration: const InputDecoration(labelText: "حساب الأستاذ العام")),
                     const SizedBox(height: 8),
                     TextField(controller: maxDeductionController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "الحد الأقصى للخصم")),
                     SwitchListTile(
                       title: const Text("احتساب تلقائي"),
                       value: isSystemAuto,
                       activeColor: Colors.teal,
                       onChanged: (val) => setStateDialog(() => isSystemAuto = val),
                     ),
                  ],

                  // --- (4) حقول البدلات ---
                  if (isAllowance) ...[
                     const SizedBox(height: 16),
                     const Text("إعدادات البدلات", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     DropdownButtonFormField<String>(
                       value: selectedAllowanceType,
                       decoration: const InputDecoration(labelText: "نوع الاحتساب", border: OutlineInputBorder()),
                       items: const [
                         DropdownMenuItem(value: "FIXED", child: Text("مبلغ ثابت")),
                         DropdownMenuItem(value: "PERCENT", child: Text("نسبة من الأساسي")),
                       ],
                       onChanged: (val) => selectedAllowanceType = val,
                     ),
                     const SizedBox(height: 8),
                     DropdownButtonFormField<String>(
                       value: selectedAllowanceFreq,
                       decoration: const InputDecoration(labelText: "دورية الصرف", border: OutlineInputBorder()),
                       items: const [
                         DropdownMenuItem(value: "MONTHLY", child: Text("شهري")),
                         DropdownMenuItem(value: "YEARLY", child: Text("سنوي")),
                         DropdownMenuItem(value: "ONCE", child: Text("مرة واحدة")),
                       ],
                       onChanged: (val) => selectedAllowanceFreq = val,
                     ),
                     const SizedBox(height: 8),
                     SwitchListTile(
                       title: const Text("خاضع للضمان"),
                       value: isTaxable,
                       activeColor: Colors.teal,
                       onChanged: (val) => setStateDialog(() => isTaxable = val),
                     ),
                     SwitchListTile(
                       title: const Text("مرتبط بالحضور"),
                       value: isAttendanceLinked,
                       activeColor: Colors.teal,
                       onChanged: (val) => setStateDialog(() => isAttendanceLinked = val),
                     ),
                  ],

                  // --- (5) حقول الحضور ---
                  if (isAttendance) ...[
                     const SizedBox(height: 16),
                     const Text("إعدادات الاحتساب", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     DropdownButtonFormField<String>(
                       value: selectedPayrollImpact,
                       decoration: const InputDecoration(labelText: "تأثير الراتب", border: OutlineInputBorder()),
                       items: const [
                         DropdownMenuItem(value: "FULL", child: Text("دوام كامل")),
                         DropdownMenuItem(value: "DEDUCT", child: Text("خصم")),
                         DropdownMenuItem(value: "OVERTIME", child: Text("إضافي")),
                         DropdownMenuItem(value: "NEUTRAL", child: Text("محايد")),
                       ],
                       onChanged: (val) => selectedPayrollImpact = val,
                     ),
                     const SizedBox(height: 8),
                     TextField(controller: multiplierController, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: "معامل الاحتساب")),
                     SwitchListTile(title: const Text("يتطلب موافقة"), value: approvalRequired, onChanged: (val) => setStateDialog(() => approvalRequired = val), activeColor: Colors.teal),
                  ],

                  // --- (6) حقول الإجازات ---
                  if (isLeave) ...[
                     const SizedBox(height: 16),
                     const Text("سياسة الإجازة", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     SwitchListTile(title: const Text("مدفوعة الأجر"), value: isPaidLeave, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => isPaidLeave = val)),
                     SwitchListTile(title: const Text("تخصم من الرصيد"), value: deductFromBalance, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => deductFromBalance = val)),
                     SwitchListTile(title: const Text("تتطلب مرفقات"), value: requiresAttachment, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => requiresAttachment = val)),
                     TextField(controller: maxDaysController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "الحد الأقصى للأيام")),
                  ],

                  // --- (7) حقول الورديات ---
                  if (isShift) ...[
                     const SizedBox(height: 16),
                     const Text("إعدادات الوردية", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     Row(children: [
                        Expanded(child: TextField(controller: startTimeController, decoration: const InputDecoration(labelText: "بدء"))),
                        const SizedBox(width: 8),
                        Expanded(child: TextField(controller: endTimeController, decoration: const InputDecoration(labelText: "انتهاء"))),
                     ]),
                     const SizedBox(height: 8),
                     Row(children: [
                        Expanded(child: TextField(controller: breakDurationController, decoration: const InputDecoration(labelText: "استراحة"))),
                        const SizedBox(width: 8),
                        Expanded(child: TextField(controller: gracePeriodController, decoration: const InputDecoration(labelText: "سماحية"))),
                     ]),
                     SwitchListTile(title: const Text("وردية ليلية"), value: isNightShift, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => isNightShift = val)),
                  ],

                  // --- (8) حقول إنهاء الخدمة ---
                  if (isTermination) ...[
                     const SizedBox(height: 16),
                     const Text("إجراءات نهاية الخدمة", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     SwitchListTile(title: const Text("استحقاق مكافأة"), value: isSeverancePayable, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => isSeverancePayable = val)),
                     SwitchListTile(title: const Text("استرداد عهد"), value: requireAssetReturn, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => requireAssetReturn = val)),
                     SwitchListTile(title: const Text("قابل لإعادة التعيين"), value: isRehireEligible, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => isRehireEligible = val)),
                     SwitchListTile(title: const Text("يلزم فترة إشعار"), value: requiresNotice, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => requiresNotice = val)),
                  ],

                  // --- (9) حقول العقود ---
                  if (isContract) ...[
                    const SizedBox(height: 16),
                    const Text("الشروط التعاقدية", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    DropdownButtonFormField<String>(
                      value: selectedPaymentBasis,
                      decoration: const InputDecoration(labelText: "أساس الاحتساب"),
                      items: const [DropdownMenuItem(value: "MONTHLY", child: Text("راتب شهري")), DropdownMenuItem(value: "DAILY", child: Text("يومي")), DropdownMenuItem(value: "HOURLY", child: Text("بالساعة")), DropdownMenuItem(value: "PIECE", child: Text("بالقطعة"))],
                      onChanged: (val) => selectedPaymentBasis = val,
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                        Expanded(child: TextField(controller: probationController, decoration: const InputDecoration(labelText: "فترة التجربة"))),
                        const SizedBox(width: 8),
                        Expanded(child: TextField(controller: noticePeriodController, decoration: const InputDecoration(labelText: "فترة الإشعار"))),
                    ]),
                    SwitchListTile(title: const Text("خاضع للضمان"), value: hasSocialSecurity, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => hasSocialSecurity = val)),
                    SwitchListTile(title: const Text("إجازات مدفوعة"), value: hasPaidLeave, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => hasPaidLeave = val)),
                  ],

                  // --- (10) حقول الدرجات ---
                  if (isJobLevel) ...[
                    const SizedBox(height: 16),
                    const Text("سلم الرواتب", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    Row(children: [
                        Expanded(child: TextField(controller: minSalaryController, decoration: const InputDecoration(labelText: "الحد الأدنى"))),
                        const SizedBox(width: 8),
                        Expanded(child: TextField(controller: maxSalaryController, decoration: const InputDecoration(labelText: "الحد الأعلى"))),
                    ]),
                    const SizedBox(height: 8),
                    TextField(controller: leaveDaysController, decoration: const InputDecoration(labelText: "رصيد الإجازات")),
                    SwitchListTile(title: const Text("يستحق بدل إضافي"), value: isOvertimeEligible, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => isOvertimeEligible = val)),
                  ],

                  // --- (11) حقول الوظائف ---
                  if (isJobTitle) ...[
                    const SizedBox(height: 16),
                    const Text("خصائص الوظيفة", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    DropdownButtonFormField<String>(
                      value: selectedJobLevel,
                      decoration: const InputDecoration(labelText: "المستوى الوظيفي"),
                      items: const [DropdownMenuItem(value: "ENTRY", child: Text("مبتدئ")), DropdownMenuItem(value: "JUNIOR", child: Text("مشارك")), DropdownMenuItem(value: "SENIOR", child: Text("خبير")), DropdownMenuItem(value: "SUPERVISOR", child: Text("مشرف")), DropdownMenuItem(value: "MANAGER", child: Text("مدير"))],
                      onChanged: (val) => selectedJobLevel = val,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedRiskLevel,
                      decoration: const InputDecoration(labelText: "درجة المخاطرة"),
                      items: const [DropdownMenuItem(value: "LOW", child: Text("منخفضة")), DropdownMenuItem(value: "MEDIUM", child: Text("متوسطة")), DropdownMenuItem(value: "HIGH", child: Text("عالية"))],
                      onChanged: (val) => selectedRiskLevel = val,
                    ),
                    SwitchListTile(title: const Text("منصب قيادي"), value: isManagerial, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => isManagerial = val)),
                  ],

                  // --- (12) حقول الربط ---
                  if (needsParentLink) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedParentId,
                      decoration: InputDecoration(labelText: parentLabel),
                      items: parentList.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                      onChanged: (val) => selectedParentId = val,
                    ),
                  ],

                  // --- (13) حقول الوثائق والمستندات ---
              if (isDoc) ...[
                 const SizedBox(height: 16),
                 const Text("إعدادات الوثيقة والأرشفة", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                 const SizedBox(height: 8),
                 SwitchListTile(
                   title: const Text("لها تاريخ انتهاء (تجدد دورياً)"),
                   subtitle: const Text("مثل: رخصة القيادة، الإقامة"),
                   value: hasExpiryDate,
                   activeColor: Colors.teal,
                   onChanged: (val) => setStateDialog(() => hasExpiryDate = val),
                 ),
                 if (hasExpiryDate)
                   Padding(
                     padding: const EdgeInsets.only(bottom: 8.0),
                     child: TextField(
                       controller: alertDaysController,
                       keyboardType: TextInputType.number,
                       decoration: const InputDecoration(labelText: "التنبيه قبل الانتهاء (يوم)", hintText: "مثلاً: 30"),
                     ),
                   ),
                 SwitchListTile(
                   title: const Text("وثيقة إلزامية للملف"),
                   value: isDocMandatory,
                   activeColor: Colors.teal,
                   onChanged: (val) => setStateDialog(() => isDocMandatory = val),
                 ),
                 SwitchListTile(
                   title: const Text("تتطلب رفع نسخة إلكترونية (Scan)"),
                   value: requiresUpload,
                   activeColor: Colors.teal,
                   onChanged: (val) => setStateDialog(() => requiresUpload = val),
                 ),
              ],

                  // --- (13) حقول المهام والمواقع ---
                  if (isTask) ...[
                     const SizedBox(height: 16),
                     const Text("تفاصيل المهمة", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     TextField(controller: roleController, decoration: const InputDecoration(labelText: "المسؤول")),
                     const SizedBox(height: 8),
                     Row(children: [
                        Expanded(child: TextField(controller: freqController, decoration: const InputDecoration(labelText: "التكرار"))),
                        const SizedBox(width: 8),
                        Expanded(child: TextField(controller: targetController, decoration: const InputDecoration(labelText: "الهدف"))),
                     ]),
                     TextField(controller: unitController, decoration: const InputDecoration(labelText: "وحدة القياس")),
                  ],
                  if (isLocation) ...[
                     const SizedBox(height: 16),
                     const Text("تفاصيل الموقع", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     DropdownButtonFormField<String>(
                       value: selectedLocationType,
                       decoration: const InputDecoration(labelText: "نوع الموقع"),
                       items: const [DropdownMenuItem(value: "FACTORY", child: Text("مصنع")), DropdownMenuItem(value: "WAREHOUSE", child: Text("مستودع")), DropdownMenuItem(value: "SHOWROOM", child: Text("معرض")), DropdownMenuItem(value: "PROJECT", child: Text("مشروع"))],
                       onChanged: (val) => selectedLocationType = val,
                     ),
                     TextField(controller: addressController, decoration: const InputDecoration(labelText: "العنوان", suffixIcon: Icon(Icons.map))),
                     TextField(controller: managerController, decoration: const InputDecoration(labelText: "المسؤول", suffixIcon: Icon(Icons.person))),
                  ],

// --- (14) حقول التأشيرات والإقامات ---
                  if (isVisa) ...[
                     const SizedBox(height: 16),
                     const Text("تفاصيل التأشيرة/الإقامة", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(child: TextField(controller: visaDurationController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "المدة (أشهر)", hintText: "12"))),
                         const SizedBox(width: 8),
                         Expanded(child: TextField(controller: visaCostController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "التكلفة (تقديرية)", hintText: "500"))),
                       ],
                     ),
                     const SizedBox(height: 8),
                     SwitchListTile(title: const Text("تتطلب فحص طبي"), value: medicalCheckRequired, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => medicalCheckRequired = val)),
                     SwitchListTile(title: const Text("تتطلب كفالة بنكية"), value: bankGuaranteeRequired, activeColor: Colors.teal, onChanged: (val) => setStateDialog(() => bankGuaranteeRequired = val)),
                  ],

// --- (15) حقول المهارات والكفاءات ---
                  if (isSkill) ...[
                     const SizedBox(height: 16),
                     const Text("تفاصيل الكفاءة (Competency Profile)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     DropdownButtonFormField<String>(
                       value: selectedSkillCategory,
                       decoration: const InputDecoration(labelText: "تصنيف المهارة", border: OutlineInputBorder()),
                       items: const [
                         DropdownMenuItem(value: "TECHNICAL", child: Text("فنية / تشغيلية")),
                         DropdownMenuItem(value: "SAFETY", child: Text("سلامة وصحة مهنية")),
                         DropdownMenuItem(value: "ADMIN", child: Text("إدارية / مكتبية")),
                         DropdownMenuItem(value: "SOFT", child: Text("سلوكية / قيادية")),
                       ],
                       onChanged: (val) => selectedSkillCategory = val,
                     ),
                     const SizedBox(height: 8),
                     SwitchListTile(
                       title: const Text("تتطلب شهادة / رخصة معتمدة"),
                       subtitle: const Text("مثل رخصة السواقة أو مزاولة المهنة"),
                       value: isCertRequired,
                       activeColor: Colors.teal,
                       onChanged: (val) => setStateDialog(() => isCertRequired = val),
                     ),
                     if (isCertRequired)
                       Padding(
                         padding: const EdgeInsets.only(top: 8.0),
                         child: TextField(
                           controller: renewalYearsController,
                           keyboardType: TextInputType.number,
                           decoration: const InputDecoration(labelText: "تجدد كل (سنة)", hintText: "0 تعني لا تجدد"),
                         ),
                       ),
                  ],

// --- (16) حقول أدوات السلامة (PPE) ---
                  if (isPPE) ...[
                     const SizedBox(height: 16),
                     const Text("إدارة المخاطر والعهد (HSE Asset)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     TextField(
                       controller: lifespanController,
                       keyboardType: TextInputType.number,
                       decoration: const InputDecoration(labelText: "العمر الافتراضي (يوم)", hintText: "365"),
                     ),
                     const SizedBox(height: 8),
                     DropdownButtonFormField<String>(
                       value: selectedMandatoryZone,
                       decoration: const InputDecoration(labelText: "إلزامية في منطقة", border: OutlineInputBorder()),
                       items: const [
                         DropdownMenuItem(value: "ALL_SITES", child: Text("جميع المواقع (عام)")),
                         DropdownMenuItem(value: "PRODUCTION", child: Text("صالة الإنتاج")),
                         DropdownMenuItem(value: "DUSTY_AREAS", child: Text("مناطق الغبار")),
                         DropdownMenuItem(value: "HEIGHTS", child: Text("العمل على مرتفعات")),
                         DropdownMenuItem(value: "NOISY_AREAS", child: Text("مناطق الضجيج")),
                       ],
                       onChanged: (val) => selectedMandatoryZone = val,
                     ),
                     SwitchListTile(
                       title: const Text("عهدة مستردة (Returnable)"),
                       subtitle: const Text("يجب إعادتها عند التلف أو ترك العمل"),
                       value: isReturnableAsset,
                       activeColor: Colors.teal,
                       onChanged: (val) => setStateDialog(() => isReturnableAsset = val),
                     ),
                  ],

                  // --- (17) حقول العُهد المستلمة ---
                  if (isCustody) ...[
                     const SizedBox(height: 16),
                     const Text("تفاصيل العهدة والأصل (Asset Profile)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     SwitchListTile(
                       title: const Text("يتطلب رقم تسلسلي (Serial No)"),
                       subtitle: const Text("لتتبع الأصل بدقة"),
                       value: requiresSerial,
                       activeColor: Colors.teal,
                       onChanged: (val) => setStateDialog(() => requiresSerial = val),
                     ),
                     SwitchListTile(
                       title: const Text("عهدة مستردة (Returnable)"),
                       subtitle: const Text("يجب إعادتها عند ترك العمل"),
                       value: isCustodyReturnable,
                       activeColor: Colors.teal,
                       onChanged: (val) => setStateDialog(() => isCustodyReturnable = val),
                     ),
                     if (isCustodyReturnable)
                       SwitchListTile(
                         title: const Text("تتطلب فحص فني عند الإرجاع"),
                         value: requiresCheck,
                         activeColor: Colors.teal,
                         onChanged: (val) => setStateDialog(() => requiresCheck = val),
                       ),
                     const SizedBox(height: 8),
                     TextField(
                       controller: estimatedValueController,
                       keyboardType: TextInputType.number,
                       decoration: const InputDecoration(labelText: "القيمة التقديرية (لغايات التأمين/الخصم)", suffixText: "د.أ"),
                     ),
                  ],

// --- (18) حقول المخالفات والجزاءات ---
                  if (isViolation) ...[
                     const SizedBox(height: 16),
                     const Text("لائحة الجزاءات (Disciplinary Rules)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     TextField(
                       controller: penaltyValueController,
                       decoration: const InputDecoration(labelText: "قيمة الجزاء المالي", hintText: "0.25 (ربع يوم) أو مبلغ"),
                     ),
                     const SizedBox(height: 8),
                     SwitchListTile(
                       title: const Text("تدرج العقوبة (Progressive)"),
                       subtitle: const Text("تتضاعف مع التكرار (أول مرة إنذار، ثم خصم...)"),
                       value: isProgressive,
                       activeColor: Colors.teal,
                       onChanged: (val) => setStateDialog(() => isProgressive = val),
                     ),
                     if (isProgressive)
                       Padding(
                         padding: const EdgeInsets.only(bottom: 8.0),
                         child: TextField(
                           controller: resetDaysController,
                           keyboardType: TextInputType.number,
                           decoration: const InputDecoration(labelText: "مدة تقادم المخالفة (يوم)", hintText: "90 يوم"),
                         ),
                       ),
                     SwitchListTile(
                       title: const Text("تتطلب تحقيق إداري"),
                       value: requiresInvestigation,
                       activeColor: Colors.teal,
                       onChanged: (val) => setStateDialog(() => requiresInvestigation = val),
                     ),
                  ],


                  // --- (19) حقول معايير التقييم ---
                  if (isEval) ...[
                     const SizedBox(height: 16),
                     const Text("إعدادات معيار الأداء (KPI Setup)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 8),
                     TextField(
                       controller: weightController,
                       keyboardType: TextInputType.number,
                       decoration: const InputDecoration(labelText: "الوزن النسبي (%)", hintText: "مثلاً: 20"),
                     ),
                     const SizedBox(height: 8),
                     DropdownButtonFormField<String>(
                       value: selectedTargetRole,
                       decoration: const InputDecoration(labelText: "الفئة المستهدفة", border: OutlineInputBorder()),
                       items: const [
                         DropdownMenuItem(value: "ALL", child: Text("عام (الجميع)")),
                         DropdownMenuItem(value: "WORKER", child: Text("الإنتاج والعمال")),
                         DropdownMenuItem(value: "DRIVER", child: Text("اللوجستيك والسائقين")),
                         DropdownMenuItem(value: "SALES", child: Text("المبيعات")),
                         DropdownMenuItem(value: "MANAGER", child: Text("الإدارة والإشراف")),
                       ],
                       onChanged: (val) => selectedTargetRole = val,
                     ),
                     const SizedBox(height: 8),
                     DropdownButtonFormField<String>(
                       value: selectedLinkedKPI,
                       decoration: const InputDecoration(labelText: "ربط بمؤشر أداء تلقائي (KPI Link)", border: OutlineInputBorder()),
                       items: const [
                         DropdownMenuItem(value: "NONE", child: Text("لا يوجد (تقييم يدوي)")),
                         DropdownMenuItem(value: "ATTENDANCE_RATE", child: Text("نسبة الحضور")),
                         DropdownMenuItem(value: "PRODUCTION_VOLUME", child: Text("حجم الإنتاج")),
                         DropdownMenuItem(value: "SALES_AMOUNT", child: Text("قيمة المبيعات")),
                         DropdownMenuItem(value: "SAFETY_VIOLATIONS", child: Text("مخالفات السلامة")),
                         DropdownMenuItem(value: "REJECT_RATE", child: Text("نسبة المرفوضات (Quality)")),
                       ],
                       onChanged: (val) => selectedLinkedKPI = val,
                     ),
                  ],



                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("إلغاء")),
              ElevatedButton(
                onPressed: () {
                  // --- منطق الحفظ (Save Logic) ---
                  Map<String, dynamic> newMetaData = item?.metaData != null ? Map.from(item!.metaData!) : {};

// حفظ الدوائر
                    if (isDept) {
                       if (selectedDeptType != null) newMetaData['type'] = selectedDeptType;
                       newMetaData['costCenter'] = costCenterController.text;
                       newMetaData['manager'] = managerNameController.text;
                       newMetaData['budget'] = budgetController.text;
                    }

                    // حفظ الأقسام
                    if (isSection) {
                       newMetaData['head'] = sectionHeadController.text;
                       newMetaData['count'] = headcountController.text;
                       if (selectedSectionType != null) newMetaData['type'] = selectedSectionType;
                    }

                    // حفظ الوحدات
                    if (isUnit) {
                       newMetaData['foreman'] = foremanController.text;
                       newMetaData['capacity'] = capacityController.text;
                       if (selectedUnitType != null) newMetaData['type'] = selectedUnitType;
                    }

                  // حفظ المكافآت (جديد)
                  if (isReward) {
                      if (selectedRewardType != null) newMetaData['type'] = selectedRewardType;
                      if (selectedKPIType != null) newMetaData['kpi'] = selectedKPIType;
                      if (rewardBasisController.text.isNotEmpty) newMetaData['basis'] = rewardBasisController.text;
                      newMetaData['taxable'] = isRewardTaxable;
                  }
                  
                  // حفظ الوثائق
                if (isDoc) {
                   newMetaData['expiry'] = hasExpiryDate;
                   if (hasExpiryDate && alertDaysController.text.isNotEmpty) {
                     newMetaData['alert'] = alertDaysController.text;
                   }
                   newMetaData['mandatory'] = isDocMandatory;
                   newMetaData['upload'] = requiresUpload;
                }

                // حفظ التأشيرات
                    if (isVisa) {
                       newMetaData['duration'] = visaDurationController.text;
                       newMetaData['cost'] = visaCostController.text;
                       newMetaData['medical'] = medicalCheckRequired;
                       newMetaData['guarantee'] = bankGuaranteeRequired;
                    }

                    // حفظ المهارات
                    if (isSkill) {
                       if (selectedSkillCategory != null) newMetaData['cat'] = selectedSkillCategory;
                       newMetaData['cert'] = isCertRequired;
                       newMetaData['renewal'] = renewalYearsController.text;
                    }
// حفظ أدوات السلامة
                    if (isPPE) {
                       newMetaData['lifespan'] = lifespanController.text;
                       if (selectedMandatoryZone != null) newMetaData['zone'] = selectedMandatoryZone;
                       newMetaData['returnable'] = isReturnableAsset;
                    }

// حفظ العُهد
                    if (isCustody) {
                       newMetaData['serial'] = requiresSerial;
                       newMetaData['returnable'] = isCustodyReturnable;
                       newMetaData['check'] = requiresCheck;
                       newMetaData['value'] = estimatedValueController.text;
                    }

// حفظ المخالفات
                    if (isViolation) {
                       newMetaData['penalty'] = penaltyValueController.text;
                       newMetaData['progressive'] = isProgressive;
                       if (isProgressive) newMetaData['reset'] = resetDaysController.text;
                       newMetaData['investigation'] = requiresInvestigation;
                    }

                    // حفظ التقييم
                    if (isEval) {
                       newMetaData['weight'] = weightController.text;
                       if (selectedTargetRole != null) newMetaData['role'] = selectedTargetRole;
                       if (selectedLinkedKPI != null) newMetaData['kpi'] = selectedLinkedKPI;
                    }


                  // حفظ باقي البيانات
                  if (isPayment) {
                     newMetaData['requireAccount'] = requiresAccount;
                     if (bankCodeController.text.isNotEmpty) newMetaData['bankCode'] = bankCodeController.text;
                     if (defaultCurrency != null) newMetaData['currency'] = defaultCurrency;
                  }
                  if (isDeduction) {
                     if (selectedDeductionType != null) newMetaData['type'] = selectedDeductionType;
                     newMetaData['maxLimit'] = maxDeductionController.text;
                     newMetaData['glAccount'] = glAccountController.text;
                     newMetaData['auto'] = isSystemAuto;
                  }
                  if (isAllowance) {
                     if (selectedAllowanceType != null) newMetaData['type'] = selectedAllowanceType;
                     if (selectedAllowanceFreq != null) newMetaData['freq'] = selectedAllowanceFreq;
                     newMetaData['taxable'] = isTaxable;
                     newMetaData['linked'] = isAttendanceLinked;
                  }
                  if (isAttendance) {
                     if (selectedPayrollImpact != null) newMetaData['impact'] = selectedPayrollImpact;
                     newMetaData['factor'] = multiplierController.text;
                     newMetaData['approval'] = approvalRequired;
                  }
                  if (isLeave) {
                     newMetaData['paid'] = isPaidLeave;
                     newMetaData['deduct'] = deductFromBalance;
                     newMetaData['attachment'] = requiresAttachment;
                     newMetaData['maxDays'] = maxDaysController.text;
                  }
                  if (isShift) {
                     newMetaData['start'] = startTimeController.text;
                     newMetaData['end'] = endTimeController.text;
                     newMetaData['break'] = breakDurationController.text;
                     newMetaData['grace'] = gracePeriodController.text;
                     newMetaData['night'] = isNightShift;
                  }
                  if (isTermination) {
                     newMetaData['severance'] = isSeverancePayable;
                     newMetaData['assets'] = requireAssetReturn;
                     newMetaData['rehire'] = isRehireEligible;
                     newMetaData['noticeReq'] = requiresNotice;
                  }
                  if (isContract) {
                     if (selectedPaymentBasis != null) newMetaData['basis'] = selectedPaymentBasis;
                     newMetaData['probation'] = probationController.text;
                     newMetaData['notice'] = noticePeriodController.text;
                     newMetaData['socialSecurity'] = hasSocialSecurity;
                     newMetaData['paidLeave'] = hasPaidLeave;
                  }
                  if (isJobLevel) {
                     newMetaData['minSalary'] = minSalaryController.text;
                     newMetaData['maxSalary'] = maxSalaryController.text;
                     newMetaData['leaveDays'] = leaveDaysController.text;
                     newMetaData['overtime'] = isOvertimeEligible;
                  }
                  if (isJobTitle) {
                     if (selectedJobLevel != null) newMetaData['jobLevel'] = selectedJobLevel;
                     if (selectedRiskLevel != null) newMetaData['riskLevel'] = selectedRiskLevel;
                     newMetaData['isManager'] = isManagerial;
                  }
                  if (needsParentLink && selectedParentId != null) newMetaData['parentId'] = selectedParentId;
                  if (isTask) {
                     newMetaData['role'] = roleController.text;
                     newMetaData['freq'] = freqController.text;
                     newMetaData['target'] = int.tryParse(targetController.text) ?? 1;
                     newMetaData['unit'] = unitController.text;
                  }
                  if (isLocation) {
                     if (selectedLocationType != null) newMetaData['type'] = selectedLocationType;
                     newMetaData['address'] = addressController.text;
                     newMetaData['manager'] = managerController.text;
                  }

                  final newItem = LookupItem(
                    id: isEdit ? item!.id : DateTime.now().toString(),
                    name: nameController.text,
                    code: codeController.text,
                    metaData: newMetaData,
                    isActive: isEdit ? item!.isActive : true,
                    color: isEdit ? item!.color : null,
                    icon: isEdit ? item!.icon : null,
                  );
                  
                  onSave(newItem); 
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00897B)),
                child: const Text("حفظ"),
              ),
            ],
          );
        }
      ),
    );
  }

  // --- نافذة إضافة قائمة جديدة ---
  static Future<void> showAddNewCategoryDialog(BuildContext context, Function(String, IconData) onAdd) async {
    final titleController = TextEditingController();
    IconData selectedIcon = Icons.list;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("إنشاء قائمة جديدة"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: "اسم القائمة")),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  children: [Icons.settings, Icons.person, Icons.work, Icons.attach_money, Icons.schedule, Icons.location_on].map((icon) {
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedIcon = icon),
                      child: Icon(icon, color: selectedIcon == icon ? Colors.teal : Colors.grey),
                    );
                  }).toList(),
                )
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("إلغاء")),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    onAdd(titleController.text, selectedIcon);
                    Navigator.pop(ctx);
                  }
                },
                child: const Text("إنشاء"),
              ),
            ],
          );
        }
      ),
    );
  }

  // --- نافذة الحذف ---
  static Future<void> showDeleteDialog(BuildContext context, String title, VoidCallback onConfirm) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: Text("هل أنت متأكد من حذف '$title'؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("حذف"),
          ),
        ],
      ),
    );
  }
}