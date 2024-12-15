import '../entities/scan_entity.dart';
import '../repositories/scan_repository.dart';

class SaveScanUseCase {
  final ScanRepository repository;

  SaveScanUseCase(this.repository);

  Future<void> call(ScanEntity scan) async {
    return repository.saveScan(scan);
  }
}
