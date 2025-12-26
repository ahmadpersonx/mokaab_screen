// FileName: lib/features/hr/org_structure/widgets/dynamic_task_list.dart
import 'package:flutter/material.dart';

// --- تصحيح الاستيراد: استخدام اسم الباكيج لتجنب أخطاء المسارات النسبية ---
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';

class DynamicTaskList extends StatefulWidget {
  final String departmentCode;

  const DynamicTaskList({super.key, required this.departmentCode});

  @override
  State<DynamicTaskList> createState() => _DynamicTaskListState();
}

class _DynamicTaskListState extends State<DynamicTaskList> {
  Map<String, int> taskProgress = {};
  List<LookupItem> assignedTasks = [];

  @override
  void initState() {
    super.initState();
    // جلب مهام تجريبية
    // التأكد من أن القوائم محملة لتجنب Null
    final allTasks = masterLookups[LookupCategory.standardTasks] ?? [];
    
    assignedTasks = allTasks
        .where((t) => t.metaData?['dept'] == widget.departmentCode || widget.departmentCode == 'DEP-PROD') 
        .take(3)
        .toList();

    // تهيئة التقدم بـ 0
    for (var task in assignedTasks) {
      taskProgress[task.id] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.playlist_add_check_circle, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  "متابعة المهام الدورية (${assignedTasks.length})",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            IconButton(
              onPressed: _openTaskBankDialog,
              icon: const Icon(Icons.add_circle, color: Colors.teal),
              tooltip: "إضافة مهمة",
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (assignedTasks.isEmpty)
          _buildEmptyState()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: assignedTasks.length,
            separatorBuilder: (c, i) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final task = assignedTasks[index];
              return _buildProgressTaskCard(task);
            },
          ),
      ],
    );
  }

  Widget _buildProgressTaskCard(LookupItem task) {
    final int target = task.metaData?['target'] ?? 1;
    final String unit = task.metaData?['unit'] ?? 'مرة';
    final String freq = task.metaData?['freq'] ?? 'يومي';

    int current = taskProgress[task.id] ?? 0;
    double progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    bool isCompleted = current >= target;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isCompleted ? Colors.green.withOpacity(0.5) : Colors.grey.shade300,
            width: isCompleted ? 1.5 : 1
        ),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف العلوي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      isCompleted ? Icons.check_circle : (task.icon ?? Icons.task_alt),
                      color: isCompleted ? Colors.green : Colors.grey[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                          task.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                              color: isCompleted ? Colors.grey : Colors.black87
                          )
                      ),
                    ),
                  ],
                ),
              ),
              if (!isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                  child: Text(freq, style: const TextStyle(fontSize: 10, color: Colors.blue)),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // الصف الأوسط: شريط التقدم
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[100],
                        color: isCompleted ? Colors.green : Colors.teal,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isCompleted ? "تم الإنجاز بالكامل" : "$current من $target $unit",
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              if (!isCompleted) ...[
                _buildActionButton(Icons.remove, () {
                  if (current > 0) setState(() => taskProgress[task.id] = current - 1);
                }),
                const SizedBox(width: 8),
                _buildActionButton(Icons.add, () {
                  setState(() => taskProgress[task.id] = current + 1);
                }, isPrimary: true),
              ] else
                const Icon(Icons.done_all, color: Colors.green, size: 28),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap, {bool isPrimary = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isPrimary ? Colors.teal : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: isPrimary ? Colors.white : Colors.grey[700]),
      ),
    );
  }

  void _openTaskBankDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("بنك المهام (SOPs Library)"),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: (masterLookups[LookupCategory.standardTasks] ?? []).length,
              itemBuilder: (context, index) {
                final task = masterLookups[LookupCategory.standardTasks]![index];
                if (assignedTasks.contains(task)) return const SizedBox.shrink();
                return ListTile(
                  title: Text(task.name),
                  subtitle: Text("${task.metaData?['target'] ?? 1} مرة ${task.metaData?['freq']}"),
                  trailing: const Icon(Icons.add_circle_outline, color: Colors.teal),
                  onTap: () {
                    setState(() {
                      assignedTasks.add(task);
                      taskProgress[task.id] = 0;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("إغلاق")),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text("لا توجد مهام"));
  }
}