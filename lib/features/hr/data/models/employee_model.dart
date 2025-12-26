// FileName: lib/features/hr/data/models/employee_model.dart
// Description: النموذج الشامل لبيانات الموظف (Master Data Model)
// Version: 1.1 (Updated for Validation)

enum EmployeeStatus { active, onLeave, suspended, terminated, probation }

class Employee {
  // --- 1. المعلومات الأساسية (Basic Info) ---
  final String id;
  final String employeeCode; 
  final String fullNameAr;
  final String fullNameEn;
  final String? profilePictureUrl;
  final EmployeeStatus status;
  final String gender; 
  final DateTime dateOfBirth;
  final String nationalityId; 
  final String nationalIdNumber; 

  // --- 2. معلومات الاتصال (Contact Info) ---
  final String mobileNumber;
  final String email;
  final String address;
  final String emergencyContactName;
  final String emergencyContactPhone;

  // --- 3. معلومات العمل (Work Info) ---
  final String contractId; 
  final DateTime joinDate;
  final DateTime? probationEndDate;
  final String departmentId; 
  final String sectionId;    
  final String? unitId;      
  final String jobTitleId;   
  final String jobLevelId;   
  final String? directManagerId; 
  final String workLocationId; 
  final String shiftId;      

  // --- 4. المعلومات المالية (Financial Info) ---
  final double basicSalary;
  final Map<String, double> allowances; 
  final String paymentMethodId; 
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

  double get totalSalary {
    double totalAllowances = allowances.values.fold(0, (sum, amount) => sum + amount);
    return basicSalary + totalAllowances;
  }
}

// --- كلاسات فرعية للملفات والعهد ---

class EmployeeDocument {
  final String id;
  final String documentTypeId; 
  final String documentNumber;
  final DateTime? expiryDate;
  final String? fileUrl; 
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
  final String custodyTypeId; 
  final String itemName; 
  final String? serialNumber;
  final DateTime receivedDate;
  final String condition; 

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
  final String leaveTypeId; 
  final double totalDays; 
  final double usedDays;  
  
  EmployeeLeaveBalance({
    required this.leaveTypeId,
    required this.totalDays,
    this.usedDays = 0.0,
  });

  double get remainingDays => totalDays - usedDays;
}