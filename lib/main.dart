import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_app/core/services/objectbox_service.dart';
import 'package:learn_app/core/services/audio_service.dart';
import 'package:learn_app/core/services/tts_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBoxService.init();
  await AudioService.instance.init();
  await TTSService.instance.init();

  runApp(const ProviderScope(child: LearnVerseApp()));
}

