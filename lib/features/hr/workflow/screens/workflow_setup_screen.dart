// FileName: lib/features/hr/workflow/screens/workflow_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/hr/workflow/models/workflow_models.dart';

class WorkflowSetupScreen extends StatefulWidget {
  const WorkflowSetupScreen({super.key});

  @override
  State<WorkflowSetupScreen> createState() => _WorkflowSetupScreenState();
}

class _WorkflowSetupScreenState extends State<WorkflowSetupScreen> {
  // قائمة القواعد (الآن يمكن تعديلها)
  List<WorkflowRule> _rules = [
    WorkflowRule(id: 'R1', requestType: RequestType.leave, approvalChain: [ApproverRole.directManager, ApproverRole.hrManager]),
    WorkflowRule(id: 'R2', requestType: RequestType.loan, approvalChain: [ApproverRole.directManager, ApproverRole.hrManager, ApproverRole.financeManager]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("إعداد مسارات الموافقة (Workflow)"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _rules.isEmpty 
          ? _buildEmptyState() 
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _rules.length,
              itemBuilder: (context, index) {
                final rule = _rules[index];
                return _buildRuleCard(rule);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openRuleEditor(),
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add),
        label: const Text("قاعدة جديدة"),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.account_tree_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text("لا توجد مسارات معرفة بعد", style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRuleCard(WorkflowRule rule) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.indigo[50], borderRadius: BorderRadius.circular(8)),
                  child: Icon(_getIcon(rule.requestType), color: Colors.indigo),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_getTypeName(rule.requestType), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("${rule.approvalChain.length} خطوات للموافقة", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue), 
                  onPressed: () => _openRuleEditor(existingRule: rule),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red), 
                  onPressed: () => _deleteRule(rule),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text("تسلسل الموافقات:", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // رسم السلسلة (Timeline)
            SizedBox(
              height: 35,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: rule.approvalChain.length,
                separatorBuilder: (ctx, i) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                ),
                itemBuilder: (context, stepIndex) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${stepIndex + 1}. ${_getRoleName(rule.approvalChain[stepIndex])}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Logic Functions ---

  void _deleteRule(WorkflowRule rule) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        title: const Text("حذف القاعدة"),
        content: Text("هل أنت متأكد من حذف مسار الموافقة الخاص بـ ${_getTypeName(rule.requestType)}؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              setState(() => _rules.remove(rule));
              Navigator.pop(context);
            }, 
            child: const Text("حذف", style: TextStyle(color: Colors.red))
          ),
        ],
      )
    );
  }

  // --- The Dynamic Editor Dialog ---
  void _openRuleEditor({WorkflowRule? existingRule}) {
    RequestType selectedType = existingRule?.requestType ?? RequestType.leave;
    List<ApproverRole> currentChain = existingRule != null ? List.from(existingRule.approvalChain) : [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20, 
              left: 20, right: 20, top: 20
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existingRule == null ? "إضافة مسار جديد" : "تعديل المسار", 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 20),
                
                // 1. اختيار نوع الطلب
                DropdownButtonFormField<RequestType>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: "نوع الطلب", border: OutlineInputBorder()),
                  items: RequestType.values.map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(_getTypeName(type)),
                  )).toList(),
                  onChanged: existingRule != null ? null : (val) { // لا يمكن تغيير النوع عند التعديل
                    if (val != null) setSheetState(() => selectedType = val);
                  },
                ),
                const SizedBox(height: 20),

                // 2. بناء السلسلة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("سلسلة الموافقات (بالترتيب)", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () {
                        // إضافة خطوة جديدة (افتراضياً HR Manager)
                        setSheetState(() => currentChain.add(ApproverRole.hrManager));
                      },
                      icon: const Icon(Icons.add_circle, size: 18),
                      label: const Text("إضافة خطوة"),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                
                if (currentChain.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(8)),
                    child: const Text("يجب إضافة خطوة موافقة واحدة على الأقل", style: TextStyle(color: Colors.orange), textAlign: TextAlign.center),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: currentChain.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.grey[50],
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 12, 
                            backgroundColor: Colors.indigo, 
                            child: Text("${index + 1}", style: const TextStyle(fontSize: 12, color: Colors.white))
                          ),
                          title: DropdownButtonHideUnderline(
                            child: DropdownButton<ApproverRole>(
                              value: currentChain[index],
                              isExpanded: true,
                              items: ApproverRole.values.map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(_getRoleName(role)),
                              )).toList(),
                              onChanged: (val) {
                                if (val != null) setSheetState(() => currentChain[index] = val);
                              },
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                            onPressed: () {
                              setSheetState(() => currentChain.removeAt(index));
                            },
                          ),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 24),
                
                // زر الحفظ
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentChain.isEmpty) return;

                      setState(() {
                        if (existingRule != null) {
                          // تعديل
                          int idx = _rules.indexWhere((r) => r.id == existingRule.id);
                          if (idx != -1) {
                            _rules[idx] = WorkflowRule(id: existingRule.id, requestType: selectedType, approvalChain: currentChain);
                          }
                        } else {
                          // إضافة جديد
                          _rules.add(WorkflowRule(
                            id: DateTime.now().millisecondsSinceEpoch.toString(), 
                            requestType: selectedType, 
                            approvalChain: currentChain
                          ));
                        }
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                    child: const Text("حفظ الإعدادات"),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  // --- Helper Methods ---
  IconData _getIcon(RequestType type) {
    switch (type) {
      case RequestType.leave: return Icons.beach_access;
      case RequestType.loan: return Icons.monetization_on;
      case RequestType.resignation: return Icons.exit_to_app;
      default: return Icons.description;
    }
  }

  String _getTypeName(RequestType type) {
    switch (type) {
      case RequestType.leave: return "طلب إجازة";
      case RequestType.loan: return "طلب سلفة مالية";
      case RequestType.resignation: return "استقالة";
      case RequestType.purchaseOrder: return "أمر شراء";
      default: return "أخرى";
    }
  }

  String _getRoleName(ApproverRole role) {
    switch (role) {
      case ApproverRole.directManager: return "المدير المباشر";
      case ApproverRole.deptHead: return "رئيس القسم";
      case ApproverRole.hrManager: return "مدير الموارد البشرية";
      case ApproverRole.financeManager: return "المدير المالي";
      case ApproverRole.generalManager: return "المدير العام";
    }
  }
}