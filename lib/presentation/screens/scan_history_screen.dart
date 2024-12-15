import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import '../../domain/entities/scan_entity.dart';
import '../../data/repositories/scan_repository_impl.dart';
import '../../utils/permission_handler.dart';
import '../widgets/history_list_widget.dart';
import '../widgets/scan_result_dialog.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  ScanHistoryScreenState createState() => ScanHistoryScreenState();
}

class ScanHistoryScreenState extends State<ScanHistoryScreen> {
  // Repository instance for to handle crud operations of scan history
  final repository = ScanRepositoryImpl();

  // List to store the history of scanned items
  List<ScanEntity> scanHistory = [];

  @override
  void initState() {
    super.initState();

    // Automatically open the scanner before showing the scanned list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startScanner();
    });

   /*
    Load the scan history: this helps us to display the list of scans
    while showing the scanner to the user
    */
    loadHistory();


  }

  // Loads scan history from the repository using shared preference and updates the state.
  Future<void> loadHistory() async {
    try {
      // Fetch data from repository
      final history = await repository.getScanHistory();
      setState(() {
        // add the fetched data to the state
        scanHistory = history;
      });
    } catch (e) {
      // Log error and notify the user
      debugPrint('Failed to load scan history (debug repository): $e');

      // check if the widget is still mounted before showing the snack bar
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error loading history'))
        );
      }
    }
  }

  /* Launches the barcode scanner and processes the result after that
  it saves it to the history list and displays it in a dialog.
   */
  Future<void> startScanner() async {
    try {
      // Check camera permission before starting the scanner
      final hasPermission = await checkCameraPermission(context);
      if (!hasPermission) {
        debugPrint('Camera permission not granted.');
        return;
      }

      // Open the barcode scanner and await for the result
      final result = await BarcodeScanner.scan();

      // Check if the result is empty and skip saving if it is
      if (result.rawContent.isEmpty) {
        debugPrint('Empty scan result. Skipping save.');
        return;
      }

      // Process the result if it is a valid code, i.e. QR code, barcode, etc.
      if (result.type == ResultType.Barcode) {
        final scan = ScanEntity(
          data: result.rawContent, // Scanned content
          timestamp: DateTime.now(), // Timestamp of scan
        );

        // Save the scan to the repository and refresh history
        //TODO instead of reloading the list, using state management like bloc or provider will be a better approach when the app grows for better performance
        await repository.saveScan(scan);
        await loadHistory();

        // Show the result to the user in a dialog
        showResultDialog(scan);
      }
    } catch (e) {
      // Handle errors and notify the user
      debugPrint('Error scanning barcode: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning: $e')),
        );
      }
    }
  }


  // Clears all saved scan history after confirming with the user.
  Future<void> clearHistory() async {
    try {
      // Clear history in the repository
      await repository.clearHistory();
      setState(() {
        scanHistory = []; // Reset the history list
      });
    } catch (e) {
      // Handle errors and show feedback to the user
      debugPrint('Failed to clear scan history: $e');
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error clearing history'))
        );
      }
    }
  }

  // Displays a dialog with the content of the scanned result.
  void showResultDialog(ScanEntity scan) {
    showDialog(
      context: context,
      builder: (context) => ScanResultDialog(scan: scan),
    );
  }

  // Prompts the user with a confirmation dialog before clearing the history.
  void confirmClearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
            'Are you sure you want to clear the scan history? This action cannot be undone.'),
        actions: [
          // Cancel button to close the dialog
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          // Clear button to confirm the action
          TextButton(
            onPressed: () {
              clearHistory(); // Clear history and close the dialog
              Navigator.of(context).pop();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Scan History', style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          // Show the clear history button only if there is history
          if (scanHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: confirmClearHistory,
              tooltip: 'Clear History',
            ),
        ],
      ),
      //TODO implementing lazy loading for the list will be a better approach when the list grows for better performance and user experience
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300), // Smooth transition for UI changes
        child: scanHistory.isEmpty
            ?  Center(
          child: Text(
            'No history available. Tap the scan button to start scanning.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center
          ),
        )
            : HistoryListWidget(scanHistory: scanHistory), // List of scan history
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: startScanner,
        tooltip: 'Scan', // Trigger the scanner
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
