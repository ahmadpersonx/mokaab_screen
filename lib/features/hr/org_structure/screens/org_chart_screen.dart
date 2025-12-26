// FileName: lib/features/hr/org_structure/screens/org_chart_screen.dart
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mokaab/features/system_config/data/models/lookup_model.dart';
import 'package:mokaab/features/system_config/data/seed_data.dart';

// أنماط العرض المتاحة
enum ChartViewMode { 
  combined, // الكل (الافتراضي)
  administrative, // إداري فقط
  financial // مالي فقط
}

class OrgChartScreen extends StatefulWidget {
  const OrgChartScreen({super.key});

  @override
  State<OrgChartScreen> createState() => _OrgChartScreenState();
}

class _OrgChartScreenState extends State<OrgChartScreen> {
  final GlobalKey _globalKey = GlobalKey();
  
  // الوضع الحالي للعرض
  ChartViewMode _currentMode = ChartViewMode.combined;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المخطط الهيكلي (Live Dashboard)"),
        // شريط التبديل بين الأوضاع
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildModeSegment("شامل", ChartViewMode.combined, Icons.dashboard),
                const SizedBox(width: 8),
                _buildModeSegment("إداري", ChartViewMode.administrative, Icons.people),
                const SizedBox(width: 8),
                _buildModeSegment("مالي", ChartViewMode.financial, Icons.attach_money),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {}, // Future: Print Logic
            tooltip: "طباعة",
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: "تحديث",
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF0F2F5),
        child: InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(2000), 
          minScale: 0.01,
          maxScale: 5.0,
          child: RepaintBoundary(
            key: _globalKey,
            child: Padding(
              padding: const EdgeInsets.all(100.0),
              child: _buildFullTree(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeSegment(String label, ChartViewMode mode, IconData icon) {
    final bool isSelected = _currentMode == mode;
    return InkWell(
      onTap: () => setState(() => _currentMode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.teal) : Border.all(color: Colors.grey.shade300),
          boxShadow: isSelected ? [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))] : [],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullTree() {
    // 1. جلب الدوائر من القائمة المحدثة
    final departments = masterLookups[LookupCategory.departments] ?? [];
    if (departments.isEmpty) return const Center(child: Text("لا توجد بيانات"));
    
    // محاولة العثور على الجذر (الإدارة العليا) بناءً على الكود الجديد 'HQ'
    final root = departments.firstWhere((d) => d.code == 'HQ', orElse: () => departments.first);
    return _buildRecursiveNode(root, 1);
  }

  Widget _buildRecursiveNode(LookupItem item, int level) {
    List<LookupItem> children = [];
    
    // منطق الربط الهيكلي (تم تحديثه ليدعم التوسعات الجديدة)
    if (level == 1) { 
      // المستوى الأول: الإدارة العليا -> باقي الإدارات
      final allDepts = masterLookups[LookupCategory.departments] ?? [];
      // نبحث عن الإدارات التي تتبع لهذه الإدارة (إذا وجد ربط parentId) أو نعرض باقي الإدارات
      children = allDepts.where((d) => d.id != item.id && (d.metaData?['parentId'] == item.id || (item.code == 'HQ' && d.code != 'HQ'))).toList();
    } else if (level == 2) { 
      // المستوى الثاني: الإدارات -> الأقسام
      final sections = masterLookups[LookupCategory.sections] ?? [];
      children = sections.where((s) => s.metaData?['parentId'] == item.id).toList();
    } else if (level == 3) { 
      // المستوى الثالث: الأقسام -> الوحدات
      final units = masterLookups[LookupCategory.units] ?? [];
      children = units.where((u) => u.metaData?['parentId'] == item.id).toList();
    }

    final metrics = _getMetricsFromMetadata(item, level); // دالة جديدة

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // تمرير نمط العرض للبطاقة
        _NodeCard(item: item, level: level, metrics: metrics, viewMode: _currentMode),

        if (children.isNotEmpty) ...[
          CustomPaint(size: const Size(2, 40), painter: _LinePainter()),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              if (children.length > 1)
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: Container(
                    height: 2, color: Colors.grey[400],
                    margin: const EdgeInsets.symmetric(horizontal: 130.0),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: children.map((child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0), 
                    child: Column(
                      children: [
                        if (children.length > 1)
                          Container(width: 2, height: 20, color: Colors.grey[400])
                        else
                          Container(width: 2, height: 20, color: Colors.grey[400]),
                        _buildRecursiveNode(child, level + 1),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // محرك البيانات (محدث ليقرأ من Metadata الجديدة)
  NodeMetrics _getMetricsFromMetadata(LookupItem item, int level) {
    // 1. قراءة الميزانية من الحقول الجديدة
    double budget = 0;
    if (item.metaData != null && item.metaData!.containsKey('budget')) {
       budget = double.tryParse(item.metaData!['budget'].toString()) ?? 0;
    }
    
    // إذا لم توجد ميزانية (بيانات وهمية للرسم فقط)
    if (budget == 0) budget = (item.id.hashCode % 50000) + 10000;

    // 2. محاكاة التكلفة الحالية (يمكن ربطها لاحقاً بجدول الرواتب الفعلي)
    double cost = budget * 0.85; // افتراض أن الصرف 85%

    // 3. المدير المسؤول
    String manager = item.metaData?['manager'] ?? 'غير محدد';

    return NodeMetrics(
      totalStaff: (item.id.hashCode % 20) + 5, // محاكاة
      vacancies: (item.id.hashCode % 3),
      totalCost: cost,
      budgetLimit: budget,
      activeTasks: (item.id.hashCode % 10) + 2,
      managerName: manager, // حقل جديد
      jobTitles: {
        manager: 1,
        "مشرف فريق": 2,
        "فني/إداري": 5,
      },
      taskBreakdown: [
        TaskInfo("تشغيل العمليات", "فريق", cost * 0.6),
        TaskInfo("الصيانة والتطوير", "فني", cost * 0.2),
        TaskInfo("إدارة ومتابعة", manager, cost * 0.2),
      ]
    );
  }
}

class NodeMetrics {
  final int totalStaff;
  final int vacancies;
  final double totalCost;
  final double budgetLimit;
  final int activeTasks;
  final String managerName; // جديد
  final Map<String, int> jobTitles;
  final List<TaskInfo> taskBreakdown;

  NodeMetrics({
    required this.totalStaff,
    required this.vacancies,
    required this.totalCost,
    required this.budgetLimit,
    required this.activeTasks,
    this.managerName = '',
    required this.jobTitles,
    required this.taskBreakdown,
  });
}

class TaskInfo {
  final String name;
  final String role;
  final double cost;
  TaskInfo(this.name, this.role, this.cost);
}

// --- البطاقة الذكية (Smart Card) ---
class _NodeCard extends StatelessWidget {
  final LookupItem item;
  final int level;
  final NodeMetrics metrics;
  final ChartViewMode viewMode;

  const _NodeCard({
    required this.item, 
    required this.level, 
    required this.metrics,
    required this.viewMode,
  });

  @override
  Widget build(BuildContext context) {
    Color headerColor;
    double width = 260; 

    // ألوان ذكية حسب نوع الإدارة (من البيانات الجديدة)
    String type = item.metaData?['type'] ?? '';
    if (type == 'PROFIT') headerColor = Colors.green[800]!; // إدارات ربحية
    else if (type == 'OPS') headerColor = Colors.blue[800]!; // عمليات
    else if (type == 'SUPPORT') headerColor = Colors.orange[800]!; // مساندة
    else if (level == 1) headerColor = const Color(0xFF1A237E); 
    else headerColor = item.color ?? Colors.grey[700]!;

    bool isOverBudget = metrics.totalCost > metrics.budgetLimit;
    Color borderColor = Colors.white;
    double borderWidth = 0;
    
    // تنبيه بصري في الوضع المالي
    if ((viewMode == ChartViewMode.financial || viewMode == ChartViewMode.combined) && isOverBudget) {
      borderColor = Colors.redAccent;
      borderWidth = 3.0;
    }

    return InkWell(
      onTap: () => _showDetailsBottomSheet(context),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // الهيدر
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isOverBudget && (viewMode == ChartViewMode.financial || viewMode == ChartViewMode.combined))
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(Icons.warning_amber_rounded, color: Colors.yellow, size: 20),
                        ),
                      if (item.icon != null) Icon(item.icon, color: Colors.white, size: 24),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (metrics.managerName.isNotEmpty)
                    Text(
                      "مدير: ${metrics.managerName}",
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10),
                    ),
                ],
              ),
            ),

            // المحتوى الديناميكي حسب الوضع
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildContentByMode(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentByMode() {
    // 1. الوضع الإداري: يركز على الموظفين والشواغر
    if (viewMode == ChartViewMode.administrative) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem("الكادر", "${metrics.totalStaff}", Icons.people, Colors.blue[800]!),
          _buildStatItem("شواغر", "${metrics.vacancies}", Icons.person_add, Colors.orange[800]!),
          _buildStatItem("مهام", "${metrics.activeTasks}", Icons.task, Colors.teal),
        ],
      );
    } 
    // 2. الوضع المالي: يركز على التكلفة والميزانية
    else if (viewMode == ChartViewMode.financial) {
      bool isOver = metrics.totalCost > metrics.budgetLimit;
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("التكلفة", _formatCurrency(metrics.totalCost), Icons.attach_money, isOver ? Colors.red : Colors.green[800]!),
              _buildStatItem("الميزانية", _formatCurrency(metrics.budgetLimit), Icons.account_balance_wallet, Colors.grey[700]!),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: metrics.budgetLimit > 0 ? (metrics.totalCost / metrics.budgetLimit).clamp(0.0, 1.0) : 0,
              backgroundColor: Colors.grey[200],
              color: isOver ? Colors.red : Colors.green,
              minHeight: 6,
            ),
          ),
        ],
      );
    } 
    // 3. الوضع الشامل (Combined): يظهر أهم المؤشرات من الاثنين
    else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("الكادر", "${metrics.totalStaff}", Icons.people, Colors.blue[800]!),
              _buildStatItem("شواغر", "${metrics.vacancies}", Icons.person_add, Colors.orange[800]!),
              _buildStatItem("التكلفة", _formatCurrency(metrics.totalCost), Icons.attach_money, Colors.green[800]!),
            ],
          ),
        ],
      );
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) return "${(amount/1000000).toStringAsFixed(1)}M";
    if (amount >= 1000) return "${(amount/1000).toStringAsFixed(1)}k";
    return amount.toStringAsFixed(0);
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  // --- نافذة التفاصيل الكاملة (تمت إعادتها وتحسينها) ---
  void _showDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.teal.withOpacity(0.1), child: Icon(item.icon, color: Colors.teal)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            if (metrics.managerName.isNotEmpty)
                              Text("المدير المسؤول: ${metrics.managerName}", style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  
                  _buildSectionTitle("المسميات الوظيفية والكادر (${metrics.totalStaff})"),
                  ...metrics.jobTitles.entries.map((entry) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.badge, size: 20, color: Colors.blueGrey),
                    title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("عدد الموظفين: ${entry.value}"),
                    trailing: Chip(label: Text("${entry.value}"), backgroundColor: Colors.blue[50]),
                  )),
                  
                  const SizedBox(height: 20),

                  _buildSectionTitle("المهام وتوزيع التكاليف"),
                  Card(
                    elevation: 0,
                    color: Colors.grey[50],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: metrics.taskBreakdown.map((task) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(child: Text(task.name, style: const TextStyle(fontSize: 13))),
                              Text("${task.cost.toStringAsFixed(0)} د.أ", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildSectionTitle("الملخص المالي"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryBox("التكلفة الكلية", "${metrics.totalCost.toStringAsFixed(0)} د.أ", Colors.red),
                      _buildSummaryBox("الميزانية", "${metrics.budgetLimit.toStringAsFixed(0)} د.أ", Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
    );
  }

  Widget _buildSummaryBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 2;
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}