// FileName: lib/features/hr/data/models/employee_model.dart
// Description: النموذج الشامل لبيانات الموظف (Master Data)
// Version: 1.0

import 'package:flutter/material.dart';

// حالات الموظف
enum EmployeeStatus { active, onLeave, suspended, terminated, probation }

class Employee {
  // --- 1. المعلومات الأساسية (Basic Info) ---
  final String id;
  final String employeeCode; // مثال: EMP-2024-001
  final String fullNameAr;
  final String fullNameEn;
  final String? profilePictureUrl;
  final EmployeeStatus status;
  final String gender; // Male/Female
  final DateTime dateOfBirth;
  final String nationalityId; // مربوط بقائمة الجنسيات (لو وجدت) أو نص
  final String nationalIdNumber; // الرقم الوطني/الإقامة

  // --- 2. معلومات الاتصال (Contact Info) ---
  final String mobileNumber;
  final String email;
  final String address;
  final String emergencyContactName;
  final String emergencyContactPhone;

  // --- 3. معلومات العمل (Work Info - From Contract & Org Structure) ---
  final String contractId; // ربط بالعقد
  final DateTime joinDate;
  final DateTime? probationEndDate;
  final String departmentId; // مربوط بـ LookupCategory.departments
  final String sectionId;    // مربوط بـ LookupCategory.sections
  final String? unitId;      // مربوط بـ LookupCategory.units
  final String jobTitleId;   // مربوط بـ LookupCategory.jobTitles
  final String jobLevelId;   // مربوط بـ LookupCategory.jobLevels
  final String? directManagerId; // ID للمدير المباشر
  final String workLocationId; // مربوط بـ LookupCategory.locations
  final String shiftId;      // مربوط بـ LookupCategory.shifts

  // --- 4. المعلومات المالية (Financial Info) ---
  final double basicSalary;
  final Map<String, double> allowances; // Key: AllowanceID, Value: Amount
  final String paymentMethodId; // مربوط بـ LookupCategory.paymentMethods
  final String? bankName;
  final String? ibanNumber;
  final String? socialSecurityNumber;

  // --- 5. القوائم الفرعية (Sub-Lists) ---
  final List<EmployeeDocument> documents;
  final List<EmployeeCustody> custodies;
  final List<EmployeeLeaveBalance> leaveBalances;

  Employee({
    required this.id,
    required this.employeeCode,
    required this.fullNameAr,
    required this.fullNameEn,
    this.profilePictureUrl,
    this.status = EmployeeStatus.active,
    required this.gender,
    required this.dateOfBirth,
    required this.nationalityId,
    required this.nationalIdNumber,
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.contractId,
    required this.joinDate,
    this.probationEndDate,
    required this.departmentId,
    required this.sectionId,
    this.unitId,
    required this.jobTitleId,
    required this.jobLevelId,
    this.directManagerId,
    required this.workLocationId,
    required this.shiftId,
    required this.basicSalary,
    this.allowances = const {},
    required this.paymentMethodId,
    this.bankName,
    this.ibanNumber,
    this.socialSecurityNumber,
    this.documents = const [],
    this.custodies = const [],
    this.leaveBalances = const [],
  });

  // Helper: لحساب الراتب الإجمالي
  double get totalSalary {
    double totalAllowances = allowances.values.fold(0, (sum, amount) => sum + amount);
    return basicSalary + totalAllowances;
  }
}

// --- كلاسات فرعية للملفات والعهد ---

class EmployeeDocument {
  final String id;
  final String documentTypeId; // مربوط بـ LookupCategory.documentTypes
  final String documentNumber;
  final DateTime? expiryDate;
  final String? fileUrl; // رابط الصورة/الملف
  final bool isVerified;

  EmployeeDocument({
    required this.id,
    required this.documentTypeId,
    required this.documentNumber,
    this.expiryDate,
    this.fileUrl,
    this.isVerified = false,
  });

  // هل الوثيقة منتهية الصلاحية؟
  bool get isExpired => expiryDate != null && expiryDate!.isBefore(DateTime.now());
  
  // هل ستنتهي قريباً؟ (تنبيه قبل 30 يوم)
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final diff = expiryDate!.difference(DateTime.now()).inDays;
    return diff >= 0 && diff <= 30;
  }
}

class EmployeeCustody {
  final String id;
  final String custodyTypeId; // مربوط بـ LookupCategory.custodyTypes
  final String itemName; // وصف إضافي (مثلاً: لابتوب Dell XPS)
  final String? serialNumber;
  final DateTime receivedDate;
  final String condition; // New, Used, Damaged

  EmployeeCustody({
    required this.id,
    required this.custodyTypeId,
    required this.itemName,
    this.serialNumber,
    required this.receivedDate,
    this.condition = 'Good',
  });
}

class EmployeeLeaveBalance {
  final String leaveTypeId; // مربوط بـ LookupCategory.leaveTypes
  final double totalDays; // الرصيد السنوي المستحق
  final double usedDays;  // المستهلك
  
  EmployeeLeaveBalance({
    required this.leaveTypeId,
    required this.totalDays,
    this.usedDays = 0.0,
  });

  double get remainingDays => totalDays - usedDays;
}
