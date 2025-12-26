// FileName: lib/features/hr/payroll/models/payroll_models.dart
import 'package:flutter/material.dart';

enum PayrollStatus { draft, processing, approved, paid }

// 1. نموذج مسير الرواتب الشهري (المجلد الكامل للشهر)
class PayrollRun {
  final String id;
  final String monthName; // e.g., "December 2025"
  final DateTime date;
  final int totalEmployees;
  final double totalAmount;
  PayrollStatus status;

  PayrollRun({
    required this.id,
    required this.monthName,
    required this.date,
    required this.totalEmployees,
    required this.totalAmount,
    this.status = PayrollStatus.draft,
  });

  Color get statusColor {
    switch (status) {
      case PayrollStatus.draft: return Colors.orange;
      case PayrollStatus.processing: return Colors.blue;
      case PayrollStatus.approved: return Colors.purple;
      case PayrollStatus.paid: return Colors.green;
    }
  }

  String get statusText {
    switch (status) {
      case PayrollStatus.draft: return "مسودة";
      case PayrollStatus.processing: return "قيد المعالجة";
      case PayrollStatus.approved: return "معتمد";
      case PayrollStatus.paid: return "مدفوع";
    }
  }
}

// 2. نموذج قسيمة راتب الموظف (التفاصيل)
class SalarySlip {
  final String employeeId;
  final String employeeName;
  final String jobTitle;
  
  // الاستحقاقات (Earnings)
  final double basicSalary;
  final double housingAllowance;
  final double transportAllowance;
  final double overtimeAmount;
  final double bonuses;

  // الاستقطاعات (Deductions)
  final double socialSecurity; // الضمان الاجتماعي
  final double tax; // ضريبة الدخل
  final double absenceDeduction; // خصم الغياب
  final double loanDeduction; // سداد سلف

  SalarySlip({
    required this.employeeId,
    required this.employeeName,
    required this.jobTitle,
    required this.basicSalary,
    this.housingAllowance = 0,
    this.transportAllowance = 0,
    this.overtimeAmount = 0,
    this.bonuses = 0,
    this.socialSecurity = 0,
    this.tax = 0,
    this.absenceDeduction = 0,
    this.loanDeduction = 0,
  });

  double get totalEarnings => basicSalary + housingAllowance + transportAllowance + overtimeAmount + bonuses;
  double get totalDeductions => socialSecurity + tax + absenceDeduction + loanDeduction;
  double get netSalary => totalEarnings - totalDeductions;
}