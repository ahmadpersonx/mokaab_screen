// FileName: lib/features/finance/presentation/screens/chart_of_accounts_screen.dart
// Description: شاشة عرض دليل الحسابات (شجري) مع البحث

import 'package:flutter/material.dart';
import 'package:mokaab/features/finance/models/account_model.dart';
import 'package:mokaab/features/finance/data/coa_data.dart';

class ChartOfAccountsScreen extends StatefulWidget {
  const ChartOfAccountsScreen({super.key});

  @override
  State<ChartOfAccountsScreen> createState() => _ChartOfAccountsScreenState();
}

class _ChartOfAccountsScreenState extends State<ChartOfAccountsScreen> {
  // القائمة الكاملة
  List<Account> _allAccounts = [];
  // القائمة المعروضة (للبحث)
  List<Account> _displayedAccounts = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _allAccounts = ChartOfAccountsData.accounts;
    _displayedAccounts = _allAccounts;
  }

  void _filterAccounts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _displayedAccounts = _allAccounts;
      } else {
        _displayedAccounts = _allAccounts.where((acc) {
          return acc.name.contains(query) || acc.code.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("دليل الحسابات (COA)"),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.print), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // 1. شريط البحث
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal[800],
            child: TextField(
              onChanged: _filterAccounts,
              decoration: InputDecoration(
                hintText: "بحث برقم الحساب أو الاسم...",
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // 2. الشجرة
          Expanded(
            child: _searchQuery.isEmpty 
              ? _buildAccountTree() // عرض شجري في الوضع العادي
              : _buildFlatList(),   // عرض قائمة مسطحة عند البحث
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // فتح نافذة إضافة حساب جديد (سنبنيها لاحقاً)
        },
        label: const Text("حساب جديد"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal[700],
      ),
    );
  }

  // --- وضع العرض الشجري (Tree View) ---
  Widget _buildAccountTree() {
    // نحدد الجذور (الحسابات التي ليس لها أب في القائمة أو المستوى 1)
    // في بياناتنا، المستوى 1 (الأصول، الخصوم..) هم الجذور
    final roots = _allAccounts.where((acc) => acc.parentCode == null || acc.code.length == 1).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: roots.length,
      itemBuilder: (context, index) {
        return _buildAccountNode(roots[index]);
      },
    );
  }

  // بناء العقدة بشكل تكراري (Recursive)
  Widget _buildAccountNode(Account account) {
    // البحث عن الأبناء
    final children = _allAccounts.where((acc) => acc.parentCode == account.code).toList();

    if (children.isEmpty) {
      // إذا لم يكن له أبناء -> هو حساب فرعي (Leaf)
      return Card(
        margin: const EdgeInsets.only(bottom: 8, right: 16), // إزاحة لليمين لبيان التفرع
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade200)),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: account.typeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(account.code, style: TextStyle(fontWeight: FontWeight.bold, color: account.typeColor, fontSize: 12)),
          ),
          title: Text(account.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: Text(_getAccountTypeName(account.type), style: const TextStyle(fontSize: 11, color: Colors.grey)),
          trailing: Text(
            "${account.currentBalance.toStringAsFixed(2)} د.أ", 
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)
          ),
          onTap: () {
            // فتح تفاصيل الحساب (دفتر الأستاذ)
          },
        ),
      );
    } else {
      // إذا كان له أبناء -> هو حساب رئيسي (Parent)
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.grey[50],
          leading: Icon(Icons.folder, color: account.typeColor),
          title: Text("${account.code} - ${account.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
          children: children.map((child) => _buildAccountNode(child)).toList(),
        ),
      );
    }
  }

  // --- وضع العرض المسطح (عند البحث) ---
  Widget _buildFlatList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _displayedAccounts.length,
      separatorBuilder: (ctx, i) => const Divider(),
      itemBuilder: (context, index) {
        final account = _displayedAccounts[index];
        return ListTile(
          leading: Text(account.code, style: TextStyle(fontWeight: FontWeight.bold, color: account.typeColor)),
          title: Text(account.name),
          subtitle: Text(_getAccountTypeName(account.type)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        );
      },
    );
  }

  String _getAccountTypeName(AccountType type) {
    switch (type) {
      case AccountType.asset: return "أصول";
      case AccountType.liability: return "خصوم";
      case AccountType.equity: return "حقوق ملكية";
      case AccountType.income: return "إيرادات";
      case AccountType.expense: return "مصروفات";
      case AccountType.offBalance: return "خارج الميزانية";
    }
  }
}