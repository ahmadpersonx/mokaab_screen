// FileName: lib/features/finance/data/journal_seed_data.dart
import 'package:mokaab/features/finance/models/schema/account_move.dart';
import 'package:mokaab/features/finance/models/schema/account_move_line.dart';
import 'package:mokaab/features/finance/models/schema/account_partial_reconcile.dart';

class JournalSeedData {
  
  // --- 1. السيناريو الصناعي (Manufacturing): تحويل مواد خام إلى إنتاج تحت التشغيل ---
  // الهدف: نقل تكلفة "الإسمنت" من المخزون إلى مركز تكلفة "المصنع"
  static final AccountMove manufacturingMove = AccountMove(
    id: 'MOV-001', name: 'MFG/2025/001', date: DateTime.now(),
    journalId: 'manufacturing', // دفتر التصنيع
    state: MoveState.posted,
    ref: 'MO-1005', // رقم أمر التصنيع
  );

  static final List<AccountMoveLine> manufacturingLines = [
    // المدين: حساب إنتاج تحت التشغيل (WIP)
    AccountMoveLine(
      id: 'L1', moveId: 'MOV-001', name: 'استهلاك إسمنت لطلبية 1005',
      accountId: '110600', // حساب WIP
      costCenterId: 'CC-FACTORY-A', // مركز التكلفة: المصنع أ
      debit: 500.0, credit: 0.0,
      productId: 'PROD-CEMENT', quantity: 5.0, uomId: 'Ton', // 5 طن
    ),
    // الدائن: حساب مخزون المواد الخام
    AccountMoveLine(
      id: 'L2', moveId: 'MOV-001', name: 'صرف مخزني',
      accountId: '110400', // مخزون مواد خام
      debit: 0.0, credit: 500.0,
      productId: 'PROD-CEMENT', quantity: 5.0, uomId: 'Ton',
    ),
  ];

  // --- 2. السيناريو التجاري (Commercial): فاتورة مبيعات لمشروع ---
  // الهدف: بيع حجر + إثبات المديونية + ربط بالمشروع
  static final AccountMove invoiceMove = AccountMove(
    id: 'MOV-002', name: 'INV/2025/099', date: DateTime.now().subtract(const Duration(days: 5)),
    journalId: 'sales', // دفتر المبيعات
    state: MoveState.posted,
    type: MoveType.out_invoice,
  );

  static final List<AccountMoveLine> invoiceLines = [
    // المدين: العميل (مطلوب منه 1160 دينار)
    AccountMoveLine(
      id: 'L3_INV', moveId: 'MOV-002', name: 'فاتورة مبيعات 099',
      accountId: '110300', // ذمم مدينة
      partnerId: 'CUST-EMAAR', // شركة الإعمار
      costCenterId: 'PROJ-ABDALI', // مشروع العبدلي (للتحليل)
      debit: 1160.0, credit: 0.0,
      amountResidual: 660.0, // <-- لاحظ: باقي عليه 660 (تم سداد 500 لاحقاً)
    ),
    // الدائن: المبيعات
    AccountMoveLine(
      id: 'L4_SALES', moveId: 'MOV-002', name: 'حجر واجهات معان',
      accountId: '410100', // مبيعات
      costCenterId: 'PROJ-ABDALI',
      debit: 0.0, credit: 1000.0,
      productId: 'STONE-MAAN', quantity: 100.0, uomId: 'm2', // 100 متر
    ),
    // الدائن: الضريبة
    AccountMoveLine(
      id: 'L5_TAX', moveId: 'MOV-002', name: 'ضريبة 16%',
      accountId: '210500',
      debit: 0.0, credit: 160.0,
    ),
  ];

  // --- 3. السيناريو المالي (Payment): سداد جزئي للفاتورة أعلاه ---
  // الهدف: قبض 500 دينار وتسويتها مع الفاتورة
  static final AccountMove paymentMove = AccountMove(
    id: 'MOV-003', name: 'PAY/2025/050', date: DateTime.now(),
    journalId: 'bank', // دفتر البنك
    state: MoveState.posted,
    ref: 'CHK-9988',
  );

  static final List<AccountMoveLine> paymentLines = [
    // المدين: البنك
    AccountMoveLine(
      id: 'L6_BANK', moveId: 'MOV-003', name: 'قبض شيك',
      accountId: '110200', // بنك
      debit: 500.0, credit: 0.0,
    ),
    // الدائن: العميل (تخفيض الذمة)
    AccountMoveLine(
      id: 'L7_PAY', moveId: 'MOV-003', name: 'سداد جزئي للفاتورة INV/2025/099',
      accountId: '110300', // نفس حساب الذمم
      partnerId: 'CUST-EMAAR',
      costCenterId: 'PROJ-ABDALI', // لضبط الكاش فلو للمشروع
      debit: 0.0, credit: 500.0,
      amountResidual: 0.0, // هذا السطر استهلك بالكامل
    ),
  ];

  // --- 4. جدول الربط (Reconciliation): السحر الحقيقي ---
  // يخبرنا أن الـ 500 دينار في السند (L7) ذهبت لسداد جزء من الفاتورة (L3)
  static final List<AccountPartialReconcile> reconciliations = [
    AccountPartialReconcile(
      id: 'REC-001',
      debitMoveId: 'L3_INV',  // سطر الفاتورة (الذي كان مديناً)
      creditMoveId: 'L7_PAY', // سطر السند (الذي أصبح دائناً)
      amount: 500.0,          // المبلغ المسدد
      date: DateTime.now(),
    ),
  ];
}