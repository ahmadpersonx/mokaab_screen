// FileName: lib/features/supply_chain/models/fleet_model.dart
// Version: 1.0
// Description: نموذج بيانات الأسطول الشامل (مالي، تشغيلي، قانوني)

import 'package:flutter/material.dart';

enum VehicleType {
  heavyMachinery, // معدات ثقيلة (جرافات، حفارات) - تعمل بالساعات
  truck,          // شاحنات نقل (تريلات) - تعمل بالكيلومتر
  forklift,       // رافعات شوكية (داخلية)
  serviceVehicle, // سيارات خدمات وباصات
  passengerCar    // سيارات إدارية
}

enum FuelType { diesel, petrol, electric, hybrid }

enum VehicleStatus { active, maintenance, outOfService, sold }

class FleetVehicle {
  final String id;
  final String name; // مثال: شاحنة مرسيدس رقم 5
  final String plateNumber; // اللوحة
  final String code; // كود داخلي: TRK-005
  final VehicleType type;
  final VehicleStatus status;

  // --- Metadata: التشغيل واللوجستيات ---
  final String driverName; // السائق المسؤول (عهدة)
  final double currentOdometer; // قراءة العداد الحالي
  final String measureUnit; // كم / ساعة (حسب النوع)
  final FuelType fuelType;
  final double loadCapacity; // طن

  // --- Metadata: القانوني والتأمين ---
  final String licenseNumber; // رقم رخصة المركبة
  final DateTime? licenseExpiryDate; // انتهاء الترخيص
  final DateTime? insuranceExpiryDate; // انتهاء التأمين
  final String insuranceCompany;

  // --- Metadata: المالي ---
  final DateTime purchaseDate;
  final double purchaseValue;
  final String costCenter; // مركز التكلفة (نقل، إنتاج، إدارة)

  FleetVehicle({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.code,
    required this.type,
    this.status = VehicleStatus.active,
    this.driverName = 'غير مخصص',
    this.currentOdometer = 0,
    this.measureUnit = 'Km',
    this.fuelType = FuelType.diesel,
    this.loadCapacity = 0,
    this.licenseNumber = '',
    this.licenseExpiryDate,
    this.insuranceExpiryDate,
    this.insuranceCompany = '',
    required this.purchaseDate,
    this.purchaseValue = 0,
    this.costCenter = 'General',
  });

  // Helper: هل الترخيص منتهي أو قارب على الانتهاء؟
  bool get isLicenseExpiringSoon {
    if (licenseExpiryDate == null) return false;
    final daysLeft = licenseExpiryDate!.difference(DateTime.now()).inDays;
    return daysLeft < 30; // تنبيه قبل شهر
  }

  Color get statusColor {
    switch (status) {
      case VehicleStatus.active: return Colors.green;
      case VehicleStatus.maintenance: return Colors.orange;
      case VehicleStatus.outOfService: return Colors.red;
      case VehicleStatus.sold: return Colors.grey;
    }
  }

  String get typeName {
    switch (type) {
      case VehicleType.heavyMachinery: return "معدات ثقيلة (Yellow Iron)";
      case VehicleType.truck: return "شاحنات نقل";
      case VehicleType.forklift: return "رافعات شوكية";
      case VehicleType.serviceVehicle: return "خدمات ونقل موظفين";
      case VehicleType.passengerCar: return "سيارات إدارية";
    }
  }
}
