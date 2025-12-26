import 'package:mokaab/features/hr/workflow/models/workflow_models.dart';

class ApprovalService {
  // محاكاة لقاعدة البيانات
  // هذه القائمة تحتوي على "كل" الطلبات في الشركة
  static final List<ApprovalRequest> _allCompanyRequests = [
    ApprovalRequest(
      id: 'REQ-101', requesterName: 'محمود حسن', requesterJob: 'سائق', type: RequestType.leave,
      details: 'إجازة سنوية', date: DateTime.now(),
      chain: [ApproverRole.directManager, ApproverRole.hrManager], 
      currentStepIndex: 0 // (الدور الحالي: Direct Manager)
    ),
    ApprovalRequest(
      id: 'REQ-102', requesterName: 'سارة علي', requesterJob: 'محاسب', type: RequestType.loan,
      details: 'سلفة مالية', date: DateTime.now(),
      chain: [ApproverRole.directManager, ApproverRole.financeManager], 
      currentStepIndex: 1 // (الدور الحالي: Finance Manager)
    ),
    ApprovalRequest(
      id: 'REQ-103', requesterName: 'خالد يوسف', requesterJob: 'مهندس', type: RequestType.resignation,
      details: 'استقالة', date: DateTime.now(),
      chain: [ApproverRole.directManager, ApproverRole.hrManager, ApproverRole.generalManager], 
      currentStepIndex: 2 // (الدور الحالي: General Manager)
    ),
  ];

  // دالة الجلب الذكية
  static List<ApprovalRequest> getRequestsForUser(ApproverRole userRole) {
    return _allCompanyRequests.where((req) {
      // 1. يجب أن يكون الطلب معلقاً
      if (req.status != WorkflowStatus.pending) return false;

      // 2. معرفة من هو الدور المطلوب منه الموافقة الآن
      ApproverRole currentRequiredRole = req.chain[req.currentStepIndex];

      // 3. هل هذا الدور يطابق دور المستخدم الحالي؟
      return currentRequiredRole == userRole;
    }).toList();
  }
}