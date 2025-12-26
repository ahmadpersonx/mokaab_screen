// FileName: lib/features/hr/notifications/screens/send_memo_screen.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';

class SendMemoScreen extends StatefulWidget {
  const SendMemoScreen({super.key});

  @override
  State<SendMemoScreen> createState() => _SendMemoScreenState();
}

class _SendMemoScreenState extends State<SendMemoScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // خيارات الاستهداف
  String _targetAudience = 'ALL'; // ALL, DEPT, EMP
  String? _selectedDeptId;
  
  // محتوى الرسالة
  String _title = '';
  String _body = '';
  String _priority = 'Normal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("إرسال تعميم / تبليغ"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("1. الجمهور المستهدف (Target Audience)", Icons.people),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text("جميع الموظفين (All Employees)"),
                      value: 'ALL',
                      groupValue: _targetAudience,
                      onChanged: (val) => setState(() => _targetAudience = val!),
                    ),
                    RadioListTile<String>(
                      title: const Text("قسم محدد (Specific Department)"),
                      value: 'DEPT',
                      groupValue: _targetAudience,
                      onChanged: (val) => setState(() => _targetAudience = val!),
                    ),
                    
                    // إذا اختار قسم، نعرض القائمة المنسدلة
                    if (_targetAudience == 'DEPT')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: "اختر القسم", border: OutlineInputBorder()),
                          items: (masterLookups[LookupCategory.departments] ?? []).map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                          onChanged: (val) => _selectedDeptId = val,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("2. محتوى الرسالة", Icons.message),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: const InputDecoration(labelText: "الأهمية / الأولوية", border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: "Normal", child: Text("عادي (Normal)")),
                        DropdownMenuItem(value: "High", child: Text("هام (High)")),
                        DropdownMenuItem(value: "Critical", child: Text("عاجل جداً (Critical)")),
                      ],
                      onChanged: (val) => _priority = val!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "عنوان التعميم", border: OutlineInputBorder()),
                      validator: (val) => val!.isEmpty ? "مطلوب" : null,
                      onSaved: (val) => _title = val!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "نص الرسالة", border: OutlineInputBorder(), alignLabelWithHint: true),
                      maxLines: 5,
                      validator: (val) => val!.isEmpty ? "مطلوب" : null,
                      onSaved: (val) => _body = val!,
                    ),
                    const SizedBox(height: 16),
                    // زر إرفاق ملف (شكلي)
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file),
                      label: const Text("إرفاق ملف (PDF / صورة)"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _sendNotification,
                  icon: const Icon(Icons.send),
                  label: const Text("إرسال التبليغ الآن"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
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
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  void _sendNotification() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // هنا يتم استدعاء API الإرسال (Firebase Cloud Messaging مثلاً)
      // سنكتفي برسالة نجاح
      
      String targetText = _targetAudience == 'ALL' ? "لجميع الموظفين" : "للقسم المحدد";
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم إرسال التعميم ($targetText) بنجاح"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        )
      );
      
      Navigator.pop(context);
    }
  }
}