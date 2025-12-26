// FileName: lib/features/hr/leaves/screens/leaves_management_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';

// --- نماذج البيانات الخاصة بالإجازات ---

class LeaveRequest {
  final String id;
  final String leaveTypeId; // مربوط بـ LookupCategory.leaveTypes
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status; // Pending, Approved, Rejected
  final double daysCount;

  LeaveRequest({
    required this.id,
    required this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.status = 'Pending',
    required this.daysCount,
  });
}

class LeaveBalance {
  final String typeId;
  final String typeName;
  final double total;
  final double used;
  final Color color;

  LeaveBalance({required this.typeId, required this.typeName, required this.total, required this.used, required this.color});
  
  double get remaining => total - used;
  double get progress => (total == 0) ? 0 : used / total;
}

// --- الشاشة الرئيسية ---

class LeavesManagementScreen extends StatefulWidget {
  const LeavesManagementScreen({super.key});

  @override
  State<LeavesManagementScreen> createState() => _LeavesManagementScreenState();
}

class _LeavesManagementScreenState extends State<LeavesManagementScreen> {
  // بيانات وهمية للأرصدة (يجب جلبها من ملف الموظف لاحقاً)
  List<LeaveBalance> _balances = [];
  
  // بيانات وهمية للطلبات
  List<LeaveRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // 1. تحضير الأرصدة بناءً على القوائم الموجودة
    _balances = [
      LeaveBalance(typeId: 'LV-ANNUAL', typeName: 'إجازة سنوية', total: 14, used: 5, color: Colors.blue),
      LeaveBalance(typeId: 'LV-SICK', typeName: 'إجازة مرضية', total: 14, used: 2, color: Colors.orange),
      LeaveBalance(typeId: 'LV-CASUAL', typeName: 'إجازة مغادرة/عارضة', total: 3, used: 1, color: Colors.purple),
    ];

    // 2. تحضير سجل الطلبات
    _requests = [
      LeaveRequest(id: 'LR-001', leaveTypeId: 'LV-ANNUAL', startDate: DateTime(2024, 2, 10), endDate: DateTime(2024, 2, 12), daysCount: 3, reason: 'ظروف عائلية', status: 'Approved'),
      LeaveRequest(id: 'LR-002', leaveTypeId: 'LV-SICK', startDate: DateTime(2024, 3, 5), endDate: DateTime(2024, 3, 5), daysCount: 1, reason: 'مراجعة طبيب', status: 'Pending'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("الإجازات والمغادرات"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. قسم الأرصدة (Cards)
            _buildBalancesHeader(),
            
            const SizedBox(height: 20),
            
            // 2. عنوان القائمة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("سجل الطلبات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: () {
                      // فلترة
                    },
                    icon: const Icon(Icons.filter_list, size: 18),
                    label: const Text("تصفية"),
                  )
                ],
              ),
            ),

            // 3. قائمة الطلبات
            _buildRequestsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLeaveRequestDialog(),
        label: const Text("طلب إجازة"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  // --- قسم الأرصدة (Horizontal Scroll) ---
  Widget _buildBalancesHeader() {
    return Container(
      height: 160,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _balances.length,
        separatorBuilder: (ctx, i) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final balance = _balances[index];
          return Container(
            width: 160,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: balance.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: balance.color.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.pie_chart, color: balance.color, size: 20),
                    Text("${balance.remaining.toStringAsFixed(0)} يوم", style: TextStyle(fontWeight: FontWeight.bold, color: balance.color, fontSize: 16)),
                  ],
                ),
                Text(balance.typeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("مستهلك: ${balance.used.toStringAsFixed(0)}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        Text("الإجمالي: ${balance.total.toStringAsFixed(0)}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: balance.progress,
                      backgroundColor: Colors.white,
                      color: balance.color,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // --- قائمة الطلبات ---
  Widget _buildRequestsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _requests.length,
      itemBuilder: (context, index) {
        final req = _requests[index];
        final leaveType = masterLookups[LookupCategory.leaveTypes]?.firstWhere(
          (e) => e.id == req.leaveTypeId, 
          orElse: () => LookupItem(id: '', name: req.leaveTypeId, code: '')
        );

        Color statusColor = Colors.grey;
        if (req.status == 'Approved') statusColor = Colors.green;
        if (req.status == 'Pending') statusColor = Colors.orange;
        if (req.status == 'Rejected') statusColor = Colors.red;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: (leaveType?.color ?? Colors.grey).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Icon(Icons.date_range, color: leaveType?.color ?? Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(leaveType?.name ?? "إجازة", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text("${req.daysCount} أيام", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        req.status == 'Pending' ? 'قيد المراجعة' : (req.status == 'Approved' ? 'مقبول' : 'مرفوض'),
                        style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "${DateFormat('yyyy/MM/dd').format(req.startDate)}  ->  ${DateFormat('yyyy/MM/dd').format(req.endDate)}",
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
                if (req.reason.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text("السبب: ${req.reason}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  // --- نافذة تقديم الطلب (Smart Dialog) ---
  void _showLeaveRequestDialog() {
    String? selectedTypeId;
    DateTime? start;
    DateTime? end;
    String reason = "";
    int daysDiff = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Text("طلب إجازة جديد", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 20),
                
                // 1. اختيار نوع الإجازة
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "نوع الإجازة", border: OutlineInputBorder()),
                  items: (masterLookups[LookupCategory.leaveTypes] ?? []).map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                  onChanged: (val) => setSheetState(() => selectedTypeId = val),
                ),
                const SizedBox(height: 16),

                // 2. اختيار التواريخ
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2025));
                          if (d != null) {
                            setSheetState(() {
                              start = d;
                              if (end != null && end!.isBefore(start!)) end = null;
                              if (start != null && end != null) {
                                daysDiff = end!.difference(start!).inDays + 1;
                              }
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: "من تاريخ", border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
                          child: Text(start != null ? DateFormat('yyyy/MM/dd').format(start!) : "اختر"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final d = await showDatePicker(context: context, initialDate: start ?? DateTime.now(), firstDate: start ?? DateTime.now(), lastDate: DateTime(2025));
                          if (d != null) {
                            setSheetState(() {
                              end = d;
                              if (start != null && end != null) {
                                daysDiff = end!.difference(start!).inDays + 1;
                              }
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: "إلى تاريخ", border: OutlineInputBorder(), suffixIcon: Icon(Icons.event_busy)),
                          child: Text(end != null ? DateFormat('yyyy/MM/dd').format(end!) : "اختر"),
                        ),
                      ),
                    ),
                  ],
                ),
                
                if (daysDiff > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.blue[50],
                      child: Row(children: [const Icon(Icons.info, size: 16, color: Colors.blue), const SizedBox(width: 5), Text("مدة الإجازة: $daysDiff أيام")]),
                    ),
                  ),

                const SizedBox(height: 16),
                
                // 3. السبب
                TextField(
                  decoration: const InputDecoration(labelText: "السبب / ملاحظات", border: OutlineInputBorder()),
                  maxLines: 2,
                  onChanged: (val) => reason = val,
                ),
                
                const SizedBox(height: 24),
                
                // زر الإرسال
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedTypeId != null && start != null && end != null) {
                        setState(() {
                          _requests.insert(0, LeaveRequest(
                            id: 'NEW-${DateTime.now().millisecondsSinceEpoch}',
                            leaveTypeId: selectedTypeId!,
                            startDate: start!,
                            endDate: end!,
                            daysCount: daysDiff.toDouble(),
                            reason: reason,
                            status: 'Pending'
                          ));
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم تقديم طلب الإجازة بنجاح")));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text("تقديم الطلب"),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
      ),
    );
  }
}