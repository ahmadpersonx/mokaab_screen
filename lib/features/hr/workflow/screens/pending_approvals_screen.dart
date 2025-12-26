// FileName: lib/features/hr/workflow/screens/pending_approvals_screen.dart
// Description: صندوق الموافقات والمهام (Enhanced UI Inbox Style)
// Version: 2.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/hr/workflow/models/workflow_models.dart';
// 1. لا تنسَ استيراد ملف الخدمة الذي أنشأناه سابقاً
import 'package:mokaab/features/hr/workflow/services/approval_service.dart';

class PendingApprovalsScreen extends StatefulWidget {
  const PendingApprovalsScreen({super.key});

  @override
  State<PendingApprovalsScreen> createState() => _PendingApprovalsScreenState();
}

class _PendingApprovalsScreenState extends State<PendingApprovalsScreen> {
  // 2. تحديد دور المستخدم الحالي (محاكاة لتسجيل الدخول)
  // جرب تغيير هذا الدور لاحقاً لترى كيف تتغير الطلبات المعروضة
  final ApproverRole _currentUserRole = ApproverRole.financeManager;

  List<ApprovalRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadMockRequests();
  }

  // 3. الدالة الجديدة التي تجلب البيانات بناءً على الدور
  void _loadMockRequests() {
    // نطلب من الخدمة: "أعطني فقط الطلبات التي تنتظر موافقة المدير المالي"
    List<ApprovalRequest> myInbox = ApprovalService.getRequestsForUser(_currentUserRole);

    setState(() {
      _requests = myInbox;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Row(
          children: [
            // تغيير العنوان ليظهر الدور الحالي للتوضيح أثناء التجربة
            Text("مهامي (${_getRoleShortName(_currentUserRole)})"),
            const SizedBox(width: 8),
            if (_requests.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                child: Text("${_requests.length}", style: const TextStyle(fontSize: 14)),
              )
          ],
        ),
        backgroundColor: const Color(0xFF263238),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _requests.isEmpty 
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _requests.length,
            itemBuilder: (context, index) {
              return _buildRequestCard(_requests[index]);
            },
          ),
    );
  }

  // ... (باقي الكود: _buildEmptyState, _buildRequestCard, _processRequest, الخ كما هو) ...
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.green[200]),
          const SizedBox(height: 16),
          const Text("رائع! لا توجد مهام معلقة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Text("أنت (${_getRoleShortName(_currentUserRole)}) ليس لديك أي طلبات للمراجعة.", style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRequestCard(ApprovalRequest req) {
    // ... (نفس كود بناء البطاقة السابق) ...
    Color themeColor = Colors.blue;
    IconData typeIcon = Icons.description;

    switch (req.type) {
      case RequestType.leave: themeColor = Colors.purple; typeIcon = Icons.beach_access; break;
      case RequestType.loan: themeColor = Colors.green; typeIcon = Icons.monetization_on; break;
      case RequestType.purchaseOrder: themeColor = Colors.orange; typeIcon = Icons.shopping_cart; break;
      case RequestType.resignation: themeColor = Colors.red; typeIcon = Icons.exit_to_app; break;
      default: break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(0)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: themeColor.withOpacity(0.1),
                          child: Icon(typeIcon, color: themeColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(req.requesterName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(req.requesterJob, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              const SizedBox(height: 4),
                              Text(DateFormat('yyyy/MM/dd HH:mm').format(req.date), style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                          child: Text(_getTypeName(req.type), style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("التفاصيل:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(req.details, style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87)),
                
                const SizedBox(height: 20),
                _buildWorkflowSteps(req, themeColor),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _processRequest(req, false),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text("رفض"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _processRequest(req, true),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text("اعتماد"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowSteps(ApprovalRequest req, Color activeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("مسار الموافقة:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        SizedBox(
          height: 30,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: req.chain.length,
            separatorBuilder: (ctx, i) => Container(
              width: 20, 
              height: 2, 
              color: i < req.currentStepIndex ? Colors.green : Colors.grey[300],
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
            itemBuilder: (context, index) {
              bool isCompleted = index < req.currentStepIndex;
              bool isCurrent = index == req.currentStepIndex;
              
              return Row(
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : (isCurrent ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                    size: 18,
                    color: isCompleted ? Colors.green : (isCurrent ? activeColor : Colors.grey[400]),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getRoleShortName(req.chain[index]),
                    style: TextStyle(
                      fontSize: 11, 
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent ? Colors.black87 : Colors.grey
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _processRequest(ApprovalRequest req, bool approved) {
    setState(() {
      if (approved) {
        req.currentStepIndex++;
        if (req.currentStepIndex >= req.chain.length) {
          req.status = WorkflowStatus.approved;
          _requests.remove(req);
          _showSuccessDialog("تم اعتماد الطلب نهائياً");
        } else {
          req.status = WorkflowStatus.pending;
          _showSuccessDialog("تمت الموافقة، وتم إرسال الطلب للمسؤول التالي");
          
          // في الواقع، هنا يجب إعادة تحميل القائمة لأن الطلب لم يعد من اختصاصي
          // ولكن للمحاكاة سنحذفه من القائمة
          _requests.remove(req);
        }
      } else {
        req.status = WorkflowStatus.rejected;
        _requests.remove(req);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم رفض الطلب"), backgroundColor: Colors.red));
      }
    });
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            Text("عملية ناجحة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  String _getTypeName(RequestType type) {
    switch (type) {
      case RequestType.leave: return "طلب إجازة";
      case RequestType.loan: return "سلفة مالية";
      case RequestType.purchaseOrder: return "أمر شراء";
      case RequestType.resignation: return "استقالة";
      default: return "طلب عام";
    }
  }

  String _getRoleShortName(ApproverRole role) {
    switch (role) {
      case ApproverRole.directManager: return "م.مباشر";
      case ApproverRole.deptHead: return "القسم";
      case ApproverRole.hrManager: return "HR";
      case ApproverRole.financeManager: return "المالية";
      case ApproverRole.generalManager: return "م.عام";
      default: return "";
    }
  }
}