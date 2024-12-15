import '../entities/scan_entity.dart';

abstract class ScanRepository {
  Future<void> saveScan(ScanEntity scan);
  Future<List<ScanEntity>> getScanHistory();
  Future<void> clearHistory();
}
