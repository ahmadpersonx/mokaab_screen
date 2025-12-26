// FileName: lib/features/system_config/data/seed_data.dart
// Description: البيانات الافتراضية لقوائم النظام (مخصصة لمصنع حجر صناعي)
// Version: 5.0 (Full Hierarchy + All Lists)

import 'package:flutter/material.dart';
import 'models/lookup_model.dart';

Map<LookupCategory, List<LookupItem>> masterLookups = {
  
 // 1. الدوائر والإدارات (Smart Departments - Organizational Structure)
  LookupCategory.departments: [
    // القيادة
    LookupItem(id: 'DEP-HQ', name: 'الإدارة العليا والاستراتيجية', code: 'HQ', color: Colors.black, metaData: {'type': 'ADMIN', 'costCenter': 'CC-100', 'manager': 'GM', 'budget': '500000'}),
    
    // العمليات الأساسية (Core Operations)
    LookupItem(id: 'DEP-PROD', name: 'إدارة الإنتاج والتصنيع', code: 'PROD', color: Colors.blue[900], metaData: {'type': 'OPS', 'costCenter': 'CC-200', 'manager': 'Production Mgr', 'budget': '2000000'}),
    LookupItem(id: 'DEP-SCM', name: 'إدارة سلسلة الإمداد (Supply Chain)', code: 'SCM', color: Colors.brown, metaData: {'type': 'OPS', 'costCenter': 'CC-300', 'manager': 'Supply Chain Mgr', 'budget': '1500000'}),
    LookupItem(id: 'DEP-PROJ', name: 'إدارة المشاريع والتركيبات', code: 'PROJ', color: Colors.orange[900], metaData: {'type': 'PROFIT', 'costCenter': 'CC-400', 'manager': 'Projects Mgr', 'budget': '1000000'}),
    
    // الرقابة والدعم الفني
    LookupItem(id: 'DEP-QHSE', name: 'إدارة الجودة والسلامة (QHSE)', code: 'QHSE', color: Colors.red[800], metaData: {'type': 'SUPPORT', 'costCenter': 'CC-500', 'manager': 'QHSE Mgr', 'budget': '300000'}),
    LookupItem(id: 'DEP-MNT', name: 'إدارة الصيانة والمشاغل', code: 'MAINT', color: Colors.grey[700], metaData: {'type': 'SUPPORT', 'costCenter': 'CC-600', 'manager': 'Maintenance Mgr', 'budget': '400000'}),
    
    // الإدارات المساندة
    LookupItem(id: 'DEP-FIN', name: 'الإدارة المالية', code: 'FIN', color: Colors.indigo, metaData: {'type': 'ADMIN', 'costCenter': 'CC-700', 'manager': 'CFO', 'budget': '200000'}),
    LookupItem(id: 'DEP-HR', name: 'إدارة الموارد البشرية (HR)', code: 'HR', color: Colors.pink, metaData: {'type': 'ADMIN', 'costCenter': 'CC-800', 'manager': 'HR Mgr', 'budget': '250000'}),
    LookupItem(id: 'DEP-IT', name: 'إدارة تقنية المعلومات (IT)', code: 'IT', color: Colors.blue, metaData: {'type': 'SUPPORT', 'costCenter': 'CC-900', 'manager': 'IT Mgr', 'budget': '150000'}),
    
    // الواجهة التجارية
    LookupItem(id: 'DEP-COM', name: 'الإدارة التجارية والمبيعات', code: 'SALES', color: Colors.green, metaData: {'type': 'PROFIT', 'costCenter': 'CC-1000', 'manager': 'Sales Director', 'budget': '600000'}),
  ],

  // 2. الأقسام الفنية والإدارية (Smart Sections - Level 2)
  LookupCategory.sections: [
    // --- تابع لـ: الإدارة العليا (DEP-HQ) ---
    LookupItem(id: 'SEC-GM-OFF', name: 'مكتب المدير العام', code: 'SEC-GM', color: Colors.grey, metaData: {'parentId': 'DEP-HQ', 'head': 'Office Manager', 'count': '3', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-AUDIT', name: 'قسم التدقيق الداخلي والحوكمة', code: 'SEC-AUD', color: Colors.blueGrey, metaData: {'parentId': 'DEP-HQ', 'head': 'Internal Auditor', 'count': '2', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-STRAT', name: 'قسم التخطيط الاستراتيجي', code: 'SEC-PLN', color: Colors.indigo, metaData: {'parentId': 'DEP-HQ', 'head': 'Strategy Officer', 'count': '2', 'type': 'INDIRECT'}),

    // --- تابع لـ: إدارة الإنتاج (DEP-PROD) ---
    LookupItem(id: 'SEC-MIX', name: 'قسم الخلاطة والصب (Mixing)', code: 'SEC-MIX', color: Colors.brown, metaData: {'parentId': 'DEP-PROD', 'head': 'Mixing Supervisor', 'count': '15', 'type': 'DIRECT'}),
    LookupItem(id: 'SEC-CUT', name: 'قسم القص والنشارة (Cutting)', code: 'SEC-CUT', color: Colors.brown[700], metaData: {'parentId': 'DEP-PROD', 'head': 'Cutting Supervisor', 'count': '20', 'type': 'DIRECT'}),
    LookupItem(id: 'SEC-POL', name: 'قسم الجلي والمعالجة (Finishing)', code: 'SEC-POL', color: Colors.teal, metaData: {'parentId': 'DEP-PROD', 'head': 'Finishing Supervisor', 'count': '25', 'type': 'DIRECT'}),
    LookupItem(id: 'SEC-CNC', name: 'قسم الأعمال الفنية (CNC)', code: 'SEC-CNC', color: Colors.purple, metaData: {'parentId': 'DEP-PROD', 'head': 'CNC Engineer', 'count': '8', 'type': 'DIRECT'}),
    LookupItem(id: 'SEC-PROD-PLAN', name: 'قسم تخطيط الإنتاج (PPC)', code: 'SEC-PPC', color: Colors.blue, metaData: {'parentId': 'DEP-PROD', 'head': 'Planning Engineer', 'count': '3', 'type': 'INDIRECT'}),

    // --- تابع لـ: إدارة الإمداد (DEP-SCM) ---
    LookupItem(id: 'SEC-PUR-RAW', name: 'قسم مشتريات المواد الخام', code: 'SEC-PUR-R', color: Colors.green[800], metaData: {'parentId': 'DEP-SCM', 'head': 'Purchasing Officer', 'count': '4', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-STR-RM', name: 'مستودعات المواد الخام', code: 'SEC-STR-R', color: Colors.orange, metaData: {'parentId': 'DEP-SCM', 'head': 'Storekeeper', 'count': '6', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-STR-FG', name: 'مستودعات المنتج التام', code: 'SEC-STR-F', color: Colors.orange[900], metaData: {'parentId': 'DEP-SCM', 'head': 'Dispatch Supervisor', 'count': '5', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-LOG-FLEET', name: 'قسم الحركة والأسطول', code: 'SEC-FLT', color: Colors.amber, metaData: {'parentId': 'DEP-SCM', 'head': 'Fleet Manager', 'count': '12', 'type': 'INDIRECT'}),

    // --- تابع لـ: إدارة الجودة (DEP-QHSE) ---
    LookupItem(id: 'SEC-QC-IN', name: 'قسم ضبط جودة الواردات', code: 'SEC-QC-I', color: Colors.red[300], metaData: {'parentId': 'DEP-QHSE', 'head': 'QC Inspector', 'count': '3', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-QC-PRO', name: 'قسم ضبط جودة العمليات', code: 'SEC-QC-P', color: Colors.red, metaData: {'parentId': 'DEP-QHSE', 'head': 'QC Supervisor', 'count': '5', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-LAB', name: 'المختبر الفني (Lab)', code: 'SEC-LAB', color: Colors.red[900], metaData: {'parentId': 'DEP-QHSE', 'head': 'Lab Technician', 'count': '2', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-HSE', name: 'قسم السلامة والبيئة', code: 'SEC-HSE', color: Colors.green, metaData: {'parentId': 'DEP-QHSE', 'head': 'Safety Officer', 'count': '4', 'type': 'INDIRECT'}),

    // --- تابع لـ: إدارة الصيانة (DEP-MNT) ---
    LookupItem(id: 'SEC-MNT-MECH', name: 'قسم الصيانة الميكانيكية', code: 'SEC-MECH', color: Colors.grey[800], metaData: {'parentId': 'DEP-MNT', 'head': 'Mech Engineer', 'count': '8', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-MNT-ELEC', name: 'قسم الصيانة الكهربائية', code: 'SEC-ELEC', color: Colors.yellow[800], metaData: {'parentId': 'DEP-MNT', 'head': 'Elec Engineer', 'count': '6', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-MNT-FAC', name: 'قسم صيانة المرافق والمباني', code: 'SEC-FAC', color: Colors.brown[300], metaData: {'parentId': 'DEP-MNT', 'head': 'Civil Supervisor', 'count': '4', 'type': 'INDIRECT'}),

    // --- تابع لـ: الإدارة المالية (DEP-FIN) ---
    LookupItem(id: 'SEC-ACC-GEN', name: 'قسم الحسابات العامة', code: 'SEC-GL', color: Colors.indigo[300], metaData: {'parentId': 'DEP-FIN', 'head': 'Chief Accountant', 'count': '5', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-ACC-COST', name: 'قسم التكاليف والموازنة', code: 'SEC-CST', color: Colors.indigo[700], metaData: {'parentId': 'DEP-FIN', 'head': 'Cost Accountant', 'count': '2', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-ACC-AR', name: 'قسم التحصيل والعملاء', code: 'SEC-AR', color: Colors.indigo[900], metaData: {'parentId': 'DEP-FIN', 'head': 'Credit Officer', 'count': '3', 'type': 'INDIRECT'}),

    // --- تابع لـ: الإدارة التجارية (DEP-COM) ---
    LookupItem(id: 'SEC-SAL-LOC', name: 'قسم المبيعات المحلية', code: 'SEC-SAL-L', color: Colors.blue[300], metaData: {'parentId': 'DEP-COM', 'head': 'Sales Manager', 'count': '6', 'type': 'DIRECT'}),
    LookupItem(id: 'SEC-SAL-EXP', name: 'قسم التصدير', code: 'SEC-EXP', color: Colors.blue[700], metaData: {'parentId': 'DEP-COM', 'head': 'Export Manager', 'count': '3', 'type': 'DIRECT'}),
    LookupItem(id: 'SEC-MKT', name: 'قسم التسويق', code: 'SEC-MKT', color: Colors.purpleAccent, metaData: {'parentId': 'DEP-COM', 'head': 'Marketing Specialist', 'count': '2', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-EST', name: 'قسم الدراسات والتسعير', code: 'SEC-EST', color: Colors.cyan, metaData: {'parentId': 'DEP-COM', 'head': 'Estimation Eng', 'count': '3', 'type': 'INDIRECT'}),

    // --- تابع لـ: الموارد البشرية (DEP-HR) ---
    LookupItem(id: 'SEC-HR-OPS', name: 'قسم شؤون الموظفين والرواتب', code: 'SEC-PRS', color: Colors.pink[300], metaData: {'parentId': 'DEP-HR', 'head': 'Personnel Officer', 'count': '4', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-HR-DEV', name: 'قسم التدريب والتطوير', code: 'SEC-DEV', color: Colors.pink[700], metaData: {'parentId': 'DEP-HR', 'head': 'Training Officer', 'count': '1', 'type': 'INDIRECT'}),
    LookupItem(id: 'SEC-ADMIN-SERV', name: 'قسم الخدمات الإدارية', code: 'SEC-ADM', color: Colors.pink[100], metaData: {'parentId': 'DEP-HR', 'head': 'Admin Supervisor', 'count': '5', 'type': 'INDIRECT'}),
  ],
  
 // 3. الوحدات التنظيمية والورش (Smart Units - Level 3)
  LookupCategory.units: [
    // --- وحدات قسم الخلاطة والصب (SEC-MIX) ---
    LookupItem(id: 'UNT-MIX-MAIN', name: 'وحدة الخلاطة المركزية (Batching)', code: 'UNT-MIX', color: Colors.brown, metaData: {'parentId': 'SEC-MIX', 'foreman': 'Mixing Foreman', 'type': 'PRODUCTION', 'capacity': '200 m3/day'}),
    LookupItem(id: 'UNT-CAST-A', name: 'وحدة صب القوالب اليدوية', code: 'UNT-CAST-A', color: Colors.brown[300], metaData: {'parentId': 'SEC-MIX', 'foreman': 'Casting Lead', 'type': 'WORKSHOP', 'capacity': '50 molds/day'}),
    LookupItem(id: 'UNT-CURE', name: 'وحدة التجفيف والمعالجة (Curing)', code: 'UNT-CURE', color: Colors.grey, metaData: {'parentId': 'SEC-MIX', 'foreman': 'Curing Sup', 'type': 'PROCESS', 'capacity': '500 pcs/day'}),

    // --- وحدات قسم القص والنشارة (SEC-CUT) ---
    LookupItem(id: 'UNT-BLK-CUT', name: 'وحدة المناشير الكبيرة (Block Cutters)', code: 'UNT-BLK', color: Colors.blueGrey, metaData: {'parentId': 'SEC-CUT', 'foreman': 'Saw Operator Lead', 'type': 'PRODUCTION', 'capacity': '10 blocks/day'}),
    LookupItem(id: 'UNT-BRG-SAW', name: 'وحدة قص الجسور (Bridge Saws)', code: 'UNT-BRG', color: Colors.blueGrey[700], metaData: {'parentId': 'SEC-CUT', 'foreman': 'Cutting Lead', 'type': 'PRODUCTION', 'capacity': '300 m2/day'}),
    LookupItem(id: 'UNT-MILLING', name: 'وحدة الفريزة والتخشين (Milling)', code: 'UNT-MILL', color: Colors.blueGrey[400], metaData: {'parentId': 'SEC-CUT', 'foreman': 'Milling Lead', 'type': 'WORKSHOP', 'capacity': '100 pcs/day'}),

    // --- وحدات قسم الجلي والمعالجة (SEC-POL) ---
    LookupItem(id: 'UNT-POL-AUTO', name: 'وحدة الجلايات الأوتوماتيكية', code: 'UNT-POL-A', color: Colors.teal, metaData: {'parentId': 'SEC-POL', 'foreman': 'Polishing Lead', 'type': 'LINE', 'capacity': '400 m2/day'}),
    LookupItem(id: 'UNT-POL-MAN', name: 'وحدة الجلي اليدوي والزوايا', code: 'UNT-POL-M', color: Colors.teal[300], metaData: {'parentId': 'SEC-POL', 'foreman': 'Hand Polish Lead', 'type': 'WORKSHOP', 'capacity': '50 m2/day'}),
    LookupItem(id: 'UNT-RESIN', name: 'وحدة المعالجة (Epoxy/Resin)', code: 'UNT-RES', color: Colors.amber, metaData: {'parentId': 'SEC-POL', 'foreman': 'Treatment Lead', 'type': 'PROCESS', 'capacity': '200 m2/day'}),

    // --- وحدات قسم الأعمال الفنية (SEC-CNC) ---
    LookupItem(id: 'UNT-CNC-OP', name: 'وحدة تشغيل CNC', code: 'UNT-CNC', color: Colors.purple, metaData: {'parentId': 'SEC-CNC', 'foreman': 'CNC Lead', 'type': 'PRODUCTION', 'capacity': '20 pcs/day'}),
    LookupItem(id: 'UNT-CARVE', name: 'وحدة النحت اليدوي والديكور', code: 'UNT-ART', color: Colors.purple[300], metaData: {'parentId': 'SEC-CNC', 'foreman': 'Artisan Lead', 'type': 'WORKSHOP', 'capacity': '5 pcs/day'}),
    LookupItem(id: 'UNT-MOLD-MAK', name: 'وحدة تصنيع القوالب (Mold Making)', code: 'UNT-MOLD', color: Colors.purple[100], metaData: {'parentId': 'SEC-CNC', 'foreman': 'Mold Maker', 'type': 'WORKSHOP', 'capacity': '2 molds/week'}),

    // --- وحدات قسم المستودعات (SEC-STR-RM/FG) ---
    LookupItem(id: 'UNT-STR-RAW', name: 'مستودع المواد الخام (Silo/Yard)', code: 'UNT-RM', color: Colors.orange, metaData: {'parentId': 'SEC-STR-RM', 'foreman': 'Storekeeper', 'type': 'WAREHOUSE', 'capacity': '1000 Tons'}),
    LookupItem(id: 'UNT-STR-SP', name: 'مستودع قطع الغيار', code: 'UNT-SP', color: Colors.orange[300], metaData: {'parentId': 'SEC-STR-RM', 'foreman': 'Spare Parts Keeper', 'type': 'WAREHOUSE', 'capacity': '5000 Items'}),
    LookupItem(id: 'UNT-STR-FG', name: 'ساحة التحميل والمنتج التام', code: 'UNT-FG', color: Colors.orange[800], metaData: {'parentId': 'SEC-STR-FG', 'foreman': 'Dispatch Lead', 'type': 'YARD', 'capacity': '500 Pallets'}),

    // --- وحدات قسم الحركة (SEC-LOG-FLEET) ---
    LookupItem(id: 'UNT-DRIVERS', name: 'وحدة السائقين والنقل', code: 'UNT-DRV', color: Colors.amber, metaData: {'parentId': 'SEC-LOG-FLEET', 'foreman': 'Fleet Super', 'type': 'OFFICE', 'capacity': '20 Vehicles'}),
    LookupItem(id: 'UNT-MECH-WS', name: 'وحدة صيانة الآليات', code: 'UNT-WS-M', color: Colors.amber[800], metaData: {'parentId': 'SEC-LOG-FLEET', 'foreman': 'Workshop Lead', 'type': 'WORKSHOP', 'capacity': '3 Trucks/day'}),

    // --- وحدات الجودة (SEC-QC-IN/PRO) ---
    LookupItem(id: 'UNT-QC-IN', name: 'وحدة استلام المواد الخام', code: 'UNT-QC-I', color: Colors.red[200], metaData: {'parentId': 'SEC-QC-IN', 'foreman': 'QC Senior', 'type': 'LAB', 'capacity': '10 Samples/day'}),
    LookupItem(id: 'UNT-QC-OUT', name: 'وحدة الفحص النهائي والتغليف', code: 'UNT-QC-O', color: Colors.red, metaData: {'parentId': 'SEC-QC-PRO', 'foreman': 'QC Lead', 'type': 'CHECKPOINT', 'capacity': '100 Pallets/day'}),

    // --- وحدات الصيانة (SEC-MNT-MECH/ELEC) ---
    LookupItem(id: 'UNT-LATHE', name: 'ورشة الخراطة واللحام', code: 'UNT-LATH', color: Colors.grey, metaData: {'parentId': 'SEC-MNT-MECH', 'foreman': 'Welding Lead', 'type': 'WORKSHOP', 'capacity': 'On Demand'}),
    LookupItem(id: 'UNT-ELEC-WS', name: 'ورشة اللوحات الكهربائية', code: 'UNT-ELC', color: Colors.yellow[800], metaData: {'parentId': 'SEC-MNT-ELEC', 'foreman': 'Elec Lead', 'type': 'WORKSHOP', 'capacity': 'On Demand'}),

    // --- وحدات المالية (SEC-ACC-GEN/AR/AP) ---
    LookupItem(id: 'UNT-AP', name: 'وحدة الذمم الدائنة (AP)', code: 'UNT-AP', color: Colors.indigo, metaData: {'parentId': 'SEC-ACC-GEN', 'foreman': 'Senior Accountant', 'type': 'OFFICE', 'capacity': 'N/A'}),
    LookupItem(id: 'UNT-AR', name: 'وحدة الذمم المدينة (AR)', code: 'UNT-AR', color: Colors.indigo[400], metaData: {'parentId': 'SEC-ACC-AR', 'foreman': 'Senior Accountant', 'type': 'OFFICE', 'capacity': 'N/A'}),
    LookupItem(id: 'UNT-TREASURY', name: 'وحدة الخزينة والبنوك', code: 'UNT-CSH', color: Colors.green, metaData: {'parentId': 'SEC-ACC-GEN', 'foreman': 'Treasurer', 'type': 'OFFICE', 'capacity': 'N/A'}),

    // --- وحدات الموارد البشرية (SEC-HR-OPS) ---
    LookupItem(id: 'UNT-PAYROLL', name: 'وحدة الرواتب والأجور', code: 'UNT-PAY', color: Colors.pink, metaData: {'parentId': 'SEC-HR-OPS', 'foreman': 'Payroll Officer', 'type': 'OFFICE', 'capacity': 'N/A'}),
    LookupItem(id: 'UNT-GOV-REL', name: 'وحدة العلاقات الحكومية', code: 'UNT-GOV', color: Colors.pink[300], metaData: {'parentId': 'SEC-HR-OPS', 'foreman': 'Liaison Officer', 'type': 'OFFICE', 'capacity': 'N/A'}),
  ],
  
  // ============================================================
  // باقي القوائم والبيانات (مواقع، وظائف، مهام...)
  // ============================================================
  
  // 3. مواقع العمل
  LookupCategory.locations: [
    LookupItem(id: 'L1', name: 'المصنع الرئيسي - المنطقة الصناعية', code: 'LOC-MAIN', icon: Icons.factory),
    LookupItem(id: 'L2', name: 'المعرض الرئيسي - خلدا', code: 'LOC-SHOW1', icon: Icons.storefront),
    LookupItem(id: 'L3', name: 'موقع المشروع (خارجي)', code: 'LOC-SITE', icon: Icons.construction),
    LookupItem(id: 'L4', name: 'سكن العمال', code: 'LOC-ACC', icon: Icons.home_work),
  ],

 // 4. المسميات الوظيفية (Comprehensive Job List)
  LookupCategory.jobTitles: [
    // --- الإدارة العليا ---
    LookupItem(id: 'JOB-GM', name: 'المدير العام', code: 'GM-01', metaData: {'jobLevel': 'MANAGER', 'riskLevel': 'LOW', 'isManager': true}),
    LookupItem(id: 'JOB-EXEC-SEC', name: 'سحرتارية تنفيذية', code: 'SEC-01', metaData: {'jobLevel': 'JUNIOR', 'riskLevel': 'LOW', 'isManager': false}),
    
    // --- الإنتاج والعمليات (مخاطر عالية) ---
    LookupItem(id: 'JOB-PROD-MGR', name: 'مدير المصنع', code: 'PRD-MGR', metaData: {'jobLevel': 'MANAGER', 'riskLevel': 'MEDIUM', 'isManager': true}),
    LookupItem(id: 'JOB-SUP-PROD', name: 'مشرف خط إنتاج', code: 'PRD-SUP', metaData: {'jobLevel': 'SUPERVISOR', 'riskLevel': 'HIGH', 'isManager': false}),
    LookupItem(id: 'JOB-OP-SAW', name: 'مشغل منشار جسر', code: 'OP-SAW-B', metaData: {'jobLevel': 'SENIOR', 'riskLevel': 'HIGH', 'isManager': false}),
    LookupItem(id: 'JOB-OP-BLOCK', name: 'مشغل منشار بلوك', code: 'OP-SAW-BLK', metaData: {'jobLevel': 'SENIOR', 'riskLevel': 'HIGH', 'isManager': false}),
    LookupItem(id: 'JOB-OP-CNC', name: 'مشغل ماكينة CNC', code: 'OP-CNC', metaData: {'jobLevel': 'SENIOR', 'riskLevel': 'MEDIUM', 'isManager': false}),
    LookupItem(id: 'JOB-OP-POL', name: 'فني جلي وتلميع', code: 'OP-POL', metaData: {'jobLevel': 'JUNIOR', 'riskLevel': 'HIGH', 'isManager': false}),
    LookupItem(id: 'JOB-ARTIST', name: 'نحات (فني ديكور)', code: 'ART-01', metaData: {'jobLevel': 'SENIOR', 'riskLevel': 'MEDIUM', 'isManager': false}),
    LookupItem(id: 'JOB-LABOR', name: 'عامل إنتاج / مساعد', code: 'LABOR', metaData: {'jobLevel': 'ENTRY', 'riskLevel': 'HIGH', 'isManager': false}),

    // --- سلسلة الإمداد واللوجستيك ---
    LookupItem(id: 'JOB-SCM-MGR', name: 'مدير سلسلة الإمداد', code: 'SCM-MGR', metaData: {'jobLevel': 'MANAGER', 'riskLevel': 'LOW', 'isManager': true}),
    LookupItem(id: 'JOB-PUR-OFF', name: 'مسؤول مشتريات', code: 'PUR-01', metaData: {'jobLevel': 'SENIOR', 'riskLevel': 'LOW', 'isManager': false}),
    LookupItem(id: 'JOB-WH-KPR', name: 'أمين مستودع', code: 'WH-01', metaData: {'jobLevel': 'SENIOR', 'riskLevel': 'MEDIUM', 'isManager': false}),
    LookupItem(id: 'JOB-DRV-FORK', name: 'سائق رافعة شوكية', code: 'DRV-FORK', metaData: {'jobLevel': 'JUNIOR', 'riskLevel': 'HIGH', 'isManager': false}),
    LookupItem(id: 'JOB-DRV-TRUCK', name: 'سائق شاحنة ثقيلة', code: 'DRV-TRUCK', metaData: {'jobLevel': 'SENIOR', 'riskLevel': 'HIGH', 'isManager': false}),

    // --- المالية ---
    LookupItem(id: 'JOB-FIN-MGR', name: 'المدير المالي', code: 'FIN-MGR', metaData: {'jobLevel': 'MANAGER', 'riskLevel': 'LOW', 'isManager': true}),
    LookupItem(id: 'JOB-ACC-MAIN', name: 'رئيس الحسابات', code: 'ACC-CHIEF', metaData: {'jobLevel': 'SUPERVISOR', 'riskLevel': 'LOW', 'isManager': true}),
    LookupItem(id: 'JOB-ACC-COST', name: 'محاسب تكاليف صناعية', code: 'ACC-COST', metaData: {'jobLevel': 'SENIOR', 'riskLevel': 'LOW', 'isManager': false}),
    LookupItem(id: 'JOB-ACC-GEN', name: 'محاسب عام', code: 'ACC-GEN', metaData: {'jobLevel': 'JUNIOR', 'riskLevel': 'LOW', 'isManager': false}),

    // --- المبيعات والتسويق ---
    LookupItem(id: 'JOB-SAL-MGR', name: 'مدير المبيعات', code: 'SAL-MGR', metaData: {'jobLevel': 'MANAGER', 'riskLevel': 'LOW', 'isManager': true}),
    LookupItem(id: 'JOB-SAL-ENG', name: 'مهندس مبيعات مشاريع', code: 'SAL-ENG', metaData: {'jobLevel': 'SENIOR', 'riskLevel': 'MEDIUM', 'isManager': false}),
    LookupItem(id: 'JOB-SAL-SHOW', name: 'مسؤول مبيعات معرض', code: 'SAL-SHOW', metaData: {'jobLevel': 'JUNIOR', 'riskLevel': 'LOW', 'isManager': false}),
    LookupItem(id: 'JOB-MKT-OFF', name: 'أخصائي تسويق', code: 'MKT-01', metaData: {'jobLevel': 'SENIOR', 'riskLevel': 'LOW', 'isManager': false}),

    // --- الصيانة والجودة ---
    LookupItem(id: 'JOB-MNT-MGR', name: 'مدير الصيانة', code: 'MNT-MGR', metaData: {'jobLevel': 'MANAGER', 'riskLevel': 'MEDIUM', 'isManager': true}),
    LookupItem(id: 'JOB-TECH-MECH', name: 'فني ميكانيك', code: 'TECH-MECH', metaData: {'jobLevel': 'SENIOR', 'riskLevel': 'HIGH', 'isManager': false}),
    LookupItem(id: 'JOB-TECH-ELEC', name: 'فني كهرباء صناعية', code: 'TECH-ELEC', metaData: {'jobLevel': 'SENIOR', 'riskLevel': 'HIGH', 'isManager': false}),
    LookupItem(id: 'JOB-QC-OFF', name: 'مراقب جودة', code: 'QC-01', metaData: {'jobLevel': 'JUNIOR', 'riskLevel': 'MEDIUM', 'isManager': false}),
    LookupItem(id: 'JOB-HSE-OFF', name: 'مشرف سلامة عامة', code: 'HSE-01', metaData: {'jobLevel': 'SUPERVISOR', 'riskLevel': 'MEDIUM', 'isManager': true}),
  ],

 // 5. الدرجات والسلم الوظيفي (تحديث: Odoo/SAP Style)
  LookupCategory.jobLevels: [
    LookupItem(id: 'LVL-01', name: 'الدرجة الأولى (تنفيذي)', code: 'EXEC', metaData: {'minSalary': '3000', 'maxSalary': '5000', 'leaveDays': '30', 'overtime': false}, color: Colors.purple),
    LookupItem(id: 'LVL-02', name: 'الدرجة الثانية (إدارة عليا)', code: 'MGT-SR', metaData: {'minSalary': '2000', 'maxSalary': '3000', 'leaveDays': '24', 'overtime': false}, color: Colors.blue[900]),
    LookupItem(id: 'LVL-03', name: 'الدرجة الثالثة (إشرافي)', code: 'SUP', metaData: {'minSalary': '1200', 'maxSalary': '2000', 'leaveDays': '21', 'overtime': true}, color: Colors.teal),
    LookupItem(id: 'LVL-04', name: 'الدرجة الرابعة (فني أول/مهني)', code: 'PRO-SR', metaData: {'minSalary': '800', 'maxSalary': '1200', 'leaveDays': '21', 'overtime': true}, color: Colors.blue),
    LookupItem(id: 'LVL-05', name: 'الدرجة الخامسة (فني/إداري)', code: 'PRO-JR', metaData: {'minSalary': '500', 'maxSalary': '800', 'leaveDays': '14', 'overtime': true}, color: Colors.lightBlue),
    LookupItem(id: 'LVL-06', name: 'الدرجة السادسة (عمالة ماهرة)', code: 'LBR-SK', metaData: {'minSalary': '350', 'maxSalary': '500', 'leaveDays': '14', 'overtime': true}, color: Colors.orange),
    LookupItem(id: 'LVL-07', name: 'الدرجة السابعة (مساعدين)', code: 'LBR-GEN', metaData: {'minSalary': '260', 'maxSalary': '350', 'leaveDays': '14', 'overtime': true}, color: Colors.grey),
  ],

// 6. أنواع العقود (Smart Contracts Update)
  LookupCategory.contractTypes: [
    LookupItem(id: 'CON-PERM', name: 'عقد دائم (غير محدد المدة)', code: 'PERM', color: Colors.green, metaData: {'basis': 'MONTHLY', 'probation': '3', 'notice': '1', 'socialSecurity': true, 'paidLeave': true}),
    LookupItem(id: 'CON-FIX', name: 'عقد محدد المدة (سنوي)', code: 'FIXED', color: Colors.blue, metaData: {'basis': 'MONTHLY', 'probation': '3', 'notice': '1', 'socialSecurity': true, 'paidLeave': true}),
    LookupItem(id: 'CON-DAILY', name: 'عقد مياومة (عمالة)', code: 'DAILY', color: Colors.amber, metaData: {'basis': 'DAILY', 'probation': '0', 'notice': '0', 'socialSecurity': true, 'paidLeave': false}),
    LookupItem(id: 'CON-PIECE', name: 'عقد إنتاج (قطعة/متر)', code: 'PIECE', color: Colors.purple, metaData: {'basis': 'PIECE', 'probation': '1', 'notice': '0.5', 'socialSecurity': false, 'paidLeave': false}),
    LookupItem(id: 'CON-TRAIN', name: 'عقد تدريب (Internship)', code: 'TRAIN', color: Colors.grey, metaData: {'basis': 'MONTHLY', 'probation': '1', 'notice': '0', 'socialSecurity': false, 'paidLeave': false}),
    LookupItem(id: 'CON-CONS', name: 'عقد استشارات خارجية', code: 'CONSULT', color: Colors.indigo, metaData: {'basis': 'HOURLY', 'probation': '0', 'notice': '1', 'socialSecurity': false, 'paidLeave': false}),
  ],

 // 7. أسباب إنهاء الخدمة (Smart Termination Reasons)
  LookupCategory.terminationReasons: [
    LookupItem(id: 'TERM-RESIGN', name: 'استقالة طوعية', code: 'RESIGN', color: Colors.blue, metaData: {'severance': true, 'assets': true, 'rehire': true, 'noticeReq': true}),
    LookupItem(id: 'TERM-CONTRACT', name: 'انتهاء مدة العقد', code: 'END-CONT', color: Colors.grey, metaData: {'severance': true, 'assets': true, 'rehire': true, 'noticeReq': false}),
    LookupItem(id: 'TERM-PROB', name: 'عدم كفاءة (تجربة)', code: 'PROB-FAIL', color: Colors.orange, metaData: {'severance': false, 'assets': true, 'rehire': false, 'noticeReq': false}),
    LookupItem(id: 'TERM-DISC', name: 'فصل تأديبي (مادة 29)', code: 'DISC', color: Colors.red, metaData: {'severance': false, 'assets': true, 'rehire': false, 'noticeReq': false}),
    LookupItem(id: 'TERM-REDUND', name: 'هيكلة / فائض عمالة', code: 'REDUND', color: Colors.teal, metaData: {'severance': true, 'assets': true, 'rehire': true, 'noticeReq': true}),
    LookupItem(id: 'TERM-RETIRE', name: 'بلوغ سن التقاعد', code: 'RETIRE', color: Colors.green, metaData: {'severance': true, 'assets': true, 'rehire': false, 'noticeReq': true}),
    LookupItem(id: 'TERM-DEATH', name: 'الوفاة', code: 'DEATH', color: Colors.black, metaData: {'severance': true, 'assets': false, 'rehire': false, 'noticeReq': false}),
    LookupItem(id: 'TERM-HEALTH', name: 'عدم اللياقة الصحية', code: 'HEALTH', color: Colors.brown, metaData: {'severance': true, 'assets': true, 'rehire': false, 'noticeReq': true}),
  ],

 // 8. ورديات العمل (Smart Shifts - Comprehensive List)
  LookupCategory.shifts: [
    // 1. الوردية الصباحية القياسية (للإدارة والإنتاج)
    LookupItem(id: 'SHIFT-MORNING', name: 'الوردية الصباحية (Morning)', code: 'SHIFT-A', color: Colors.amber, metaData: {'start': '07:30', 'end': '16:00', 'break': '30', 'grace': '15', 'night': false}),
    
    // 2. الوردية المسائية (لاستمرار الإنتاج)
    LookupItem(id: 'SHIFT-EVENING', name: 'الوردية المسائية (Evening)', code: 'SHIFT-B', color: Colors.indigo, metaData: {'start': '16:00', 'end': '00:00', 'break': '30', 'grace': '10', 'night': true}),
    
    // 3. الوردية الليلية (للصيانة والإنتاج المكثف)
    LookupItem(id: 'SHIFT-NIGHT', name: 'الوردية الليلية (Night)', code: 'SHIFT-C', color: Colors.black, metaData: {'start': '00:00', 'end': '07:30', 'break': '45', 'grace': '0', 'night': true}),
    
    // 4. وردية الدوام المرن (للمبيعات والإدارة العليا) - فترة سماح عالية
    LookupItem(id: 'SHIFT-FLEX', name: 'الدوام المرن (Flexible)', code: 'FLEX', color: Colors.blue, metaData: {'start': '08:00', 'end': '17:00', 'break': '60', 'grace': '120', 'night': false}),
    
    // 5. وردية رمضان (ساعات مخفضة)
    LookupItem(id: 'SHIFT-RAMADAN', name: 'وردية رمضان (Ramadan)', code: 'RAMADAN', color: Colors.purple, metaData: {'start': '09:00', 'end': '15:00', 'break': '0', 'grace': '15', 'night': false}),
    
    // 6. وردية الطوارئ/الصيانة (تحسب بالساعة - التوقيت 00:00 إشارة للنظام أنها حسب الطلب)
    LookupItem(id: 'SHIFT-ONCALL', name: 'وردية الطوارئ (On-Call)', code: 'ON-CALL', color: Colors.redAccent, metaData: {'start': '00:00', 'end': '00:00', 'break': '0', 'grace': '0', 'night': false}),
    
    // 7. وردية عطلة نهاية الأسبوع (للحراس - 12 ساعة عادة)
    LookupItem(id: 'SHIFT-WEEKEND', name: 'وردية نهاية الأسبوع (Weekend)', code: 'WEEKEND', color: Colors.green, metaData: {'start': '08:00', 'end': '20:00', 'break': '60', 'grace': '0', 'night': false}),
    
    // 8. دوام إداري ثابت (للمكاتب)
    LookupItem(id: 'SHIFT-ADMIN', name: 'دوام إداري ثابت (Admin)', code: 'ADMIN', color: Colors.teal, metaData: {'start': '09:00', 'end': '17:00', 'break': '60', 'grace': '30', 'night': false}),
  ],

  // 9. أنواع الإجازات (Smart Leaves - Comprehensive)
  LookupCategory.leaveTypes: [
    // 1. إجازة سنوية
    LookupItem(id: 'LV-ANNUAL', name: 'إجازة سنوية', code: 'ANNUAL', color: Colors.green, metaData: {'paid': true, 'deduct': true, 'attachment': false, 'maxDays': '21'}),
    
    // 2. إجازة مرضية
    LookupItem(id: 'LV-SICK', name: 'إجازة مرضية', code: 'SICK', color: Colors.orange, metaData: {'paid': true, 'deduct': false, 'attachment': true, 'maxDays': '14'}),
    
    // 3. إجازة طارئة/عارضة
    LookupItem(id: 'LV-CASUAL', name: 'إجازة طارئة/عارضة', code: 'CASUAL', color: Colors.redAccent, metaData: {'paid': true, 'deduct': true, 'attachment': false, 'maxDays': '3'}),
    
    // 4. إجازة بدون راتب
    LookupItem(id: 'LV-UNPAID', name: 'إجازة بدون راتب', code: 'UNPAID', color: Colors.grey, metaData: {'paid': false, 'deduct': false, 'attachment': false, 'maxDays': '90'}),
    
    // 5. إجازة زواج
    LookupItem(id: 'LV-MARRIAGE', name: 'إجازة زواج', code: 'MARRIAGE', color: Colors.pink, metaData: {'paid': true, 'deduct': false, 'attachment': true, 'maxDays': '7'}),
    
    // 6. إجازة حج (جديد)
    LookupItem(id: 'LV-HAJJ', name: 'إجازة حج', code: 'HAJJ', color: Colors.indigo, metaData: {'paid': true, 'deduct': false, 'attachment': true, 'maxDays': '21'}),
    
    // 7. إجازة أمومة
    LookupItem(id: 'LV-MATERNITY', name: 'إجازة أمومة', code: 'MATERNITY', color: Colors.purple, metaData: {'paid': true, 'deduct': false, 'attachment': true, 'maxDays': '70'}),
    
    // 8. إجازة أبوة
    LookupItem(id: 'LV-PATERNITY', name: 'إجازة أبوة', code: 'PATERNITY', color: Colors.blue, metaData: {'paid': true, 'deduct': false, 'attachment': true, 'maxDays': '3'}),
    
    // 9. إجازة دراسية
    LookupItem(id: 'LV-STUDY', name: 'إجازة دراسية/امتحانات', code: 'STUDY', color: Colors.teal, metaData: {'paid': true, 'deduct': false, 'attachment': true, 'maxDays': '10'}),
    
    // 10. إجازة تعويضية (جديد)
    LookupItem(id: 'LV-COMP', name: 'إجازة تعويضية', code: 'COMPENSATORY', color: Colors.cyan, metaData: {'paid': true, 'deduct': false, 'attachment': false, 'maxDays': '5'}),
    
    // 11. إجازة وفاة (إضافي مفيد)
    LookupItem(id: 'LV-DEATH', name: 'إجازة وفاة (حداد)', code: 'DEATH', color: Colors.black, metaData: {'paid': true, 'deduct': false, 'attachment': true, 'maxDays': '3'}),
  ],

// 10. حالات الحضور والغياب (Smart Attendance - Comprehensive List)
  LookupCategory.attendanceStatus: [
    // 1. حضور طبيعي
    LookupItem(id: 'ATT-P', name: 'حضور كامل (Present)', code: 'P', color: Colors.green, metaData: {'impact': 'FULL', 'factor': '1.0', 'approval': false}),
    
    // 2. غياب غير مبرر (خصم)
    LookupItem(id: 'ATT-A', name: 'غياب غير مبرر (Absent)', code: 'A', color: Colors.red, metaData: {'impact': 'DEDUCT', 'factor': '1.0', 'approval': false}),
    
    // 3. غياب مبرر (يخصم من الرصيد أو يتطلب موافقة)
    LookupItem(id: 'ATT-EXC', name: 'غياب مبرر (Excused)', code: 'EXC', color: Colors.orange, metaData: {'impact': 'FULL', 'factor': '1.0', 'approval': true}),
    
    // 4. تأخير (خصم جزئي حسب اللائحة)
    LookupItem(id: 'ATT-L', name: 'تأخير صباحي (Late In)', code: 'L', color: Colors.amber, metaData: {'impact': 'DEDUCT', 'factor': '0.25', 'approval': false}),
    
    // 5. مغادرة مبكرة
    LookupItem(id: 'ATT-E', name: 'مغادرة مبكرة (Early Out)', code: 'E', color: Colors.deepOrange, metaData: {'impact': 'DEDUCT', 'factor': '0.25', 'approval': true}),
    
    // 6. عمل إضافي (زيادة)
    LookupItem(id: 'ATT-OT', name: 'عمل إضافي (Overtime)', code: 'OT', color: Colors.blue, metaData: {'impact': 'OVERTIME', 'factor': '1.5', 'approval': true}),
    
    // 7. مهمة خارجية (مدفوعة - لا تتطلب بصمة داخلية)
    LookupItem(id: 'ATT-M', name: 'مهمة خارجية (Mission)', code: 'M', color: Colors.indigo, metaData: {'impact': 'FULL', 'factor': '1.0', 'approval': true}),
    
    // 8. عمل عن بعد
    LookupItem(id: 'ATT-R', name: 'عمل عن بعد (Remote)', code: 'R', color: Colors.purple, metaData: {'impact': 'FULL', 'factor': '1.0', 'approval': true}),
    
    // 9. عطلة رسمية (مدفوعة)
    LookupItem(id: 'ATT-PH', name: 'عطلة رسمية (Public Holiday)', code: 'PH', color: Colors.teal, metaData: {'impact': 'FULL', 'factor': '1.0', 'approval': false}),
    
    // 10. راحة أسبوعية
    LookupItem(id: 'ATT-WK', name: 'راحة أسبوعية (Weekend)', code: 'WK', color: Colors.blueGrey, metaData: {'impact': 'FULL', 'factor': '1.0', 'approval': false}),
    
    // 11. نقص ساعات (تراكمي)
    LookupItem(id: 'ATT-SHORT', name: 'نقص ساعات (Short Hours)', code: 'SH', color: Colors.brown, metaData: {'impact': 'DEDUCT', 'factor': '1.0', 'approval': false}),
  ],

 // 11. أنواع البدلات والإضافي (Smart Allowances - Comprehensive List)
  LookupCategory.allowanceTypes: [
    // بدلات ثابتة
    LookupItem(id: 'ALL-HOUSE', name: 'بدل سكن (Housing)', code: 'HOUSE', color: Colors.blueGrey, metaData: {'type': 'FIXED', 'freq': 'MONTHLY', 'taxable': true, 'linked': false}),
    LookupItem(id: 'ALL-TRANS', name: 'بدل مواصلات (Transport)', code: 'TRANS', color: Colors.teal, metaData: {'type': 'FIXED', 'freq': 'MONTHLY', 'taxable': true, 'linked': true}),
    LookupItem(id: 'ALL-PHONE', name: 'بدل هاتف (Phone)', code: 'PHONE', color: Colors.indigo, metaData: {'type': 'FIXED', 'freq': 'MONTHLY', 'taxable': true, 'linked': false}),
    
    // بدلات تشغيلية
    LookupItem(id: 'ALL-RISK', name: 'بدل خطورة (Risk)', code: 'RISK', color: Colors.red, metaData: {'type': 'FIXED', 'freq': 'MONTHLY', 'taxable': true, 'linked': true}),
    LookupItem(id: 'ALL-DUST', name: 'بدل غبار وتلوث', code: 'DUST', color: Colors.brown, metaData: {'type': 'FIXED', 'freq': 'MONTHLY', 'taxable': true, 'linked': true}),
    LookupItem(id: 'ALL-NIGHT', name: 'بدل سهر (Night Shift)', code: 'NIGHT', color: Colors.black, metaData: {'type': 'PERCENT', 'freq': 'MONTHLY', 'taxable': true, 'linked': true}),
    
    // بدلات إدارية
    LookupItem(id: 'ALL-POS', name: 'بدل منصب/إشراف', code: 'POSITION', color: Colors.purple, metaData: {'type': 'FIXED', 'freq': 'MONTHLY', 'taxable': true, 'linked': false}),
    LookupItem(id: 'ALL-CAR', name: 'بدل سيارة (Car)', code: 'CAR', color: Colors.blue, metaData: {'type': 'FIXED', 'freq': 'MONTHLY', 'taxable': false, 'linked': false}),
    
    // حوافز متغيرة
    LookupItem(id: 'ALL-COMM', name: 'عمولة مبيعات (Commission)', code: 'COMM', color: Colors.green, metaData: {'type': 'PERCENT', 'freq': 'MONTHLY', 'taxable': true, 'linked': false}),
    LookupItem(id: 'ALL-PROD', name: 'مكافأة إنتاجية (Production)', code: 'BONUS', color: Colors.amber, metaData: {'type': 'PERCENT', 'freq': 'MONTHLY', 'taxable': true, 'linked': true}),
    LookupItem(id: 'ALL-EDU', name: 'بدل تعليم أبناء', code: 'EDU', color: Colors.cyan, metaData: {'type': 'FIXED', 'freq': 'YEARLY', 'taxable': false, 'linked': false}),
  ],

// 12. أنواع الخصومات والاقتطاع (Smart Deductions - Comprehensive List)
  LookupCategory.deductionTypes: [
    // --- خصومات قانونية وإلزامية ---
    LookupItem(id: 'DED-SS', name: 'ضمان اجتماعي (Social Security)', code: 'SS', color: Colors.blueGrey, metaData: {'type': 'PERCENT_BASIC', 'maxLimit': '7.5', 'glAccount': '21010', 'auto': true}),
    LookupItem(id: 'DED-TAX', name: 'ضريبة دخل (Income Tax)', code: 'TAX', color: Colors.red, metaData: {'type': 'PERCENT_GROSS', 'maxLimit': '0', 'glAccount': '21020', 'auto': true}),
    LookupItem(id: 'DED-INS', name: 'تأمين صحي (Health Insurance)', code: 'INS', color: Colors.teal, metaData: {'type': 'FIXED', 'maxLimit': '0', 'glAccount': '21030', 'auto': true}),
    LookupItem(id: 'DED-UNION', name: 'اشتراك نقابة/جمعية (Union Fees)', code: 'UNION', color: Colors.indigo, metaData: {'type': 'FIXED', 'maxLimit': '0', 'glAccount': '21040', 'auto': false}),

    // --- سلف وقروض ---
    LookupItem(id: 'DED-LOAN', name: 'سلفة شخصية (Personal Loan)', code: 'LOAN', color: Colors.orange, metaData: {'type': 'FIXED', 'maxLimit': '30', 'glAccount': '11050', 'auto': false}),
    LookupItem(id: 'DED-ADV', name: 'سلفة راتب (Salary Advance)', code: 'ADVANCE', color: Colors.amber, metaData: {'type': 'FIXED', 'maxLimit': '100', 'glAccount': '11055', 'auto': false}),

    // --- حضور وغياب ---
    LookupItem(id: 'DED-ABSENT', name: 'غياب غير مبرر (Unexcused)', code: 'ABSENT', color: Colors.deepOrange, metaData: {'type': 'FIXED', 'maxLimit': '0', 'glAccount': '41010', 'auto': true}),
    LookupItem(id: 'DED-LATE', name: 'تأخير صباحي (Late Arrival)', code: 'LATE', color: Colors.brown, metaData: {'type': 'FIXED', 'maxLimit': '0', 'glAccount': '41010', 'auto': true}),

    // --- جزاءات ومخالفات ---
    LookupItem(id: 'DED-ADM-PEN', name: 'مخالفة إدارية (Admin Penalty)', code: 'PEN-ADM', color: Colors.purple, metaData: {'type': 'FIXED', 'maxLimit': '100', 'glAccount': '42050', 'auto': false}),
    LookupItem(id: 'DED-HSE-PEN', name: 'مخالفة سلامة عامة (HSE)', code: 'PEN-HSE', color: Colors.redAccent, metaData: {'type': 'FIXED', 'maxLimit': '100', 'glAccount': '42055', 'auto': false}),

    // --- مطالبات مالية ---
    LookupItem(id: 'DED-DMG', name: 'تلف معدات/عهدة (Asset Damage)', code: 'DAMAGE', color: Colors.black, metaData: {'type': 'FIXED', 'maxLimit': '100', 'glAccount': '15020', 'auto': false}),
    LookupItem(id: 'DED-SHORT', name: 'نقص في العهدة المالية (Cash Shortage)', code: 'SHORTAGE', color: Colors.grey, metaData: {'type': 'FIXED', 'maxLimit': '100', 'glAccount': '11010', 'auto': false}),
    LookupItem(id: 'DED-COURT', name: 'اقتطاع قضائي (Court Order)', code: 'COURT', color: Colors.blue[900], metaData: {'type': 'FIXED', 'maxLimit': '25', 'glAccount': '22090', 'auto': false}),
  ],

// 13. طرق دفع الرواتب (Smart Payments - Comprehensive List)
  LookupCategory.paymentMethods: [
    // 1. تحويل بنكي مباشر (IBAN)
    LookupItem(id: 'PAY-BANK', name: 'تحويل بنكي مباشر (Bank Transfer)', code: 'BANK', color: Colors.blue[800], metaData: {'requireAccount': true, 'bankCode': 'TRF', 'currency': 'JOD'}),
    
    // 2. نظام حماية الأجور (WPS) - إلزامي
    LookupItem(id: 'PAY-WPS', name: 'نظام حماية الأجور (WPS)', code: 'WPS', color: Colors.blue, metaData: {'requireAccount': true, 'bankCode': 'WPS-001', 'currency': 'JOD'}),
    
    // 3. شيك بنكي
    LookupItem(id: 'PAY-CHEQUE', name: 'شيك بنكي (Cheque)', code: 'CHQ', color: Colors.teal, metaData: {'requireAccount': false, 'bankCode': '', 'currency': 'JOD'}),
    
    // 4. نقداً
    LookupItem(id: 'PAY-CASH', name: 'نقداً (Cash)', code: 'CASH', color: Colors.green, metaData: {'requireAccount': false, 'bankCode': '', 'currency': 'JOD'}),
    
    // 5. محفظة إلكترونية
    LookupItem(id: 'PAY-WALLET', name: 'محفظة إلكترونية (E-Wallet)', code: 'WALLET', color: Colors.purple, metaData: {'requireAccount': true, 'bankCode': 'EWALLET', 'currency': 'JOD'}),
    
    // 6. حوالة خارجية
    LookupItem(id: 'PAY-INTL', name: 'حوالة خارجية (Intl. Remittance)', code: 'INTL', color: Colors.orange, metaData: {'requireAccount': true, 'bankCode': 'SWIFT', 'currency': 'USD'}),
    
    // 7. بطاقة مسبقة الدفع
    LookupItem(id: 'PAY-CARD', name: 'بطاقة مسبقة الدفع (Prepaid Card)', code: 'PREPAID', color: Colors.indigo, metaData: {'requireAccount': true, 'bankCode': 'CARD', 'currency': 'JOD'}),
  ],

  // 14. أنواع المكافآت والحوافز (Smart Rewards - Comprehensive List)
  LookupCategory.rewardTypes: [
    // 1. مكافأة إنتاجية (مرتبطة بالتارجت)
    LookupItem(id: 'REW-PROD', name: 'مكافأة إنتاجية (Production Bonus)', code: 'PROD', color: Colors.green, metaData: {'type': 'CASH', 'kpi': 'PRODUCTION', 'basis': 'Target Achievement', 'taxable': true}),

    // 2. عمولة مبيعات
    LookupItem(id: 'REW-COMM', name: 'عمولة مبيعات (Sales Commission)', code: 'COMM', color: Colors.teal, metaData: {'type': 'CASH', 'kpi': 'SALES', 'basis': '% of Collection', 'taxable': true}),

    // 3. مكافأة أداء سنوية
    LookupItem(id: 'REW-ANNUAL', name: 'مكافأة أداء سنوية (Performance)', code: 'ANNUAL', color: Colors.blue, metaData: {'type': 'CASH', 'kpi': 'GENERAL', 'basis': 'Appraisal Score', 'taxable': true}),

    // 4. مكافأة الشهر المثالي
    LookupItem(id: 'REW-EMP', name: 'موظف الشهر المثالي (Employee of Month)', code: 'EMP-M', color: Colors.amber, metaData: {'type': 'GIFT', 'kpi': 'GENERAL', 'basis': 'Nomination', 'taxable': false}),

    // 5. مكافأة السلامة (مهمة للمصانع)
    LookupItem(id: 'REW-SAFE', name: 'مكافأة التزام بالسلامة (Safety)', code: 'SAFE', color: Colors.deepOrange, metaData: {'type': 'CASH', 'kpi': 'SAFETY', 'basis': 'Zero Accidents', 'taxable': true}),

    // 6. مكافأة ولاء (سنوات خدمة)
    LookupItem(id: 'REW-LOYAL', name: 'مكافأة ولاء (Loyalty Bonus)', code: 'LOYAL', color: Colors.indigo, metaData: {'type': 'CASH', 'kpi': 'GENERAL', 'basis': '5+ Years Service', 'taxable': true}),

    // 7. مكافأة إبداع واقتراحات
    LookupItem(id: 'REW-IDEA', name: 'مكافأة إبداع واقتراحات (Innovation)', code: 'IDEA', color: Colors.purple, metaData: {'type': 'CASH', 'kpi': 'GENERAL', 'basis': 'Cost Saving Idea', 'taxable': false}),

    // 8. مكافأة مشروع (تسليم مبكر)
    LookupItem(id: 'REW-PROJ', name: 'مكافأة إنجاز مشروع (Project Bonus)', code: 'PROJ', color: Colors.cyan, metaData: {'type': 'CASH', 'kpi': 'GENERAL', 'basis': 'Early Delivery', 'taxable': true}),

    // 9. مكافأة فورية (عمل طارئ)
    LookupItem(id: 'REW-SPOT', name: 'مكافأة فورية (Spot Bonus)', code: 'SPOT', color: Colors.redAccent, metaData: {'type': 'CASH', 'kpi': 'GENERAL', 'basis': 'Emergency Task', 'taxable': true}),

    // 10. مكافأة بدل تدريب
    LookupItem(id: 'REW-TRAIN', name: 'مكافأة بدل تدريب (Training Incentive)', code: 'TRAIN', color: Colors.brown, metaData: {'type': 'CASH', 'kpi': 'GENERAL', 'basis': 'Training Colleagues', 'taxable': true}),
  ],

  // 15. أنواع الوثائق والمستندات (Smart Documents - Comprehensive List)
  LookupCategory.documentTypes: [
    // وثائق إثبات الشخصية
    LookupItem(id: 'DOC-ID', name: 'الهوية الوطنية / الشخصية', code: 'ID', color: Colors.blue, metaData: {'expiry': true, 'alert': '30', 'mandatory': true, 'upload': true}),
    LookupItem(id: 'DOC-PASS', name: 'جواز السفر (Passport)', code: 'PASS', color: Colors.indigo, metaData: {'expiry': true, 'alert': '180', 'mandatory': false, 'upload': true}),
    LookupItem(id: 'DOC-FAMILY', name: 'دفتر العائلة', code: 'FAMILY', color: Colors.blueGrey, metaData: {'expiry': false, 'alert': '0', 'mandatory': true, 'upload': true}),

    // وثائق العمل القانونية (للأجانب والسائقين)
    LookupItem(id: 'DOC-WORK-PMT', name: 'تصريح العمل (Work Permit)', code: 'PERMIT', color: Colors.red, metaData: {'expiry': true, 'alert': '45', 'mandatory': true, 'upload': true}),
    LookupItem(id: 'DOC-RES', name: 'بطاقة الإقامة (Residency)', code: 'RES', color: Colors.deepOrange, metaData: {'expiry': true, 'alert': '30', 'mandatory': true, 'upload': true}),
    LookupItem(id: 'DOC-DRV-HVY', name: 'رخصة قيادة إنشائية (فئة 6)', code: 'DRV-HVY', color: Colors.orange, metaData: {'expiry': true, 'alert': '30', 'mandatory': false, 'upload': true}),
    LookupItem(id: 'DOC-DRV-PVT', name: 'رخصة قيادة خاصة', code: 'DRV-PVT', color: Colors.amber, metaData: {'expiry': true, 'alert': '30', 'mandatory': false, 'upload': true}),

    // وثائق التوظيف والشهادات
    LookupItem(id: 'DOC-CONT', name: 'عقد العمل الموقع', code: 'CONTRACT', color: Colors.green, metaData: {'expiry': true, 'alert': '60', 'mandatory': true, 'upload': true}),
    LookupItem(id: 'DOC-DEGREE', name: 'الشهادة الجامعية / الدبلوم', code: 'DEGREE', color: Colors.teal, metaData: {'expiry': false, 'alert': '0', 'mandatory': true, 'upload': true}),
    LookupItem(id: 'DOC-EXP', name: 'شهادات الخبرة السابقة', code: 'EXP', color: Colors.cyan, metaData: {'expiry': false, 'alert': '0', 'mandatory': false, 'upload': true}),
    LookupItem(id: 'DOC-CLEAR', name: 'شهادة عدم محكومية', code: 'CLEAR', color: Colors.purple, metaData: {'expiry': true, 'alert': '90', 'mandatory': true, 'upload': true}),

    // وثائق مالية وطبية
    LookupItem(id: 'DOC-IBAN', name: 'شهادة بنكية (IBAN)', code: 'BANK', color: Colors.brown, metaData: {'expiry': false, 'alert': '0', 'mandatory': true, 'upload': true}),
    LookupItem(id: 'DOC-MED', name: 'تقرير فحص طبي (Medical)', code: 'MED-CHECK', color: Colors.pink, metaData: {'expiry': true, 'alert': '30', 'mandatory': true, 'upload': true}),
  ],

// 16. تأشيرات العمل والإقامات (Smart Visas - Comprehensive List)
  LookupCategory.visaTypes: [
    // 1. إقامة عمل سنوية (الوضع القياسي)
    LookupItem(id: 'VIS-RES', name: 'إقامة عمل سنوية (Residency)', code: 'RES-WORK', color: Colors.blue, metaData: {'duration': '12', 'cost': '500', 'medical': true, 'guarantee': false}),
    
    // 2. تصريح عمل (مصنع/مهني)
    LookupItem(id: 'VIS-PMT', name: 'تصريح عمل (Work Permit)', code: 'PMT-FAC', color: Colors.indigo, metaData: {'duration': '12', 'cost': '400', 'medical': true, 'guarantee': true}),
    
    // 3. تأشيرة زيارة عمل
    LookupItem(id: 'VIS-BUS', name: 'تأشيرة زيارة عمل (Business)', code: 'VIS-BUS', color: Colors.teal, metaData: {'duration': '3', 'cost': '150', 'medical': false, 'guarantee': false}),
    
    // 4. خروج وعودة (مفردة/متعددة)
    LookupItem(id: 'VIS-EXIT-S', name: 'خروج وعودة (مفردة)', code: 'EXIT-S', color: Colors.orange, metaData: {'duration': '2', 'cost': '200', 'medical': false, 'guarantee': false}),
    LookupItem(id: 'VIS-EXIT-M', name: 'خروج وعودة (متعددة)', code: 'EXIT-M', color: Colors.deepOrange, metaData: {'duration': '6', 'cost': '500', 'medical': false, 'guarantee': false}),
    
    // 5. خروج نهائي
    LookupItem(id: 'VIS-FINAL', name: 'تأشيرة خروج نهائي (Final)', code: 'FINAL', color: Colors.red, metaData: {'duration': '2', 'cost': '0', 'medical': false, 'guarantee': false}),
    
    // 6. نقل كفالة (إجراء إداري)
    LookupItem(id: 'VIS-TRANS', name: 'نقل كفالة (Sponsorship Transfer)', code: 'TRANS', color: Colors.purple, metaData: {'duration': '0', 'cost': '2000', 'medical': true, 'guarantee': false}),
    
    // 7. إقامة مستثمر (للشركاء)
    LookupItem(id: 'VIS-INV', name: 'إقامة مستثمر (Investor)', code: 'RES-INV', color: Colors.amber, metaData: {'duration': '60', 'cost': '0', 'medical': true, 'guarantee': false}),
    
    // 8. تأشيرة مرافقي (للعائلات)
    LookupItem(id: 'VIS-DEP', name: 'تأشيرة مرافقي (Dependent)', code: 'DEP', color: Colors.green, metaData: {'duration': '12', 'cost': '400', 'medical': true, 'guarantee': false}),
  ],

 // 17. المهارات والكفاءات الفنية (Smart Competencies - Comprehensive Matrix)
  LookupCategory.skillTypes: [
    // --- 1. مهارات الإنتاج والتصنيع (Production) ---
    LookupItem(id: 'SK-CNC', name: 'برمجة وتشغيل CNC', code: 'PROD-CNC', color: Colors.blue[900], metaData: {'cat': 'TECHNICAL', 'cert': true, 'renewal': '0'}),
    LookupItem(id: 'SK-SAW', name: 'تشغيل مناشير جسرية (Bridge Saw)', code: 'PROD-SAW', color: Colors.blue[800], metaData: {'cat': 'TECHNICAL', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-POLISH', name: 'فني جلي وتلميع (Polishing)', code: 'PROD-POL', color: Colors.blue[700], metaData: {'cat': 'TECHNICAL', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-WATER', name: 'قص ووتر جيت (Waterjet)', code: 'PROD-WJET', color: Colors.blue[600], metaData: {'cat': 'TECHNICAL', 'cert': true, 'renewal': '0'}),
    LookupItem(id: 'SK-CAST', name: 'خلط وصب الخرسانة/الحجر', code: 'PROD-CAST', color: Colors.brown, metaData: {'cat': 'TECHNICAL', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-CARVE', name: 'نحت وزخرفة يدوية', code: 'PROD-ART', color: Colors.amber[900], metaData: {'cat': 'TECHNICAL', 'cert': false, 'renewal': '0'}),

    // --- 2. الصيانة والهندسة (Engineering & Maint) ---
    LookupItem(id: 'SK-ELEC', name: 'كهرباء صناعية (Industrial Electric)', code: 'ENG-ELEC', color: Colors.red[900], metaData: {'cat': 'TECHNICAL', 'cert': true, 'renewal': '3'}),
    LookupItem(id: 'SK-MECH', name: 'صيانة ميكانيكية وهيدروليك', code: 'ENG-MECH', color: Colors.red[700], metaData: {'cat': 'TECHNICAL', 'cert': true, 'renewal': '0'}),
    LookupItem(id: 'SK-AUTOCAD', name: 'رسم هندسي (AutoCAD/2D)', code: 'ENG-CAD', color: Colors.purple, metaData: {'cat': 'TECHNICAL', 'cert': true, 'renewal': '0'}),
    LookupItem(id: 'SK-BIM', name: 'نمذجة ثلاثية الأبعاد (3D/BIM)', code: 'ENG-3D', color: Colors.purpleAccent, metaData: {'cat': 'TECHNICAL', 'cert': true, 'renewal': '0'}),
    LookupItem(id: 'SK-PLC', name: 'برمجة لوحات تحكم (PLC)', code: 'ENG-PLC', color: Colors.redAccent, metaData: {'cat': 'TECHNICAL', 'cert': true, 'renewal': '0'}),

    // --- 3. الجودة والسلامة (QHSE) ---
    LookupItem(id: 'SK-ISO', name: 'تدقيق الجودة (ISO 9001)', code: 'QC-ISO', color: Colors.teal[800], metaData: {'cat': 'TECHNICAL', 'cert': true, 'renewal': '3'}),
    LookupItem(id: 'SK-INSP', name: 'فحص الحجر والمواد الخام', code: 'QC-MAT', color: Colors.teal, metaData: {'cat': 'TECHNICAL', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-SAFE', name: 'إدارة السلامة والصحة المهنية (OSHA)', code: 'HSE-MGT', color: Colors.orange[900], metaData: {'cat': 'SAFETY', 'cert': true, 'renewal': '2'}),
    LookupItem(id: 'SK-FIRE', name: 'مكافحة الحرائق والإخلاء', code: 'HSE-FIRE', color: Colors.deepOrange, metaData: {'cat': 'SAFETY', 'cert': true, 'renewal': '2'}),
    LookupItem(id: 'SK-FIRST', name: 'إسعافات أولية (First Aid)', code: 'HSE-AID', color: Colors.red, metaData: {'cat': 'SAFETY', 'cert': true, 'renewal': '2'}),

    // --- 4. اللوجستيات وسلاسل الإمداد (Logistics) ---
    LookupItem(id: 'SK-FORK', name: 'قيادة رافعة شوكية (Forklift)', code: 'LOG-FORK', color: Colors.amber, metaData: {'cat': 'SAFETY', 'cert': true, 'renewal': '1'}),
    LookupItem(id: 'SK-CRANE', name: 'تشغيل ونش علوي (Overhead Crane)', code: 'LOG-CRANE', color: Colors.amber[700], metaData: {'cat': 'SAFETY', 'cert': true, 'renewal': '2'}),
    LookupItem(id: 'SK-WMS', name: 'إدارة المخزون والمستودعات (WMS)', code: 'LOG-WMS', color: Colors.brown[400], metaData: {'cat': 'ADMIN', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-PROC', name: 'التخليص الجمركي والشحن', code: 'LOG-SHIP', color: Colors.brown[600], metaData: {'cat': 'ADMIN', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-PACK', name: 'تغليف وتوضيب (Packaging)', code: 'LOG-PACK', color: Colors.brown[300], metaData: {'cat': 'TECHNICAL', 'cert': false, 'renewal': '0'}),

    // --- 5. المالية والإدارة (Finance & Admin) ---
    LookupItem(id: 'SK-ACC', name: 'محاسبة عامة وقيود', code: 'FIN-ACC', color: Colors.indigo, metaData: {'cat': 'ADMIN', 'cert': true, 'renewal': '0'}),
    LookupItem(id: 'SK-TAX', name: 'قوانين الضريبة والضمان', code: 'FIN-TAX', color: Colors.indigo[800], metaData: {'cat': 'ADMIN', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-COST', name: 'محاسبة التكاليف الصناعية', code: 'FIN-COST', color: Colors.indigoAccent, metaData: {'cat': 'ADMIN', 'cert': true, 'renewal': '0'}),
    LookupItem(id: 'SK-ERP-USR', name: 'استخدام نظام ERP', code: 'SYS-ERP', color: Colors.blueGrey, metaData: {'cat': 'ADMIN', 'cert': false, 'renewal': '0'}),

    // --- 6. الموارد البشرية (HR) ---
    LookupItem(id: 'SK-PAY', name: 'إعداد الرواتب (Payroll)', code: 'HR-PAY', color: Colors.pink, metaData: {'cat': 'ADMIN', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-LABOR', name: 'قانون العمل والعمال', code: 'HR-LAW', color: Colors.pink[700], metaData: {'cat': 'ADMIN', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-REC', name: 'التوظيف والمقابلات', code: 'HR-REC', color: Colors.pinkAccent, metaData: {'cat': 'SOFT', 'cert': false, 'renewal': '0'}),

    // --- 7. المبيعات والتسويق (Sales) ---
    LookupItem(id: 'SK-NEG', name: 'فنون التفاوض والإقناع', code: 'SAL-NEG', color: Colors.green, metaData: {'cat': 'SOFT', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-CRM', name: 'إدارة علاقات العملاء (CRM)', code: 'SAL-CRM', color: Colors.green[700], metaData: {'cat': 'ADMIN', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-MKT', name: 'التسويق الرقمي', code: 'MKT-DIG', color: Colors.lightGreen, metaData: {'cat': 'TECHNICAL', 'cert': true, 'renewal': '0'}),
    LookupItem(id: 'SK-ENG-SAL', name: 'قراءة المخططات للتسعير', code: 'SAL-ENG', color: Colors.green[900], metaData: {'cat': 'TECHNICAL', 'cert': false, 'renewal': '0'}),

    // --- 8. مهارات ناعمة وقيادية (Soft Skills) ---
    LookupItem(id: 'SK-LEAD', name: 'القيادة وإدارة الفرق', code: 'SOFT-LEAD', color: Colors.cyan, metaData: {'cat': 'SOFT', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-COMM', name: 'التواصل الفعال', code: 'SOFT-COMM', color: Colors.cyan[600], metaData: {'cat': 'SOFT', 'cert': false, 'renewal': '0'}),
    LookupItem(id: 'SK-PROB', name: 'حل المشكلات واتخاذ القرار', code: 'SOFT-PROB', color: Colors.cyan[800], metaData: {'cat': 'SOFT', 'cert': false, 'renewal': '0'}),
  ],

 // 22. بنك المهام القياسية (SOPs - Ultra Comprehensive List)
  LookupCategory.standardTasks: [
    // ============================================================
    // 1. قسم الإنتاج (Production Department) - القلب النابض
    // ============================================================
    // أ. وحدة الخلاطة والصب (Mixing & Casting)
    LookupItem(id: 'SOP-MIX-01', name: 'معايرة ميزان المواد والمياه (Recipe Check)', code: 'PRD-MIX-01', icon: Icons.scale, metaData: {'freq': 'يومي', 'dept': 'PROD', 'target': 1, 'unit': 'معايرة', 'role': 'مشغل الخلاطة'}),
    LookupItem(id: 'SOP-MIX-02', name: 'فحص نظافة القوالب وعزلها (Mold Prep)', code: 'PRD-MIX-02', icon: Icons.cleaning_services, metaData: {'freq': 'كل صبة', 'dept': 'PROD', 'target': 50, 'unit': 'قالب', 'role': 'عامل صب'}),
    LookupItem(id: 'SOP-MIX-03', name: 'مراقبة زمن الهزاز (Vibration Time)', code: 'PRD-MIX-03', icon: Icons.vibration, metaData: {'freq': 'كل صبة', 'dept': 'PROD', 'target': 1, 'unit': 'فحص', 'role': 'فني تشغيل'}),
    LookupItem(id: 'SOP-MIX-04', name: 'أخذ عينات الخرسانة للفحص (Slump Test)', code: 'PRD-MIX-04', icon: Icons.science, metaData: {'freq': 'كل خلطة', 'dept': 'PROD', 'target': 3, 'unit': 'عينة', 'role': 'مراقب جودة'}),
    LookupItem(id: 'SOP-MIX-05', name: 'تسجيل كميات الاستهلاك (Raw Material Log)', code: 'PRD-MIX-05', icon: Icons.edit_note, metaData: {'freq': 'نهاية الوردية', 'dept': 'PROD', 'target': 1, 'unit': 'تقرير', 'role': 'مشرف الإنتاج'}),
    
    // ب. وحدة القص (Cutting Unit)
    LookupItem(id: 'SOP-CUT-01', name: 'فحص وتبريد شفرات المنشار', code: 'PRD-CUT-01', icon: Icons.ac_unit, metaData: {'freq': 'كل 2 ساعة', 'dept': 'PROD', 'target': 4, 'unit': 'فحص', 'role': 'فني قص'}),
    LookupItem(id: 'SOP-CUT-02', name: 'برمجة مقاسات القص (Dimension Setup)', code: 'PRD-CUT-02', icon: Icons.settings, metaData: {'freq': 'لكل طلبية', 'dept': 'PROD', 'target': 1, 'unit': 'إعداد', 'role': 'مشغل منشار'}),
    LookupItem(id: 'SOP-CUT-03', name: 'إزالة الزوائد والرايش (Deburring)', code: 'PRD-CUT-03', icon: Icons.cut, metaData: {'freq': 'مستمر', 'dept': 'PROD', 'target': 100, 'unit': 'قطعة', 'role': 'عامل مساعد'}),
    LookupItem(id: 'SOP-CUT-04', name: 'فحص استقامة القص (Squareness Check)', code: 'PRD-CUT-04', icon: Icons.square_foot, metaData: {'freq': 'عشوائي', 'dept': 'QC', 'target': 10, 'unit': 'عينة', 'role': 'مراقب جودة'}),
    
    // ج. وحدة الـ CNC والنحت (CNC & Carving)
    LookupItem(id: 'SOP-CNC-01', name: 'تحميل ومراجعة كود التصميم (G-Code)', code: 'PRD-CNC-01', icon: Icons.code, metaData: {'freq': 'لكل طلبية', 'dept': 'PROD', 'target': 1, 'unit': 'ملف', 'role': 'مشغل CNC'}),
    LookupItem(id: 'SOP-CNC-02', name: 'تثبيت القطعة على الطاولة (Workholding)', code: 'PRD-CNC-02', icon: Icons.anchor, metaData: {'freq': 'قبل التشغيل', 'dept': 'PROD', 'target': 1, 'unit': 'تثبيت', 'role': 'مشغل CNC'}),
    LookupItem(id: 'SOP-CNC-03', name: 'مراقبة تآكل الريشة (Tool Wear)', code: 'PRD-CNC-03', icon: Icons.construction, metaData: {'freq': 'كل 4 ساعات', 'dept': 'PROD', 'target': 1, 'unit': 'فحص', 'role': 'فني تشغيل'}),
    LookupItem(id: 'SOP-CNC-04', name: 'تنظيف الماكينة من الغبار (Dust Clean)', code: 'PRD-CNC-04', icon: Icons.cleaning_services, metaData: {'freq': 'نهاية الوردية', 'dept': 'PROD', 'target': 1, 'unit': 'تنظيف', 'role': 'مشغل CNC'}),

    // د. وحدة الجلي والتلميع (Polishing)
    LookupItem(id: 'SOP-POL-01', name: 'تغيير أحجار الجلي (Abrasives Change)', code: 'PRD-POL-01', icon: Icons.change_circle, metaData: {'freq': 'عند الحاجة', 'dept': 'PROD', 'target': 1, 'unit': 'تغيير', 'role': 'فني جلي'}),
    LookupItem(id: 'SOP-POL-02', name: 'قياس درجة اللمعان (Gloss Meter)', code: 'PRD-POL-02', icon: Icons.wb_sunny, metaData: {'freq': 'كل ساعة', 'dept': 'QC', 'target': 5, 'unit': 'قراءة', 'role': 'مراقب جودة'}),
    LookupItem(id: 'SOP-POL-03', name: 'معالجة الشقوق بالريزين (Resin Fill)', code: 'PRD-POL-03', icon: Icons.format_paint, metaData: {'freq': 'حسب الحاجة', 'dept': 'PROD', 'target': 10, 'unit': 'قطعة', 'role': 'فني معالجة'}),

    // ============================================================
    // 2. إدارة الجودة (Quality Control - QC)
    // ============================================================
    LookupItem(id: 'SOP-QC-01', name: 'فحص المواد الخام الواردة (Inbound QC)', code: 'QC-MAT-01', icon: Icons.science, metaData: {'freq': 'لكل شحنة', 'dept': 'QC', 'target': 1, 'unit': 'فحص', 'role': 'مهندس جودة'}),
    LookupItem(id: 'SOP-QC-02', name: 'فحص الأبعاد والسماكة (Dimension Check)', code: 'QC-CHK-01', icon: Icons.straighten, metaData: {'freq': 'عشوائي', 'dept': 'QC', 'target': 20, 'unit': 'عينة', 'role': 'مراقب جودة'}),
    LookupItem(id: 'SOP-QC-03', name: 'فحص العيوب البصرية واللون (Visual)', code: 'QC-CHK-02', icon: Icons.visibility, metaData: {'freq': 'مستمر', 'dept': 'QC', 'target': 100, 'unit': '%', 'role': 'مراقب جودة'}),
    LookupItem(id: 'SOP-QC-04', name: 'اختبار قوة الكسر (Strength Test)', code: 'QC-LAB-01', icon: Icons.fitness_center, metaData: {'freq': 'أسبوعي', 'dept': 'QC', 'target': 3, 'unit': 'عينة', 'role': 'فني مختبر'}),
    LookupItem(id: 'SOP-QC-05', name: 'معايرة أجهزة القياس (Calibration)', code: 'QC-CAL-01', icon: Icons.tune, metaData: {'freq': 'شهري', 'dept': 'QC', 'target': 5, 'unit': 'جهاز', 'role': 'مدير الجودة'}),
    LookupItem(id: 'SOP-QC-06', name: 'إصدار شهادة المطابقة (CoC)', code: 'QC-DOC-01', icon: Icons.verified, metaData: {'freq': 'لكل طلبية', 'dept': 'QC', 'target': 1, 'unit': 'شهادة', 'role': 'مهندس جودة'}),
    LookupItem(id: 'SOP-QC-07', name: 'تحليل شكاوى العملاء (RCA)', code: 'QC-RCA-01', icon: Icons.report_problem, metaData: {'freq': 'عند الشكوى', 'dept': 'QC', 'target': 1, 'unit': 'تحليل', 'role': 'مدير الجودة'}),

    // ============================================================
    // 3. الصيانة والهندسة (Maintenance & Engineering)
    // ============================================================
    // أ. صيانة ميكانيكية
    LookupItem(id: 'SOP-MNT-01', name: 'تشحيم المحاور والجنازير (Lubrication)', code: 'MNT-MECH-01', icon: Icons.opacity, metaData: {'freq': 'أسبوعي', 'dept': 'MAINT', 'target': 1, 'unit': 'جولة', 'role': 'فني ميكانيك'}),
    LookupItem(id: 'SOP-MNT-02', name: 'تفريغ مياه ضواغط الهواء (Air Compressor)', code: 'MNT-MECH-02', icon: Icons.air, metaData: {'freq': 'يومي', 'dept': 'MAINT', 'target': 1, 'unit': 'مرة', 'role': 'مساعد فني'}),
    LookupItem(id: 'SOP-MNT-03', name: 'فحص وتغيير زيوت الهيدروليك', code: 'MNT-MECH-03', icon: Icons.oil_barrel, metaData: {'freq': 'شهري', 'dept': 'MAINT', 'target': 1, 'unit': 'ماكينة', 'role': 'فني ميكانيك'}),
    
    // ب. صيانة كهربائية
    LookupItem(id: 'SOP-MNT-04', name: 'تفقد حرارة اللوحات الكهربائية (Thermal)', code: 'MNT-ELC-01', icon: Icons.thermostat, metaData: {'freq': 'أسبوعي', 'dept': 'MAINT', 'target': 1, 'unit': 'جولة', 'role': 'كهربائي'}),
    LookupItem(id: 'SOP-MNT-05', name: 'فحص وتنظيف فلاتر التبريد (Cooling)', code: 'MNT-ELC-02', icon: Icons.mode_fan_off, metaData: {'freq': 'أسبوعي', 'dept': 'MAINT', 'target': 10, 'unit': 'فلتر', 'role': 'مساعد كهربائي'}),
    LookupItem(id: 'SOP-MNT-06', name: 'اختبار أنظمة الطوارئ (E-Stop)', code: 'MNT-ELC-03', icon: Icons.stop_circle, metaData: {'freq': 'شهري', 'dept': 'MAINT', 'target': 1, 'unit': 'اختبار', 'role': 'مهندس صيانة'}),
    
    // ج. صيانة عامة ومباني
    LookupItem(id: 'SOP-MNT-07', name: 'صيانة الونش العلوي (Overhead Crane)', code: 'MNT-GEN-01', icon: Icons.precision_manufacturing, metaData: {'freq': 'شهري', 'dept': 'MAINT', 'target': 1, 'unit': 'فحص', 'role': 'فني ميكانيك'}),
    LookupItem(id: 'SOP-MNT-08', name: 'فحص نظام معالجة المياه (Recycling)', code: 'MNT-GEN-02', icon: Icons.water_drop, metaData: {'freq': 'يومي', 'dept': 'MAINT', 'target': 1, 'unit': 'فحص', 'role': 'فني صيانة'}),

    // ============================================================
    // 4. اللوجستيات وسلاسل الإمداد (Logistics & Supply Chain)
    // ============================================================
    // أ. المستودعات (Warehouse)
    LookupItem(id: 'SOP-LOG-01', name: 'استلام المواد وفحص المطابقة (GRN)', code: 'LOG-WH-01', icon: Icons.fact_check, metaData: {'freq': 'عند الوصول', 'dept': 'LOG', 'target': 1, 'unit': 'شحنة', 'role': 'أمين مستودع'}),
    LookupItem(id: 'SOP-LOG-02', name: 'صرف مواد للإنتاج (Material Issue)', code: 'LOG-WH-02', icon: Icons.outbox, metaData: {'freq': 'يومي', 'dept': 'LOG', 'target': 10, 'unit': 'طلب', 'role': 'أمين مستودع'}),
    LookupItem(id: 'SOP-LOG-03', name: 'جرد المواد الخام (Stocktake)', code: 'LOG-WH-03', icon: Icons.inventory_2, metaData: {'freq': 'شهري', 'dept': 'LOG', 'target': 1, 'unit': 'جرد', 'role': 'لجنة جرد'}),
    LookupItem(id: 'SOP-LOG-04', name: 'ترتيب وتنظيم الرفوف (5S)', code: 'LOG-WH-04', icon: Icons.shelves, metaData: {'freq': 'أسبوعي', 'dept': 'LOG', 'target': 1, 'unit': 'جولة', 'role': 'عامل مستودع'}),
    
    // ب. الشحن والتوصيل (Shipping & Fleet)
    LookupItem(id: 'SOP-LOG-05', name: 'تغليف وتربيط الطبالي (Strapping)', code: 'LOG-SHP-01', icon: Icons.archive, metaData: {'freq': 'مستمر', 'dept': 'LOG', 'target': 20, 'unit': 'طبلية', 'role': 'عامل تغليف'}),
    LookupItem(id: 'SOP-LOG-06', name: 'تحميل الشاحنات وتأمين الحمولة', code: 'LOG-SHP-02', icon: Icons.local_shipping, metaData: {'freq': 'لكل شحنة', 'dept': 'LOG', 'target': 1, 'unit': 'شاحنة', 'role': 'مشرف حركة'}),
    LookupItem(id: 'SOP-LOG-07', name: 'فحص المركبات اليومي (Vehicle Check)', code: 'LOG-FLT-01', icon: Icons.car_repair, metaData: {'freq': 'يومي', 'dept': 'LOG', 'target': 1, 'unit': 'فحص', 'role': 'سائق'}),
    LookupItem(id: 'SOP-LOG-08', name: 'متابعة الصيانة الدورية للأسطول', code: 'LOG-FLT-02', icon: Icons.build_circle, metaData: {'freq': 'شهري', 'dept': 'LOG', 'target': 1, 'unit': 'تقرير', 'role': 'مسؤول حركة'}),

    // ج. المشتريات (Procurement)
    LookupItem(id: 'SOP-PUR-01', name: 'إصدار أوامر الشراء (PO Creation)', code: 'LOG-PUR-01', icon: Icons.shopping_cart, metaData: {'freq': 'عند الطلب', 'dept': 'LOG', 'target': 1, 'unit': 'أمر', 'role': 'موظف مشتريات'}),
    LookupItem(id: 'SOP-PUR-02', name: 'تقييم أداء الموردين (Vendor Eval)', code: 'LOG-PUR-02', icon: Icons.rate_review, metaData: {'freq': 'ربع سنوي', 'dept': 'LOG', 'target': 1, 'unit': 'تقييم', 'role': 'مدير المشتريات'}),
    LookupItem(id: 'SOP-PUR-03', name: 'متابعة التخليص الجمركي', code: 'LOG-PUR-03', icon: Icons.local_police, metaData: {'freq': 'لكل شحنة', 'dept': 'LOG', 'target': 1, 'unit': 'معاملة', 'role': 'مخلص جمركي'}),

    // ============================================================
    // 5. السلامة والصحة المهنية (HSE - Safety First)
    // ============================================================
    LookupItem(id: 'SOP-HSE-01', name: 'جولة تفتيش السلامة اليومية (Walkthrough)', code: 'HSE-AUD-01', icon: Icons.security, metaData: {'freq': 'يومي', 'dept': 'HSE', 'target': 1, 'unit': 'جولة', 'role': 'مشرف سلامة'}),
    LookupItem(id: 'SOP-HSE-02', name: 'التفتيش على ارتداء PPE', code: 'HSE-AUD-02', icon: Icons.masks, metaData: {'freq': 'مستمر', 'dept': 'HSE', 'target': 20, 'unit': 'عامل', 'role': 'مشرف سلامة'}),
    LookupItem(id: 'SOP-HSE-03', name: 'فحص صلاحية طفايات الحريق', code: 'HSE-EQP-01', icon: Icons.fire_extinguisher, metaData: {'freq': 'شهري', 'dept': 'HSE', 'target': 1, 'unit': 'فحص شامل', 'role': 'مسؤول سلامة'}),
    LookupItem(id: 'SOP-HSE-04', name: 'تفقد صناديق الإسعافات الأولية', code: 'HSE-EQP-02', icon: Icons.medical_services, metaData: {'freq': 'أسبوعي', 'dept': 'HSE', 'target': 5, 'unit': 'صندوق', 'role': 'مسعف'}),
    LookupItem(id: 'SOP-HSE-05', name: 'تقييم المخاطر قبل العمل (Risk Assessment)', code: 'HSE-RSK-01', icon: Icons.warning, metaData: {'freq': 'قبل المهام', 'dept': 'HSE', 'target': 1, 'unit': 'تصريح', 'role': 'مهندس سلامة'}),
    LookupItem(id: 'SOP-HSE-06', name: 'التدريب التعريفي للموظفين الجدد (Induction)', code: 'HSE-TRN-01', icon: Icons.school, metaData: {'freq': 'عند التعيين', 'dept': 'HSE', 'target': 1, 'unit': 'دورة', 'role': 'مدرب سلامة'}),
    LookupItem(id: 'SOP-HSE-07', name: 'التحقيق في الحوادث الوشيقة (Near Miss)', code: 'HSE-INC-01', icon: Icons.report, metaData: {'freq': 'عند الحدوث', 'dept': 'HSE', 'target': 1, 'unit': 'تقرير', 'role': 'مدير HSE'}),

    // ============================================================
    // 6. المبيعات والتسويق (Sales & Marketing)
    // ============================================================
    // أ. المبيعات (Sales)
    LookupItem(id: 'SOP-SAL-01', name: 'متابعة العملاء المحتملين (Leads)', code: 'SAL-CRM-01', icon: Icons.contact_phone, metaData: {'freq': 'يومي', 'dept': 'SALES', 'target': 10, 'unit': 'اتصال', 'role': 'موظف مبيعات'}),
    LookupItem(id: 'SOP-SAL-02', name: 'إعداد وإرسال عروض الأسعار (Quotations)', code: 'SAL-QTE-01', icon: Icons.request_quote, metaData: {'freq': 'عند الطلب', 'dept': 'SALES', 'target': 1, 'unit': 'عرض', 'role': 'موظف مبيعات'}),
    LookupItem(id: 'SOP-SAL-03', name: 'زيارة ميدانية لموقع العميل (Site Visit)', code: 'SAL-VST-01', icon: Icons.location_on, metaData: {'freq': 'أسبوعي', 'dept': 'SALES', 'target': 5, 'unit': 'زيارة', 'role': 'مهندس مبيعات'}),
    LookupItem(id: 'SOP-SAL-04', name: 'أخذ المقاسات في الموقع (Measurements)', code: 'SAL-ENG-01', icon: Icons.architecture, metaData: {'freq': 'عند الطلب', 'dept': 'SALES', 'target': 1, 'unit': 'رفع مساحي', 'role': 'فني قياس'}),
    LookupItem(id: 'SOP-SAL-05', name: 'إغلاق الصفقات وتوقيع العقود', code: 'SAL-CLS-01', icon: Icons.handshake, metaData: {'freq': 'شهري', 'dept': 'SALES', 'target': 1, 'unit': 'هدف', 'role': 'مدير المبيعات'}),
    
    // ب. التسويق (Marketing)
    LookupItem(id: 'SOP-MKT-01', name: 'تحديث منصات التواصل الاجتماعي', code: 'MKT-SOC-01', icon: Icons.share, metaData: {'freq': 'أسبوعي', 'dept': 'MKT', 'target': 3, 'unit': 'منشور', 'role': 'مسؤول تسويق'}),
    LookupItem(id: 'SOP-MKT-02', name: 'تحليل المنافسين والسوق', code: 'MKT-ANL-01', icon: Icons.query_stats, metaData: {'freq': 'شهري', 'dept': 'MKT', 'target': 1, 'unit': 'تقرير', 'role': 'مدير التسويق'}),
    LookupItem(id: 'SOP-MKT-03', name: 'تصوير المنتجات والمشاريع المنفذة', code: 'MKT-PHO-01', icon: Icons.camera_alt, metaData: {'freq': 'بعد التركيب', 'dept': 'MKT', 'target': 1, 'unit': 'ألبوم', 'role': 'مصور'}),

    // ============================================================
    // 7. المالية والإدارة (Finance & Admin)
    // ============================================================
    // أ. المحاسبة والمالية
    LookupItem(id: 'SOP-FIN-01', name: 'جرد ومطابقة الصندوق اليومي (Cash)', code: 'FIN-CSH-01', icon: Icons.point_of_sale, metaData: {'freq': 'يومي', 'dept': 'FIN', 'target': 1, 'unit': 'إغلاق', 'role': 'أمين صندوق'}),
    LookupItem(id: 'SOP-FIN-02', name: 'تسجيل القيود المحاسبية (Journal Entries)', code: 'FIN-GL-01', icon: Icons.book, metaData: {'freq': 'يومي', 'dept': 'FIN', 'target': 1, 'unit': 'دفتر', 'role': 'محاسب عام'}),
    LookupItem(id: 'SOP-FIN-03', name: 'إصدار فواتير المبيعات (Invoicing)', code: 'FIN-INV-01', icon: Icons.receipt_long, metaData: {'freq': 'عند البيع', 'dept': 'FIN', 'target': 1, 'unit': 'فاتورة', 'role': 'محاسب مبيعات'}),
    LookupItem(id: 'SOP-FIN-04', name: 'متابعة التحصيلات والذمم (Collections)', code: 'FIN-COL-01', icon: Icons.phone_forwarded, metaData: {'freq': 'أسبوعي', 'dept': 'FIN', 'target': 20, 'unit': 'عميل', 'role': 'محاسب عملاء'}),
    LookupItem(id: 'SOP-FIN-05', name: 'مطابقة الحسابات البنكية (Reconciliation)', code: 'FIN-BNK-01', icon: Icons.account_balance, metaData: {'freq': 'شهري', 'dept': 'FIN', 'target': 1, 'unit': 'مطابقة', 'role': 'رئيس حسابات'}),
    LookupItem(id: 'SOP-FIN-06', name: 'إعداد إقرارات ضريبة الدخل والمبيعات', code: 'FIN-TAX-01', icon: Icons.calculate, metaData: {'freq': 'دوري', 'dept': 'FIN', 'target': 1, 'unit': 'إقرار', 'role': 'المدير المالي'}),

    // ============================================================
    // 8. الموارد البشرية (Human Resources - HR)
    // ============================================================
    LookupItem(id: 'SOP-HR-01', name: 'مراجعة سجلات الحضور والغياب', code: 'HR-ATT-01', icon: Icons.fingerprint, metaData: {'freq': 'يومي', 'dept': 'HR', 'target': 1, 'unit': 'تقرير', 'role': 'مسؤول HR'}),
    LookupItem(id: 'SOP-HR-02', name: 'إعداد كشوف الرواتب (Payroll)', code: 'HR-PAY-01', icon: Icons.payments, metaData: {'freq': 'شهري', 'dept': 'HR', 'target': 1, 'unit': 'كشف', 'role': 'مسؤول رواتب'}),
    LookupItem(id: 'SOP-HR-03', name: 'تجديد الإقامات والتصاريح', code: 'HR-GOV-01', icon: Icons.badge, metaData: {'freq': 'قبل الانتهاء', 'dept': 'HR', 'target': 1, 'unit': 'معاملة', 'role': 'مراسل/معقب'}),
    LookupItem(id: 'SOP-HR-04', name: 'إجراء مقابلات التوظيف', code: 'HR-REC-01', icon: Icons.people, metaData: {'freq': 'عند الشواغر', 'dept': 'HR', 'target': 1, 'unit': 'مقابلة', 'role': 'مدير HR'}),
    LookupItem(id: 'SOP-HR-05', name: 'تقييم أداء الموظفين السنوي', code: 'HR-EVAL-01', icon: Icons.assessment, metaData: {'freq': 'سنوي', 'dept': 'HR', 'target': 1, 'unit': 'دورة', 'role': 'مدير HR'}),
    LookupItem(id: 'SOP-HR-06', name: 'متابعة الإجازات والمغادرات', code: 'HR-LEAVE-01', icon: Icons.flight_takeoff, metaData: {'freq': 'يومي', 'dept': 'HR', 'target': 1, 'unit': 'تحديث', 'role': 'مسؤول HR'}),

    // ============================================================
    // 9. الإدارة العليا والتخطيط (HQ & Strategy)
    // ============================================================
    LookupItem(id: 'SOP-HQ-01', name: 'مراجعة لوحة المؤشرات اليومية (Dashboard)', code: 'HQ-DASH-01', icon: Icons.dashboard, metaData: {'freq': 'يومي', 'dept': 'HQ', 'target': 1, 'unit': 'مراجعة', 'role': 'المدير العام'}),
    LookupItem(id: 'SOP-HQ-02', name: 'اجتماع مدراء الإدارات الدوري', code: 'HQ-MTG-01', icon: Icons.groups, metaData: {'freq': 'أسبوعي', 'dept': 'HQ', 'target': 1, 'unit': 'اجتماع', 'role': 'المدير العام'}),
    LookupItem(id: 'SOP-HQ-03', name: 'مراجعة القوائم المالية الشهرية (P&L)', code: 'HQ-FIN-01', icon: Icons.pie_chart, metaData: {'freq': 'شهري', 'dept': 'HQ', 'target': 1, 'unit': 'تقرير', 'role': 'المدير المالي'}),
    LookupItem(id: 'SOP-HQ-04', name: 'إعداد الموازنة التقديرية (Budgeting)', code: 'HQ-BUD-01', icon: Icons.account_balance_wallet, metaData: {'freq': 'سنوي', 'dept': 'HQ', 'target': 1, 'unit': 'موازنة', 'role': 'مجلس الإدارة'}),
  ],

// 18. أدوات السلامة (Smart PPE - Factory Standard)
  LookupCategory.safetyTools: [
    // حماية الرأس والوجه
    LookupItem(id: 'PPE-HELMET', name: 'خوذة سلامة صناعية (Hard Hat)', code: 'HELMET', color: Colors.yellow[700], metaData: {'lifespan': '730', 'returnable': true, 'zone': 'ALL_SITES'}),
    LookupItem(id: 'PPE-GOGGLE', name: 'نظارات واقية (Safety Goggles)', code: 'EYE', color: Colors.blue[300], metaData: {'lifespan': '90', 'returnable': false, 'zone': 'PRODUCTION'}),
    LookupItem(id: 'PPE-SHIELD', name: 'واقي وجه كامل (Face Shield)', code: 'FACE', color: Colors.blueGrey, metaData: {'lifespan': '180', 'returnable': true, 'zone': 'CUTTING'}),

    // حماية التنفس (حيوي جداً للحجر)
    LookupItem(id: 'PPE-MASK', name: 'كمامة غبار (N95/FPP3)', code: 'MASK', color: Colors.white, metaData: {'lifespan': '1', 'returnable': false, 'zone': 'DUSTY_AREAS'}),
    
    // حماية اليد والقدم
    LookupItem(id: 'PPE-GLOVE', name: 'قفازات عمل شاقة (Heavy Duty)', code: 'GLOVE', color: Colors.brown, metaData: {'lifespan': '30', 'returnable': false, 'zone': 'HANDLING'}),
    LookupItem(id: 'PPE-SHOES', name: 'حذاء سلامة (Steel Toe)', code: 'BOOTS', color: Colors.black, metaData: {'lifespan': '365', 'returnable': false, 'zone': 'ALL_SITES'}),

    // حماية السمع والجسد
    LookupItem(id: 'PPE-EAR', name: 'سدادات أذن (Earplugs)', code: 'EAR', color: Colors.orange, metaData: {'lifespan': '30', 'returnable': false, 'zone': 'NOISY_AREAS'}),
    LookupItem(id: 'PPE-VEST', name: 'سترة عاكسة (Reflective Vest)', code: 'VEST', color: Colors.orangeAccent, metaData: {'lifespan': '180', 'returnable': true, 'zone': 'YARD_LOGISTICS'}),
    LookupItem(id: 'PPE-HARN', name: 'حزام أمان (Safety Harness)', code: 'BELT', color: Colors.red, metaData: {'lifespan': '1095', 'returnable': true, 'zone': 'HEIGHTS'}),
    LookupItem(id: 'PPE-SUIT', name: 'بدلة عمل (Coverall)', code: 'SUIT', color: Colors.indigo, metaData: {'lifespan': '180', 'returnable': false, 'zone': 'WORKSHOP'}),
  ],



// 19. أنواع العُهد المستلمة (Smart Custody Assets)
  LookupCategory.custodyTypes: [
    // عهد تكنولوجية
    LookupItem(id: 'CUST-LAPTOP', name: 'لابتوب / جهاز لوحي (IT)', code: 'IT-DEV', color: Colors.blue, metaData: {'serial': true, 'returnable': true, 'check': true, 'value': '500'}),
    LookupItem(id: 'CUST-MOBILE', name: 'هاتف محمول (Mobile)', code: 'MOB', color: Colors.blueAccent, metaData: {'serial': true, 'returnable': true, 'check': true, 'value': '200'}),
    LookupItem(id: 'CUST-SIM', name: 'شريحة اتصال / بيانات', code: 'SIM', color: Colors.lightBlue, metaData: {'serial': true, 'returnable': true, 'check': false, 'value': '10'}),

    // مركبات ومعدات
    LookupItem(id: 'CUST-CAR', name: 'سيارة / مركبة (Vehicle)', code: 'CAR', color: Colors.red, metaData: {'serial': true, 'returnable': true, 'check': true, 'value': '15000'}),
    LookupItem(id: 'CUST-FORKLIFT', name: 'رافعة شوكية (Forklift)', code: 'FORK', color: Colors.orange, metaData: {'serial': true, 'returnable': true, 'check': true, 'value': '10000'}),

    // أدوات ومعدات يدوية
    LookupItem(id: 'CUST-TOOLS', name: 'طقم عدد يدوية (Toolkit)', code: 'TOOL', color: Colors.brown, metaData: {'serial': false, 'returnable': true, 'check': true, 'value': '50'}),
    LookupItem(id: 'CUST-DRILL', name: 'دريل / صاروخ قص', code: 'DRILL', color: Colors.brown[700], metaData: {'serial': true, 'returnable': true, 'check': true, 'value': '80'}),

    // عهد إدارية وشخصية
    LookupItem(id: 'CUST-KEY', name: 'مفتاح مكتب / مستودع', code: 'KEY', color: Colors.grey, metaData: {'serial': false, 'returnable': true, 'check': false, 'value': '5'}),
    LookupItem(id: 'CUST-UNIFORM', name: 'زي موحد (Uniform)', code: 'UNI', color: Colors.teal, metaData: {'serial': false, 'returnable': false, 'check': false, 'value': '20'}),
    LookupItem(id: 'CUST-CASH', name: 'عهدة نقدية (Petty Cash)', code: 'CASH', color: Colors.green, metaData: {'serial': false, 'returnable': true, 'check': true, 'value': '100'}),
  ],
  
  /// 20. لائحة المخالفات والجزاءات (Smart Disciplinary Code - Comprehensive Matrix)
  LookupCategory.violationTypes: [
    // --- 1. مخالفات الدوام والحضور (Time & Attendance) ---
    LookupItem(id: 'VIO-LATE', name: 'تأخير صباحي (Late Arrival)', code: 'ATT-LATE', color: Colors.amber, metaData: {'penalty': '0.25', 'progressive': true, 'reset': '30', 'investigation': false}),
    LookupItem(id: 'VIO-ABSENT', name: 'غياب بدون عذر (Absent)', code: 'ATT-ABS', color: Colors.deepOrange, metaData: {'penalty': '1.0', 'progressive': true, 'reset': '90', 'investigation': false}),
    LookupItem(id: 'VIO-EARLY', name: 'مغادرة قبل الموعد دون إذن', code: 'ATT-EARLY', color: Colors.orange, metaData: {'penalty': '0.5', 'progressive': true, 'reset': '30', 'investigation': false}),
    LookupItem(id: 'VIO-FINGER', name: 'عدم التبصيم (دخول/خروج)', code: 'ATT-NO-FP', color: Colors.brown, metaData: {'penalty': '0.25', 'progressive': true, 'reset': '30', 'investigation': false}),
    LookupItem(id: 'VIO-SLEEP', name: 'النوم أثناء العمل (Sleeping)', code: 'ATT-SLEEP', color: Colors.red[300], metaData: {'penalty': '1.0', 'progressive': true, 'reset': '180', 'investigation': true}),

    // --- 2. السلامة والصحة المهنية (HSE - Factory Critical) ---
    LookupItem(id: 'VIO-PPE', name: 'عدم ارتداء مهمات الوقاية (PPE)', code: 'HSE-PPE', color: Colors.red, metaData: {'penalty': '0.5', 'progressive': true, 'reset': '90', 'investigation': false}),
    LookupItem(id: 'VIO-SMOKE', name: 'تدخين في الأماكن المحظورة', code: 'HSE-SMOKE', color: Colors.red[900], metaData: {'penalty': '3.0', 'progressive': false, 'reset': '365', 'investigation': true}),
    LookupItem(id: 'VIO-DEVICE', name: 'تعطيل أجهزة السلامة/الحساسات', code: 'HSE-TAMP', color: Colors.redAccent, metaData: {'penalty': 'TERMINATION', 'progressive': false, 'reset': '0', 'investigation': true}),
    LookupItem(id: 'VIO-HYG', name: 'عدم الالتزام بالنظافة العامة', code: 'HSE-HYG', color: Colors.brown[300], metaData: {'penalty': 'WARNING', 'progressive': true, 'reset': '60', 'investigation': false}),

    // --- 3. الإنتاج والجودة (Production & Quality) ---
    LookupItem(id: 'VIO-PROD-LOW', name: 'تعمد تقليل الإنتاجية', code: 'PRD-LOW', color: Colors.blueGrey, metaData: {'penalty': '1.0', 'progressive': true, 'reset': '90', 'investigation': true}),
    LookupItem(id: 'VIO-WASTE', name: 'هدر غير مبرر للمواد الخام', code: 'PRD-WASTE', color: Colors.brown, metaData: {'penalty': 'COST', 'progressive': true, 'reset': '180', 'investigation': true}),
    LookupItem(id: 'VIO-QC-FAIL', name: 'تمرير منتج معيب (إهمال)', code: 'QC-NEG', color: Colors.deepPurple, metaData: {'penalty': '1.0', 'progressive': true, 'reset': '180', 'investigation': true}),
    LookupItem(id: 'VIO-MACHINE', name: 'سوء استخدام الآلات والمعدات', code: 'PRD-MACH', color: Colors.indigo, metaData: {'penalty': 'COST+10%', 'progressive': false, 'reset': '365', 'investigation': true}),
    LookupItem(id: 'VIO-PHONE', name: 'استخدام الهاتف في خط الإنتاج', code: 'PRD-PHONE', color: Colors.amber[800], metaData: {'penalty': '0.25', 'progressive': true, 'reset': '30', 'investigation': false}),

    // --- 4. اللوجستيات والسائقين (Logistics & Fleet) ---
    LookupItem(id: 'VIO-SPEED', name: 'تجاوز السرعة/تهور (سائقين)', code: 'LOG-SPEED', color: Colors.red, metaData: {'penalty': '1.0', 'progressive': true, 'reset': '180', 'investigation': false}),
    LookupItem(id: 'VIO-ROUTE', name: 'تغيير خط السير دون إذن', code: 'LOG-ROUTE', color: Colors.orange, metaData: {'penalty': '0.5', 'progressive': true, 'reset': '90', 'investigation': true}),
    LookupItem(id: 'VIO-VEHICLE', name: 'عدم تفقد المركبة/النظافة', code: 'LOG-CHK', color: Colors.grey, metaData: {'penalty': 'WARNING', 'progressive': true, 'reset': '60', 'investigation': false}),
    LookupItem(id: 'VIO-ACCIDENT', name: 'تسبب بحادث (خطأ السائق)', code: 'LOG-ACC', color: Colors.red[900], metaData: {'penalty': 'COST', 'progressive': false, 'reset': '365', 'investigation': true}),

    // --- 5. المبيعات والتسويق (Sales & CRM) ---
    LookupItem(id: 'VIO-CLIENT', name: 'سوء التعامل مع العملاء', code: 'SAL-RUDE', color: Colors.pink, metaData: {'penalty': '2.0', 'progressive': true, 'reset': '365', 'investigation': true}),
    LookupItem(id: 'VIO-REPORT', name: 'تقديم تقارير زيارة وهمية', code: 'SAL-FAKE', color: Colors.pink[900], metaData: {'penalty': '3.0', 'progressive': false, 'reset': '365', 'investigation': true}),
    LookupItem(id: 'VIO-DRESS', name: 'عدم الالتزام بالمظهر العام', code: 'SAL-LOOK', color: Colors.purpleAccent, metaData: {'penalty': 'WARNING', 'progressive': true, 'reset': '30', 'investigation': false}),

    // --- 6. المالية والعهدة (Finance & Assets) ---
    LookupItem(id: 'VIO-CASH', name: 'عجز في العهدة المالية', code: 'FIN-SHORT', color: Colors.green[900], metaData: {'penalty': 'PAY-DIFF', 'progressive': true, 'reset': '365', 'investigation': true}),
    LookupItem(id: 'VIO-ASSET', name: 'فقدان/تلف عهدة (لابتوب/عدة)', code: 'FIN-ASSET', color: Colors.teal[900], metaData: {'penalty': 'COST', 'progressive': false, 'reset': '0', 'investigation': true}),
    LookupItem(id: 'VIO-THEFT', name: 'سرقة أو اختلاس (فصل)', code: 'FIN-THEFT', color: Colors.black, metaData: {'penalty': 'TERMINATION', 'progressive': false, 'reset': '0', 'investigation': true}),

    // --- 7. السلوك العام والإداري (General Conduct) ---
    LookupItem(id: 'VIO-INSUB', name: 'عدم الامتثال للأوامر (Insubordination)', code: 'GEN-INSUB', color: Colors.purple, metaData: {'penalty': '1.0', 'progressive': true, 'reset': '180', 'investigation': true}),
    LookupItem(id: 'VIO-FIGHT', name: 'مشاجرة / اعتداء لفظي', code: 'GEN-FIGHT', color: Colors.redAccent, metaData: {'penalty': '3.0', 'progressive': false, 'reset': '365', 'investigation': true}),
    LookupItem(id: 'VIO-SECRET', name: 'إفشاء أسرار العمل', code: 'GEN-SEC', color: Colors.grey[800], metaData: {'penalty': 'TERMINATION', 'progressive': false, 'reset': '0', 'investigation': true}),
    LookupItem(id: 'VIO-DOCS', name: 'تزوير مستندات رسمية', code: 'GEN-FORGE', color: Colors.black, metaData: {'penalty': 'TERMINATION', 'progressive': false, 'reset': '0', 'investigation': true}),
  ],

 // 21. معايير التقييم السنوي (Smart Performance Appraisal - Comprehensive Matrix)
  LookupCategory.evaluationCriteria: [
    // --- 1. معايير الكفاءة العامة (General Competencies - For All) ---
    LookupItem(id: 'EVAL-ATTEND', name: 'الالتزام بالدوام والمواعيد', code: 'GEN-ATT', color: Colors.blue, metaData: {'weight': '15', 'role': 'ALL', 'kpi': 'ATTENDANCE_RATE'}),
    LookupItem(id: 'EVAL-TEAM', name: 'التعاون والعمل بروح الفريق', code: 'GEN-TEAM', color: Colors.indigo, metaData: {'weight': '10', 'role': 'ALL', 'kpi': 'NONE'}),
    LookupItem(id: 'EVAL-DISC', name: 'الامتثال للسياسات واللوائح', code: 'GEN-RULE', color: Colors.blueGrey, metaData: {'weight': '10', 'role': 'ALL', 'kpi': 'VIOLATION_COUNT'}),
    LookupItem(id: 'EVAL-COMM', name: 'مهارات التواصل الفعال', code: 'GEN-COMM', color: Colors.cyan, metaData: {'weight': '10', 'role': 'ALL', 'kpi': 'NONE'}),

    // --- 2. الإنتاج والعمليات (Production & Operations) ---
    LookupItem(id: 'EVAL-PROD-QTY', name: 'كمية الإنتاج (تحقيق التارجت)', code: 'PRD-QTY', color: Colors.green[800], metaData: {'weight': '30', 'role': 'WORKER', 'kpi': 'PRODUCTION_VOLUME'}),
    LookupItem(id: 'EVAL-PROD-QLT', name: 'جودة العمل (دقة التصنيع)', code: 'PRD-QLT', color: Colors.teal, metaData: {'weight': '25', 'role': 'WORKER', 'kpi': 'REJECT_RATE'}),
    LookupItem(id: 'EVAL-WASTE', name: 'كفاءة استخدام المواد (تقليل الهادر)', code: 'PRD-WST', color: Colors.brown, metaData: {'weight': '15', 'role': 'WORKER', 'kpi': 'WASTE_PERCENT'}),
    LookupItem(id: 'EVAL-MACH', name: 'المحافظة على الماكينات والمعدات', code: 'PRD-EQP', color: Colors.grey[700], metaData: {'weight': '15', 'role': 'WORKER', 'kpi': 'MACHINE_DOWNTIME'}),

    // --- 3. السلامة والصحة المهنية (HSE - Critical) ---
    LookupItem(id: 'EVAL-SAFE-INC', name: 'سجل الحوادث والإصابات (Zero Accidents)', code: 'HSE-REC', color: Colors.red[900], metaData: {'weight': '25', 'role': 'WORKER', 'kpi': 'ACCIDENT_COUNT'}),
    LookupItem(id: 'EVAL-SAFE-PPE', name: 'الالتزام بارتداء مهمات الوقاية', code: 'HSE-PPE', color: Colors.redAccent, metaData: {'weight': '15', 'role': 'ALL', 'kpi': 'SAFETY_VIOLATIONS'}),
    
    // --- 4. المبيعات والتسويق (Sales & Marketing) ---
    LookupItem(id: 'EVAL-SAL-TGT', name: 'تحقيق هدف المبيعات (Sales Target)', code: 'SAL-TGT', color: Colors.purple, metaData: {'weight': '50', 'role': 'SALES', 'kpi': 'SALES_AMOUNT'}),
    LookupItem(id: 'EVAL-CUST-SAT', name: 'رضا العملاء (Customer Satisfaction)', code: 'SAL-SAT', color: Colors.purpleAccent, metaData: {'weight': '20', 'role': 'SALES', 'kpi': 'NPS_SCORE'}),
    LookupItem(id: 'EVAL-NEW-CLT', name: 'استقطاب عملاء جدد (New Business)', code: 'SAL-NEW', color: Colors.deepPurple, metaData: {'weight': '15', 'role': 'SALES', 'kpi': 'NEW_LEADS'}),
    LookupItem(id: 'EVAL-COLL', name: 'تحصيل الذمم المالية (Collections)', code: 'SAL-COL', color: Colors.indigoAccent, metaData: {'weight': '15', 'role': 'SALES', 'kpi': 'COLLECTION_RATE'}),

    // --- 5. اللوجستيات وسلاسل الإمداد (Logistics & Supply Chain) ---
    LookupItem(id: 'EVAL-DELIV', name: 'الالتزام بمواعيد التوصيل (On-Time)', code: 'LOG-TIME', color: Colors.orange[800], metaData: {'weight': '40', 'role': 'DRIVER', 'kpi': 'DELIVERY_SLA'}),
    LookupItem(id: 'EVAL-VEHICLE', name: 'نظافة وصيانة المركبة', code: 'LOG-VEH', color: Colors.orange, metaData: {'weight': '20', 'role': 'DRIVER', 'kpi': 'MAINTENANCE_COST'}),
    LookupItem(id: 'EVAL-INV-ACC', name: 'دقة جرد المخزون (Inventory Accuracy)', code: 'LOG-INV', color: Colors.brown[400], metaData: {'weight': '30', 'role': 'STOREKEEPER', 'kpi': 'STOCK_VARIANCE'}),
    LookupItem(id: 'EVAL-FUEL', name: 'كفاءة استهلاك الوقود', code: 'LOG-FUEL', color: Colors.amber[900], metaData: {'weight': '10', 'role': 'DRIVER', 'kpi': 'FUEL_CONSUMPTION'}),

    // --- 6. الجودة (Quality Control) ---
    LookupItem(id: 'EVAL-QC-ACC', name: 'دقة الفحص وكشف العيوب', code: 'QC-ACC', color: Colors.teal[800], metaData: {'weight': '40', 'role': 'QC', 'kpi': 'DEFECT_DETECTION'}),
    LookupItem(id: 'EVAL-ISO', name: 'الامتثال لمعايير ISO', code: 'QC-ISO', color: Colors.teal[300], metaData: {'weight': '20', 'role': 'QC', 'kpi': 'AUDIT_SCORE'}),

    // --- 7. المالية والإدارة (Finance & Admin) ---
    LookupItem(id: 'EVAL-REP-ACC', name: 'دقة التقارير المالية', code: 'FIN-ACC', color: Colors.blueGrey[800], metaData: {'weight': '30', 'role': 'ADMIN', 'kpi': 'ERROR_RATE'}),
    LookupItem(id: 'EVAL-DEADLINE', name: 'الالتزام بالمواعيد النهائية (Deadlines)', code: 'FIN-TIME', color: Colors.blueGrey[600], metaData: {'weight': '20', 'role': 'ADMIN', 'kpi': 'TASK_SLA'}),
    LookupItem(id: 'EVAL-COST', name: 'مبادرات تقليل التكاليف', code: 'FIN-COST', color: Colors.green[900], metaData: {'weight': '15', 'role': 'ADMIN', 'kpi': 'SAVINGS_AMOUNT'}),

    // --- 8. القيادة والإدارة العليا (Leadership & HR) ---
    LookupItem(id: 'EVAL-LEAD', name: 'القيادة وتطوير الفريق', code: 'MGT-LEAD', color: Colors.black, metaData: {'weight': '30', 'role': 'MANAGER', 'kpi': 'TEAM_PERFORMANCE'}),
    LookupItem(id: 'EVAL-RETENT', name: 'الحفاظ على الموظفين (Retention)', code: 'HR-RET', color: Colors.pink, metaData: {'weight': '20', 'role': 'MANAGER', 'kpi': 'TURNOVER_RATE'}),
    LookupItem(id: 'EVAL-STRAT', name: 'التخطيط الاستراتيجي وتحقيق الأهداف', code: 'MGT-STR', color: Colors.black45, metaData: {'weight': '30', 'role': 'MANAGER', 'kpi': 'COMPANY_PROFIT'}),
  ],



};