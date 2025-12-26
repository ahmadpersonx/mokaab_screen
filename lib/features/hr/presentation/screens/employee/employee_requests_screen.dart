// FileName: lib/features/hr/presentation/screens/employee/employee_requests_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/hr/presentation/screens/employee/requests/request_forms.dart';

// نموذج بسيط لطلب الموظف
class MyRequest {
  final String id;
  final String title; // "إجازة سنوية"، "مغادرة خاصة"، "شهادة راتب"
  final String type;  // Leave, Permission, Letter, Complaint
  final DateTime date;
  final String status; // Pending, Approved, Rejected
  final String? note;

  MyRequest({required this.id, required this.title, required this.type, required this.date, required this.status, this.note});
}

class EmployeeRequestsScreen extends StatefulWidget {
  const EmployeeRequestsScreen({super.key});

  @override
  State<EmployeeRequestsScreen> createState() => _EmployeeRequestsScreenState();
}

class _EmployeeRequestsScreenState extends State<EmployeeRequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // بيانات وهمية لطلبات الموظف
  final List<MyRequest> _allRequests = [
    MyRequest(id: 'REQ-101', title: 'إجازة سنوية (3 أيام)', type: 'Leave', date: DateTime.now().add(const Duration(days: 2)), status: 'Pending', note: 'ظروف عائلية'),
    MyRequest(id: 'REQ-102', title: 'مغادرة شخصية (ساعتين)', type: 'Permission', date: DateTime.now().subtract(const Duration(days: 1)), status: 'Approved'),
    MyRequest(id: 'REQ-103', title: 'طلب شهادة لمن يهمه الأمر', type: 'Letter', date: DateTime.now().subtract(const Duration(days: 5)), status: 'Approved'),
    MyRequest(id: 'REQ-104', title: 'إجازة مرضية', type: 'Leave', date: DateTime.now().subtract(const Duration(days: 10)), status: 'Rejected', note: 'عدم وجود تقرير طبي'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("طلباتي ومتابعاتي"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amber,
          tabs: const [
            Tab(text: "الكل"),
            Tab(text: "قيد الانتظار"),
            Tab(text: "مكتملة"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestList(_allRequests), // الكل
          _buildRequestList(_allRequests.where((r) => r.status == 'Pending').toList()), // الانتظار
          _buildRequestList(_allRequests.where((r) => r.status != 'Pending').toList()), // المكتملة
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewRequestBottomSheet(),
        label: const Text("طلب جديد"),
        icon: const Icon(Icons.add_circle_outline),
        backgroundColor: Colors.blue[800],
      ),
    );
  }

  Widget _buildRequestList(List<MyRequest> requests) {
    if (requests.isEmpty) {
      return const Center(child: Text("لا توجد طلبات في هذه القائمة", style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return _buildRequestCard(req);
      },
    );
  }

  Widget _buildRequestCard(MyRequest req) {
    Color statusColor;
    IconData icon;
    String statusText;

    // تحديد الألوان والأيقونات حسب الحالة والنوع
    switch (req.status) {
      case 'Approved': statusColor = Colors.green; statusText = "تمت الموافقة"; break;
      case 'Rejected': statusColor = Colors.red; statusText = "مرفوض"; break;
      default: statusColor = Colors.orange; statusText = "قيد المراجعة";
    }

    switch (req.type) {
      case 'Leave': icon = Icons.flight_takeoff; break;
      case 'Permission': icon = Icons.access_time; break;
      case 'Letter': icon = Icons.description; break;
      default: icon = Icons.assignment;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.blue[800]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(req.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(DateFormat('yyyy/MM/dd').format(req.date), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.5)),
                  ),
                  child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            if (req.note != null) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(req.note!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  // --- نافذة إنشاء طلب جديد ---
  void _showNewRequestBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("نوع الطلب الجديد", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            _buildActionTile(Icons.date_range, "طلب إجازة", Colors.purple, () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveRequestScreen())); // ربط
            }),
            
            _buildActionTile(Icons.access_time_filled, "طلب مغادرة ساعات", Colors.orange, () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HourlyPermissionScreen())); // ربط
            }),
            
            _buildActionTile(Icons.description, "طلب وثيقة / شهادة", Colors.blue, () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentRequestScreen())); // ربط
            }),
            
            _buildActionTile(Icons.report_problem, "شكوى أو مذكرة", Colors.red, () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InternalMemoScreen())); // ربط
            }),
            
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String label, Color color, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}