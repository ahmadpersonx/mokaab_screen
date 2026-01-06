// FileName: lib/features/finance/presentation/screens/payment_receipt_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/finance/models/payment_model.dart';
import 'package:mokaab/features/finance/models/journal_entry_model.dart';
import 'package:mokaab/features/finance/models/account_model.dart';
import 'package:mokaab/core/widgets/schema_viewer.dart';
class PaymentReceiptScreen extends StatefulWidget {
  const PaymentReceiptScreen({super.key});

  @override
  State<PaymentReceiptScreen> createState() => _PaymentReceiptScreenState();
}

class _PaymentReceiptScreenState extends State<PaymentReceiptScreen> with TickerProviderStateMixin {
    late TabController _tabController;
  final List<String> _costCenters = ['عام', 'مشروع العبدلي', 'مشروع البحر الميت'];
  String _selectedCostCenter = 'عام';
  
  late PaymentReceipt _receipt;
  List<JournalItem> _journalPreview = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _receipt = PaymentReceipt(
      id: '1', number: 'REC-999', customerName: 'مؤسسة الأفق للمقاولات', date: DateTime.now(),
      lines: [], // قائمة فارغة في البداية
    );
    _tabController = TabController(length: 3, vsync: this); // <-- زيادة إلى 3

  }

  // --- محرك القيد: هنا يتم توجيه الدفعات للحسابات ---
  void _updateJournalEntry() {
    List<JournalItem> items = [];

    // 1. الطرف المدين (يتعدد حسب طريقة الدفع)
    for (var line in _receipt.lines) {
      String accountCode = '';
      String accountName = '';

      // المنطق الذكي للتوجيه
      switch (line.method) {
        case PaymentMethod.cash: 
          accountCode = '110101'; accountName = 'الصندوق الرئيسي'; break;
        case PaymentMethod.bankTransfer: 
          accountCode = '110201'; accountName = 'البنك العربي'; break;
        case PaymentMethod.checkCurrent: 
          accountCode = '110305'; accountName = 'شيكات برسم التحصيل'; break;
        case PaymentMethod.checkPostDated: 
          accountCode = '110306'; accountName = 'أوراق قبض (مؤجلة)'; break;
      }

      items.add(JournalItem(
        id: DateTime.now().toString(),
        account: Account(id: 'x', code: accountCode, name: accountName, type: AccountType.asset),
        debit: line.amount, credit: 0,
        label: line.methodLabel,
        costCenterId: _selectedCostCenter, // ربط مركز التكلفة
      ));
    }

    // 2. الطرف الدائن (العميل)
    if (_receipt.totalAmount > 0) {
      items.add(JournalItem(
        id: 'CUST',
        account: Account(id: 'c', code: '110301', name: 'الذمم المدينة', type: AccountType.asset),
        partnerId: _receipt.customerName,
        debit: 0, credit: _receipt.totalAmount,
        label: 'سند قبض ${_receipt.number}',
      ));
    }

    setState(() => _journalPreview = items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text("سند قبض (متعدد طرق الدفع)"), backgroundColor: Colors.green[800], foregroundColor: Colors.white),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextFormField(initialValue: _receipt.customerName, decoration: const InputDecoration(labelText: "استلمنا من السادة", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCostCenter,
                  decoration: const InputDecoration(labelText: "مركز التكلفة (لأغراض التقارير)", border: OutlineInputBorder(), prefixIcon: Icon(Icons.pie_chart)),
                  items: _costCenters.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    setState(() => _selectedCostCenter = val!);
                    _updateJournalEntry();
                  },
                ),
              ],
            ),
          ),
          
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.green[800],
              indicatorColor: Colors.green,
              tabs: const [
                Tab(text: "طرق الدفع"), 
                Tab(text: "معاينة القيد"),
                Tab(icon: Icon(Icons.developer_mode), text: "DB Data"), // <-- الجديد
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPaymentMethodsInput(),
                _buildJournalPreview(),
                _buildDatabaseSchemaTab(), // <-- الجديد
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildDatabaseSchemaTab() {
    final Map<String, dynamic> dbRecord = {
      'id': _receipt.id,
      'name': _receipt.number,
      'partner_id': _receipt.customerName,
      'payment_date': _receipt.date,
      'state': _receipt.status,
      'amount': _receipt.totalAmount,
      'cost_center_id': _selectedCostCenter, // الحقل الجديد الذي أضفناه
      'journal_id': 'BNK (Bank)',
      'payment_lines_ids': _receipt.lines.length, // One2Many
      'currency_id': 'JOD',
    };

    return SchemaViewer(tableName: 'account_payment', data: dbRecord);
  }

  Widget _buildPaymentMethodsInput() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _buildAddButton("نقد", PaymentMethod.cash, Icons.money)),
            const SizedBox(width: 8),
            Expanded(child: _buildAddButton("شيك", PaymentMethod.checkCurrent, Icons.newspaper)),
            const SizedBox(width: 8),
            Expanded(child: _buildAddButton("حوالة", PaymentMethod.bankTransfer, Icons.account_balance)),
          ],
        ),
        const SizedBox(height: 16),
        const Text("الدفعات المدرجة:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        
        ..._receipt.lines.map((line) => Card(
          child: ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text(line.methodLabel),
            trailing: Text("${line.amount} د.أ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text("يتم الترحيل لحساب: ${line.targetAccountCode}"),
          ),
        )),

        const Divider(height: 30),
        Center(child: Text("الإجمالي: ${_receipt.totalAmount} د.أ", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green))),
      ],
    );
  }

  Widget _buildAddButton(String label, PaymentMethod method, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        // محاكاة إضافة مبلغ ثابت للتجربة
        setState(() {
          _receipt.lines.add(PaymentLine(method: method, amount: 1000));
          _updateJournalEntry();
        });
      },
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green[50], foregroundColor: Colors.green[900]),
    );
  }

  Widget _buildJournalPreview() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _journalPreview.length,
      itemBuilder: (context, index) {
        final item = _journalPreview[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text("${item.account.code} - ${item.account.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("مركز التكلفة: ${_selectedCostCenter}"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (item.debit > 0) Text("مدين: ${item.debit}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                if (item.credit > 0) Text("دائن: ${item.credit}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}