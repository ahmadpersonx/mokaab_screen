// FileName: lib/features/system_config/screens/dynamic_category_builder_screen.dart
import 'package:flutter/material.dart';

// أنواع البيانات المتاحة للحقول
enum FieldDataType { text, number, date, boolean, selection }

// نموذج لتعريف الحقل الواحد
class FieldDefinition {
  String name;
  String key; // سيتم توليده تلقائياً بالإنجليزية
  FieldDataType type;
  bool isRequired;

  FieldDefinition({
    this.name = '',
    this.key = '',
    this.type = FieldDataType.text,
    this.isRequired = false,
  });
}

class DynamicCategoryBuilderScreen extends StatefulWidget {
  const DynamicCategoryBuilderScreen({super.key});

  @override
  State<DynamicCategoryBuilderScreen> createState() => _DynamicCategoryBuilderScreenState();
}

class _DynamicCategoryBuilderScreenState extends State<DynamicCategoryBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // بيانات القائمة الجديدة
  String _categoryName = '';
  String _categoryCode = '';
  
  // قائمة الحقول الديناميكية
  final List<FieldDefinition> _fields = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("تعريف قائمة جديدة (Custom List)"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // --- القسم 1: معلومات القائمة الأساسية ---
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("1. بيانات القائمة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "اسم القائمة (مثلاً: سجل الزوار)",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.list_alt),
                          ),
                          validator: (val) => val!.isEmpty ? "مطلوب" : null,
                          onSaved: (val) => _categoryName = val!,
                          onChanged: (val) {
                            // توليد كود تلقائي بسيط
                            setState(() {
                              _categoryCode = "CUST-${val.split(' ').first.toUpperCase()}";
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "الكود المرجعي",
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color(0xFFEEEEEE),
                          ),
                          readOnly: true,
                          controller: TextEditingController(text: _categoryCode),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- القسم 2: منشئ الحقول (Fields Builder) ---
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("2. هيكلية البيانات (الحقول)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo)),
                        ElevatedButton.icon(
                          onPressed: _addNewField,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("إضافة حقل"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    
                    // قائمة الحقول المضافة
                    Expanded(
                      child: _fields.isEmpty
                          ? _buildEmptyState()
                          : ListView.separated(
                              itemCount: _fields.length,
                              separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                return _buildFieldRow(index);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2))]),
        child: ElevatedButton(
          onPressed: _saveCategory,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: const Text("حفظ وبناء القائمة"),
        ),
      ),
    );
  }

  // --- بناء صف الحقل الواحد ---
  Widget _buildFieldRow(int index) {
    final field = _fields[index];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رقم الحقل
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey[400],
            child: Text("${index + 1}", style: const TextStyle(fontSize: 12, color: Colors.white)),
          ),
          const SizedBox(width: 12),
          
          // اسم الحقل
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: field.name,
                  decoration: const InputDecoration(
                    labelText: "اسم الحقل",
                    hintText: "مثلاً: تاريخ الوصول",
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    field.name = val;
                    field.key = "fld_${val.hashCode}"; // توليد مفتاح للحفظ
                  },
                  validator: (val) => val!.isEmpty ? "مطلوب" : null,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: field.isRequired, 
                      onChanged: (val) => setState(() => field.isRequired = val!),
                      visualDensity: VisualDensity.compact,
                    ),
                    const Text("حقل إجباري", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // نوع البيانات
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<FieldDataType>(
              value: field.type,
              decoration: const InputDecoration(
                labelText: "نوع البيانات",
                isDense: true,
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: FieldDataType.text, child: Row(children: [Icon(Icons.text_fields, size: 16, color: Colors.blue), SizedBox(width: 8), Text("نص")])),
                DropdownMenuItem(value: FieldDataType.number, child: Row(children: [Icon(Icons.onetwothree, size: 16, color: Colors.orange), SizedBox(width: 8), Text("رقم")])),
                DropdownMenuItem(value: FieldDataType.date, child: Row(children: [Icon(Icons.calendar_today, size: 16, color: Colors.purple), SizedBox(width: 8), Text("تاريخ")])),
                DropdownMenuItem(value: FieldDataType.boolean, child: Row(children: [Icon(Icons.toggle_on, size: 16, color: Colors.green), SizedBox(width: 8), Text("نعم/لا")])),
              ],
              onChanged: (val) => setState(() => field.type = val!),
            ),
          ),
          
          // زر الحذف
          IconButton(
            onPressed: () => setState(() => _fields.removeAt(index)),
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: "حذف الحقل",
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.playlist_add, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("لا توجد حقول مضافة بعد", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          const SizedBox(height: 8),
          const Text("اضغط على 'إضافة حقل' لبدء تصميم قائمتك", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  void _addNewField() {
    setState(() {
      _fields.add(FieldDefinition());
    });
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_fields.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يجب إضافة حقل واحد على الأقل"), backgroundColor: Colors.orange));
        return;
      }

      // --- هنا يتم حفظ الهيكلية في قاعدة البيانات ---
      // مثال على الهيكل الذي سيتم حفظه (JSON Structure)
      /*
      {
        "id": "CUST-VISITORS",
        "name": "سجل الزوار",
        "isSystem": false,
        "fields": [
          {"key": "fld_123", "label": "اسم الزائر", "type": "text", "required": true},
          {"key": "fld_456", "label": "وقت الدخول", "type": "date", "required": true},
          {"key": "fld_789", "label": "رقم الهوية", "type": "number", "required": false}
        ]
      }
      */

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إنشاء القائمة الجديدة بنجاح!"), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }
}