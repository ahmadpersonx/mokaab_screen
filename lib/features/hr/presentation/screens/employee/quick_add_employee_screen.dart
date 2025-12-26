// FileName: lib/features/hr/presentation/screens/employee/quick_add_employee_screen.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';

class QuickAddEmployeeScreen extends StatefulWidget {
  const QuickAddEmployeeScreen({super.key});

  @override
  State<QuickAddEmployeeScreen> createState() => _QuickAddEmployeeScreenState();
}

class _QuickAddEmployeeScreenState extends State<QuickAddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // متغيرات لحفظ البيانات
  String? fullNameAr;
  String? fullNameEn;
  String? nationalId;
  String? mobile;
  String? gender = 'Male';
  String? jobTitleId; // اختياري لتسهيل البحث
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("فتح ملف موظف جديد"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. البيانات الأساسية ---
              _buildSectionTitle("البيانات الأساسية", Icons.person),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: "الاسم الكامل (عربي) *", border: OutlineInputBorder()),
                              validator: (val) => val == null || val.isEmpty ? "مطلوب" : null,
                              onSaved: (val) => fullNameAr = val,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: "الاسم الكامل (إنجليزي)", border: OutlineInputBorder()),
                              onSaved: (val) => fullNameEn = val,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: "الرقم الوطني / الإقامة *", border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (val) => val == null || val.isEmpty ? "مطلوب" : null,
                              onSaved: (val) => nationalId = val,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(labelText: "الجنس", border: OutlineInputBorder()),
                              value: gender,
                              items: const [
                                DropdownMenuItem(value: "Male", child: Text("ذكر")),
                                DropdownMenuItem(value: "Female", child: Text("أنثى")),
                              ],
                              onChanged: (val) => setState(() => gender = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // اختيار المسمى الوظيفي المقترح (اختياري)
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "المسمى الوظيفي المقترح", border: OutlineInputBorder()),
                        items: (masterLookups[LookupCategory.jobTitles] ?? [])
                            .map((e) => DropdownMenuItem(value: e.id, child: Text(e.name)))
                            .toList(),
                        onChanged: (val) => jobTitleId = val,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- 2. معلومات الاتصال ---
              _buildSectionTitle("معلومات الاتصال", Icons.phone),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "رقم الهاتف *", border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone_android)),
                          keyboardType: TextInputType.phone,
                          validator: (val) => val == null || val.isEmpty ? "مطلوب" : null,
                          onSaved: (val) => mobile = val,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "البريد الإلكتروني", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email_outlined)),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- 3. جهة اتصال الطوارئ ---
              _buildSectionTitle("حالات الطوارئ", Icons.emergency),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "اسم القريب", border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "هاتف الطوارئ", border: OutlineInputBorder()),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // هنا يتم حفظ الموظف في قاعدة البيانات
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("تم فتح الملف بنجاح! سيظهر الآن في قائمة الموظفين مع تنبيه النواقص.")),
                      );
                      Navigator.pop(context); // العودة للقائمة
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("حفظ وفتح الملف", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[800], size: 20),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900])),
      ],
    );
  }
}