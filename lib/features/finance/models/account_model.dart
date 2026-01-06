// FileName: lib/features/finance/models/account_model.dart
// Description: نموذج الحساب المالي (يتطابق مع شجرة الحسابات المرفقة)

import 'package:flutter/material.dart';

// أنواع الحسابات الرئيسية (للتصنيف في الميزانية وقائمة الدخل)
enum AccountType {
  asset,        // أصول (1)
  liability,    // خصوم (2)
  equity,       // حقوق ملكية (3)
  income,       // إيرادات (4)
  expense,      // مصروفات (5)
  offBalance    // خارج الميزانية (نظامي)
}

// النوع الفرعي (هام جداً للأتمتة في Odoo/SAP)
// مثال: إذا كان النوع "ذمم مدينة"، النظام يعرف أنه يجب اختيار "عميل" عند القيد
enum AccountSubType {
  none,         // عادي
  receivable,   // ذمم مدينة (عملاء)
  payable,      // ذمم دائنة (موردين)
  bank,         // بنك (للشيكات والتسوية)
  cash,         // صندوق
}

class Account {
  final String id;
  final String code; // رقم الحساب (مثلاً: 110101)
  final String name; // اسم الحساب
  final AccountType type;
  final AccountSubType subType;
  final bool allowReconciliation; // هل يقبل التسوية؟ (للعملاء والموردين والبنوك)
  final String? parentCode; // الحساب الأب (لعمل شجرة هرمية)
  
  // الرصيد الحالي (يتم تحديثه بالحركات)
  double currentBalance; 

  Account({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    this.subType = AccountSubType.none,
    this.allowReconciliation = false,
    this.parentCode,
    this.currentBalance = 0.0,
  });

  // Helper: لتحديد اللون حسب النوع في التقارير
  Color get typeColor {
    switch (type) {
      case AccountType.asset: return Colors.teal;
      case AccountType.liability: return Colors.redAccent;
      case AccountType.equity: return Colors.indigo;
      case AccountType.income: return Colors.green;
      case AccountType.expense: return Colors.orange;
      default: return Colors.grey;
    }
  }
}