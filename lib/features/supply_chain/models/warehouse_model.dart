// FileName: lib/features/supply_chain/models/warehouse_model.dart
import 'package:flutter/material.dart';

// تعريف أنواع المواقع اللوجستية
enum WarehouseType {
  view,           // مجلد تجميعي (View)
  internal,       // تخزين داخلي (Internal)
  customer,       // موقع عميل (Customer)
  vendor,         // موقع مورد (Vendor)
  production,     // موقع إنتاج (WIP)
  transit,        // موقع عبور (Transit)
  inventoryLoss,  // خسائر/سكراب (Loss)
  subcontracting  // تصنيع خارجي (Subcontracting)
}

class WarehouseLocation {
  final String id;
  final String name;
  final String code; 
  final WarehouseType type;
  
  // --- Metadata (البيانات الوصفية) ---
  final String managerName; // أمين العهدة
  final String? valuationAccount; // حساب المخزون (GL)
  final double capacity; 
  final double currentLoad; 
  final String address; 
  
  // --- Rules (قواعد التشغيل) ---
  final bool allowNegativeStock; // السماح بالسالب
  final bool isScrap; // موقع إتلاف
  final bool isBonded; // مستودع جمركي

  WarehouseLocation({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    this.managerName = 'غير محدد',
    this.valuationAccount,
    this.capacity = 0,
    this.currentLoad = 0,
    this.address = '',
    this.allowNegativeStock = false,
    this.isScrap = false,
    this.isBonded = false,
  });

  // Helper: اللون حسب النوع
  Color get typeColor {
    switch (type) {
      case WarehouseType.view: return Colors.blueGrey;
      case WarehouseType.internal: return Colors.blue;
      case WarehouseType.customer: return Colors.orange;
      case WarehouseType.vendor: return Colors.purple;
      case WarehouseType.production: return Colors.amber[700]!;
      case WarehouseType.transit: return Colors.teal;
      case WarehouseType.inventoryLoss: return Colors.red;
      case WarehouseType.subcontracting: return Colors.indigo;
    }
  }

  // Helper: الاسم العربي للنوع
  String get typeName {
    switch (type) {
      case WarehouseType.view: return "مجلد (View)";
      case WarehouseType.internal: return "تخزين داخلي";
      case WarehouseType.customer: return "موقع عميل";
      case WarehouseType.vendor: return "موقع مورد";
      case WarehouseType.production: return "إنتاج (WIP)";
      case WarehouseType.transit: return "عبور (Transit)";
      case WarehouseType.inventoryLoss: return "خسائر/سكراب";
      case WarehouseType.subcontracting: return "تصنيع خارجي";
    }
  }
}