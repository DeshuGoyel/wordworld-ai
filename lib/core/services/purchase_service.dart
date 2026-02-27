import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_app/core/services/storage_service.dart';

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return PurchaseService(ref.read(storageServiceProvider));
});

class PurchaseService {
  final StorageService _storage;

  PurchaseService(this._storage);

  bool get isPremium => _storage.getSetting('premium') == 'true';

  Future<void> upgradeToPremium() async {
    await _storage.saveSetting('premium', 'true');
  }

  Future<void> resetPremium() async {
     await _storage.saveSetting('premium', 'false');
  }
}
