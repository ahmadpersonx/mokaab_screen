// FileName: lib/features/system_config/screens/lookups_management_screen.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';

// --- الاستيرادات الجديدة ---
import 'widgets/lookup_utils.dart';       // استيراد التعريفات من هنا
import 'widgets/lookup_dialogs.dart';     // استيراد الديالوج
import 'widgets/lookups_list_view.dart';  // استيراد الجدول

// [هام جداً]: تم حذف class CategoryDescriptor من هنا لمنع التكرار

class LookupsManagementScreen extends StatefulWidget {
  const LookupsManagementScreen({super.key});

  @override
  State<LookupsManagementScreen> createState() => _LookupsManagementScreenState();
}

class _LookupsManagementScreenState extends State<LookupsManagementScreen> {
  late CategoryDescriptor selectedCategory; // الآن يستخدم الكلاس من lookup_utils
  List<CategoryDescriptor> displayCategories = [];
  Map<String, List<LookupItem>> customDataStore = {};

  @override
  void initState() {
    super.initState();
    _initializeCategories();
  }

  void _initializeCategories() {
    final systemMap = {
      LookupCategory.departments: "الدوائر والإدارات",
      LookupCategory.sections: "الأقسام الفنية والإدارية",
      LookupCategory.units: "الوحدات التنظيمية والورش",
      LookupCategory.locations: "مواقع العمل والفروع",
      LookupCategory.jobTitles: "المسميات الوظيفية",
      LookupCategory.jobLevels: "الدرجات والسلم الوظيفي",
      LookupCategory.contractTypes: "أنواع العقود",
      LookupCategory.terminationReasons: "أسباب إنهاء الخدمة",
      LookupCategory.shifts: "ورديات العمل",
      LookupCategory.leaveTypes: "أنواع الإجازات",
      LookupCategory.attendanceStatus: "حالات الحضور والغياب",
      LookupCategory.allowanceTypes: "أنواع البدلات والإضافي",
      LookupCategory.deductionTypes: "أنواع الخصومات والاقتطاع",
      LookupCategory.paymentMethods: "طرق دفع الرواتب",
      LookupCategory.rewardTypes: "أنواع المكافآت والحوافز",
      LookupCategory.documentTypes: "أنواع الوثائق والمستندات",
      LookupCategory.visaTypes: "تأشيرات العمل والإقامات",
      LookupCategory.skillTypes: "المهارات والكفاءات الفنية",
      LookupCategory.safetyTools: "أدوات السلامة (PPE)",
      LookupCategory.custodyTypes: "أنواع العُهد المستلمة",
      LookupCategory.violationTypes: "لائحة المخالفات والجزاءات",
      LookupCategory.evaluationCriteria: "معايير التقييم السنوي",
      LookupCategory.standardTasks: "بنك المهام القياسية (SOPs)",
    };

    displayCategories = systemMap.entries.map((e) {
      return CategoryDescriptor(
        id: e.key.toString(),
        title: e.value,
        icon: getSystemIcon(e.key), // استخدام الدالة من lookup_utils
        isSystem: true,
        systemEnum: e.key,
      );
    }).toList();

    selectedCategory = displayCategories.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("إعدادات النظام والقوائم"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildBrandingHeader(),
          Expanded(
            child: Row(
              children: [
                // 1. القائمة الجانبية
                SizedBox(
                  width: 280,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: displayCategories.length,
                            separatorBuilder: (ctx, i) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final cat = displayCategories[index];
                              final isSelected = cat.id == selectedCategory.id;
                              return ListTile(
                                title: Text(cat.title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.teal : Colors.black87, fontSize: 13)),
                                leading: Icon(cat.icon, color: isSelected ? Colors.teal : Colors.grey, size: 20),
                                selected: isSelected,
                                selectedTileColor: Colors.teal.withOpacity(0.05),
                                onTap: () => setState(() => selectedCategory = cat),
                                trailing: !cat.isSystem 
                                  ? IconButton(
                                      icon: const Icon(Icons.close, size: 14, color: Colors.red),
                                      onPressed: () => LookupDialogs.showDeleteDialog(context, cat.title, () {
                                         setState(() {
                                           displayCategories.remove(cat);
                                           customDataStore.remove(cat.id);
                                           if (selectedCategory.id == cat.id) selectedCategory = displayCategories.first;
                                         });
                                      }),
                                    )
                                  : null,
                              );
                            },
                          ),
                        ),
                        // زر إضافة قائمة
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
                          child: ElevatedButton.icon(
                            onPressed: () => LookupDialogs.showAddNewCategoryDialog(context, (title, icon) {
                               setState(() {
                                 final newId = "CUST-${DateTime.now().millisecondsSinceEpoch}";
                                 final newCategory = CategoryDescriptor(id: newId, title: title, icon: icon, isSystem: false);
                                 displayCategories.add(newCategory);
                                 customDataStore[newId] = [];
                                 selectedCategory = newCategory;
                               });
                            }),
                            icon: const Icon(Icons.playlist_add),
                            label: const Text("إنشاء قائمة جديدة"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, minimumSize: const Size(double.infinity, 45)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(width: 1),
                
                // 2. المحتوى الرئيسي
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderSection(),
                        const SizedBox(height: 16),
                        Expanded(
                          // استخدام الـ Widget المفصول
                          child: LookupsListView(
                            items: _getCurrentItems(),
                            selectedCategory: selectedCategory,
                            onEdit: (item) => _openAddEditDialog(item: item),
                            onDelete: (item) => _deleteItem(item),
                            onStatusChange: (item, val) => setState(() => item.isActive = val),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandingHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("شركة مكعب للحجر الصناعي", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          Text("لملفات المحاكة والمخططات - لوحة التحكم", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(selectedCategory.icon, size: 28, color: Colors.black87),
                const SizedBox(width: 8),
                Text(selectedCategory.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            Text(
              selectedCategory.isSystem ? "قائمة نظام أساسية (System Defined)" : "قائمة مخصصة (User Defined)",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _openAddEditDialog(),
          icon: const Icon(Icons.add),
          label: const Text("إضافة عنصر للقائمة"),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00897B), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
        ),
      ],
    );
  }

  List<LookupItem> _getCurrentItems() {
    if (selectedCategory.isSystem && selectedCategory.systemEnum != null) {
      return masterLookups[selectedCategory.systemEnum] ?? [];
    } else {
      return customDataStore[selectedCategory.id] ?? [];
    }
  }

  void _openAddEditDialog({LookupItem? item}) {
    // استخدام دالة الديالوج من الملف المفصول
    LookupDialogs.showAddEditItemDialog(context, selectedCategory, (newItem) {
      setState(() {
        if (selectedCategory.isSystem) {
          final list = masterLookups[selectedCategory.systemEnum]!;
          if (item != null) {
            final index = list.indexOf(item);
            if (index != -1) list[index] = newItem;
          } else {
            list.add(newItem);
          }
        } else {
          final list = customDataStore[selectedCategory.id]!;
          if (item != null) {
            final index = list.indexOf(item);
            if (index != -1) list[index] = newItem;
          } else {
            list.add(newItem);
          }
        }
      });
    }, item: item);
  }

  void _deleteItem(LookupItem item) {
    setState(() {
       if (selectedCategory.isSystem) {
         masterLookups[selectedCategory.systemEnum]?.remove(item);
       } else {
         customDataStore[selectedCategory.id]?.remove(item);
       }
    });
  }
}