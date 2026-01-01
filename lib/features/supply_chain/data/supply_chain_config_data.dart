// FileName: lib/features/supply_chain/data/supply_chain_config_data.dart
// Version: 5.0 (Full Seed Data: Warehouses, Fleet, GeoLocations)

import 'package:flutter/material.dart';
import 'package:mokaab/features/supply_chain/models/warehouse_model.dart';
import 'package:mokaab/features/supply_chain/models/fleet_model.dart';
import 'package:mokaab/features/supply_chain/models/geo_location_model.dart';

class SupplyChainConfigData {
  // --- 1. المعرفات (IDs) ---
  static const String idWarehouses = 'warehouses';
  static const String idFleet = 'fleet';
  static const String idLocations = 'locations';
  static const String idUom = 'uom';
  static const String idCategories = 'categories';

  // --- 2. عناصر القائمة الجانبية ---
  static final List<Map<String, dynamic>> menuItems = [
    {'id': idWarehouses, 'title': 'المستودعات والمخازن', 'subtitle': 'تعريف المخازن، مناطق الإنتاج، والسكراب', 'icon': Icons.warehouse},
    {'id': idFleet, 'title': 'الأسطول والآليات', 'subtitle': 'الشاحنات، الرافعات، وسيارات الحركة', 'icon': Icons.local_shipping},
    {'id': idLocations, 'title': 'المواقع الجغرافية', 'subtitle': 'الساحات، المحاجر، ومواقع العملاء', 'icon': Icons.map},
    {'id': idUom, 'title': 'وحدات القياس (UoM)', 'subtitle': 'التحويلات (طن، متر، حبة...)', 'icon': Icons.scale},
    {'id': idCategories, 'title': 'فئات المنتجات', 'subtitle': 'شجرة تصنيف المواد', 'icon': Icons.category},
  ];

  // --- 3. بيانات المستودعات الافتراضية (Warehouses) ---
  static final List<WarehouseLocation> locations = [
    // المواد الخام
    WarehouseLocation(
      id: '1', name: 'مستودع المواد الأولية (الكيماويات)', code: 'WH/RAW/CHEM', 
      type: WarehouseType.internal, managerName: 'سعيد خليل', 
      valuationAccount: '12010101', address: 'هنجر رقم 3',
    ),
    WarehouseLocation(
      id: '2', name: 'ساحة التشوين (رمل وحصمة)', code: 'WH/RAW/YARD', 
      type: WarehouseType.internal, managerName: 'سعيد خليل', 
      valuationAccount: '12010102', capacity: 50000, currentLoad: 32000, 
    ),
    // المنتج التام
    WarehouseLocation(
      id: '3', name: 'مستودع المنتج التام', code: 'WH/FG', 
      type: WarehouseType.internal, managerName: 'علي يوسف', 
      valuationAccount: '12010200', capacity: 10000, currentLoad: 4500,
    ),
    // المستودع العام
    WarehouseLocation(
      id: '4', name: 'المستودع العام (إداري)', code: 'WH/GEN', 
      type: WarehouseType.internal, managerName: 'مسؤول الخدمات', 
      valuationAccount: '12010600', address: 'المبنى الإداري'
    ),
    // قطع الغيار
    WarehouseLocation(
      id: '5', name: 'مستودع قطع الغيار', code: 'WH/SPARE', 
      type: WarehouseType.internal, managerName: 'محمود الصيانة', 
      valuationAccount: '12010500',
    ),
    // مناطق الإنتاج
    WarehouseLocation(
      id: '6', name: 'منطقة الخلاطات والصب', code: 'WH/PROD/MIX', 
      type: WarehouseType.production, managerName: 'مدير الإنتاج',
      valuationAccount: '12010900', allowNegativeStock: true, 
    ),
    WarehouseLocation(
      id: '7', name: 'منطقة الجفاف والمعالجة', code: 'WH/PROD/CURE', 
      type: WarehouseType.production, managerName: 'مدير الإنتاج',
      valuationAccount: '12010900',
    ),
    // السكراب
    WarehouseLocation(
      id: '8', name: 'منطقة الإتلاف', code: 'WH/SCRAP', 
      type: WarehouseType.inventoryLoss, managerName: 'النظام',
      valuationAccount: '52050000', isScrap: true,
    ),
  ];

  // --- 4. بيانات الأسطول الافتراضية (Fleet) ---
  static final List<FleetVehicle> fleet = [
    FleetVehicle(
      id: '1', name: 'مرسيدس اكتروس', plateNumber: '50-1425', code: 'TRK-01',
      type: VehicleType.truck, driverName: 'محمد السائق',
      currentOdometer: 150000, measureUnit: 'Km', loadCapacity: 40,
      licenseExpiryDate: DateTime.now().add(const Duration(days: 20)),
      purchaseDate: DateTime(2020, 1, 1), purchaseValue: 45000, costCenter: 'CC-LOGISTICS',
    ),
    FleetVehicle(
      id: '2', name: 'جرافة كاتربيلر 966', plateNumber: 'إنشائي-88', code: 'EQP-CAT-01',
      type: VehicleType.heavyMachinery, driverName: 'سالم الحفار',
      currentOdometer: 5400, measureUnit: 'Hours',
      status: VehicleStatus.active,
      purchaseDate: DateTime(2019, 5, 15), purchaseValue: 120000, costCenter: 'CC-QUARRY',
    ),
    FleetVehicle(
      id: '3', name: 'رافعة شوكية 5 طن', plateNumber: 'بدون', code: 'FORK-03',
      type: VehicleType.forklift, driverName: 'عمال التحميل',
      currentOdometer: 1200, measureUnit: 'Hours',
      status: VehicleStatus.maintenance,
      purchaseDate: DateTime(2022, 3, 10), purchaseValue: 15000, costCenter: 'CC-FACTORY',
    ),
    FleetVehicle(
      id: '4', name: 'باص كوستر', plateNumber: '12-9988', code: 'BUS-01',
      type: VehicleType.serviceVehicle, driverName: 'خالد النقل',
      currentOdometer: 80000, measureUnit: 'Km',
      purchaseDate: DateTime(2021, 1, 1), purchaseValue: 35000, costCenter: 'CC-HR',
    ),
  ];

  // --- 5. بيانات المواقع الجغرافية (Geo Locations) ---
  static final List<GeoLocation> geoLocations = [
    GeoLocation(
      id: 'LOC-1', name: 'محجر الأزرق الجنوبي', code: 'QRY-AZR',
      type: GeoLocationType.quarry,
      addressText: 'طريق الأزرق - الكيلو 50', city: 'الزرقاء',
      gpsCoordinates: '31.85, 36.80', geofenceRadius: 2000,
      costCenterId: 'CC-QRY-01', managerName: 'مهندس التعدين',
      licenseNumber: 'MIN-998877', licenseExpiry: DateTime(2026, 12, 31),
    ),
    GeoLocation(
      id: 'LOC-2', name: 'المصنع الرئيسي - القسطل', code: 'FAC-MAIN',
      type: GeoLocationType.factorySite,
      addressText: 'المنطقة الصناعية - شارع 10', city: 'عمان',
      gpsCoordinates: '31.70, 35.90', costCenterId: 'CC-PROD-MAIN',
      managerName: 'مدير المصنع', licenseNumber: 'IND-112233',
    ),
    GeoLocation(
      id: 'LOC-3', name: 'معرض خلدا', code: 'SHW-KHL',
      type: GeoLocationType.showroom,
      addressText: 'شارع وصفي التل', city: 'عمان',
      costCenterId: 'CC-SALES-01', managerName: 'مدير المبيعات',
    ),
    GeoLocation(
      id: 'LOC-4', name: 'مشروع أبراج العبدلي', code: 'PRJ-ABD',
      type: GeoLocationType.projectSite,
      addressText: 'البوليفارد - مدخل 3', city: 'عمان',
      gpsCoordinates: '31.96, 35.91', geofenceRadius: 300,
      costCenterId: 'CC-PRJ-ABD', managerName: 'مهندس الموقع',
    ),
  ];
}