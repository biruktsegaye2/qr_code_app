import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Checks for camera permission and handles user prompts
Future<bool> checkCameraPermission(BuildContext context) async {
  // Get the current camera permission status
  final status = await Permission.camera.status;

  if (status.isGranted) {
    return true; // Permission already granted
  } else if (status.isDenied) {
    // Permission is denied but not permanently
    return await _requestPermission(context, 'Camera access is required to scan QR codes.');
  } else if (status.isPermanentlyDenied) {
    // Permission is permanently denied
    return await _showSettingsDialog(
      context,
      'Permission Required',
      'Camera access is permanently denied. Please enable it from the app settings.',
    );
  }

  return false; // Default to permission not granted
}

/// Handles permission request and displays a dialog if denied
Future<bool> _requestPermission(BuildContext context, String message) async {
  final result = await Permission.camera.request();

  if (result.isGranted) {
    return true;
  } else if (result.isPermanentlyDenied) {
    // Show dialog if permission is permanently denied after the request
    return await _showSettingsDialog(
      context,
      'Permission Required',
      'Camera access is permanently denied. Please enable it from the app settings.',
    );
  } else {
    // Show dialog for regular denial
    return await _showDeniedDialog(
      context,
      'Permission Denied',
      message,
    );
  }
}

/// Displays a dialog for denied permissions
Future<bool> _showDeniedDialog(BuildContext context, String title, String message) async {
  if (context.mounted) {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              openAppSettings(); // Open app settings
            },
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }
  return false;
}

/// Displays a dialog for permanently denied permissions
Future<bool> _showSettingsDialog(BuildContext context, String title, String message) async {
  if (context.mounted) {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              openAppSettings(); // Open app settings
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
  return false;
}
