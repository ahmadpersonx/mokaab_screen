// FileName: lib/features/finance/models/payment_model.dart
import 'package:flutter/material.dart';

enum PaymentMethod {
  cash,           // نقد (يذهب للصندوق)
  bankTransfer,   // حوالة (تذهب للبنك مباشرة)
  checkCurrent,   // شيك حال / مستحق الصرف (شيكات برسم التحصيل)
  checkPostDated  // شيك مؤجل (أوراق قبض / شيكات آجلة)
}

// سطر طريقة الدفع (يمكن أن يحتوي السند على أكثر من سطر)
class PaymentLine {
  final PaymentMethod method;
  final double amount;
  final String reference; // رقم الشيك أو الحوالة
  final String bankName; // اسم البنك (للشيكات)
  final DateTime? dueDate; // تاريخ الاستحقاق (للشيكات المؤجلة)

  PaymentLine({
    required this.method,
    required this.amount,
    this.reference = '',
    this.bankName = '',
    this.dueDate,
  });

  // تحديد الحساب المالي بناءً على الطريقة (Logic Mapping)
  String get targetAccountCode {
    switch (method) {
      case PaymentMethod.cash: return '1101'; // الصندوق
      case PaymentMethod.bankTransfer: return '1102'; // البنك الجاري
      case PaymentMethod.checkCurrent: return '1106'; // شيكات برسم التحصيل (تحت التسوية)
      case PaymentMethod.checkPostDated: return '1107'; // شيكات برسم التحصيل المؤجلة
    }
  }

  String get methodLabel {
    switch (method) {
      case PaymentMethod.cash: return "نقد (Cash)";
      case PaymentMethod.bankTransfer: return "حوالة بنكية";
      case PaymentMethod.checkCurrent: return "شيك حال";
      case PaymentMethod.checkPostDated: return "شيك مؤجل";
    }
  }
}

class PaymentReceipt {
  final String id;
  final String number; // REC/2025/001
  final String customerName;
  final DateTime date;
  String status; // Draft, Posted
  List<PaymentLine> lines;

  PaymentReceipt({
    required this.id,
    required this.number,
    required this.customerName,
    required this.date,
    this.status = 'Draft',
    required this.lines,
  });

  double get totalAmount => lines.fold(0, (sum, item) => sum + item.amount);
}