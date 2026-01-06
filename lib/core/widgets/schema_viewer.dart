// FileName: lib/core/widgets/schema_viewer.dart
import 'package:flutter/material.dart';

class SchemaViewer extends StatelessWidget {
  final String tableName;
  final Map<String, dynamic> data; // البيانات: اسم الحقل والقيمة
  final String primaryKey;

  const SchemaViewer({
    super.key,
    required this.tableName,
    required this.data,
    this.primaryKey = 'id',
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Database Record Inspector", style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontFamily: 'Courier')),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.table_chart, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text("Table: $tableName", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Courier')),
                    ],
                  ),
                ],
              ),
            ),
            
            // The Table
            SizedBox(
              width: double.infinity,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
                columns: const [
                  DataColumn(label: Text("Field Name", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Type", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Current Value", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: data.entries.map((entry) {
                  return DataRow(
                    cells: [
                      DataCell(Row(
                        children: [
                          if (entry.key == primaryKey) const Icon(Icons.vpn_key, size: 14, color: Colors.orange),
                          if (entry.key == primaryKey) const SizedBox(width: 4),
                          Text(entry.key, style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold)),
                        ],
                      )),
                      DataCell(Text(_getTypeName(entry.value), style: TextStyle(color: Colors.grey[600], fontSize: 12))),
                      DataCell(
                        Container(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Text(entry.value.toString(), style: const TextStyle(color: Colors.blueAccent)),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeName(dynamic value) {
    if (value == null) return "NULL";
    if (value is String) return "VARCHAR";
    if (value is int) return "INTEGER";
    if (value is double) return "DECIMAL";
    if (value is bool) return "BOOLEAN";
    if (value is DateTime) return "DATETIME";
    if (value is List) return "ONE2MANY (Rel)";
    return value.runtimeType.toString();
  }
}