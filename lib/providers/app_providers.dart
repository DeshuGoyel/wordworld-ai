import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/models.dart';
import '../core/services/storage_service.dart';
import '../core/services/ai_service.dart';
import '../core/services/progress_service.dart';
import '../core/services/image_gen_service.dart';
import '../core/services/image_animate_service.dart';
import '../core/services/vision_service.dart';
import '../core/services/stt_service.dart';
import '../core/services/voice_gen_service.dart';
import '../core/services/video_gen_service.dart';
import '../core/services/video_analysis_service.dart';
import '../core/services/fast_ai_service.dart';
import '../core/services/tutor_brain_service.dart';
import 'package:learn_app/core/services/audio_service.dart';

// ─── AI Service Providers ───

final aiServiceProvider = Provider<AIService>((ref) {
  final storage = ref.read(storageServiceProvider);
  final service = AIService(storage: storage);
  service.initFromSettings();
  return service;
});

final imageGenServiceProvider = Provider<ImageGenService>((ref) {
  return ImageGenService(ref.read(aiServiceProvider));
});

final imageAnimateServiceProvider = Provider<ImageAnimateService>((ref) {
  return ImageAnimateService(ref.read(aiServiceProvider));
});

final visionServiceProvider = Provider<VisionService>((ref) {
  return VisionService(ref.read(aiServiceProvider));
});

final sttServiceProvider = Provider<SttService>((ref) {
  return SttService(ref.read(aiServiceProvider));
});

final voiceGenServiceProvider = Provider<VoiceGenService>((ref) {
  return VoiceGenService(ref.read(aiServiceProvider));
});

final videoGenServiceProvider = Provider<VideoGenService>((ref) {
  return VideoGenService(ref.read(aiServiceProvider));
});

final videoAnalysisServiceProvider = Provider<VideoAnalysisService>((ref) {
  return VideoAnalysisService(ref.read(aiServiceProvider));
});

final fastAIServiceProvider = Provider<FastAIService>((ref) {
  return FastAIService(ref.read(aiServiceProvider));
});

final tutorBrainProvider = Provider<TutorBrainService>((ref) {
  return TutorBrainService(
    ref.read(storageServiceProvider),
    ref.read(progressServiceProvider),
    ref.read(aiServiceProvider),
  );
});

// ─── Existing App Providers ───

// Active child provider
final activeChildProvider = StateNotifierProvider<ActiveChildNotifier, ChildProfile?>((ref) {
  return ActiveChildNotifier(ref.read(storageServiceProvider));
});

class ActiveChildNotifier extends StateNotifier<ChildProfile?> {
  final StorageService _storage;
  ActiveChildNotifier(this._storage) : super(null) {
    _load();
  }

  void _load() {
    final id = _storage.getActiveChildId();
    if (id != null) state = _storage.getChild(id);
  }

  Future<void> setActiveChild(String childId) async {
    await _storage.setActiveChildId(childId);
    state = _storage.getChild(childId);
  }

  Future<void> updateChild(ChildProfile child) async {
    await _storage.saveChild(child);
    if (state?.id == child.id) state = child;
  }

  void refresh() => _load();
}

// All children provider
final allChildrenProvider = Provider<List<ChildProfile>>((ref) {
  ref.watch(activeChildProvider);
  return ref.read(storageServiceProvider).getAllChildren();
});

// Onboarding state
final onboardingCompleteProvider = Provider<bool>((ref) {
  return ref.read(storageServiceProvider).isOnboarded();
});

// Language provider
final languageProvider = StateProvider<String>((ref) {
  return ref.read(storageServiceProvider).getLanguage() ?? 'en_hi';
});

// User type provider
final userTypeProvider = StateProvider<String>((ref) {
  return ref.read(storageServiceProvider).getUserType() ?? '';
});

