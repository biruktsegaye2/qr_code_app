import 'package:flutter/material.dart';
import '../../domain/entities/scan_entity.dart';
import 'package:flutter/services.dart';

class ScanResultDialog extends StatelessWidget {
  final ScanEntity scan;

  // Constructor to receive the scanned entity
  const ScanResultDialog({super.key, required this.scan});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Adding rounded corners for a modern look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Ensures the dialog wraps its content
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.qr_code_2,
              size: 60,
              color: Colors.blue
            ),

            const SizedBox(height: 16),

            // Dialog title to indicate scan result
             Text(
              'Scan Result',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 12),

            // Made selectable to allow users to copy specific parts manually
            SelectableText(
              scan.data,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center
            ),

            const SizedBox(height: 16),

            // Buttons for user actions: Copy and Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Copy button to copy the scan result to clipboard
                ElevatedButton.icon(
                  onPressed: () {
                    // To Copy data to clipboard
                    Clipboard.setData(ClipboardData(text: scan.data));
                    // To closes the dialog after copying
                    Navigator.pop(context);
                    // Show a confirmation SnackBar to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        content: Text('Copied to clipboard', style: Theme.of(context).textTheme.bodyMedium,),
                        behavior: SnackBarBehavior.floating // Floating style for better visibility
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                  ),
                ),

                // Close button to simply dismiss the dialog
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.red)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
