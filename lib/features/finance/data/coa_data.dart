// FileName: lib/features/finance/data/coa_data.dart
// Description: بيانات شجرة الحسابات (محاكاة لما تم رفعه في الملف)

import 'package:mokaab/features/finance/models/account_model.dart';

class ChartOfAccountsData {
  static final List<Account> accounts = [
    // --- 1. الأصول (Assets) ---
    Account(id: '1', code: '1', name: 'الأصول', type: AccountType.asset),
    Account(id: '11', code: '11', name: 'الأصول المتداولة', type: AccountType.asset, parentCode: '1'),
    
    // النقدية وما في حكمها
    Account(id: '1101', code: '1101', name: 'النقدية بالصندوق', type: AccountType.asset, subType: AccountSubType.cash, allowReconciliation: true, parentCode: '11'),
    Account(id: '1102', code: '1102', name: 'البنك العربي - جاري', type: AccountType.asset, subType: AccountSubType.bank, allowReconciliation: true, parentCode: '11'),
    
    // الذمم المدينة (العملاء)
    Account(id: '1103', code: '1103', name: 'الذمم المدينة التجارية', type: AccountType.asset, subType: AccountSubType.receivable, allowReconciliation: true, parentCode: '11'),
    
    // المخزون (ربط مع المستودعات)
    Account(id: '1104', code: '1104', name: 'مخزون المواد الخام', type: AccountType.asset, parentCode: '11'),
    Account(id: '1105', code: '1105', name: 'مخزون المنتج التام', type: AccountType.asset, parentCode: '11'),

    // --- 2. الخصوم (Liabilities) ---
    Account(id: '2', code: '2', name: 'الخصوم', type: AccountType.liability),
    Account(id: '21', code: '21', name: 'الذمم الدائنة (الموردين)', type: AccountType.liability, subType: AccountSubType.payable, allowReconciliation: true, parentCode: '2'),
    Account(id: '22', code: '22', name: 'ضريبة المبيعات المستحقة', type: AccountType.liability, parentCode: '2'),

    // --- 4. الإيرادات (Income) ---
    Account(id: '4', code: '4', name: 'الإيرادات', type: AccountType.income),
    Account(id: '4101', code: '4101', name: 'مبيعات حجر واجهات', type: AccountType.income, parentCode: '4'),
    Account(id: '4102', code: '4102', name: 'مبيعات ديكورات داخلية', type: AccountType.income, parentCode: '4'),

    // --- 5. المصروفات (Expenses) ---
    Account(id: '5', code: '5', name: 'المصروفات', type: AccountType.expense),
    Account(id: '5101', code: '5101', name: 'تكلفة البضاعة المباعة (COGS)', type: AccountType.expense, parentCode: '5'),
    Account(id: '5201', code: '5201', name: 'رواتب وأجور', type: AccountType.expense, parentCode: '5'),
    Account(id: '5202', code: '5202', name: 'مصاريف كهرباء وماء', type: AccountType.expense, parentCode: '5'),
  ];

  // دالة لجلب الحساب بالكود (ستستخدم كثيراً في المحرك)
  static Account? getAccountByCode(String code) {
    try {
      return accounts.firstWhere((acc) => acc.code == code);
    } catch (e) {
      return null;
    }
  }
}