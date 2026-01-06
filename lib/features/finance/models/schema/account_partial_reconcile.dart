// FileName: lib/features/finance/models/schema/account_partial_reconcile.dart
class AccountPartialReconcile {
  final String id;
  final String debitMoveId;  // معرف السطر المدين (مثلاً: سطر الفاتورة للعميل)
  final String creditMoveId; // معرف السطر الدائن (مثلاً: سطر سند القبض)
  final double amount;       // المبلغ الذي تم تسويته (مثلاً 500 من أصل 1000)
  final double amountCurrency; // المبلغ بالعملة الأجنبية (إذا وجد)
  final String currencyId;   // كود العملة
  final DateTime date;       // تاريخ التسوية

  AccountPartialReconcile({
    required this.id,
    required this.debitMoveId,
    required this.creditMoveId,
    required this.amount,
    this.amountCurrency = 0.0,
    this.currencyId = 'JOD',
    required this.date,
  });
}