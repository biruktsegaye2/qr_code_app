import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/scan_entity.dart';
import '../../domain/repositories/scan_repository.dart';

class ScanRepositoryImpl implements ScanRepository {
  static const _key = 'scanHistory'; // Key used to store the scan history

  @override
  Future<void> saveScan(ScanEntity scan) async {
    final prefs = await SharedPreferences.getInstance();

    // Fetch existing history or initialize an empty list
    final existingHistory = prefs.getStringList(_key) ?? [];

    // Format the scan data as a string "data|timestamp"
    final newEntry = '${scan.data}|${scan.timestamp.toIso8601String()}';
    existingHistory.add(newEntry);

    // Maintain a maximum history size of 100 entries to avoid excessive growth
    if (existingHistory.length > 100) {
      existingHistory.removeAt(0); // Remove the oldest entry
    }

    // Save the updated history back to SharedPreferences
    await prefs.setStringList(_key, existingHistory);
  }

  @override
  Future<List<ScanEntity>> getScanHistory() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the stored scan history
    final history = prefs.getStringList(_key) ?? [];

    // Parse the history into a list of ScanEntity objects
    return history
        .map((e) {
      final parts = e.split('|');

      // Ensure each entry has exactly two parts: data and timestamp
      if (parts.length != 2) {
        debugPrint('Skipping malformed entry: $e');
        return null;
      }
      try {
        // Attempt to parse the entry into a ScanEntity
        return ScanEntity(
          data: parts[0],
          timestamp: DateTime.parse(parts[1]),
        );
      } catch (e) {
        // Log any errors encountered during parsing
        debugPrint('Error parsing entry: $e');
        return null;
      }
    })
        .whereType<ScanEntity>() // Filter out null entries
        .toList();
  }

  @override
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();

    // Remove the scan history from SharedPreferences
    await prefs.remove(_key);
  }
}
