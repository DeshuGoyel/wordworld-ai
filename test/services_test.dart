// Tests for XPService and StreakService
// Run: flutter test test/services_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/core/services/xp_service.dart';
import 'package:learn_app/core/services/streak_service.dart';
import 'package:learn_app/core/services/storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

/// Opens temporary in-memory Hive boxes for testing.
Future<void> _initHive() async {
  final tmpDir = await Directory.systemTemp.createTemp('hive_test_');
  Hive.init(tmpDir.path);
  // All boxes used by StorageService
  for (final box in ['app_settings', 'child_profiles', 'activities', 'progress', 'user_data']) {
    if (!Hive.isBoxOpen(box)) await Hive.openBox(box);
  }
}

void main() {
  setUpAll(() async => await _initHive());

  tearDownAll(() async => await Hive.deleteFromDisk());

  group('XPService', () {
    late StorageService storage;
    late XPService xp;

    setUp(() {
      // Clear settings box before each test
      Hive.box('app_settings').clear();
      storage = StorageService();
      xp = XPService(storage);
    });

    test('starts at 0 XP', () {
      expect(xp.totalXP, 0);
    });

    test('addXP increases total', () {
      xp.addXP(10);
      expect(xp.totalXP, 10);
      xp.addXP(5);
      expect(xp.totalXP, 15);
    });

    test('awardXP returns correct amount for known action', () {
      final awarded = xp.awardXP('quiz_correct');
      expect(awarded, 5);
      expect(xp.totalXP, 5);
    });

    test('awardXP falls back to 5 for unknown action', () {
      final awarded = xp.awardXP('unknown_action');
      expect(awarded, 5);
    });

    test('setXP sets exact amount', () {
      xp.setXP(100);
      expect(xp.totalXP, 100);
    });

    test('XP persists across instances', () {
      xp.addXP(42);
      final xp2 = XPService(storage);
      expect(xp2.totalXP, 42);
    });

    test('didLevelUp returns true when level changes', () {
      final prev = xp.totalXP;
      xp.setXP(500); // enough to level up
      expect(xp.didLevelUp(prev), isTrue);
    });

    test('didLevelUp returns false on small gain', () {
      xp.setXP(10);
      final prev = xp.totalXP;
      xp.addXP(1); // not enough to level up
      expect(xp.didLevelUp(prev), isFalse);
    });

    test('progressToNext is between 0 and 1', () {
      xp.setXP(50);
      expect(xp.progressToNext, greaterThanOrEqualTo(0.0));
      expect(xp.progressToNext, lessThanOrEqualTo(1.0));
    });

    test('resetXP clears XP', () {
      xp.addXP(200);
      xp.resetXP();
      expect(xp.totalXP, 0);
    });
  });

  group('StreakService', () {
    late StorageService storage;
    late StreakService streak;

    setUp(() {
      Hive.box('app_settings').clear();
      storage = StorageService();
      streak = StreakService(storage);
    });

    test('starts with streak 0', () {
      expect(streak.currentStreak, 0);
      expect(streak.isTodayActive, isFalse);
    });

    test('recordActivity sets streak to 1 on first call', () async {
      await streak.recordActivity();
      expect(streak.currentStreak, 1);
      expect(streak.isTodayActive, isTrue);
    });

    test('duplicate call on same day does not increase streak', () async {
      await streak.recordActivity();
      await streak.recordActivity();
      expect(streak.currentStreak, 1);
    });

    test('streak persists across instances', () async {
      await streak.recordActivity();
      final streak2 = StreakService(storage);
      expect(streak2.currentStreak, 1);
    });

    test('addFreeze increments freeze count', () async {
      final initial = streak.freezes;
      await streak.addFreeze();
      expect(streak.freezes, initial + 1);
    });

    test('longestStreak tracks maximum', () async {
      await streak.recordActivity();
      expect(streak.longestStreak, greaterThanOrEqualTo(1));
    });
  });

  group('StorageService — module scores', () {
    late StorageService storage;

    setUp(() async {
      await Hive.box('app_settings').clear();
      await Hive.box('progress').clear();
      storage = StorageService();
    });

    test('saveModuleScore and loadModuleScore round-trip', () async {
      await storage.saveModuleScore(
          childId: 'child1', moduleKey: 'phonics_level1', score: 9, total: 10);
      final result = storage.loadModuleScore(
          childId: 'child1', moduleKey: 'phonics_level1');
      expect(result, isNotNull);
      expect(result!.score, 9);
      expect(result.total, 10);
      expect(result.stars, 3); // 90% = 3 stars
    });

    test('stars = 2 for 60–89%', () async {
      await storage.saveModuleScore(
          childId: 'c', moduleKey: 'math_money', score: 7, total: 10);
      final r = storage.loadModuleScore(childId: 'c', moduleKey: 'math_money');
      expect(r!.stars, 2);
    });

    test('stars = 1 for <60%', () async {
      await storage.saveModuleScore(
          childId: 'c', moduleKey: 'art_craft', score: 4, total: 10);
      final r = storage.loadModuleScore(childId: 'c', moduleKey: 'art_craft');
      expect(r!.stars, 1);
    });

    test('getCompletedModules returns correct keys', () async {
      await storage.saveModuleScore(
          childId: 'c', moduleKey: 'mod_a', score: 5, total: 10);
      await storage.saveModuleScore(
          childId: 'c', moduleKey: 'mod_b', score: 8, total: 10);
      final mods = storage.getCompletedModules('c');
      expect(mods, containsAll(['mod_a', 'mod_b']));
    });

    test('loadModuleScore returns null for missing key', () {
      final r =
          storage.loadModuleScore(childId: 'c', moduleKey: 'nonexistent');
      expect(r, isNull);
    });
  });
}
