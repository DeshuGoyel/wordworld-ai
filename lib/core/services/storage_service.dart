import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/models.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  Box get _settingsBox => Hive.box('app_settings');
  Box get _childBox => Hive.box('child_profiles');
  Box get _activityBox => Hive.box('activities');
  Box get _progressBox => Hive.box('progress');
  Box get _userBox => Hive.box('user_data');

  // App Settings
  String? getLanguage() => _settingsBox.get('language');
  Future<void> setLanguage(String lang) => _settingsBox.put('language', lang);

  String? getUserType() => _settingsBox.get('userType');
  Future<void> setUserType(String type) => _settingsBox.put('userType', type);

  bool isOnboarded() => _settingsBox.get('onboarded', defaultValue: false);
  Future<void> setOnboarded(bool v) => _settingsBox.put('onboarded', v);

  String? getActiveChildId() => _settingsBox.get('activeChildId');
  Future<void> setActiveChildId(String id) =>
      _settingsBox.put('activeChildId', id);

  int getSessionMinutes() =>
      _settingsBox.get('sessionMinutes', defaultValue: 30);
  Future<void> setSessionMinutes(int m) =>
      _settingsBox.put('sessionMinutes', m);

  bool getMusicEnabled() =>
      _settingsBox.get('musicEnabled', defaultValue: true);
  Future<void> setMusicEnabled(bool v) => _settingsBox.put('musicEnabled', v);

  bool getStreaksVisible() =>
      _settingsBox.get('streaksVisible', defaultValue: true);
  Future<void> setStreaksVisible(bool v) =>
      _settingsBox.put('streaksVisible', v);

  // User
  Future<void> saveUser(AppUser user) =>
      _userBox.put(user.id, user.toJson());

  AppUser? getUser(String id) {
    final data = _userBox.get(id);
    if (data == null) return null;
    return AppUser.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> saveCurrentUserId(String id) =>
      _settingsBox.put('currentUserId', id);

  String? getCurrentUserId() => _settingsBox.get('currentUserId');

  // Child profiles
  Future<void> saveChild(ChildProfile child) =>
      _childBox.put(child.id, child.toJson());

  ChildProfile? getChild(String id) {
    final data = _childBox.get(id);
    if (data == null) return null;
    return ChildProfile.fromJson(Map<String, dynamic>.from(data));
  }

  List<ChildProfile> getAllChildren() {
    return _childBox.values
        .map((e) => ChildProfile.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Activities
  Future<void> saveActivity(Activity activity) =>
      _activityBox.put(activity.id, activity.toJson());

  List<Activity> getActivitiesForChild(String childId) {
    return _activityBox.values
        .map((e) => Activity.fromJson(Map<String, dynamic>.from(e)))
        .where((a) => a.childId == childId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Progress
  Future<void> saveWordProgress(String childId, WordProgress progress) =>
      _progressBox.put('${childId}_${progress.wordId}', progress.toJson());

  WordProgress? getWordProgress(String childId, String wordId) {
    final data = _progressBox.get('${childId}_$wordId');
    if (data == null) return null;
    return WordProgress.fromJson(Map<String, dynamic>.from(data));
  }

  Map<String, WordProgress> getAllWordProgress(String childId) {
    final map = <String, WordProgress>{};
    for (final key in _progressBox.keys) {
      if (key.toString().startsWith('${childId}_')) {
        final data = _progressBox.get(key);
        if (data != null) {
          final wp = WordProgress.fromJson(Map<String, dynamic>.from(data));
          map[wp.wordId] = wp;
        }
      }
    }
    return map;
  }


  // Pin
  Future<void> savePin(String pin) => _settingsBox.put('pin', pin);
  String? getPin() => _settingsBox.get('pin');

  // Generic settings (for AI config etc.)
  Future<void> saveSetting(String key, String value) => _settingsBox.put(key, value);
  String? getSetting(String key) => _settingsBox.get(key);

  // ─── XP Persistence ───
  Future<void> saveXP(int xp) => _settingsBox.put('total_xp', xp);
  int loadXP() => _settingsBox.get('total_xp', defaultValue: 0);

  // ─── Streak Persistence ───
  Future<void> saveStreak({
    required int current,
    required int longest,
    required int freezes,
    String? lastActiveDate, // ISO-8601 date string e.g. "2026-02-21"
  }) async {
    await _settingsBox.put('streak_current', current);
    await _settingsBox.put('streak_longest', longest);
    await _settingsBox.put('streak_freezes', freezes);
    if (lastActiveDate != null) {
      await _settingsBox.put('streak_last_date', lastActiveDate);
    }
  }

  ({int current, int longest, int freezes, String? lastActiveDate}) loadStreak() {
    return (
      current: _settingsBox.get('streak_current', defaultValue: 0),
      longest: _settingsBox.get('streak_longest', defaultValue: 0),
      freezes: _settingsBox.get('streak_freezes', defaultValue: 1),
      lastActiveDate: _settingsBox.get('streak_last_date'),
    );
  }

  // ─── Module Score Persistence (V2/V3 screens) ───
  /// key pattern: "module_<childId>_<moduleKey>" => {"score": int, "total": int, "stars": int}
  Future<void> saveModuleScore({
    required String childId,
    required String moduleKey,
    required int score,
    required int total,
  }) async {
    final stars = score / total >= 0.9 ? 3 : score / total >= 0.6 ? 2 : 1;
    await _progressBox.put('module_${childId}_$moduleKey', {
      'score': score,
      'total': total,
      'stars': stars,
      'ts': DateTime.now().toIso8601String(),
    });
  }

  ({int score, int total, int stars})? loadModuleScore({
    required String childId,
    required String moduleKey,
  }) {
    final data = _progressBox.get('module_${childId}_$moduleKey');
    if (data == null) return null;
    final m = Map<String, dynamic>.from(data as Map);
    return (
      score: (m['score'] as num).toInt(),
      total: (m['total'] as num).toInt(),
      stars: (m['stars'] as num).toInt(),
    );
  }

  /// All completed module keys for a child
  List<String> getCompletedModules(String childId) {
    final prefix = 'module_${childId}_';
    return _progressBox.keys
        .where((k) => k.toString().startsWith(prefix))
        .map((k) => k.toString().substring(prefix.length))
        .where((k) => k.isNotEmpty)
        .toList();
  }
}
