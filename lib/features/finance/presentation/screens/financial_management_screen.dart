// FileName: lib/features/finance/presentation/screens/financial_management_screen.dart
import 'package:flutter/material.dart';

class FinancialManagementScreen extends StatelessWidget {
  const FinancialManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // نفس لون خلفية النظام
      appBar: AppBar(
        title: const Text("الإدارة المالية"),
        centerTitle: true,
        backgroundColor: Colors.teal[800], // لون مميز للمالية
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            
            // الشبكة المتجاوبة
            LayoutBuilder(
              builder: (context, constraints) {
                // تحديد عدد الأعمدة (Responsive)
                int crossAxisCount = 2;
                if (constraints.maxWidth > 1200) crossAxisCount = 5;
                else if (constraints.maxWidth > 800) crossAxisCount = 4;
                else if (constraints.maxWidth > 600) crossAxisCount = 3;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0, // بطاقات مربعة
                  children: [
                    // العمليات اليومية
                    _buildFinanceCard("فاتورة مبيعات", Icons.point_of_sale, Colors.blue, () {}),
                    _buildFinanceCard("فاتورة مشتريات", Icons.shopping_cart, Colors.orange, () {}),
                    _buildFinanceCard("سندات القبض", Icons.download_rounded, Colors.green, () {}),
                    _buildFinanceCard("سندات الصرف", Icons.upload_rounded, Colors.redAccent, () {}),
                    
                    // العمليات المحاسبية
                    _buildFinanceCard("اليومية العامة", Icons.library_books, Colors.indigo, () {}),
                    _buildFinanceCard("إدارة الشيكات", Icons.payments, Colors.teal, () {}),
                    
                    // الهيكل والتقارير
                    _buildFinanceCard("مراكز التكلفة", Icons.hub, Colors.brown, () {}),
                    _buildFinanceCard("دليل الحسابات", Icons.menu_book, Colors.blueGrey, () {}),
                    _buildFinanceCard("التقارير المالية", Icons.pie_chart, Colors.purple, () {}),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  // --- ترويسة الصفحة ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.teal[700]!, Colors.teal[500]!]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.account_balance, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("لوحة التحكم المالية", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              Text("إدارة السندات، الفواتير، والقيود المحاسبية", style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  // --- تصميم البطاقة المحسن (Unified Card Style) ---
  Widget _buildFinanceCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        hoverColor: color.withOpacity(0.05),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}