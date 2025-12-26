import 'package:flutter/material.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';

// --- هذا هو المكان الوحيد الذي يجب أن يُعرف فيه هذا الكلاس ---
class CategoryDescriptor {
  final String id;
  final String title;
  final IconData icon;
  final bool isSystem;
  final LookupCategory? systemEnum;

  CategoryDescriptor({
    required this.id,
    required this.title,
    required this.icon,
    this.isSystem = false,
    this.systemEnum,
  });
}

IconData getSystemIcon(LookupCategory category) {
  // ... (نفس كود الأيقونات السابق)
  switch (category) {
    case LookupCategory.departments: return Icons.apartment;
    case LookupCategory.sections: return Icons.category;
    case LookupCategory.units: return Icons.grid_view;
    case LookupCategory.locations: return Icons.place;
    case LookupCategory.jobTitles: return Icons.badge;
    case LookupCategory.jobLevels: return Icons.stairs;
    case LookupCategory.contractTypes: return Icons.description;
    case LookupCategory.terminationReasons: return Icons.exit_to_app;
    case LookupCategory.shifts: return Icons.access_time;
    case LookupCategory.leaveTypes: return Icons.flight_takeoff;
    case LookupCategory.attendanceStatus: return Icons.how_to_reg;
    case LookupCategory.allowanceTypes: return Icons.monetization_on;
    case LookupCategory.deductionTypes: return Icons.money_off;
    case LookupCategory.paymentMethods: return Icons.payment;
    case LookupCategory.documentTypes: return Icons.folder_shared;
    case LookupCategory.visaTypes: return Icons.public;
    case LookupCategory.skillTypes: return Icons.psychology;
    case LookupCategory.standardTasks: return Icons.playlist_add_check;
    case LookupCategory.rewardTypes: return Icons.emoji_events;
    case LookupCategory.safetyTools: return Icons.health_and_safety;
    case LookupCategory.custodyTypes: return Icons.handyman;
    case LookupCategory.violationTypes: return Icons.gavel;
    case LookupCategory.evaluationCriteria: return Icons.analytics;
    default: return Icons.settings;
  }
}