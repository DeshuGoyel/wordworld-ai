import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import 'storage_service.dart';

/// XP and leveling system — Seedling → Champion
/// Persists XP to Hive via StorageService.
class XPService {
  final StorageService _storage;
  int _totalXP = 0;

  XPService(this._storage) {
    _totalXP = _storage.loadXP();
  }

  int get totalXP => _totalXP;

  /// XP awards by action
  static const Map<String, int> xpValues = {
    'lesson_complete': 10,
    'quiz_correct': 5,
    'quiz_wrong': 1,
    'word_mastered': 25,
    'letter_mastered': 50,
    'daily_challenge': 30,
    'streak_bonus': 5,
    'subject_complete': 100,
    'story_complete': 15,
    'first_try_correct': 8,
  };

  /// Award XP for a named action and save
  int awardXP(String action) {
    final xp = xpValues[action] ?? 5;
    _totalXP += xp;
    _storage.saveXP(_totalXP);
    return xp;
  }

  /// Award custom XP and save
  void addXP(int amount) {
    _totalXP += amount;
    _storage.saveXP(_totalXP);
  }

  /// Get current level info
  ({String name, String emoji, int minXP}) get currentLevel =>
      AppLevels.forXP(_totalXP);

  /// Get progress to next level (0.0 – 1.0)
  double get progressToNext => AppLevels.progressToNext(_totalXP);

  /// Check if just leveled up (call after awarding XP)
  bool didLevelUp(int previousXP) {
    return AppLevels.forXP(previousXP).name != AppLevels.forXP(_totalXP).name;
  }

  /// Set XP directly (for admin/testing)
  void setXP(int xp) {
    _totalXP = xp;
    _storage.saveXP(_totalXP);
  }

  /// Reset XP (e.g. new child profile)
  void resetXP() => setXP(0);
}

final xpServiceProvider = Provider<XPService>((ref) {
  return XPService(ref.read(storageServiceProvider));
});
