// FileName: lib/features/hr/attendance/screens/attendance_dashboard_screen.dart
// Description: لوحة متابعة الدوام (مع خيارات: بصمة، إكسل، يدوي)
// Version: 1.2 (Added Excel Import)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

// --- نموذج سجل الدوام اليومي ---
class DailyAttendance {
  final String id;
  final String employeeName;
  final String jobTitle;
  final String shiftId;
  
  TimeOfDay? checkIn;
  TimeOfDay? checkOut;
  String status; // Present, Absent, Late, Leave
  
  int delayMinutes;
  int overtimeMinutes;
  
  String? adjustmentNote;
  bool isManual; // هل تم التعديل يدوياً؟
  String source; // Fingerprint, Excel, Manual

  DailyAttendance({
    required this.id,
    required this.employeeName,
    required this.jobTitle,
    required this.shiftId,
    this.checkIn,
    this.checkOut,
    this.status = 'Absent',
    this.delayMinutes = 0,
    this.overtimeMinutes = 0,
    this.adjustmentNote,
    this.isManual = false,
    this.source = 'System', // المصدر الافتراضي
  });
}

class AttendanceDashboardScreen extends StatefulWidget {
  const AttendanceDashboardScreen({super.key});

  @override
  State<AttendanceDashboardScreen> createState() => _AttendanceDashboardScreenState();
}

class _AttendanceDashboardScreenState extends State<AttendanceDashboardScreen> {
  DateTime _selectedDate = DateTime.now();
  List<DailyAttendance> _records = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    setState(() {
      _records = [
        DailyAttendance(id: '1', employeeName: 'أحمد محمد', jobTitle: 'مشغل CNC', shiftId: 'SHIFT-A'),
        DailyAttendance(id: '2', employeeName: 'سالم علي', jobTitle: 'فني صيانة', shiftId: 'SHIFT-A'),
        DailyAttendance(id: '3', employeeName: 'محمود حسن', jobTitle: 'سائق', shiftId: 'SHIFT-A'),
        DailyAttendance(id: '4', employeeName: 'خالد يوسف', jobTitle: 'مدير إنتاج', shiftId: 'SHIFT-A'),
        DailyAttendance(id: '5', employeeName: 'رامي سعيد', jobTitle: 'عامل تغليف', shiftId: 'SHIFT-B'),
      ];
    });
  }

  // --- 1. محاكاة السحب من البصمة ---
  Future<void> _simulateDeviceSync() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    final random = Random();
    
    setState(() {
      for (var record in _records) {
        if (record.isManual || record.status == 'Leave') continue;
        
        // منطق عشوائي للبصمة
        bool isPresent = random.nextBool(); 
        if (isPresent) {
          int inHour = 7 + random.nextInt(2); 
          int inMinute = random.nextInt(59);
          record.checkIn = TimeOfDay(hour: inHour, minute: inMinute);
          record.status = 'Present';
          record.source = 'Fingerprint'; // تحديد المصدر

          // حساب التأخير
          if (inHour > 8 || (inHour == 8 && inMinute > 15)) {
             record.status = 'Late';
             record.delayMinutes = ((inHour - 8) * 60) + inMinute;
          }
        }
      }
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم سحب البيانات من أجهزة البصمة بنجاح"), backgroundColor: Colors.green));
  }

  // --- 2. محاكاة استيراد ملف Excel (الميزة الجديدة) ---
  Future<void> _importFromExcel() async {
    // هنا في التطبيق الحقيقي نفتح FilePicker
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // محاكاة قراءة الملف

    setState(() {
      // نفترض أن ملف الإكسل يحتوي على بيانات دقيقة لجميع الموظفين
      for (var record in _records) {
        // تحديث البيانات كأنها جاءت من شيت إكسل
        record.checkIn = const TimeOfDay(hour: 7, minute: 55); // الجميع حضر مبكراً حسب الملف
        record.checkOut = const TimeOfDay(hour: 16, minute: 05);
        record.status = 'Present';
        record.delayMinutes = 0;
        record.source = 'Excel Import'; // تحديد المصدر
      }
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم استيراد ملف (Attendance_Log.xlsx) بنجاح"), backgroundColor: Colors.teal));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("متابعة الدوام اليومي"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          if (_isLoading)
            const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          else
            PopupMenuButton<String>(
              icon: const Icon(Icons.cloud_download),
              tooltip: "خيارات استيراد البيانات",
              onSelected: (value) {
                if (value == 'DEVICE') _simulateDeviceSync();
                if (value == 'EXCEL') _importFromExcel();
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'DEVICE',
                  child: ListTile(
                    leading: Icon(Icons.fingerprint, color: Colors.indigo),
                    title: Text('سحب من البصمة (Live)'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'EXCEL',
                  child: ListTile(
                    leading: Icon(Icons.table_view, color: Colors.green),
                    title: Text('استيراد ملف Excel'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                  _loadInitialData();
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateHeader(),
          _buildSummaryCards(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                return _buildAttendanceCard(_records[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('EEEE, d MMMM yyyy', 'ar').format(_selectedDate), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Text("سجل الحركات اليومية", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.indigo[50], borderRadius: BorderRadius.circular(20)),
            child: Text("آخر تحديث: ${DateFormat('HH:mm').format(DateTime.now())}", style: TextStyle(color: Colors.indigo[800], fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    int present = _records.where((e) => e.status == 'Present' || e.status == 'Late').length;
    int late = _records.where((e) => e.status == 'Late').length;
    int absent = _records.where((e) => e.status == 'Absent').length;
    int leaves = _records.where((e) => e.status == 'Leave').length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _summaryItem("حضور", "$present", Colors.green, Icons.check_circle),
          const SizedBox(width: 10),
          _summaryItem("تأخير", "$late", Colors.orange, Icons.access_time),
          const SizedBox(width: 10),
          _summaryItem("غياب", "$absent", Colors.red, Icons.cancel),
          const SizedBox(width: 10),
          _summaryItem("إجازات", "$leaves", Colors.blue, Icons.beach_access),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)]),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(DailyAttendance record) {
    Color statusColor;
    String statusText;

    switch (record.status) {
      case 'Present': statusColor = Colors.green; statusText = 'حضور'; break;
      case 'Late': statusColor = Colors.orange; statusText = 'تأخير'; break;
      case 'Absent': statusColor = Colors.red; statusText = 'غياب'; break;
      case 'Leave': statusColor = Colors.blue; statusText = 'إجازة'; break;
      default: statusColor = Colors.grey; statusText = '-';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: Colors.grey[200], child: const Icon(Icons.person, color: Colors.grey)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(record.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(record.jobTitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: statusColor.withOpacity(0.5))),
                      child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    if (record.source != 'System' && record.status != 'Absent')
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text("المصدر: ${record.source}", style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                      )
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            
            if (record.status != 'Absent' && record.status != 'Leave')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _timeColumn("دخول", record.checkIn, Colors.green),
                  _timeColumn("خروج", record.checkOut, Colors.red),
                  
                  if (record.delayMinutes > 0)
                    _calcBadge("${record.delayMinutes} د", "تأخير", Colors.orange),
                  if (record.overtimeMinutes > 0)
                    _calcBadge("${(record.overtimeMinutes/60).toStringAsFixed(1)} س", "إضافي", Colors.blue),
                  
                  IconButton(
                    icon: const Icon(Icons.edit_note, color: Colors.indigo),
                    onPressed: () => _showManualAdjustmentDialog(record),
                  )
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    record.status == 'Absent' ? "لم يتم تسجيل أي بصمة" : "في إجازة رسمية",
                    style: const TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                  TextButton.icon(
                    onPressed: () => _showManualAdjustmentDialog(record),
                    icon: const Icon(Icons.touch_app, size: 16),
                    label: const Text("تسجيل يدوي"),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _timeColumn(String label, TimeOfDay? time, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(
          time != null ? time.format(context) : "--:--",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
        ),
      ],
    );
  }

  Widget _calcBadge(String val, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Text(val, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  void _showManualAdjustmentDialog(DailyAttendance record) {
    TimeOfDay? newIn = record.checkIn;
    TimeOfDay? newOut = record.checkOut;
    TextEditingController noteCtrl = TextEditingController(text: record.adjustmentNote);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("تعديل سجل الدوام (Manual)"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("وقت الدخول"),
                  trailing: Text(newIn?.format(context) ?? "--:--", style: const TextStyle(fontWeight: FontWeight.bold)),
                  leading: const Icon(Icons.login, color: Colors.green),
                  onTap: () async {
                    final t = await showTimePicker(context: context, initialTime: newIn ?? const TimeOfDay(hour: 8, minute: 0));
                    if (t != null) setDialogState(() => newIn = t);
                  },
                ),
                ListTile(
                  title: const Text("وقت الخروج"),
                  trailing: Text(newOut?.format(context) ?? "--:--", style: const TextStyle(fontWeight: FontWeight.bold)),
                  leading: const Icon(Icons.logout, color: Colors.red),
                  onTap: () async {
                    final t = await showTimePicker(context: context, initialTime: newOut ?? const TimeOfDay(hour: 17, minute: 0));
                    if (t != null) setDialogState(() => newOut = t);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: noteCtrl,
                  decoration: const InputDecoration(labelText: "سبب التعديل", border: OutlineInputBorder()),
                  maxLines: 2,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    record.checkIn = newIn;
                    record.checkOut = newOut;
                    record.adjustmentNote = noteCtrl.text;
                    record.isManual = true;
                    record.source = 'Manual Edit'; // تحديث المصدر
                    
                    if (newIn != null) {
                      record.status = 'Present';
                      double inDouble = newIn!.hour + newIn!.minute / 60.0;
                      if (inDouble > 8.25) { 
                        record.status = 'Late';
                        record.delayMinutes = ((inDouble - 8.0) * 60).toInt();
                      } else {
                        record.delayMinutes = 0;
                      }
                    }
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                child: const Text("حفظ"),
              ),
            ],
          );
        }
      ),
    );
  }
}