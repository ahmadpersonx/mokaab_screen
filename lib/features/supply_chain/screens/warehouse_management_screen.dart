// FileName: lib/features/supply_chain/screens/warehouse_management_screen.dart
import 'package:flutter/material.dart';
import 'package:mokaab/features/supply_chain/models/warehouse_model.dart';
import 'package:mokaab/features/supply_chain/data/supply_chain_config_data.dart';

class WarehouseManagementScreen extends StatefulWidget {
  const WarehouseManagementScreen({super.key});

  @override
  State<WarehouseManagementScreen> createState() => _WarehouseManagementScreenState();
}

class _WarehouseManagementScreenState extends State<WarehouseManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<WarehouseLocation> _localLocations; // قائمة محلية قابلة للتعديل

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // تحميل البيانات الأولية
    _localLocations = List.from(SupplyChainConfigData.locations);
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
                    const Text("إدارة المواقع اللوجستية والمخازن", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    
                    // إحصائية سريعة
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                      child: Text("${_localLocations.length} موقع معرف", style: const TextStyle(color: Colors.white)),
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
                    Tab(text: "كافة المواقع"),
                    Tab(text: "التخزين الداخلي (Internal)"),
                    Tab(text: "مناطق الإنتاج (WIP)"),
                    Tab(text: "خارجي وعبور (External)"),
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
                _buildLocationsList(_localLocations),
                _buildLocationsList(_localLocations.where((w) => w.type == WarehouseType.internal || w.type == WarehouseType.inventoryLoss).toList()),
                _buildLocationsList(_localLocations.where((w) => w.type == WarehouseType.production).toList()),
                _buildLocationsList(_localLocations.where((w) => w.type == WarehouseType.transit || w.type == WarehouseType.subcontracting).toList()),
              ],
            ),
          ),
        ],
      ),
      
      // زر الإضافة العائم
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // فتح الديالوج وانتظار النتيجة
          final newWh = await showDialog<WarehouseLocation>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => const WarehouseFormDialog(),
          );

          // إذا تم الحفظ، تحديث القائمة
          if (newWh != null) {
            setState(() {
              _localLocations.add(newWh);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("تم إضافة الموقع: ${newWh.name}"), backgroundColor: Colors.green),
            );
          }
        },
        label: const Text("موقع جديد"),
        icon: const Icon(Icons.add_location_alt),
        backgroundColor: Colors.blue[900],
      ),
    );
  }

  Widget _buildLocationsList(List<WarehouseLocation> list) {
    if (list.isEmpty) {
      return const Center(child: Text("لا توجد مواقع في هذا التصنيف", style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) => _buildLocationCard(list[index]),
    );
  }

  Widget _buildLocationCard(WarehouseLocation loc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(color: loc.typeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(_getIconForType(loc.type), color: loc.typeColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildTag(loc.code, Colors.grey.shade200, Colors.black87),
                          const SizedBox(width: 8),
                          _buildTag(loc.typeName, loc.typeColor.withOpacity(0.1), loc.typeColor),
                        ],
                      )
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.settings, color: Colors.grey), onPressed: () {}),
              ],
            ),
            const Divider(height: 24),
            _buildMetaRow("المسؤول (Custodian)", loc.managerName, Icons.person_outline),
            const SizedBox(height: 8),
            _buildMetaRow("حساب المخزون (GL)", loc.valuationAccount ?? "غير محدد", Icons.account_balance),
            
            if (loc.address.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildMetaRow("الموقع", loc.address, Icons.location_on_outlined),
            ],

            if (loc.allowNegativeStock || loc.isScrap || loc.isBonded) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (loc.allowNegativeStock) _buildFlag("يسمح بالسالب", Colors.orange),
                  if (loc.isScrap) _buildFlag("موقع إتلاف", Colors.red),
                  if (loc.isBonded) _buildFlag("جمركي", Colors.purple),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text("$label: ", style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87))),
      ],
    );
  }

  Widget _buildTag(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildFlag(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: color.withOpacity(0.3))),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  IconData _getIconForType(WarehouseType type) {
    switch (type) {
      case WarehouseType.internal: return Icons.warehouse;
      case WarehouseType.production: return Icons.precision_manufacturing;
      case WarehouseType.transit: return Icons.local_shipping;
      case WarehouseType.inventoryLoss: return Icons.delete_outline;
      case WarehouseType.subcontracting: return Icons.handshake;
      default: return Icons.store;
    }
  }
}

// --- كلاس نافذة الإضافة (Dialog) ---
class WarehouseFormDialog extends StatefulWidget {
  const WarehouseFormDialog({super.key});

  @override
  State<WarehouseFormDialog> createState() => _WarehouseFormDialogState();
}

class _WarehouseFormDialogState extends State<WarehouseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _managerController = TextEditingController();
  final _accountController = TextEditingController();
  final _addressController = TextEditingController();
  final _capacityController = TextEditingController();

  WarehouseType _selectedType = WarehouseType.internal;
  bool _allowNegative = false;
  bool _isScrap = false;
  bool _isBonded = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.add_location_alt, color: Colors.blue, size: 28),
                  const SizedBox(width: 12),
                  const Text("تعريف موقع لوجستي جديد", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      _buildSectionTitle("البيانات الأساسية"),
                      Row(children: [
                        Expanded(child: _buildTextField(_nameController, "اسم الموقع", Icons.label)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(_codeController, "الكود (Short Code)", Icons.qr_code)),
                      ]),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<WarehouseType>(
                        value: _selectedType,
                        decoration: const InputDecoration(labelText: "نوع الموقع", border: OutlineInputBorder(), prefixIcon: Icon(Icons.category)),
                        items: WarehouseType.values.map((t) => DropdownMenuItem(value: t, child: Text(_getTypeName(t)))).toList(),
                        onChanged: (val) => setState(() => _selectedType = val!),
                      ),
                      const SizedBox(height: 24),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle("مالي وإداري"),
                                _buildTextField(_managerController, "أمين العهدة", Icons.person),
                                const SizedBox(height: 16),
                                _buildTextField(_accountController, "حساب المخزون (GL)", Icons.account_balance),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle("لوجستي"),
                                _buildTextField(_addressController, "العنوان / الإحداثيات", Icons.location_on),
                                const SizedBox(height: 16),
                                _buildTextField(_capacityController, "السعة القصوى", Icons.storage, isNumber: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      CheckboxListTile(
                        title: const Text("السماح بالسحب بالسالب"),
                        subtitle: const Text("للعمليات المستمرة دون توقف"),
                        value: _allowNegative,
                        onChanged: (val) => setState(() => _allowNegative = val!),
                        activeColor: Colors.orange,
                      ),
                      CheckboxListTile(
                        title: const Text("موقع إتلاف (Scrap)"),
                        value: _isScrap,
                        onChanged: (val) => setState(() => _isScrap = val!),
                        activeColor: Colors.red,
                      ),
                      CheckboxListTile(
                        title: const Text("مستودع جمركي (Bonded)"),
                        value: _isBonded,
                        onChanged: (val) => setState(() => _isBonded = val!),
                        activeColor: Colors.purple,
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

  Widget _buildSectionTitle(String title) {
    return Padding(padding: const EdgeInsets.only(bottom: 16), child: Text(title, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)));
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), prefixIcon: Icon(icon)),
      validator: (v) => v!.isEmpty ? "مطلوب" : null,
    );
  }

  String _getTypeName(WarehouseType type) {
    switch (type) {
      case WarehouseType.view: return "مجلد (View)";
      case WarehouseType.internal: return "تخزين داخلي";
      case WarehouseType.customer: return "موقع عميل";
      case WarehouseType.vendor: return "موقع مورد";
      case WarehouseType.production: return "إنتاج (WIP)";
      case WarehouseType.transit: return "عبور (Transit)";
      case WarehouseType.inventoryLoss: return "خسائر/سكراب";
      case WarehouseType.subcontracting: return "تصنيع خارجي";
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newWh = WarehouseLocation(
        id: DateTime.now().toString(),
        name: _nameController.text,
        code: _codeController.text,
        type: _selectedType,
        managerName: _managerController.text.isEmpty ? "غير محدد" : _managerController.text,
        valuationAccount: _accountController.text,
        address: _addressController.text,
        capacity: double.tryParse(_capacityController.text) ?? 0,
        allowNegativeStock: _allowNegative,
        isScrap: _isScrap,
        isBonded: _isBonded,
      );
      Navigator.pop(context, newWh);
    }
  }
}