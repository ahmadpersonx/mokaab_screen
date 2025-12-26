// FileName: lib/features/hr/presentation/screens/employee/requests/request_forms.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';

// -----------------------------------------------------------------------------
// 1. شاشة طلب إجازة (Leave Request Form)
// -----------------------------------------------------------------------------
class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedLeaveTypeId;
  DateTime? _startDate;
  DateTime? _endDate;
  int _daysCount = 0;
  final TextEditingController _reasonController = TextEditingController();

  // حساب الفرق بالأيام
  void _calculateDuration() {
    if (_startDate != null && _endDate != null) {
      setState(() {
        _daysCount = _endDate!.difference(_startDate!).inDays + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // جلب أنواع الإجازات من القوائم
    final leaveTypes = masterLookups[LookupCategory.leaveTypes] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("تقديم طلب إجازة"), backgroundColor: Colors.purple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("نوع الإجازة", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.category)),
                items: leaveTypes.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                onChanged: (val) => setState(() => _selectedLeaveTypeId = val),
                validator: (val) => val == null ? "مطلوب" : null,
              ),
              
              const SizedBox(height: 20),
              
              // صف التواريخ
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2026));
                        if (d != null) {
                          setState(() {
                            _startDate = d;
                            // إعادة ضبط تاريخ النهاية إذا كان قبل البداية
                            if (_endDate != null && _endDate!.isBefore(d)) _endDate = null;
                            _calculateDuration();
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: "من تاريخ", border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
                        child: Text(_startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : "اختر"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final d = await showDatePicker(context: context, initialDate: _startDate ?? DateTime.now(), firstDate: _startDate ?? DateTime.now(), lastDate: DateTime(2026));
                        if (d != null) {
                          setState(() {
                            _endDate = d;
                            _calculateDuration();
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: "إلى تاريخ", border: OutlineInputBorder(), suffixIcon: Icon(Icons.event_busy)),
                        child: Text(_endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : "اختر"),
                      ),
                    ),
                  ),
                ],
              ),

              if (_daysCount > 0)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.purple[50], borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text("المدة المحسوبة: $_daysCount أيام", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: "السبب / الملاحظات", border: OutlineInputBorder(), alignLabelWithHint: true),
                maxLines: 3,
                validator: (val) => val!.isEmpty ? "يرجى ذكر السبب" : null,
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text("إرسال الطلب"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _startDate != null && _endDate != null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إرسال طلب الإجازة للمدير المباشر")));
                      Navigator.pop(context);
                    } else if (_startDate == null || _endDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يرجى تحديد التواريخ"), backgroundColor: Colors.red));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. شاشة طلب مغادرة (Hourly Permission Form)
// -----------------------------------------------------------------------------
class HourlyPermissionScreen extends StatefulWidget {
  const HourlyPermissionScreen({super.key});

  @override
  State<HourlyPermissionScreen> createState() => _HourlyPermissionScreenState();
}

class _HourlyPermissionScreenState extends State<HourlyPermissionScreen> {
  DateTime _date = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  
  // قائمة أنواع المغادرات (ثابتة أو من Lookups)
  final List<String> _types = ["ظرف شخصي", "مراجعة طبية", "عمل رسمي خارجي"];
  String? _selectedType;

  String get _durationText {
    if (_startTime == null || _endTime == null) return "--";
    final start = _startTime!.hour * 60 + _startTime!.minute;
    final end = _endTime!.hour * 60 + _endTime!.minute;
    final diff = end - start;
    if (diff <= 0) return "خطأ في التوقيت";
    final hours = diff ~/ 60;
    final minutes = diff % 60;
    return "$hours ساعة و $minutes دقيقة";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("طلب مغادرة (ساعات)"), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // التاريخ
            ListTile(
              title: const Text("تاريخ المغادرة"),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_date)),
              trailing: const Icon(Icons.calendar_today),
              shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime(2025));
                if (d != null) setState(() => _date = d);
              },
            ),
            const SizedBox(height: 16),

            // الأوقات
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (t != null) setState(() => _startTime = t);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: "وقت الخروج", border: OutlineInputBorder()),
                      child: Text(_startTime?.format(context) ?? "--:--"),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (t != null) setState(() => _endTime = t);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: "وقت العودة", border: OutlineInputBorder()),
                      child: Text(_endTime?.format(context) ?? "--:--"),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.orange[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text("المدة المطلوبة: $_durationText", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "نوع المغادرة", border: OutlineInputBorder()),
              items: _types.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => _selectedType = val,
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text("تقديم الطلب"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم تقديم طلب المغادرة")));
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. طلب وثيقة / شهادة (Document Request)
// -----------------------------------------------------------------------------
class DocumentRequestScreen extends StatefulWidget {
  const DocumentRequestScreen({super.key});

  @override
  State<DocumentRequestScreen> createState() => _DocumentRequestScreenState();
}

class _DocumentRequestScreenState extends State<DocumentRequestScreen> {
  String? _docType;
  String _lang = "Arabic";
  final TextEditingController _entityController = TextEditingController();

  final List<String> _docTypes = [
    "شهادة لمن يهمه الأمر (إثبات عمل)",
    "شهادة راتب (Salary Slip)",
    "كشف حساب بنكي (لغايات القروض)",
    "شهادة خبرة",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("طلب وثيقة / شهادة"), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "نوع الوثيقة المطلوبة", border: OutlineInputBorder(), prefixIcon: Icon(Icons.file_copy)),
              items: _docTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _docType = val),
            ),
            const SizedBox(height: 16),
            
            // خيار اللغة
            Row(
              children: [
                const Text("اللغة المطلوبة: ", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                ChoiceChip(label: const Text("عربي"), selected: _lang == "Arabic", onSelected: (v) => setState(() => _lang = "Arabic")),
                const SizedBox(width: 10),
                ChoiceChip(label: const Text("English"), selected: _lang == "English", onSelected: (v) => setState(() => _lang = "English")),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _entityController,
              decoration: const InputDecoration(
                labelText: "موجهة إلى (الجهة الطالبة)",
                hintText: "مثلاً: البنك العربي، السفارة الفرنسية...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(height: 10),
            const Text("ملاحظة: سيتم إصدار الوثيقة مختومة من الموارد البشرية خلال 24 ساعة.", style: TextStyle(color: Colors.grey, fontSize: 12)),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.print),
                label: const Text("إرسال الطلب"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم استلام طلب الوثيقة")));
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. مذكرة داخلية / شكوى (Internal Memo)
// -----------------------------------------------------------------------------
class InternalMemoScreen extends StatelessWidget {
  const InternalMemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("مذكرة داخلية / شكوى"), backgroundColor: Colors.redAccent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "التصنيف", border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: "Complaint", child: Text("شكوى / تظلم")),
                DropdownMenuItem(value: "Suggestion", child: Text("اقتراح تحسين")),
                DropdownMenuItem(value: "Report", child: Text("إبلاغ عن مخالفة")),
                DropdownMenuItem(value: "Other", child: Text("أخرى")),
              ],
              onChanged: (val) {},
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: "الموضوع (العنوان)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: "نص المذكرة / التفاصيل", border: OutlineInputBorder(), alignLabelWithHint: true),
              maxLines: 6,
            ),
            const SizedBox(height: 16),
            // خيار السرية
            CheckboxListTile(
              title: const Text("سرية للغاية (يطلع عليها المدير العام فقط)"),
              value: false,
              onChanged: (val) {},
              contentPadding: EdgeInsets.zero,
            ),
            
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock_clock), // أيقونة توحي بالجدية/السرية
                label: const Text("إرسال المذكرة"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إرسال المذكرة بنجاح")));
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
