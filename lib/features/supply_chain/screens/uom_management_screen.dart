// FileName: lib/features/supply_chain/screens/uom_management_screen.dart
// Version: 1.0

import 'package:flutter/material.dart';
import 'package:mokaab/features/supply_chain/models/uom_model.dart';
import 'package:mokaab/features/supply_chain/data/supply_chain_config_data.dart';

class UomManagementScreen extends StatefulWidget {
  const UomManagementScreen({super.key});

  @override
  State<UomManagementScreen> createState() => _UomManagementScreenState();
}

class _UomManagementScreenState extends State<UomManagementScreen> with TickerProviderStateMixin {
    late TabController _tabController;
  late List<UnitOfMeasure> _localUoms;

  // استخراج الفئات الفريدة لعمل التبويبات ديناميكياً
  final List<UomCategory> _categories = UomCategory.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length + 1, vsync: this); // +1 للكل
    _localUoms = List.from(SupplyChainConfigData.uoms);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.blue[900]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("وحدات القياس والتحويلات", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      onPressed: () {}, // فتح ديالوج الإضافة
                      icon: const Icon(Icons.add),
                      label: const Text("وحدة جديدة"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.orange,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  isScrollable: true,
                  tabs: [
                    const Tab(text: "الكل"),
                    ..._categories.map((c) => Tab(text: _getCategoryName(c))),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUomList(_localUoms), // الكل
                ..._categories.map((cat) => _buildUomList(_localUoms.where((u) => u.category == cat).toList())),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUomList(List<UnitOfMeasure> list) {
    if (list.isEmpty) return const Center(child: Text("لا توجد وحدات في هذه الفئة", style: TextStyle(color: Colors.grey)));
    
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) => _buildUomCard(list[index]),
    );
  }

  Widget _buildUomCard(UnitOfMeasure uom) {
    bool isRef = uom.type == UomType.reference;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon / Symbol Box
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: uom.categoryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Text(
                uom.code, 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: uom.categoryColor)
              ),
            ),
            const SizedBox(width: 16),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(uom.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      if (isRef)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                          child: const Text("وحدة مرجعية", style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(uom.conversionDescription, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildMiniInfo("الفئة", uom.categoryName),
                      const SizedBox(width: 12),
                      _buildMiniInfo("الدقة", "${uom.roundingPrecision} خانات"),
                      if (uom.uneceCode.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        _buildMiniInfo("كود دولي", uom.uneceCode),
                      ]
                    ],
                  )
                ],
              ),
            ),
            
            IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniInfo(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
      child: Text("$label: $value", style: const TextStyle(fontSize: 11, color: Colors.black87)),
    );
  }

  String _getCategoryName(UomCategory cat) {
    switch (cat) {
      case UomCategory.unit: return "وحدات";
      case UomCategory.weight: return "وزن";
      case UomCategory.length: return "طول";
      case UomCategory.volume: return "حجم";
      case UomCategory.area: return "مساحة";
      case UomCategory.time: return "وقت";
    }
  }
}