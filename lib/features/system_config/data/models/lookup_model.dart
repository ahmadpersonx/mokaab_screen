// FileName: lib/features/system_config/data/models/lookup_model.dart
import 'package:flutter/material.dart';

enum LookupCategory {
  // 1. الهيكل والأساسيات
  departments, sections,units, locations,
  
  // 2. التوظيف والعقود
  jobTitles, jobLevels, contractTypes, terminationReasons,
  
  // 3. الدوام والحضور
  shifts, leaveTypes, attendanceStatus,
  
  // 4. المالية
  allowanceTypes, deductionTypes, paymentMethods, rewardTypes, // تمت إضافة rewardTypes
  
  // 5. المستندات والقانونية
  documentTypes, visaTypes,
  
  // 6. المهارات والمهام
  skillTypes, standardTasks,
  
  // 7. قوائم صناعية جديدة (تمت إضافتها)
  safetyTools,      // أدوات السلامة
  custodyTypes,     // أنواع العهد
  violationTypes,   // أنواع المخالفات
  evaluationCriteria // معايير التقييم
}

class LookupItem {
  final String id;
  String name; 
  String code; 
  final String? description;
  bool isActive; 
  final Color? color;
  final IconData? icon;
  final Map<String, dynamic>? metaData;

  LookupItem({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.isActive = true,
    this.color,
    this.icon,
    this.metaData,
  });
}