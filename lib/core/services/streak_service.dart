import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage_service.dart';

/// Streak tracking service — daily login streak with freeze
/// Persists to Hive via StorageService.
class StreakService {
  final StorageService _storage;
  int _currentStreak = 0;
  int _longestStreak = 0;
  int _freezes = 1;
  DateTime? _lastActiveDate;

  StreakService(this._storage) {
    _load();
  }

  void _load() {
    final saved = _storage.loadStreak();
    _currentStreak = saved.current;
    _longestStreak = saved.longest;
    _freezes = saved.freezes;
    final dateStr = saved.lastActiveDate;
    if (dateStr != null) {
      _lastActiveDate = DateTime.tryParse(dateStr);
    }
  }

  Future<void> _save() async {
    await _storage.saveStreak(
      current: _currentStreak,
      longest: _longestStreak,
      freezes: _freezes,
      lastActiveDate: _lastActiveDate?.toIso8601String().substring(0, 10),
    );
  }

  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  int get freezes => _freezes;

  /// Call on every session start
  Future<void> recordActivity() async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (_lastActiveDate == null) {
      _currentStreak = 1;
    } else {
      final lastDate = DateTime(
          _lastActiveDate!.year, _lastActiveDate!.month, _lastActiveDate!.day);
      final diff = todayDate.difference(lastDate).inDays;

      if (diff == 0) {
        // Already recorded today — no change needed
        return;
      } else if (diff == 1) {
        _currentStreak++;
      } else if (diff == 2 && _freezes > 0) {
        // Use freeze
        _freezes--;
        _currentStreak++;
      } else {
        _currentStreak = 1; // Streak broken
      }
    }

    _lastActiveDate = todayDate;
    if (_currentStreak > _longestStreak) _longestStreak = _currentStreak;
    await _save();
  }

  /// Grant a streak freeze (earned or purchased)
  Future<void> addFreeze() async {
    _freezes++;
    await _save();
  }

  /// Is today's activity recorded?
  bool get isTodayActive {
    if (_lastActiveDate == null) return false;
    final today = DateTime.now();
    return _lastActiveDate!.year == today.year &&
        _lastActiveDate!.month == today.month &&
        _lastActiveDate!.day == today.day;
  }
}

final streakServiceProvider = Provider<StreakService>((ref) {
  return StreakService(ref.read(storageServiceProvider));
});
