// FileName: lib/features/supply_chain/screens/fleet_management_screen.dart
// Version: 1.0
// Description: شاشة إدارة الأسطول والآليات مع نموذج إضافة متقدم

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokaab/features/supply_chain/models/fleet_model.dart';
import 'package:mokaab/features/supply_chain/data/supply_chain_config_data.dart';

class FleetManagementScreen extends StatefulWidget {
  const FleetManagementScreen({super.key});

  @override
  State<FleetManagementScreen> createState() => _FleetManagementScreenState();
}

class _FleetManagementScreenState extends State<FleetManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<FleetVehicle> _localFleet;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _localFleet = List.from(SupplyChainConfigData.fleet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Header Area
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.blue[900]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("إدارة الأسطول والآليات", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                      child: Text("${_localFleet.length} آلية مسجلة", style: const TextStyle(color: Colors.white)),
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
                  tabs: const [
                    Tab(text: "الكل"),
                    Tab(text: "شاحنات نقل "),
                    Tab(text: "المعدات (Yellow Iron)"),
                    Tab(text: "الخدمات والرافعات"),
                  ],
                ),
              ],
            ),
          ),
          
          // List Area
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFleetList(_localFleet),
                _buildFleetList(_localFleet.where((v) => v.type == VehicleType.truck).toList()),
                _buildFleetList(_localFleet.where((v) => v.type == VehicleType.heavyMachinery).toList()),
                _buildFleetList(_localFleet.where((v) => v.type == VehicleType.forklift || v.type == VehicleType.serviceVehicle).toList()),
              ],
            ),
          ),
        ],
      ),
      
      // زر الإضافة
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newVehicle = await showDialog<FleetVehicle>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => const FleetFormDialog(),
          );

          if (newVehicle != null) {
            setState(() {
              _localFleet.add(newVehicle);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("تم إضافة الآلية: ${newVehicle.name}"), backgroundColor: Colors.green),
            );
          }
        },
        label: const Text("آلية جديدة"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue[900],
      ),
    );
  }

  Widget _buildFleetList(List<FleetVehicle> list) {
    if (list.isEmpty) return const Center(child: Text("لا توجد آليات", style: TextStyle(color: Colors.grey)));
    
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) => _buildVehicleCard(list[index]),
    );
  }

  Widget _buildVehicleCard(FleetVehicle vehicle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                  child: Icon(_getIconForType(vehicle.type), color: Colors.blue[800], size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicle.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildTag(vehicle.plateNumber, Colors.black, Colors.white), // اللوحة بالأسود
                          const SizedBox(width: 8),
                          _buildTag(vehicle.typeName, Colors.grey[200]!, Colors.black87),
                        ],
                      )
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: vehicle.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: vehicle.statusColor)
                  ),
                  child: Text(_getStatusName(vehicle.status), style: TextStyle(color: vehicle.statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Info Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetaInfo("السائق", vehicle.driverName, Icons.person),
                _buildMetaInfo("العداد", "${NumberFormat('#,###').format(vehicle.currentOdometer)} ${vehicle.measureUnit}", Icons.speed),
                _buildMetaInfo("مركز التكلفة", vehicle.costCenter, Icons.account_balance),
              ],
            ),

            // Warning Alerts (Expiry)
            if (vehicle.isLicenseExpiringSoon) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.warning, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text("تنبيه: ترخيص المركبة ينتهي قريباً", style: TextStyle(fontSize: 12, color: Colors.red)),
                    const Spacer(),
                    Text(DateFormat('yyyy-MM-dd').format(vehicle.licenseExpiryDate!), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey.shade300)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  IconData _getIconForType(VehicleType type) {
    switch (type) {
      case VehicleType.heavyMachinery: return Icons.construction;
      case VehicleType.truck: return Icons.local_shipping;
      case VehicleType.forklift: return Icons.forklift; // قد تحتاج لأيقونة مخصصة
      case VehicleType.serviceVehicle: return Icons.airport_shuttle;
      default: return Icons.directions_car;
    }
  }

  String _getStatusName(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.active: return "بالخدمة";
      case VehicleStatus.maintenance: return "في الصيانة";
      case VehicleStatus.outOfService: return "خارج الخدمة";
      case VehicleStatus.sold: return "مباع";
    }
  }
}

// --- نافذة الإضافة (Form Dialog) ---
class FleetFormDialog extends StatefulWidget {
  const FleetFormDialog({super.key});

  @override
  State<FleetFormDialog> createState() => _FleetFormDialogState();
}

class _FleetFormDialogState extends State<FleetFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _plateController = TextEditingController();
  final _driverController = TextEditingController();
  final _odometerController = TextEditingController();
  final _costCenterController = TextEditingController();

  VehicleType _selectedType = VehicleType.truck;
  VehicleStatus _selectedStatus = VehicleStatus.active;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 700,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.add_circle, color: Colors.blue, size: 28),
                  const SizedBox(width: 12),
                  const Text("إضافة آلية جديدة", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
                ],
              ),
              const Divider(height: 30),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // القسم الأول: البيانات الأساسية
                      const Text("البيانات الأساسية", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(labelText: "اسم المركبة / وصف الآلية", border: OutlineInputBorder()),
                              validator: (v) => v!.isEmpty ? "مطلوب" : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<VehicleType>(
                              value: _selectedType,
                              decoration: const InputDecoration(labelText: "النوع", border: OutlineInputBorder()),
                              items: VehicleType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.toString().split('.').last))).toList(), // يمكن تحسين الأسماء
                              onChanged: (val) => setState(() => _selectedType = val!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _plateController,
                              decoration: const InputDecoration(labelText: "رقم اللوحة", border: OutlineInputBorder(), prefixIcon: Icon(Icons.grid_3x3)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<VehicleStatus>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(labelText: "الحالة", border: OutlineInputBorder()),
                              items: VehicleStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.toString().split('.').last))).toList(),
                              onChanged: (val) => setState(() => _selectedStatus = val!),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      // القسم الثاني: التشغيل والمالية
                      const Text("التشغيل والمالية", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _driverController,
                              decoration: const InputDecoration(labelText: "السائق المسؤول", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _odometerController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: "قراءة العداد الحالية", border: OutlineInputBorder(), prefixIcon: Icon(Icons.speed)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _costCenterController,
                        decoration: const InputDecoration(labelText: "مركز التكلفة (Cost Center)", border: OutlineInputBorder(), prefixIcon: Icon(Icons.account_balance)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.save),
                    label: const Text("حفظ"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newVehicle = FleetVehicle(
        id: DateTime.now().toString(),
        name: _nameController.text,
        plateNumber: _plateController.text,
        code: 'AUTO-${DateTime.now().second}',
        type: _selectedType,
        status: _selectedStatus,
        driverName: _driverController.text,
        currentOdometer: double.tryParse(_odometerController.text) ?? 0,
        costCenter: _costCenterController.text,
        purchaseDate: DateTime.now(), // افتراضي للآن
      );
      Navigator.pop(context, newVehicle);
    }
  }
}