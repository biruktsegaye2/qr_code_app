import 'package:flutter/material.dart';
import 'package:qr_scanner_app/presentation/screens/scan_history_screen.dart';
import 'package:qr_scanner_app/utils/app_themes.dart';

void main() {
  runApp(const QRScannerApp());
}

class QRScannerApp extends StatelessWidget {
  const QRScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner
      title: 'QR Scanner',
      theme: AppThemes.lightTheme, // Light theme
      darkTheme: AppThemes.darkTheme, // Dark theme
      themeMode: ThemeMode.system, // Automatically switch based on system setting

      home: const ScanHistoryScreen(), // Set the History Screen as the home screen
    );
  }
}
