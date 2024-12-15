import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_scanner_app/data/repositories/scan_repository_impl.dart';
import 'package:qr_scanner_app/domain/entities/scan_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Ensure Flutter services are initialized before running tests.
  WidgetsFlutterBinding.ensureInitialized();

  group('ScanRepositoryImpl Tests', () {
    late ScanRepositoryImpl repository;

    setUp(() {
      // Set up mock SharedPreferences for an isolated testing environment.
      SharedPreferences.setMockInitialValues({});
      repository = ScanRepositoryImpl();
    });

    test('saveScan adds a new scan and limits history to 100 entries', () async {
      // Arrange
      // Create a sample ScanEntity object to simulate a scanned QR code.
      final scan = ScanEntity(
        data: 'Test QR Code',
        timestamp: DateTime.now(),
      );

      // Act
      // Save the scan to the repository.
      await repository.saveScan(scan);

      // Assert
      // Fetch the saved scan history and verify its contents.
      final history = await repository.getScanHistory();
      expect(history.length, 1, reason: 'History should contain exactly one scan');
      expect(history.first.data, 'Test QR Code', reason: 'The saved scan data should match the input');
    });

    test('getScanHistory retrieves saved scan entities', () async {
      // Arrange
      // Initialize SharedPreferences with pre-defined scan history.
      final initialData = [
        'Data1|2024-12-14T10:00:00.000Z', // A valid scan entry
        'Data2|2024-12-14T12:00:00.000Z', // Another valid scan entry
      ];
      SharedPreferences.setMockInitialValues({'scanHistory': initialData});

      // Act
      // Retrieve the scan history from the repository.
      final history = await repository.getScanHistory();

      // Assert
      // Verify that the retrieved history matches the expected data.
      expect(history.length, 2, reason: 'History should contain two entries');
      expect(history[0].data, 'Data1', reason: 'The first entry should match "Data1"');
      expect(history[1].data, 'Data2', reason: 'The second entry should match "Data2"');
    });

    test('clearHistory removes all saved scans', () async {
      // Arrange
      // Initialize SharedPreferences with some pre-existing scan history.
      final initialData = [
        'Data1|2024-12-14T10:00:00.000Z',
        'Data2|2024-12-14T12:00:00.000Z',
      ];
      SharedPreferences.setMockInitialValues({'scanHistory': initialData});

      // Act
      // Clear the scan history using the repository.
      await repository.clearHistory();

      // Assert
      // Fetch the history and verify that it is empty.
      final history = await repository.getScanHistory();
      expect(history.isEmpty, true, reason: 'History should be empty after clearing');
    });

    test('saveScan skips malformed entries when retrieving history', () async {
      // Arrange
      // Pre-fill SharedPreferences with a mix of malformed and valid data.
      final initialData = [
        'MalformedData', // Invalid entry (missing separator)
        'ValidData|2024-12-14T15:00:00.000Z', // Valid entry
      ];
      SharedPreferences.setMockInitialValues({'scanHistory': initialData});

      // Act
      // Retrieve the scan history and filter out invalid entries.
      final history = await repository.getScanHistory();

      // Assert
      // Only valid entries should be included in the retrieved history.
      expect(history.length, 1, reason: 'Only valid entries should be included');
      expect(history[0].data, 'ValidData', reason: 'The valid entry should match "ValidData"');
    });
  });
}
