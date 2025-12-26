// FileName: lib/features/hr/workflow/models/workflow_models.dart
import 'package:flutter/material.dart';

// الأدوار التي يمكنها الموافقة
enum ApproverRole { directManager, deptHead, hrManager, financeManager, generalManager }

// أنواع الطلبات التي تخضع للموافقة
enum RequestType { leave, loan, resignation, purchaseOrder, contract }

// حالة الطلب في كل مرحلة
enum WorkflowStatus { pending, approved, rejected, returned }

// 1. تعريف خط السير (القاعدة)
class WorkflowRule {
  final String id;
  final RequestType requestType;
  final List<ApproverRole> approvalChain; // التسلسل: [مباشر -> قسم -> HR]

  WorkflowRule({required this.id, required this.requestType, required this.approvalChain});
}

// 2. طلب الموافقة الفعلي (Instance)
class ApprovalRequest {
  final String id;
  final String requesterName;
  final String requesterJob;
  final RequestType type;
  final String details; // تفاصيل الطلب (إجازة 3 أيام..)
  final DateTime date;
  
  int currentStepIndex; // في أي خطوة نحن الآن؟ (0, 1, 2)
  WorkflowStatus status;
  List<ApproverRole> chain; // السلسلة التي يجب أن يمر بها

  ApprovalRequest({
    required this.id,
    required this.requesterName,
    required this.requesterJob,
    required this.type,
    required this.details,
    required this.date,
    required this.chain,
    this.currentStepIndex = 0,
    this.status = WorkflowStatus.pending,
  });

  // معرفة من هو الشخص المطلوب منه الموافقة الآن
  ApproverRole get currentApprover => chain[currentStepIndex];
  
  // هل انتهت السلسلة؟
  bool get isCompleted => currentStepIndex >= chain.length;

  Color get statusColor {
    switch (status) {
      case WorkflowStatus.pending: return Colors.orange;
      case WorkflowStatus.approved: return Colors.green;
      case WorkflowStatus.rejected: return Colors.red;
      case WorkflowStatus.returned: return Colors.blue;
    }
  }
}