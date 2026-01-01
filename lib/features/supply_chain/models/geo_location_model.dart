// FileName: lib/features/supply_chain/models/geo_location_model.dart
// Version: 1.0
// Description: نموذج المواقع الجغرافية (محاجر، مشاريع، معارض) مع بيانات ذكية

import 'package:flutter/material.dart';

enum GeoLocationType {
  quarry,       // محجر (Source) - يحتاج ترخيص تعدين
  factorySite,  // موقع مصنع (Processing) - منطقة صناعية
  showroom,     // معرض تجاري (Sales Point)
  projectSite,  // موقع عميل/مشروع (Delivery Point)
  exportPort,   // ميناء تصدير (Logistics)
  adminOffice   // مكتب إداري
}

class GeoLocation {
  final String id;
  final String name;
  final String code; // e.g., LOC-AMM-01
  final GeoLocationType type;
  
  // --- Metadata: لوجستي وجغرافي ---
  final String addressText;
  final String gpsCoordinates; // "31.9539, 35.9106"
  final double geofenceRadius; // نصف قطر النطاق الجغرافي (لضبط دوام الموظفين وحركة الشاحنات)
  final String city;
  
  // --- Metadata: مالي وقانوني ---
  final String costCenterId; // مركز التكلفة (لتحميل المصاريف)
  final String licenseNumber; // رقم رخصة المهن / رخصة التعدين
  final DateTime? licenseExpiry; // تاريخ انتهاء الترخيص
  final String managerName; // مدير الموقع

  GeoLocation({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.addressText,
    this.gpsCoordinates = '',
    this.geofenceRadius = 500.0, // 500 متر افتراضي
    this.city = '',
    this.costCenterId = 'CC-GEN',
    this.licenseNumber = '',
    this.licenseExpiry,
    this.managerName = 'غير محدد',
  });

  // هل الترخيص منتهي؟
  bool get isLicenseExpired => licenseExpiry != null && DateTime.now().isAfter(licenseExpiry!);

  Color get typeColor {
    switch (type) {
      case GeoLocationType.quarry: return Colors.brown;
      case GeoLocationType.factorySite: return Colors.blueGrey;
      case GeoLocationType.showroom: return Colors.purple;
      case GeoLocationType.projectSite: return Colors.orange;
      case GeoLocationType.exportPort: return Colors.teal;
      case GeoLocationType.adminOffice: return Colors.indigo;
    }
  }

  String get typeName {
    switch (type) {
      case GeoLocationType.quarry: return "محجر / مقلع";
      case GeoLocationType.factorySite: return "موقع صناعي";
      case GeoLocationType.showroom: return "معرض تجاري";
      case GeoLocationType.projectSite: return "موقع مشروع (عميل)";
      case GeoLocationType.exportPort: return "ميناء / منطقة حرة";
      case GeoLocationType.adminOffice: return "مكتب إداري";
    }
  }
}