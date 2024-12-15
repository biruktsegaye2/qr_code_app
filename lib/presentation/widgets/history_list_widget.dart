import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/scan_entity.dart';

class HistoryListWidget extends StatelessWidget {
  final List<ScanEntity> scanHistory;

  // Constructor to initialize the list of scanned history
  const HistoryListWidget({super.key, required this.scanHistory});

  // Format the timestamp into a readable format
  String formatDate(DateTime timestamp) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // build the list based on the scanned History length
      itemCount: scanHistory.length,
      itemBuilder: (context, index) {
        // Reverse the list order to show scans in reverse chronological order, from most recent to earliest.
        final scan = scanHistory.reversed.toList()[index];

        // Return a card-styled widget for each scan entry
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            child: ListTile(
              // Leading icon container to show QR code icon
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: const Icon(
                  Icons.qr_code,
                  color: Colors.blue
                ),
              ),
              // Title displaying the scanned data
              title: Text(
                scan.data,
                style: const TextStyle(fontWeight: FontWeight.bold)
              ),
              // Subtitle to diplay the formatted date and time
              subtitle: Text(
                formatDate(scan.timestamp),
                style: Theme.of(context).textTheme.bodyMedium
              ),
            ),
          ),
        );
      },
    );
  }
}
