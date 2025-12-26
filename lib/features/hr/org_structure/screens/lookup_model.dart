import 'package:flutter/material.dart';

enum LookupCategory {
  // 1. الهيكل التنظيمي
  departments,      // الدوائر
  sections,         // الأقسام
  locations,        // مواقع العمل (المصنع الرئيسي، المحجر، المعرض)
  
  // 2. التوظيف والمهن
  jobTitles,        // المسميات الوظيفية
  jobLevels,        // الدرجات الوظيفية (سلم الرواتب)
  contractTypes,    // أنواع العقود
  terminationReasons, // أسباب إنهاء الخدمة
  
  // 3. الوقت والحضور
  shifts,           // الورديات
  leaveTypes,       // أنواع الإجازات
  attendanceStatus, // حالات الحضور (حضور، غياب، تأخير)
  
  // 4. الرواتب والمالية
  allowanceTypes,   // أنواع البدلات (بدل غبار، بدل خطورة)
  deductionTypes,   // أنواع الخصومات
  paymentMethods,   // طرق الدفع
  
  // 5. الوثائق والمستندات
  documentTypes,    // أنواع الوثائق (جواز، هوية، رخصة قيادة ونش)
  visaTypes,        // أنواع التأشيرات (للعمالة الوافدة)
  
  // 6. التقييم والمهارات
  skillTypes,       // المهارات (قص، جلي، صيانة)
}

class LookupItem {
  final String id;
  String name;
  String code;       // للكود البرمجي والربط
  final String? description;
  bool isActive;
  
  // خصائص بصرية (UI)
  final Color? color;      // يستخدم في التقويم والرسوم البيانية
  final IconData? icon;    // أيقونة تمثيلية
  
  // خصائص وظيفية (Logic)
  // مثال: للإجازات {'isPaid': true}, للورديات {'hours': 8}
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