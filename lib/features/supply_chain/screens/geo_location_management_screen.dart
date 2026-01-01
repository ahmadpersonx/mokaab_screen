// FileName: lib/features/supply_chain/screens/geo_location_management_screen.dart
// Version: 2.0 (Fixed Brackets Issue)

import 'package:flutter/material.dart';
import 'package:mokaab/features/supply_chain/models/geo_location_model.dart';
import 'package:mokaab/features/supply_chain/data/supply_chain_config_data.dart';
import 'package:mokaab/features/supply_chain/data/jordan_geo_data.dart'; // تأكد من وجود هذا الملف

class GeoLocationManagementScreen extends StatefulWidget {
  const GeoLocationManagementScreen({super.key});

  @override
  State<GeoLocationManagementScreen> createState() => _GeoLocationManagementScreenState();
}

class _GeoLocationManagementScreenState extends State<GeoLocationManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<GeoLocation> _localLocations;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _localLocations = List.from(SupplyChainConfigData.geoLocations);
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
                    const Text("المواقع الجغرافية والمشاريع", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                      child: Text("${_localLocations.length} موقع نشط", style: const TextStyle(color: Colors.white)),
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
                    Tab(text: "المحاجر والمصانع"),
                    Tab(text: "مواقع المشاريع (العملاء)"),
                    Tab(text: "المعارض والإدارة"),
                  ],
                ),
              ],
            ),
          ),
          
          // List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(_localLocations),
                _buildList(_localLocations.where((l) => l.type == GeoLocationType.quarry || l.type == GeoLocationType.factorySite).toList()),
                _buildList(_localLocations.where((l) => l.type == GeoLocationType.projectSite).toList()),
                _buildList(_localLocations.where((l) => l.type == GeoLocationType.showroom || l.type == GeoLocationType.adminOffice).toList()),
              ],
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newLoc = await showDialog<GeoLocation>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => const GeoLocationFormDialog(),
          );
          if (newLoc != null) {
            setState(() => _localLocations.add(newLoc));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إضافة الموقع بنجاح"), backgroundColor: Colors.green));
          }
        },
        label: const Text("موقع جديد"),
        icon: const Icon(Icons.add_location),
        backgroundColor: Colors.blue[900],
      ),
    );
  }

  Widget _buildList(List<GeoLocation> list) {
    if (list.isEmpty) return const Center(child: Text("لا توجد مواقع", style: TextStyle(color: Colors.grey)));
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (ctx, idx) => _buildCard(list[idx]),
    );
  }

  Widget _buildCard(GeoLocation loc) {
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
                  child: Icon(Icons.place, color: loc.typeColor, size: 28),
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
                if (loc.isLicenseExpired)
                  const Tooltip(message: "الترخيص منتهي", child: Icon(Icons.warning, color: Colors.red)),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetaInfo("العنوان", loc.city, Icons.location_city),
                _buildMetaInfo("مركز التكلفة", loc.costCenterId, Icons.account_balance_wallet),
                if (loc.gpsCoordinates.isNotEmpty)
                  _buildMetaInfo("GPS", "متوفر", Icons.gps_fixed, valueColor: Colors.blue),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfo(String label, String value, IconData icon, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text("$label: ", style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: valueColor ?? Colors.black87)),
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
}

// --- نافذة الإضافة المتطورة (Advanced Geo Dialog) ---
class GeoLocationFormDialog extends StatefulWidget {
  const GeoLocationFormDialog({super.key});

  @override
  State<GeoLocationFormDialog> createState() => _GeoLocationFormDialogState();
}

class _GeoLocationFormDialogState extends State<GeoLocationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _gpsCtrl = TextEditingController();
  final _costCenterCtrl = TextEditingController();
  final _streetCtrl = TextEditingController(); 

  GeoLocationType _selectedType = GeoLocationType.projectSite;

  // متغيرات القوائم المتسلسلة
  String? _selectedGov;
  String? _selectedDistrict;
  String? _selectedNeighborhood;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("تعريف موقع جغرافي جديد", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(height: 30),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الصف الأول: الاسم والكود
                      Row(
                        children: [
                          Expanded(child: _buildField(_nameCtrl, "اسم الموقع", Icons.label)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildField(_codeCtrl, "الكود", Icons.qr_code)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<GeoLocationType>(
                        value: _selectedType,
                        decoration: const InputDecoration(labelText: "نوع الموقع", border: OutlineInputBorder()),
                        items: GeoLocationType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.toString().split('.').last))).toList(),
                        onChanged: (v) => setState(() => _selectedType = v!),
                      ),
                      
                      const SizedBox(height: 24),
                      const Text("العنوان الجغرافي (تحديد دقيق)", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),

                      // --- القوائم المترابطة (Cascading Dropdowns) ---
                      Row(
                        children: [
                          // 1. المحافظة
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedGov,
                              decoration: const InputDecoration(labelText: "المحافظة", border: OutlineInputBorder()),
                              items: JordanGeoData.getGovernorates().map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedGov = val;
                                  _selectedDistrict = null; // تصفير التابع
                                  _selectedNeighborhood = null;
                                });
                              },
                              validator: (v) => v == null ? "مطلوب" : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // 2. المنطقة/اللواء
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedDistrict,
                              decoration: const InputDecoration(labelText: "المنطقة / اللواء", border: OutlineInputBorder()),
                              items: _selectedGov == null 
                                ? [] 
                                : JordanGeoData.getDistricts(_selectedGov!).map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedDistrict = val;
                                  _selectedNeighborhood = null; // تصفير التابع
                                });
                              },
                              validator: (v) => v == null ? "مطلوب" : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // 3. الحي
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedNeighborhood,
                              decoration: const InputDecoration(labelText: "الحي", border: OutlineInputBorder()),
                              items: (_selectedGov == null || _selectedDistrict == null)
                                ? [] 
                                : JordanGeoData.getNeighborhoods(_selectedGov!, _selectedDistrict!).map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                              onChanged: (val) => setState(() => _selectedNeighborhood = val),
                              validator: (v) => v == null ? "مطلوب" : null,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      // تفاصيل الشارع
                      _buildField(_streetCtrl, "اسم الشارع / رقم المبنى / علامة مميزة", Icons.map),

                      const SizedBox(height: 24),
                      
                      Row(
                        children: [
                          Expanded(child: _buildField(_gpsCtrl, "إحداثيات GPS (اختياري)", Icons.pin_drop, required: false)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildField(_costCenterCtrl, "مركز التكلفة المالي", Icons.attach_money)),
                        ],
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
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text("حفظ"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900], foregroundColor: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- دوال المساعدة داخل الكلاس ---
  Widget _buildField(TextEditingController c, String label, IconData icon, {bool required = true}) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: const OutlineInputBorder()),
      validator: (v) => required && (v == null || v.isEmpty) ? "مطلوب" : null,
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      // تجميع العنوان الكامل
      final fullAddress = "$_selectedGov - $_selectedDistrict - $_selectedNeighborhood - ${_streetCtrl.text}";

      Navigator.pop(context, GeoLocation(
        id: DateTime.now().toString(),
        name: _nameCtrl.text,
        code: _codeCtrl.text,
        type: _selectedType,
        addressText: fullAddress, // تخزين العنوان المجمع
        city: _selectedGov ?? '', // تخزين المحافظة كمدينة رئيسية
        gpsCoordinates: _gpsCtrl.text,
        costCenterId: _costCenterCtrl.text,
      ));
    }
  }
}