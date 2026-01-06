// FileName: lib/features/finance/models/journal_entry_model.dart
// Version: 3.0 (Full ERP Industrial Structure)
// Description: نموذج القيود اليومية الشامل (رأس وأسطر) متوافق مع معايير Odoo و SAP

import 'package:mokaab/features/finance/models/account_model.dart';

// --- 1. Enumerations (القوائم الثابتة) ---

/// حالة القيد المحاسبي
enum EntryState {
  draft,    // مسودة (قابل للتعديل، لا يؤثر على التقارير النهائية)
  posted,   // مرحل (نهائي، يؤثر على الحسابات، لا يمكن حذفه)
  cancelled // ملغى (يحتفظ به للأرشفة والتدقيق)
}

/// نوع الدفتر المحاسبي (لتصنيف العمليات)
enum JournalType {
  sale,           // مبيعات (فواتير عملاء)
  purchase,       // مشتريات (فواتير موردين)
  cash,           // نقدية (صندوق)
  bank,           // بنك (شيكات وحوالات)
  inventory,      // مخزون (حركات المواد والبضاعة)
  manufacturing,  // تصنيع (قيود التكاليف الصناعية)
  general,        // قيود عامة (تسويات، إهلاك)
  salaries,       // رواتب وأجور
  opening,        // أرصدة افتتاحية
  exchangeDiff    // فروقات عملة
}

/// نوع الوثيقة الأصلية (لتحديد مصدر القيد)
enum MoveType {
  entry,        // قيد يدوي
  outInvoice,   // فاتورة مبيعات
  inInvoice,    // فاتورة مشتريات
  outReceipt,   // سند قبض
  inReceipt     // سند صرف
}

// --- 2. سطر القيد (The Detailed Line) - العقل المدبر ---
/// يمثل السطر الواحد في القيد (مدين أو دائن) ويحوي كافة الأبعاد التحليلية
class JournalItem {
  final String id;
  final String moveId; // ربط مع رأس القيد (Foreign Key)

  // --- الأبعاد المالية (Financial Dimensions) ---
  final Account account;        // الحساب المالي (GL Account) - "ماذا؟"
  final String? partnerId;      // الشريك (عميل/مورد) - "من؟"
  final String? costCenterId;   // مركز التكلفة/المشروع - "أين/لمن؟"

  // --- القيم المالية (Values) ---
  final double debit;           // مدين (عملة محلية)
  final double credit;          // دائن (عملة محلية)
  final double balance;         // (محسوب: مدين - دائن) لتسريع العمليات
  final double amountCurrency;  // المبلغ بالعملة الأجنبية
  final String? currencyCode;   // كود العملة (USD, EUR)

  // --- إدارة الديون والتسويات (Reconciliation Logic) ---
  final double amountResidual;  // المبلغ المتبقي للسداد (للفواتير)
  final String? matchingNumber; // رقم المطابقة (عند التسوية الكاملة)
  final DateTime? dateMaturity; // تاريخ الاستحقاق (للشيكات/الذمم)

  // --- البيانات الصناعية واللوجستية (Industrial Data) ---
  final String? productId;      // المنتج المرتبط (لتحليل ربحية الصنف)
  final double quantity;        // الكمية (لتحليل تكلفة الوحدة)
  final String? uomId;          // وحدة القياس (طن، متر)
  
  // --- بيانات إضافية ---
  final String label;           // البيان / الشرح
  final String? taxLineId;      // معرف السطر الضريبي (للإقرارات)

  JournalItem({
    required this.id,
    this.moveId = '', // يتم تعيينه لاحقاً عند الحفظ
    required this.account,
    this.partnerId,
    this.costCenterId,
    this.debit = 0.0,
    this.credit = 0.0,
    this.amountCurrency = 0.0,
    this.currencyCode,
    this.amountResidual = 0.0,
    this.matchingNumber,
    this.dateMaturity,
    this.productId,
    this.quantity = 0.0,
    this.uomId,
    this.label = '',
    this.taxLineId,
  }) : balance = debit - credit; // الحساب التلقائي للرصيد

  // التحقق من صحة السطر (يجب أن يكون مديناً أو دائناً، وليس الاثنين معاً)
  bool get isValid => (debit > 0 && credit == 0) || (credit > 0 && debit == 0) || (debit == 0 && credit == 0);
}

// --- 3. رأس القيد (The Header) ---
/// يمثل الغلاف الذي يجمع الأسطر ويعطيها هوية قانونية وتسلسلية
class JournalEntry {
  final String id;
  final String name;          // الرقم المتسلسل (JRN/2026/001) - يتولد عند الترحيل
  final String ref;           // المرجع الخارجي (رقم فاتورة المورد، رقم الشيك)
  final DateTime date;        // تاريخ الاستحقاق المحاسبي
  final JournalType journalType; // نوع الدفتر (مبيعات، بنك...)
  final EntryState state;     // حالة القيد (مسودة، مرحل)
  final MoveType moveType;    // نوع الحركة الأصلية
  final bool autoReverse;     // هل هو قيد عكسي آلي؟
  final List<JournalItem> lines; // قائمة الأسطر التفصيلية
  
  // معلومات التدقيق (Audit Info)
  final String createdBy;     // اسم المستخدم الذي أنشأ القيد
  final DateTime createdAt;   // وقت الإنشاء الفعلي

  JournalEntry({
    required this.id,
    required this.name,
    this.ref = '',
    required this.date,
    required this.journalType,
    this.state = EntryState.draft,
    this.moveType = MoveType.entry,
    this.autoReverse = false,
    required this.lines,
    this.createdBy = 'System',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // --- دوال مساعدة (Helper Getters) ---

  // إجمالي المدين
  double get totalDebit => lines.fold(0.0, (sum, item) => sum + item.debit);

  // إجمالي الدائن
  double get totalCredit => lines.fold(0.0, (sum, item) => sum + item.credit);

  // التحقق من توازن القيد (شرط أساسي للترحيل)
  bool get isBalanced {
    // نسمح بفرق تقريب بسيط جداً (0.01) لتجنب مشاكل الفواصل العشرية
    return (totalDebit - totalCredit).abs() < 0.01;
  }

  // الحصول على اسم الدفتر بالعربية للعرض في الواجهة
  String get journalLabel {
    switch (journalType) {
      case JournalType.sale: return "مبيعات (INV)";
      case JournalType.purchase: return "مشتريات (BILL)";
      case JournalType.cash: return "صندوق (CSH)";
      case JournalType.bank: return "بنك (BNK)";
      case JournalType.inventory: return "مخزون (STK)";
      case JournalType.manufacturing: return "تصنيع (MFG)";
      case JournalType.general: return "قيود عامة (MISC)";
      case JournalType.salaries: return "رواتب (PAY)";
      case JournalType.opening: return "افتتاحي (OPEN)";
      case JournalType.exchangeDiff: return "فروقات عملة (EXCH)";
    }
  }
}