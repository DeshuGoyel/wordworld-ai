// Widget tests for key WordWorld screens
// Run: flutter test test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learn_app/shared/widgets/quiz_result_screen.dart';
import 'dart:io';

late Directory _tmpDir;

Future<void> _initHive() async {
  _tmpDir = await Directory.systemTemp.createTemp('widget_hive_');
  Hive.init(_tmpDir.path);
  for (final box in [
    'app_settings',
    'child_profiles',
    'activities',
    'progress',
    'user_data',
  ]) {
    if (!Hive.isBoxOpen(box)) await Hive.openBox(box);
  }
}

void main() {
  setUpAll(() async => await _initHive());
  tearDownAll(() async {
    await Hive.close();
    await _tmpDir.delete(recursive: true);
  });

  // ─────────────────────────────────────────
  group('QuizResultScreen', () {
    Widget buildSubject({
      required int score,
      required int total,
      String title = 'Test Quiz',
      Color color = Colors.blue,
      VoidCallback? onBack,
      VoidCallback? onRetry,
    }) {
      return ProviderScope(
        child: MaterialApp(
          home: QuizResultScreen(
            score: score,
            total: total,
            title: title,
            color: color,
            onBack: onBack ?? () {},
            onRetry: onRetry ?? () {},
          ),
        ),
      );
    }

    testWidgets('shows score fraction', (tester) async {
      await tester.pumpWidget(buildSubject(score: 7, total: 10));
      await tester.pumpAndSettle();
      expect(find.text('7 / 10'), findsOneWidget);
    });

    testWidgets('shows percentage', (tester) async {
      await tester.pumpWidget(buildSubject(score: 8, total: 10));
      await tester.pumpAndSettle();
      expect(find.text('80% correct'), findsOneWidget);
    });

    testWidgets('shows "Outstanding!" for 90%+ score', (tester) async {
      await tester.pumpWidget(buildSubject(score: 9, total: 10));
      await tester.pumpAndSettle();
      expect(find.textContaining('Outstanding'), findsOneWidget);
    });

    testWidgets('shows "Well Done!" for 60–89% score', (tester) async {
      await tester.pumpWidget(buildSubject(score: 7, total: 10));
      await tester.pumpAndSettle();
      expect(find.textContaining('Well Done'), findsOneWidget);
    });

    testWidgets('shows "Keep Practicing!" for <60% score', (tester) async {
      await tester.pumpWidget(buildSubject(score: 3, total: 10));
      await tester.pumpAndSettle();
      expect(find.textContaining('Keep Practicing'), findsOneWidget);
    });

    testWidgets('Back button calls onBack', (tester) async {
      bool backCalled = false;
      await tester
          .pumpWidget(buildSubject(score: 5, total: 10, onBack: () => backCalled = true));
      await tester.pumpAndSettle();
      await tester.tap(find.text('← Back'));
      await tester.pump();
      expect(backCalled, isTrue);
    });

    testWidgets('Retry button calls onRetry', (tester) async {
      bool retryCalled = false;
      await tester.pumpWidget(
          buildSubject(score: 5, total: 10, onRetry: () => retryCalled = true));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Retry 🔄'));
      await tester.pump();
      expect(retryCalled, isTrue);
    });

    testWidgets('shows three star icons', (tester) async {
      await tester.pumpWidget(buildSubject(score: 5, total: 10));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
    });

    testWidgets('shows title text', (tester) async {
      await tester.pumpWidget(
          buildSubject(score: 5, total: 10, title: '🔢 Sequences'));
      await tester.pumpAndSettle();
      expect(find.text('🔢 Sequences'), findsOneWidget);
    });
  });
}
