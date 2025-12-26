// FileName: lib/features/hr/org_structure/data/mock_departments.dart
// Description: نموذج بيانات الأقسام مع بيانات وهمية للمحاكاة

import 'package:flutter/material.dart';

enum DepartmentStatus { active, archived }

class Department {
  final String id;
  final String name;
  final String managerName;
  final String? parentDept; // القسم الأب
  final int employeeCount;
  final int openJobs;
  final double totalExpenses; // للمحاكاة المالية
  final String costCenter; // مركز التكلفة
  final DepartmentStatus status; // الحالة
  final String description; // الوصف والمهام
  final Color color; // لتمييز البطاقات

  Department({
    required this.id,
    required this.name,
    required this.managerName,
    this.parentDept,
    required this.employeeCount,
    required this.openJobs,
    required this.totalExpenses,
    required this.costCenter,
    this.status = DepartmentStatus.active,
    this.description = '',
    required this.color,
  });
}

// --- بيانات وهمية تحاكي شركة مكعب للحجر الصناعي ---
List<Department> mockDepartments = [
  Department(
    id: '1',
    name: 'الإدارة العامة',
    managerName: 'أحمد المدير',
    parentDept: null,
    employeeCount: 5,
    openJobs: 0,
    totalExpenses: 15000.0,
    costCenter: 'CC-100',
    description: 'الإشراف العام على استراتيجية الشركة.',
    color: Colors.blueGrey,
  ),
  Department(
    id: '2',
    name: 'إدارة الإنتاج',
    managerName: 'م. خالد الحجر',
    parentDept: 'الإدارة العامة',
    employeeCount: 45,
    openJobs: 3,
    totalExpenses: 85000.0,
    costCenter: 'CC-200',
    description: 'إدارة عمليات قص ونحت الحجر وتجهيز الطلبيات.',
    color: Colors.orange,
  ),
  Department(
    id: '3',
    name: 'قسم القص والتفصيل',
    managerName: 'سعيد القصاص',
    parentDept: 'إدارة الإنتاج',
    employeeCount: 20,
    openJobs: 2,
    totalExpenses: 32000.0,
    costCenter: 'CC-210',
    color: Colors.orangeAccent,
  ),
  Department(
    id: '4',
    name: 'إدارة المالية والمحاسبة',
    managerName: 'سمير الحسابات',
    parentDept: 'الإدارة العامة',
    employeeCount: 8,
    openJobs: 1,
    totalExpenses: 12000.0,
    costCenter: 'CC-300',
    color: Colors.purple,
  ),
  Department(
    id: '5',
    name: 'المخازن والمستودعات',
    managerName: 'علي المخزن',
    parentDept: 'الإدارة العامة',
    employeeCount: 6,
    openJobs: 0,
    totalExpenses: 8000.0,
    costCenter: 'CC-400',
    status: DepartmentStatus.archived, // مثال على قسم مؤرشف
    color: Colors.teal,
  ),
];