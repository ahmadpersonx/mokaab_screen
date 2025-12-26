// FileName: lib/features/system_config/screens/widgets/lookups_list_view.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';
import 'lookup_utils.dart';

class LookupsListView extends StatelessWidget {
  final List<LookupItem> items;
  final CategoryDescriptor selectedCategory;
  final Function(LookupItem) onEdit;
  final Function(LookupItem) onDelete;
  final Function(LookupItem, bool) onStatusChange;

  const LookupsListView({
    super.key,
    required this.items,
    required this.selectedCategory,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const Center(child: Text("لا توجد عناصر"));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
          columns: const [
            DataColumn(label: Text("الاسم", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("الكود", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("تفاصيل / ارتباط", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("الحالة", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("إجراءات", style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: items.map((item) {
            return DataRow(cells: [
              DataCell(Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500))),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(4)),
                  child: Text(item.code, style: const TextStyle(fontSize: 12, fontFamily: 'Courier')),
                ),
              ),
              DataCell(Text(_getDetailsText(item), style: TextStyle(fontSize: 11, color: Colors.grey[700]))),
              DataCell(Switch(
                value: item.isActive,
                activeColor: Colors.teal,
                onChanged: (val) => onStatusChange(item, val),
              )),
              DataCell(Row(
                children: [
                  IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), onPressed: () => onEdit(item)),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () => onDelete(item)),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  String _getDetailsText(LookupItem item) {

// 21. تفاصيل الدوائر
    if (selectedCategory.systemEnum == LookupCategory.departments) {
       final type = item.metaData?['type'] ?? 'GEN';
       final cc = item.metaData?['costCenter'] ?? '-';
       final mgr = item.metaData?['manager'] ?? '-';
       return "$type | CC: $cc | مدير: $mgr";
    }

    // 22. تفاصيل الأقسام (تحديث للشرط الموجود سابقاً)
    if (selectedCategory.systemEnum == LookupCategory.sections) {
       // جلب اسم الدائرة الأب
       String parentName = "-";
       if (item.metaData != null && item.metaData!.containsKey('parentId')) {
          final parentId = item.metaData!['parentId'];
          final parent = masterLookups[LookupCategory.departments]?.firstWhere((e) => e.id == parentId, orElse: () => LookupItem(id: '', name: '', code: ''));
          if (parent != null) parentName = parent.name;
       }

       final head = item.metaData?['head'] ?? '-';
       final count = item.metaData?['count'] ?? '0';
       return "دائرة: $parentName | رئيس: $head (HC: $count)";
    }


// 23. تفاصيل الوحدات (تحديث للشرط الموجود سابقاً)
    if (selectedCategory.systemEnum == LookupCategory.units) {
       // جلب اسم القسم الأب
       String parentName = "-";
       if (item.metaData != null && item.metaData!.containsKey('parentId')) {
          final parentId = item.metaData!['parentId'];
          final parent = masterLookups[LookupCategory.sections]?.firstWhere((e) => e.id == parentId, orElse: () => LookupItem(id: '', name: '', code: ''));
          if (parent != null) parentName = parent.name;
       }

       final foreman = item.metaData?['foreman'] ?? '-';
       final cap = item.metaData?['capacity'] ?? '-';
       return "قسم: $parentName | مشرف: $foreman ($cap)";
    }
    
    // 1. المكافآت (جديد)
    if (selectedCategory.systemEnum == LookupCategory.rewardTypes) {
       final type = item.metaData?['type'] ?? 'CASH';
       final kpi = item.metaData?['kpi'] ?? 'General';
       return "$type | KPI: $kpi";
    }
    // 2. الدفع
    if (selectedCategory.systemEnum == LookupCategory.paymentMethods) {
       final req = item.metaData?['requireAccount'] == true ? "يحتاج حساب" : "لا";
       return req;
    }
    // 3. الخصومات
    if (selectedCategory.systemEnum == LookupCategory.deductionTypes) {
       final type = item.metaData?['type'] == 'PERCENT' ? '%' : 'ثابت';
       return type;
    }
    // 4. البدلات
    if (selectedCategory.systemEnum == LookupCategory.allowanceTypes) {
       final type = item.metaData?['type'] == 'PERCENT' ? '%' : 'ثابت';
       return type;
    }
    // 5. الحضور
    if (selectedCategory.systemEnum == LookupCategory.attendanceStatus) {
       return item.metaData?['impact'] ?? '-';
    }
    // 6. الإجازات
    if (selectedCategory.systemEnum == LookupCategory.leaveTypes) {
       return item.metaData?['paid'] == true ? "مدفوعة" : "غير مدفوعة";
    }
    // 7. الورديات
    if (selectedCategory.systemEnum == LookupCategory.shifts) {
       return "${item.metaData?['start']} - ${item.metaData?['end']}";
    }
    // 8. الإنهاء
    if (selectedCategory.systemEnum == LookupCategory.terminationReasons) {
       return item.metaData?['severance'] == true ? "مستحقات" : "لا";
    }
    // 9. العقود
    if (selectedCategory.systemEnum == LookupCategory.contractTypes) {
       return "الأساس: ${item.metaData?['basis']}";
    }
    // 10. الدرجات
    if (selectedCategory.systemEnum == LookupCategory.jobLevels) {
       return "${item.metaData?['minSalary']}-${item.metaData?['maxSalary']}";
    }
    // 11. الوظائف
    if (selectedCategory.systemEnum == LookupCategory.jobTitles) {
       return "مخاطر: ${item.metaData?['riskLevel']}";
    }
    // 12. الارتباط الهيكلي
    if (item.metaData != null && item.metaData!.containsKey('parentId')) {
       final parentId = item.metaData!['parentId'];
       if (selectedCategory.systemEnum == LookupCategory.sections) {
         final parent = masterLookups[LookupCategory.departments]?.firstWhere((e) => e.id == parentId, orElse: () => LookupItem(id: '', name: '', code: ''));
         if (parent != null) return "دائرة: ${parent.name}";
       }
       if (selectedCategory.systemEnum == LookupCategory.units) {
         final parent = masterLookups[LookupCategory.sections]?.firstWhere((e) => e.id == parentId, orElse: () => LookupItem(id: '', name: '', code: ''));
         if (parent != null) return "قسم: ${parent.name}";
       }
    }
    // 13. المهام والمواقع
    if (selectedCategory.systemEnum == LookupCategory.standardTasks) return "مسؤول: ${item.metaData?['role']}";
    if (selectedCategory.systemEnum == LookupCategory.locations) return item.metaData?['type'] ?? '-';

// 13. تفاصيل الوثائق (جديد)
    if (selectedCategory.systemEnum == LookupCategory.documentTypes) {
       final expiry = item.metaData?['expiry'] == true ? "تجدد" : "دائمة";
       final mandat = item.metaData?['mandatory'] == true ? "إلزامية" : "اختيارية";
       final alert = item.metaData?['alert'] != null ? " | تنبيه: ${item.metaData!['alert']} يوم" : "";
       
       return "$mandat | $expiry$alert";
    }

// 14. تفاصيل التأشيرات
    if (selectedCategory.systemEnum == LookupCategory.visaTypes) {
       final dur = item.metaData?['duration'] ?? '-';
       final cost = item.metaData?['cost'] ?? '-';
       return "المدة: $dur شهر | التكلفة: $cost";
    }

// 15. تفاصيل المهارات
    if (selectedCategory.systemEnum == LookupCategory.skillTypes) {
       final cat = item.metaData?['cat'] ?? 'GEN';
       final cert = item.metaData?['cert'] == true ? "شهادة مطلوبة" : "";
       final renew = (item.metaData?['renewal'] != null && item.metaData!['renewal'] != "0") 
           ? " | تجدد كل ${item.metaData!['renewal']} سنة" 
           : "";
       return "$cat | $cert$renew";
    }

// 16. تفاصيل أدوات السلامة
    if (selectedCategory.systemEnum == LookupCategory.safetyTools) {
       final life = item.metaData?['lifespan'] ?? '-';
       final ret = item.metaData?['returnable'] == true ? "مستردة" : "استهلاكية";
       return "عمر: $life يوم | $ret";
    }


// 17. تفاصيل العُهد
    if (selectedCategory.systemEnum == LookupCategory.custodyTypes) {
       final serial = item.metaData?['serial'] == true ? "تسلسلي" : "كمية";
       final ret = item.metaData?['returnable'] == true ? "مستردة" : "استهلاك";
       final val = item.metaData?['value'] ?? '0';
       return "$serial | $ret | القيمة: $val";
    }

// 18. تفاصيل المخالفات
    if (selectedCategory.systemEnum == LookupCategory.violationTypes) {
       final pen = item.metaData?['penalty'] ?? '-';
       final prog = item.metaData?['progressive'] == true ? "(تدرج)" : "(ثابت)";
       return "جزاء: $pen $prog";
    }

// 19. تفاصيل التقييم
    if (selectedCategory.systemEnum == LookupCategory.evaluationCriteria) {
       final weight = item.metaData?['weight'] ?? '0';
       final role = item.metaData?['role'] ?? 'All';
       final kpi = item.metaData?['kpi'] != 'NONE' && item.metaData?['kpi'] != null 
           ? " | آلي: ${item.metaData!['kpi']}" 
           : " | يدوي";
       return "الوزن: $weight% | $role$kpi";
    }




    return "-";
  }



}