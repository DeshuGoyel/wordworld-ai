import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters
  await _initHive();

  runApp(const ProviderScope(child: LearnVerseApp()));
}

Future<void> _initHive() async {
  await Hive.openBox('app_settings');
  await Hive.openBox('child_profiles');
  await Hive.openBox('activities');
  await Hive.openBox('progress');
  await Hive.openBox('user_data');
}
