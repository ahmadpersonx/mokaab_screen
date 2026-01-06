// FileName: lib/features/finance/presentation/screens/journal_entries_screen.dart
// Version: 3.0 (Fixed & Fully Compatible with JournalEntry Model v3.0)
// Description: شاشة اليومية العامة (تعرض القيود وتفلترها حسب النوع والحالة)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/finance/models/journal_entry_model.dart'; // تأكد أن هذا الملف هو النسخة v3.0
import 'package:mokaab/features/finance/models/account_model.dart';

class JournalEntriesScreen extends StatefulWidget {
  const JournalEntriesScreen({super.key});

  @override
  State<JournalEntriesScreen> createState() => _JournalEntriesScreenState();
}

class _JournalEntriesScreenState extends State<JournalEntriesScreen> with TickerProviderStateMixin {
    late TabController _tabController;
  
  // --- بيانات تجريبية محدثة لتتوافق مع النموذج الجديد (v3.0) ---
  final List<JournalEntry> _allEntries = [
    // 1. قيد ناتج عن فاتورة مبيعات
    JournalEntry(
      id: '1', 
      name: 'JRN/2025/001', 
      ref: 'INV-1001',
      date: DateTime.now().subtract(const Duration(days: 1)),
      journalType: JournalType.sale, // استخدام Enum الصحيح
      moveType: MoveType.outInvoice, // نوع الحركة
      state: EntryState.posted,
      lines: [
        JournalItem(id: '1', account: Account(id: '1', code: '1103', name: 'العملاء', type: AccountType.asset), debit: 1160, credit: 0, partnerId: 'شركة البناء'),
        JournalItem(id: '2', account: Account(id: '2', code: '4101', name: 'مبيعات حجر', type: AccountType.income), debit: 0, credit: 1000),
        JournalItem(id: '3', account: Account(id: '3', code: '2201', name: 'ضريبة مبيعات', type: AccountType.liability), debit: 0, credit: 160),
      ]
    ),

    // 2. قيد ناتج عن سند صرف مخزني
    JournalEntry(
      id: '2', 
      name: 'JRN/2025/002', 
      ref: 'STK-OUT-055',
      date: DateTime.now(),
      journalType: JournalType.inventory, // استخدام Enum الصحيح
      moveType: MoveType.entry,
      state: EntryState.posted,
      lines: [
        JournalItem(id: '4', account: Account(id: '4', code: '5205', name: 'مصاريف قرطاسية', type: AccountType.expense), label: 'صرف ورق A4', debit: 50, credit: 0, costCenterId: 'CC-ADMIN'),
        JournalItem(id: '5', account: Account(id: '5', code: '1105', name: 'مخزون المستودع', type: AccountType.asset), label: 'إخراج مواد', debit: 0, credit: 50),
      ]
    ),

    // 3. قيد سند قبض
    JournalEntry(
      id: '3', 
      name: 'JRN/2025/003', 
      ref: 'REC-99',
      date: DateTime.now(),
      journalType: JournalType.bank, // استخدام Enum الصحيح
      moveType: MoveType.inReceipt,
      state: EntryState.draft,
      lines: [
        JournalItem(id: '6', account: Account(id: '6', code: '1102', name: 'البنك العربي', type: AccountType.asset), debit: 500, credit: 0),
        JournalItem(id: '7', account: Account(id: '7', code: '1103', name: 'العملاء', type: AccountType.asset), debit: 0, credit: 500, partnerId: 'شركة البناء'),
      ]
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("قيود اليومية العامة"),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          isScrollable: true,
          tabs: const [
            Tab(text: "الكل"),
            Tab(text: "مبيعات (Sales)"),
            Tab(text: "مخزون (Stock)"),
            Tab(text: "مالية (Bank/Cash)"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEntriesList(_allEntries), // الكل
          
          // فلترة المبيعات
          _buildEntriesList(_allEntries.where((e) => e.journalType == JournalType.sale).toList()),
          
          // فلترة المخزون والتصنيع
          _buildEntriesList(_allEntries.where((e) => e.journalType == JournalType.inventory || e.journalType == JournalType.manufacturing).toList()),
          
          // فلترة البنك والصندوق
          _buildEntriesList(_allEntries.where((e) => e.journalType == JournalType.bank || e.journalType == JournalType.cash).toList()),
        ],
      ),
    );
  }

  Widget _buildEntriesList(List<JournalEntry> entries) {
    if (entries.isEmpty) return const Center(child: Text("لا توجد قيود", style: TextStyle(color: Colors.grey)));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        return _buildEntryCard(entries[index]);
      },
    );
  }

  Widget _buildEntryCard(JournalEntry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          // استخدام دالة اللون الجديدة
          decoration: BoxDecoration(color: _getJournalColor(entry.journalType).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          // عرض كود قصير للنوع
          child: Text(_getJournalShortCode(entry.journalType), style: TextStyle(fontWeight: FontWeight.bold, color: _getJournalColor(entry.journalType))),
        ),
        title: Row(
          children: [
            Text(entry.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            _buildStateBadge(entry.state),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.ref.isNotEmpty) Text("مرجع: ${entry.ref}", style: const TextStyle(fontSize: 11, color: Colors.black54)),
            Text(DateFormat('yyyy-MM-dd').format(entry.date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(NumberFormat("#,##0.00").format(entry.totalDebit), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const Text("د.أ", style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        children: [
          Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.all(12),
            child: Column(
              children: entry.lines.map((line) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4, 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${line.account.code} - ${line.account.name}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          if (line.label.isNotEmpty) Text(line.label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          if (line.costCenterId != null) 
                            Text("مركز: ${line.costCenterId}", style: TextStyle(fontSize: 10, color: Colors.brown[300])),
                          if (line.partnerId != null) 
                            Text("شريك: ${line.partnerId}", style: TextStyle(fontSize: 10, color: Colors.blueGrey)),
                        ],
                      )
                    ),
                    Expanded(
                      flex: 2, 
                      child: Text(line.debit > 0 ? line.debit.toStringAsFixed(2) : "-", textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87))
                    ),
                    Expanded(
                      flex: 2, 
                      child: Text(line.credit > 0 ? line.credit.toStringAsFixed(2) : "-", textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87))
                    ),
                  ],
                ),
              )).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStateBadge(EntryState state) {
    Color color;
    String text;
    switch (state) {
      case EntryState.draft: color = Colors.blueGrey; text = "مسودة"; break;
      case EntryState.posted: color = Colors.green; text = "مرحل"; break;
      case EntryState.cancelled: color = Colors.red; text = "ملغى"; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }

  // Helper: تحديد اللون حسب Enum
  Color _getJournalColor(JournalType type) {
    switch (type) {
      case JournalType.sale: return Colors.blue;
      case JournalType.purchase: return Colors.indigo;
      case JournalType.inventory: return Colors.orange;
      case JournalType.bank: return Colors.purple;
      case JournalType.cash: return Colors.green;
      case JournalType.manufacturing: return Colors.brown;
      default: return Colors.grey;
    }
  }

  // Helper: كود قصير للعرض
  String _getJournalShortCode(JournalType type) {
    switch (type) {
      case JournalType.sale: return "INV";
      case JournalType.purchase: return "BILL";
      case JournalType.inventory: return "STK";
      case JournalType.bank: return "BNK";
      case JournalType.cash: return "CSH";
      case JournalType.manufacturing: return "MFG";
      default: return "MSC";
    }
  }
}