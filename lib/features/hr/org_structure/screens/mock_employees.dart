// FileName: lib/features/hr/data/models/mock_employees.dart
// Description: نموذج بيانات الموظفين مع بيانات وهمية للمحاكاة

import 'package:flutter/material.dart';

enum EmployeeStatus { active, onLeave, archived }

class Employee {
  final String id;
  final String name;
  final String jobTitle;
  final String department;
  final String managerName;
  final String email;
  final String phone;
  final String imageUrl; // يمكن استخدام ألوان أو أيقونات حالياً
  final EmployeeStatus status;
  final int contractCount;
  final int leaveBalance;
  final double lastEvaluation;

  Employee({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.department,
    required this.managerName,
    required this.email,
    required this.phone,
    this.imageUrl = '',
    required this.status,
    this.contractCount = 1,
    this.leaveBalance = 21,
    this.lastEvaluation = 4.5,
  });
}

// --- بيانات وهمية ---
List<Employee> mockEmployees = [
  Employee(
    id: 'EMP-001',
    name: 'محمد أحمد',
    jobTitle: 'مدير الإنتاج',
    department: 'إدارة الإنتاج',
    managerName: 'أحمد المدير',
    email: 'm.ahmed@mokaab.com',
    phone: '0501234567',
    status: EmployeeStatus.active,
    contractCount: 2,
  ),
  Employee(
    id: 'EMP-002',
    name: 'سارة علي',
    jobTitle: 'محاسب أول',
    department: 'المالية',
    managerName: 'سمير الحسابات',
    email: 's.ali@mokaab.com',
    phone: '0509876543',
    status: EmployeeStatus.active,
    leaveBalance: 14,
  ),
  Employee(
    id: 'EMP-003',
    name: 'خالد العتيبي',
    jobTitle: 'فني قص',
    department: 'قسم القص والتفصيل',
    managerName: 'سعيد القصاص',
    email: 'k.otaibi@mokaab.com',
    phone: '0555555555',
    status: EmployeeStatus.onLeave,
    leaveBalance: 0,
  ),
];

Color getStatusColor(EmployeeStatus status) {
  if (status == EmployeeStatus.active) return Colors.green;
  if (status == EmployeeStatus.onLeave) return Colors.orange;
  return Colors.grey;
}