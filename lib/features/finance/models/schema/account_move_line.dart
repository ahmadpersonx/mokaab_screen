// FileName: lib/features/finance/models/schema/account_move_line.dart
class AccountMoveLine {
  final String id;
  final String moveId; // FK: رابط مع القيد الرئيسي
  final String name;   // البيان / الشرح
  
  // --- الأطراف المالية ---
  final String accountId; // FK: الحساب المالي (GL Account)
  final String? partnerId; // FK: العميل أو المورد
  final String? costCenterId; // FK: مركز التكلفة (للمشاريع/الفروع)

  // --- القيم المالية ---
  final double debit;
  final double credit;
  final double balance; // (محسوب: debit - credit)
  final double amountCurrency; // المبلغ بالعملة الأصلية
  final String currencyId;
  
  // --- إدارة الديون والتسويات (SAP/Odoo Logic) ---
  final double amountResidual; // المبلغ المتبقي (للفواتير غير المدفوعة بالكامل)
  final String? matchingNumber; // رقم المطابقة (للتسوية الكاملة)
  final DateTime? dateMaturity; // تاريخ الاستحقاق (للشيكات والفواتير الآجلة)
  
  // --- البيانات الصناعية واللوجستية ---
  final String? productId; // FK: الصنف (حجر، ديزل، خدمة)
  final double quantity;   // الكمية
  final String? uomId;     // وحدة القياس (متر، طن)

  AccountMoveLine({
    required this.id,
    required this.moveId,
    required this.name,
    required this.accountId,
    this.partnerId,
    this.costCenterId,
    this.debit = 0.0,
    this.credit = 0.0,
    this.amountCurrency = 0.0,
    this.currencyId = 'JOD',
    this.amountResidual = 0.0,
    this.matchingNumber,
    this.dateMaturity,
    this.productId,
    this.quantity = 0.0,
    this.uomId,
  }) : balance = debit - credit;
}