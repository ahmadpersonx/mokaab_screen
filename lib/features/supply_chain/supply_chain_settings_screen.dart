// FileName: lib/features/supply_chain/screens/supply_chain_settings_screen.dart
// Version: 2.0 (Fixed Navigation & Imports)

import 'package:flutter/material.dart';
import 'package:mokaab/features/supply_chain/data/supply_chain_config_data.dart';
import 'package:mokaab/features/supply_chain/screens/warehouse_management_screen.dart';
import 'package:mokaab/features/supply_chain/screens/fleet_management_screen.dart';
import 'package:mokaab/features/supply_chain/screens/geo_location_management_screen.dart';

class SupplyChainSettingsScreen extends StatefulWidget {
  const SupplyChainSettingsScreen({super.key});

  @override
  State<SupplyChainSettingsScreen> createState() => _SupplyChainSettingsScreenState();
}

class _SupplyChainSettingsScreenState extends State<SupplyChainSettingsScreen> {
  // الافتراضي هو المستودعات
  String _selectedId = SupplyChainConfigData.idWarehouses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("إعدادات سلسلة الإمداد"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. القائمة الجانبية
          Container(
            width: 300,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("القوائم التعريفية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    itemCount: SupplyChainConfigData.menuItems.length,
                    separatorBuilder: (ctx, i) => const Divider(height: 1, indent: 20, endIndent: 20),
                    itemBuilder: (context, index) {
                      final item = SupplyChainConfigData.menuItems[index];
                      final isSelected = _selectedId == item['id'];
                      
                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[50] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Icon(item['icon'], color: isSelected ? Colors.blue[900] : Colors.grey),
                        ),
                        title: Text(
                          item['title'],
                          style: TextStyle(
                            color: isSelected ? Colors.blue[900] : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(item['subtitle'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        selected: isSelected,
                        selectedTileColor: Colors.blue.withOpacity(0.05),
                        onTap: () => setState(() => _selectedId = item['id']),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const VerticalDivider(width: 1, thickness: 1),

          // 2. منطقة المحتوى
          Expanded(
            child: _buildSelectedScreen(),
          ),
        ],
      ),
    );
  }

  // دالة التوجيه (Router)
  Widget _buildSelectedScreen() {
    switch (_selectedId) {
      
      case SupplyChainConfigData.idWarehouses:
        return const WarehouseManagementScreen();
        
      case SupplyChainConfigData.idFleet:
        return const FleetManagementScreen();
        
      case SupplyChainConfigData.idLocations:
        return const GeoLocationManagementScreen(); // تمت إزالة const لتجنب الأخطاء
        
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text("هذه الشاشة قيد التطوير", style: TextStyle(fontSize: 20, color: Colors.grey)),
            ],
          ),
        );
    }
  }
}