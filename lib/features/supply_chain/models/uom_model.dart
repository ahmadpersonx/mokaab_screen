// FileName: lib/features/supply_chain/models/uom_model.dart
// Version: 1.0
// Description: نموذج وحدات القياس الذكي (Smart UoM) مع منطق التحويل

import 'package:flutter/material.dart';

// فئات الوحدات (لا يجوز التحويل بين فئات مختلفة)
enum UomCategory {
  unit,    // عدد (حبة، كرتونة، طبلية)
  weight,  // وزن (كغم، طن، غرام)
  length,  // طول (متر، سم، ملم) - لقص الحجر
  volume,  // حجم (متر مكعب، لتر) - للبلوكات والسوائل
  area,    // مساحة (متر مربع) - للمنتج التام (ألواح)
  time     // وقت (ساعة، يوم) - لتأجير المعدات والعمالة
}

// نوع الوحدة بالنسبة للمرجع
enum UomType {
  reference, // الوحدة الأساسية (مثلاً: كغم)
  bigger,    // أكبر من الأساسية (مثلاً: طن = 1000 كغم)
  smaller    // أصغر من الأساسية (مثلاً: غرام = 0.001 كغم)
}

class UnitOfMeasure {
  final String id;
  final String name;
  final String code; // Short code e.g., "kg", "m2"
  final UomCategory category;
  final UomType type;
  final double ratio; // معامل التحويل
  
  // --- Metadata (البيانات الذكية) ---
  final int roundingPrecision; // عدد الخانات العشرية (0.001)
  final String uneceCode; // كود المعيار الدولي (للفوترة الإلكترونية)
  final bool active;

  UnitOfMeasure({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
    required this.type,
    required this.ratio,
    this.roundingPrecision = 2,
    this.uneceCode = '',
    this.active = true,
  });

  // وصف التحويل البشري
  String get conversionDescription {
    if (type == UomType.reference) return "هي الوحدة المرجعية لهذه الفئة";
    if (type == UomType.bigger) return "1 $code = $ratio من الوحدة المرجعية";
    return "1 $code = ${1/ratio} من الوحدة المرجعية"; // للتبسيط
  }

  Color get categoryColor {
    switch (category) {
      case UomCategory.unit: return Colors.blue;
      case UomCategory.weight: return Colors.brown;
      case UomCategory.length: return Colors.green;
      case UomCategory.volume: return Colors.teal;
      case UomCategory.area: return Colors.orange;
      case UomCategory.time: return Colors.purple;
    }
  }

  String get categoryName {
    switch (category) {
      case UomCategory.unit: return "عدد / وحدات";
      case UomCategory.weight: return "وزن / كتلة";
      case UomCategory.length: return "طول / مسافة";
      case UomCategory.volume: return "حجم / سعة";
      case UomCategory.area: return "مساحة";
      case UomCategory.time: return "وقت / زمن";
    }
  }
}