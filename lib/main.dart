// FileName: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// استيراد الشاشة الرئيسية الجديدة
import 'package:mokaab/features/home/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mokaab ERP',
      debugShowCheckedModeBanner: false,
      
      // إعدادات اللغة العربية
      locale: const Locale('ar', 'JO'),
      supportedLocales: const [
        Locale('ar', 'JO'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Tajawal', // تأكد من إضافة الخط في pubspec.yaml أو سيستخدم الافتراضي
        useMaterial3: false, // لضمان ثبات التصميم الكلاسيكي للـ ERP
      ),
      
      // نقطة البداية: الشاشة الرئيسية المجمعة
      home: const HomeScreen(),
    );
  }
}