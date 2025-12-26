// FileName: lib/features/hr/contracts/services/contract_pdf_service.dart
// Description: خدمة توليد ملف PDF للعقود (Fixed Type Conflict)
// Version: 1.2

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mokaab/features/hr/contracts/screens/contract_management_screen.dart';

class ContractPdfService {
  
  // دالة الطباعة المباشرة
  static Future<void> printContract(EmploymentContract contract) async {
    final pdf = await generateContractDocument(contract);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Contract-${contract.employeeName}',
    );
  }

  // دالة بناء ملف الـ PDF
  static Future<pw.Document> generateContractDocument(EmploymentContract contract) async {
    final pdf = pw.Document();

    // 1. تحميل الخطوط العربية
    // نستخدم دالة مساعدة لجلب خطوط تدعم العربية
    final font = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();
    
    final dateFormat = intl.DateFormat('yyyy/MM/dd');

    // تعريف الستايلات هنا لتجنب التضارب وتمريرها للدوال
    final titleStyle = pw.TextStyle(font: fontBold, fontSize: 12, color: PdfColors.blue900);
    final bodyStyle = pw.TextStyle(font: font, fontSize: 11, lineSpacing: 4); // زيادة التباعد للقراءة
    final headerStyle = pw.TextStyle(font: fontBold, fontSize: 14);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        textDirection: pw.TextDirection.rtl, // اتجاه النص من اليمين لليسار
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // --- الترويسة ---
              _buildHeader(headerStyle, font),
              pw.SizedBox(height: 20),
              
              // --- العنوان ---
              pw.Center(
                child: pw.Text(
                  "عقد عمل موحد", 
                  style: pw.TextStyle(font: fontBold, fontSize: 18, decoration: pw.TextDecoration.underline)
                ),
              ),
              pw.SizedBox(height: 20),

              // --- الديباجة ---
              _buildPreamble(contract, dateFormat, bodyStyle),
              pw.SizedBox(height: 20),

              // --- مواد العقد ---
              _buildArticle(
                "المادة (1): التعيين والوظيفة", 
                "وافق الطرف الأول على تعيين الطرف الثاني في وظيفة (${_getJobTitleName(contract)}) في قسم (${_getSectionName(contract)})، ويتعهد الطرف الثاني بأداء واجباته بأمانة وإخلاص وفقاً لتعليمات إدارة الشركة.",
                titleStyle,
                bodyStyle
              ),
              
              _buildArticle(
                "المادة (2): مدة العقد وفترة التجربة", 
                "تبدأ مدة هذا العقد بتاريخ ${contract.startDate != null ? dateFormat.format(contract.startDate!) : '..../../..'} ${contract.endDate != null ? 'وينتهي بتاريخ ${dateFormat.format(contract.endDate!)}' : 'وهو عقد غير محدد المدة'}. \n"
                "يخضع الطرف الثاني لفترة تجربة مدتها (${contract.probationMonths}) أشهر، يحق خلالها للطرف الأول إنهاء العقد دون إشعار أو تعويض في حال عدم ثبوت الكفاءة.",
                titleStyle,
                bodyStyle
              ),

              _buildArticle(
                "المادة (3): الراتب والمزايا المالية", 
                "يتقاضى الطرف الثاني لقاء عمله راتباً أساسياً شهرياً قدره (${contract.basicSalary}) دينار أردني.\n"
                "بالإضافة إلى البدلات التالية: ${_getAllowancesText(contract)}.\n"
                "يخضع الراتب للاقتطاعات القانونية (الضمان الاجتماعي وضريبة الدخل) حسب القوانين السارية.",
                titleStyle,
                bodyStyle
              ),

              _buildArticle(
                "المادة (4): ساعات العمل والإجازات", 
                "يلتزم الطرف الثاني بالعمل وفق نظام الورديات المعتمد (${_getShiftName(contract)}). يستحق الطرف الثاني إجازة سنوية مدفوعة الأجر مدتها 14 يوماً (تصبح 21 يوماً بعد مرور 5 سنوات)، بالإضافة للعطل الرسمية.",
                titleStyle,
                bodyStyle
              ),

              _buildArticle(
                "المادة (5): إنهاء العقد", 
                "في حال رغبة أي من الطرفين بإنهاء هذا العقد بعد فترة التجربة، يجب تقديم إشعار خطي قبل (${contract.noticePeriodMonths}) أشهر، أو دفع راتب شهر بدلاً عن الإشعار.",
                titleStyle,
                bodyStyle
              ),

              pw.SizedBox(height: 40),

              // --- التواقيع ---
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text("الطرف الأول (الشركة)", style: pw.TextStyle(font: fontBold)),
                      pw.SizedBox(height: 40),
                      pw.Text("التوقيع والختم: _________________"),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text("الطرف الثاني (الموظف)", style: pw.TextStyle(font: fontBold)),
                      pw.SizedBox(height: 40),
                      pw.Text("التوقيع: _________________"),
                    ],
                  ),
                ],
              ),
              
              pw.Spacer(),
              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  "شركة مكعب للحجر الصناعي - جميع الحقوق محفوظة", 
                  style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey)
                )
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  // --- دوال مساعدة لبناء الـ widgets (تم تحديثها لتقبل الستايل كمعامل) ---

  static pw.Widget _buildHeader(pw.TextStyle headerStyle, pw.Font font) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("شركة مكعب للحجر الصناعي", style: headerStyle),
            pw.Text("عمان - الأردن", style: pw.TextStyle(font: font, fontSize: 10)),
            pw.Text("سجل تجاري رقم: 123456", style: pw.TextStyle(font: font, fontSize: 10)),
          ],
        ),
        // pw.Image(logoImage, width: 50), // مكان اللوجو
        pw.Text("Ref: HR-CONT-${DateTime.now().year}", style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  static pw.Widget _buildPreamble(EmploymentContract contract, intl.DateFormat fmt, pw.TextStyle style) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("إنه في يوم: ............ الموافق: ${fmt.format(DateTime.now())}، تم الاتفاق بين كل من:", style: style),
          pw.SizedBox(height: 5),
          pw.Text("1. شركة مكعب للحجر الصناعي، ويمثلها المدير العام، ويشار إليها بـ (الطرف الأول).", style: style),
          pw.Text("2. السيد/ة: ${contract.employeeName ?? '...........................'}، ويشار إليه/ا بـ (الطرف الثاني).", style: style),
          pw.SizedBox(height: 5),
          pw.Text("أهلاً قانونياً للتعاقد، فقد اتفق الطرفان على ما يلي:", style: style),
        ],
      ),
    );
  }

  static pw.Widget _buildArticle(String title, String content, pw.TextStyle titleStyle, pw.TextStyle bodyStyle) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: titleStyle),
        pw.SizedBox(height: 2),
        pw.Text(content, style: bodyStyle),
        pw.SizedBox(height: 8),
      ],
    );
  }

  // --- دوال لجلب الأسماء ---
  static String _getJobTitleName(EmploymentContract c) {
    return c.jobTitleId != null ? "مسمى: ${c.jobTitleId}" : "الموظف"; 
  }

  static String _getSectionName(EmploymentContract c) {
    return c.sectionId != null ? "قسم: ${c.sectionId}" : "الشركة";
  }

  static String _getShiftName(EmploymentContract c) {
    return c.shiftId != null ? "وردية: ${c.shiftId}" : "الوردية الصباحية";
  }

  static String _getAllowancesText(EmploymentContract c) {
    if (c.allowanceIds.isEmpty) return "لا يوجد";
    return "بدلات إضافية عدد (${c.allowanceIds.length})"; 
  }
}