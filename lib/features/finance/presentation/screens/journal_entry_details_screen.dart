// FileName: lib/features/finance/presentation/screens/journal_entry_details_screen.dart
// Description: شاشة تفاصيل القيد (تعرض المدين والدائن بشكل جدول محاسبي)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/finance/models/journal_entry_model.dart';
// import 'package:mokaab/features/finance/data/services/journal_service.dart'; // سنستخدمه لاحقاً للربط

class JournalEntryDetailsScreen extends StatefulWidget {
  final JournalEntry entry; // يمكن تمرير القيد مباشرة
  // final String? entryId; // أو تمرير الـ ID لجلب البيانات (خيار مستقبلي)

  const JournalEntryDetailsScreen({super.key, required this.entry});

  @override
  State<JournalEntryDetailsScreen> createState() => _JournalEntryDetailsScreenState();
}

class _JournalEntryDetailsScreenState extends State<JournalEntryDetailsScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("تفاصيل القيد", style: TextStyle(fontSize: 16)),
            Text(widget.entry.name, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
        actions: [
          // زر الطباعة (Placeholder)
          IconButton(onPressed: () {}, icon: const Icon(Icons.print)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildLinesTable(),
            const SizedBox(height: 16),
            _buildFooterTotals(),
          ],
        ),
      ),
    );
  }

  // 1. بطاقة المعلومات العامة (رأس القيد)
  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem("التاريخ", DateFormat('yyyy-MM-dd').format(widget.entry.date), Icons.calendar_today),
                _buildInfoItem("المرجع", widget.entry.ref ?? '-', Icons.bookmark_border),
                _buildStatusBadge(widget.entry.state),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem("نوع الدفتر", widget.entry.journalType.toString().split('.').last.toUpperCase(), Icons.book),
                if (widget.entry.sourceModel != null)
                  _buildInfoItem("المصدر", "${widget.entry.sourceModel} #${widget.entry.sourceId}", Icons.link),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(EntryState state) {
    Color color = state == EntryState.posted ? Colors.green : Colors.orange;
    String text = state == EntryState.posted ? "مرحل" : "مسودة";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  // 2. جدول الأسطر (التفاصيل المالية)
  Widget _buildLinesTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text("الحساب / البيان", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text("مدين", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text("دائن", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(height: 1),
          ...widget.entry.lines.map((line) => _buildLineRow(line)).toList(),
        ],
      ),
    );
  }

  Widget _buildLineRow(JournalItem line) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        children: [
          // الحساب والبيان
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(line.accountCode, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                    const SizedBox(width: 8),
                    if (line.partnerName != null) 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                        child: Text(line.partnerName!, style: TextStyle(fontSize: 10, color: Colors.blue[800])),
                      ),
                  ],
                ),
                if (line.accountName.isNotEmpty) Text(line.accountName, style: const TextStyle(fontSize: 12)),
                if (line.label.isNotEmpty) Text(line.label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                if (line.costCenterId != null) 
                  Text("مركز: ${line.costCenterId}", style: TextStyle(fontSize: 10, color: Colors.brown[600])),
              ],
            ),
          ),
          // مدين
          Expanded(
            flex: 1,
            child: Text(
              line.debit > 0 ? NumberFormat("#,##0.00").format(line.debit) : "-", 
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // دائن
          Expanded(
            flex: 1,
            child: Text(
              line.credit > 0 ? NumberFormat("#,##0.00").format(line.credit) : "-", 
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // 3. ذيل المجموع
  Widget _buildFooterTotals() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("الإجمالي:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Row(
            children: [
              _buildTotalBox("إجمالي المدين", widget.entry.totalDebit, Colors.green),
              const SizedBox(width: 12),
              _buildTotalBox("إجمالي الدائن", widget.entry.totalCredit, Colors.red),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTotalBox(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          NumberFormat("#,##0.00").format(value), 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
        ),
      ],
    );
  }
}