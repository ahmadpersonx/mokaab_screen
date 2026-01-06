// FileName: lib/features/finance/models/schema/account_move.dart
enum MoveState { draft, posted, cancelled }
enum MoveType { entry, out_invoice, in_invoice, out_receipt, in_receipt } // لتحديد نوع الوثيقة الأصلية

class AccountMove {
  final String id;
  final String name; // الرقم المتسلسل (JRN/2025/001)
  final DateTime date;
  final String ref; // مرجع خارجي (رقم فاتورة المورد)
  final String journalId; // نوع الدفتر (مبيعات، بنك، مخزون...)
  final MoveState state;
  final MoveType type; 
  final bool autoReverse; // هل هو قيد عكسي؟

  AccountMove({
    required this.id,
    required this.name,
    required this.date,
    this.ref = '',
    required this.journalId,
    this.state = MoveState.draft,
    this.type = MoveType.entry,
    this.autoReverse = false,
  });
}