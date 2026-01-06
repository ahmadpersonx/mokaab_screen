// FileName: lib/features/finance/models/invoice_model.dart
import 'package:flutter/material.dart';

enum InvoiceStatus { draft, posted, paid, cancelled }

class InvoiceLine {
  final String product;
  final String accountCode; // حساب الإيرادات المرتبط بالمنتج (مثلاً 4101)
  double quantity;
  double price;
  double taxRate; // 0.16

  InvoiceLine({
    required this.product,
    required this.accountCode,
    this.quantity = 1,
    this.price = 0,
    this.taxRate = 0.16,
  });

  double get subtotal => quantity * price;
  double get taxAmount => subtotal * taxRate;
  double get total => subtotal + taxAmount;
}

class Invoice {
  final String id;
  final String number; // INV/2025/001
  final String customerName;
  final DateTime date;
  InvoiceStatus status;
  List<InvoiceLine> lines;

  Invoice({
    required this.id,
    required this.number,
    required this.customerName,
    required this.date,
    this.status = InvoiceStatus.draft,
    required this.lines,
  });

  double get totalUntaxed => lines.fold(0, (sum, item) => sum + item.subtotal);
  double get totalTax => lines.fold(0, (sum, item) => sum + item.taxAmount);
  double get totalAmount => totalUntaxed + totalTax;

  Color get statusColor {
    switch (status) {
      case InvoiceStatus.draft: return Colors.blueGrey;
      case InvoiceStatus.posted: return Colors.blue;
      case InvoiceStatus.paid: return Colors.green;
      case InvoiceStatus.cancelled: return Colors.red;
    }
  }
  
  String get statusText {
    switch (status) {
      case InvoiceStatus.draft: return "مسودة (Draft)";
      case InvoiceStatus.posted: return "مرحلة (Posted)";
      case InvoiceStatus.paid: return "مدفوعة";
      case InvoiceStatus.cancelled: return "ملغاة";
    }
  }
}