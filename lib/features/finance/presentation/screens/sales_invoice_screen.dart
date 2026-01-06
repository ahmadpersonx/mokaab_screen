// FileName: lib/features/finance/presentation/screens/sales_invoice_screen.dart
// Description: فاتورة مبيعات ذكية توضح التوجيه المحاسبي الآلي

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/finance/models/invoice_model.dart';
import 'package:mokaab/features/finance/models/journal_entry_model.dart';
import 'package:mokaab/features/finance/models/account_model.dart';
import 'package:mokaab/core/widgets/schema_viewer.dart';

class SalesInvoiceScreen extends StatefulWidget {
  const SalesInvoiceScreen({super.key});

  @override
  State<SalesInvoiceScreen> createState() => _SalesInvoiceScreenState();
}

class _SalesInvoiceScreenState extends State<SalesInvoiceScreen> with TickerProviderStateMixin {
    late TabController _tabController;
  
  // --- بيانات القوائم (محاكاة للداتا بيس) ---
  final List<String> _costCenters = ['المركز الرئيسي', 'فرع الرياض', 'مشروع العبدلي', 'مشروع البحر الميت'];
  
  // قائمة المنتجات مع الحساب المرتبط بها (هذا هو سر التوجيه الآلي)
  final List<Map<String, dynamic>> _products = [
    {'name': 'حجر واجهات (متر)', 'price': 15.0, 'account': '410101 (مبيعات حجر)'},
    {'name': 'تركيب ميكانيك (متر)', 'price': 8.0, 'account': '410105 (إيرادات خدمات تركيب)'},
    {'name': 'نقل (نقلة)', 'price': 50.0, 'account': '420100 (إيرادات نقل)'},
  ];

  // المتغيرات
  String? _selectedCostCenter;
  late Invoice _invoice;
  List<JournalItem> _journalLines = [];



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedCostCenter = _costCenters[0]; // الافتراضي
_tabController = TabController(length: 3, vsync: this); // <-- زيادة عدد التابات إلى 3
    // إنشاء فاتورة مبدئية
    _invoice = Invoice(
      id: '1', number: 'INV-2025-001', customerName: 'شركة الإعمار الهندسية', date: DateTime.now(),
      lines: [
        // سنبدأ بسطر افتراضي
        InvoiceLine(product: _products[0]['name'], price: _products[0]['price'], quantity: 100, accountCode: _products[0]['account']),
      ],
    );
    _updateJournalPreview();
  }

  // --- المحرك: تحديث القيد بناءً على المدخلات ---
  void _updateJournalPreview() {
    List<JournalItem> temp = [];
    
    // 1. المدين: العميل (بإجمالي الفاتورة)
    temp.add(JournalItem(
      id: 'DR', 
      account: Account(id: '1', code: '110301', name: 'الذمم المدينة', type: AccountType.asset),
      partnerId: _invoice.customerName,
      debit: _invoice.totalAmount, credit: 0,
      label: 'استحقاق فاتورة ${_invoice.number}'
    ));

    // 2. الدائن: الإيرادات (مفصلة حسب السطور)
    for (var line in _invoice.lines) {
      temp.add(JournalItem(
        id: DateTime.now().toString(),
        // هنا يأخذ الحساب من المنتج، ومركز التكلفة من الترويسة
        account: Account(id: 'x', code: line.accountCode.split(' ')[0], name: line.accountCode.split(' ')[1], type: AccountType.income),
        debit: 0, credit: line.subtotal,
        label: line.product,
        costCenterId: _selectedCostCenter, // <-- التوجيه التحليلي
      ));
    }

    // 3. الدائن: الضريبة
    if (_invoice.totalTax > 0) {
      temp.add(JournalItem(
        id: 'TAX',
        account: Account(id: 't', code: '210500', name: 'أمانات ضريبة المبيعات', type: AccountType.liability),
        debit: 0, credit: _invoice.totalTax,
        label: 'ضريبة 16%'
      ));
    }
    
    setState(() => _journalLines = temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text("فاتورة مبيعات جديدة"), backgroundColor: Colors.blue[900], foregroundColor: Colors.white),
      body: Column(
        children: [
          // 1. ترويسة الفاتورة (Header)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildTextField("العميل", _invoice.customerName, Icons.person)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField("التاريخ", DateFormat('yyyy-MM-dd').format(_invoice.date), Icons.date_range)),
                  ],
                ),
                const SizedBox(height: 16),
                // --- اختيار مركز التكلفة ---
                DropdownButtonFormField<String>(
                  value: _selectedCostCenter,
                  decoration: const InputDecoration(labelText: "مركز التكلفة / المشروع (Cost Center)", border: OutlineInputBorder(), prefixIcon: Icon(Icons.hub, color: Colors.brown)),
                  items: _costCenters.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    setState(() => _selectedCostCenter = val);
                    _updateJournalPreview(); // تحديث القيد فوراً عند التغيير
                  },
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // 2. التبويبات
        Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue[900],
              indicatorColor: Colors.orange,
              tabs: const [
                Tab(text: "بنود الفاتورة"), 
                Tab(text: "معاينة القيد"),
                Tab(icon: Icon(Icons.developer_mode), text: "DB Schema"), // <-- التاب الجديد
              ],
            ),
          ),

          // 3. المحتوى
         Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInvoiceLines(),
                _buildJournalPreview(),
                _buildDatabaseSchemaTab(), // <-- محتوى التاب الجديد
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- واجهة إضافة السطور ---
  Widget _buildInvoiceLines() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // زر إضافة سطر
        ElevatedButton.icon(
          onPressed: _showAddProductDialog,
          icon: const Icon(Icons.add),
          label: const Text("إضافة منتج"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[50], foregroundColor: Colors.blue[900], elevation: 0),
        ),
        const SizedBox(height: 10),
        
        // جدول السطور
        ..._invoice.lines.map((line) => Card(
          child: ListTile(
            leading: const CircleAvatar(child: Text("1")),
            title: Text(line.product, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("الحساب المرتبط: ${line.accountCode}"), // إظهار الحساب للمستخدم للتأكيد
            trailing: Text("${line.subtotal.toStringAsFixed(2)} د.أ", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        )),

        const Divider(),
        // المجموع
        _buildSummaryRow("الإجمالي قبل الضريبة", _invoice.totalUntaxed),
        _buildSummaryRow("الضريبة (16%)", _invoice.totalTax),
        _buildSummaryRow("الصافي", _invoice.totalAmount, isBold: true, color: Colors.blue[900]),
      ],
    );
  }

  // --- واجهة معاينة القيد ---
  Widget _buildJournalPreview() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _journalLines.length,
      itemBuilder: (context, index) {
        final item = _journalLines[index];
        bool isDebit = item.debit > 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(left: BorderSide(color: isDebit ? Colors.green : Colors.red, width: 4)),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)]
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${item.account.code} - ${item.account.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (item.costCenterId != null)
                      Text("مركز التكلفة: ${item.costCenterId}", style: TextStyle(fontSize: 11, color: Colors.brown[600])),
                  ],
                ),
              ),
              Expanded(flex: 1, child: Text(item.debit > 0 ? "${item.debit}" : "-", textAlign: TextAlign.center, style: const TextStyle(color: Colors.green))),
              Expanded(flex: 1, child: Text(item.credit > 0 ? "${item.credit}" : "-", textAlign: TextAlign.center, style: const TextStyle(color: Colors.red))),
            ],
          ),
        );
      },
    );
  }

// ... دالة بناء التاب الجديد ...
  Widget _buildDatabaseSchemaTab() {
    // تحويل الكائن إلى Map لمحاكاة شكل الداتابيس
    final Map<String, dynamic> dbRecord = {
      'id': _invoice.id,
      'name': _invoice.number,
      'partner_id': _invoice.customerName, // في الواقع سيكون ID
      'date_invoice': _invoice.date,
      'state': _invoice.status.toString().split('.').last,
      'amount_untaxed': _invoice.totalUntaxed,
      'amount_tax': _invoice.totalTax,
      'amount_total': _invoice.totalAmount,
      'cost_center_id': _selectedCostCenter,
      'journal_id': 'INV (Sales)',
      'invoice_lines_ids': _invoice.lines.length.toString(), // علاقة One2Many
      'create_uid': 'Admin',
      'create_date': DateTime.now(),
    };

    return SchemaViewer(tableName: 'account_move (Invoice)', data: dbRecord);
  }

  Widget _buildTextField(String label, String value, IconData icon) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), prefixIcon: Icon(icon), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
          Text(value.toStringAsFixed(2), style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 16, color: color)),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView.builder(
        itemCount: _products.length,
        itemBuilder: (c, i) => ListTile(
          title: Text(_products[i]['name']),
          subtitle: Text("السعر: ${_products[i]['price']} | الحساب: ${_products[i]['account']}"),
          onTap: () {
            setState(() {
              _invoice.lines.add(InvoiceLine(
                product: _products[i]['name'],
                price: _products[i]['price'],
                quantity: 1,
                accountCode: _products[i]['account']
              ));
              _updateJournalPreview();
            });
            Navigator.pop(context);
          },
        ),
      )
    );
  }
}