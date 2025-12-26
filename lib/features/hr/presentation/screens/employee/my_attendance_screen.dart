// FileName: lib/features/hr/presentation/screens/employee/my_attendance_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// نموذج لحركة الدوام (خاص بالعرض)
class AttendanceRecord {
  final DateTime date;
  final String checkIn;
  final String checkOut;
  final String status; // Present, Late, Absent, Leave, Weekend
  final int delayMinutes;
  final int overtimeMinutes;

  AttendanceRecord({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    this.delayMinutes = 0,
    this.overtimeMinutes = 0,
  });
}

class MyAttendanceScreen extends StatefulWidget {
  const MyAttendanceScreen({super.key});

  @override
  State<MyAttendanceScreen> createState() => _MyAttendanceScreenState();
}

class _MyAttendanceScreenState extends State<MyAttendanceScreen> {
  DateTime _selectedMonth = DateTime.now();
  
  // بيانات وهمية (يجب جلبها من الـ API للموظف الحالي)
  final List<AttendanceRecord> _records = [
    AttendanceRecord(date: DateTime.now(), checkIn: "07:55", checkOut: "16:05", status: "Present"),
    AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 1)), checkIn: "08:15", checkOut: "16:00", status: "Late", delayMinutes: 15),
    AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 2)), checkIn: "--:--", checkOut: "--:--", status: "Leave"),
    AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 3)), checkIn: "07:50", checkOut: "18:00", status: "Present", overtimeMinutes: 120),
    AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 4)), checkIn: "--:--", checkOut: "--:--", status: "Absent"),
    AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 5)), checkIn: "--:--", checkOut: "--:--", status: "Weekend"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("سجل دوامي"),
        centerTitle: true,
        backgroundColor: Colors.redAccent, // لون مميز لهذه الشاشة
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              // اختيار الشهر
              final date = await showDatePicker(
                context: context, 
                initialDate: _selectedMonth, 
                firstDate: DateTime(2023), 
                lastDate: DateTime(2030),
                initialDatePickerMode: DatePickerMode.year, // للتبسيط
              );
              if (date != null) setState(() => _selectedMonth = date);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. ملخص الشهر
          _buildMonthSummary(),
          
          // 2. قائمة الحركات
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                return _buildRecordCard(_records[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- ملخص الشهر ---
  Widget _buildMonthSummary() {
    // حسابات بسيطة
    int totalDelay = _records.fold(0, (sum, item) => sum + item.delayMinutes);
    int totalAbsent = _records.where((r) => r.status == 'Absent').length;
    int totalOvertime = _records.fold(0, (sum, item) => sum + item.overtimeMinutes);

    return Container(
      color: Colors.redAccent,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        children: [
          Text(
            DateFormat('MMMM yyyy', 'ar').format(_selectedMonth),
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryItem("تأخير (دقيقة)", "$totalDelay", Icons.timer_off),
              Container(width: 1, height: 30, color: Colors.white30),
              _summaryItem("غياب (أيام)", "$totalAbsent", Icons.person_off),
              Container(width: 1, height: 30, color: Colors.white30),
              _summaryItem("إضافي (ساعة)", "${(totalOvertime/60).toStringAsFixed(1)}", Icons.access_time_filled),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  // --- بطاقة السجل اليومي ---
  Widget _buildRecordCard(AttendanceRecord record) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (record.status) {
      case 'Present':
        statusColor = Colors.green; statusText = "حضور"; statusIcon = Icons.check_circle; break;
      case 'Late':
        statusColor = Colors.orange; statusText = "تأخير"; statusIcon = Icons.warning; break;
      case 'Absent':
        statusColor = Colors.red; statusText = "غياب"; statusIcon = Icons.cancel; break;
      case 'Leave':
        statusColor = Colors.blue; statusText = "إجازة"; statusIcon = Icons.beach_access; break;
      default:
        statusColor = Colors.grey; statusText = "عطلة"; statusIcon = Icons.weekend;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // التاريخ واليوم
            Container(
              width: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(DateFormat('dd').format(record.date), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(DateFormat('EEE', 'ar').format(record.date), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // تفاصيل الحركة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 6),
                      Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 14)),
                      if (record.delayMinutes > 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text("(${record.delayMinutes}د تأخير)", style: const TextStyle(color: Colors.orange, fontSize: 11)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (record.status != 'Absent' && record.status != 'Leave' && record.status != 'Weekend')
                    Row(
                      children: [
                        _timeBadge("دخول", record.checkIn, Colors.green),
                        const SizedBox(width: 12),
                        const Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
                        const SizedBox(width: 12),
                        _timeBadge("خروج", record.checkOut, Colors.red),
                      ],
                    )
                  else
                    Text(
                      record.status == 'Leave' ? "إجازة رسمية مدفوعة" : (record.status == 'Absent' ? "غياب غير مبرر" : "عطلة نهاية أسبوع"),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeBadge(String label, String time, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
      ],
    );
  }
}