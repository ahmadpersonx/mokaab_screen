// FileName: lib/features/hr/contracts/screens/contracts_list_screen.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/hr/contracts/screens/contract_management_screen.dart';

// نموذج تجريبي لعقد في القائمة
class ContractSummary {
  final String id;
  final String employeeName;
  final String jobTitle;
  final String type;
  final String status; // Active, Draft, Expiring, Terminated
  final DateTime startDate;
  final DateTime? endDate;

  ContractSummary(this.id, this.employeeName, this.jobTitle, this.type, this.status, this.startDate, this.endDate);
}

class ContractsListScreen extends StatefulWidget {
  const ContractsListScreen({super.key});

  @override
  State<ContractsListScreen> createState() => _ContractsListScreenState();
}

class _ContractsListScreenState extends State<ContractsListScreen> {
  // بيانات وهمية للمحاكاة
  final List<ContractSummary> _contracts = [
    ContractSummary("C001", "أحمد محمد", "مشغل CNC", "محدد المدة", "Active", DateTime(2024, 1, 1), DateTime(2024, 12, 31)),
    ContractSummary("C002", "سارة علي", "محاسب عام", "دائم", "Active", DateTime(2023, 5, 15), null),
    ContractSummary("C003", "خالد يوسف", "سائق", "مياومة", "Draft", DateTime(2024, 6, 1), null),
    ContractSummary("C004", "محمود حسن", "فني صيانة", "محدد المدة", "Expiring", DateTime(2023, 6, 1), DateTime(2024, 6, 1)), // ينتهي قريباً
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("سجل العقود الوظيفية"),
        centerTitle: true,
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildStatsHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _contracts.length,
              itemBuilder: (context, index) => _buildContractCard(_contracts[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // الانتقال لشاشة إنشاء العقد التي بنيناها سابقاً
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContractManagementScreen()),
          );
        },
        label: const Text("عقد جديد"),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF00897B),
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("عقود سارية", "125", Colors.green),
          _buildStatItem("تنتهي قريباً", "3", Colors.orange), // تنبيه مهم للـ HR
          _buildStatItem("مسودات", "5", Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildContractCard(ContractSummary contract) {
    Color statusColor = Colors.green;
    String statusText = "ساري المفعول";

    if (contract.status == 'Draft') {
      statusColor = Colors.grey;
      statusText = "مسودة";
    } else if (contract.status == 'Expiring') {
      statusColor = Colors.orange;
      statusText = "ينتهي قريباً";
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
                CircleAvatar(
                  backgroundColor: statusColor.withOpacity(0.1),
                  child: Icon(Icons.description, color: statusColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contract.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("${contract.jobTitle} • ${contract.type}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("تاريخ البدء: ${contract.startDate.toString().split(' ')[0]}", style: const TextStyle(fontSize: 12)),
                if (contract.endDate != null)
                  Text("تاريخ الانتهاء: ${contract.endDate.toString().split(' ')[0]}", style: TextStyle(fontSize: 12, color: contract.status == 'Expiring' ? Colors.red : Colors.black)),
                
                // أزرار الإجراءات السريعة
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.print, size: 20, color: Colors.grey), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.edit, size: 20, color: Colors.blue), onPressed: () {}),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}