import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/models.dart';
import '../../data/seed/content_seed.dart';
import 'storage_service.dart';

final tutorBrainProvider = Provider<TutorBrainService>((ref) {
  return TutorBrainService(ref.read(storageServiceProvider));
});

class TutorBrainService {
  final StorageService _storage;

  TutorBrainService(this._storage);

  /// Suggest "Today's Word" based on incomplete progress + variety
  WordData suggestTodaysWord(String childId) {
    final allWords = ContentSeed.getAllActiveWords();
    final progressMap = _storage.getAllWordProgress(childId);

    // First: find words that haven't been started
    final unstarted = allWords.where((w) {
      final wp = progressMap[w.id];
      return wp == null || wp.totalStars == 0;
    }).toList();

    if (unstarted.isNotEmpty) {
      unstarted.shuffle();
      return unstarted.first;
    }

    // Second: find words that are in progress but not mastered
    final inProgress = allWords.where((w) {
      final wp = progressMap[w.id];
      return wp != null && !wp.isMastered;
    }).toList();

    if (inProgress.isNotEmpty) {
      inProgress.shuffle();
      return inProgress.first;
    }

    // All mastered: return random
    allWords.shuffle();
    return allWords.first;
  }

  /// Suggest weak area tab
  String suggestWeakTab(String childId) {
    final allProgress = _storage.getAllWordProgress(childId);
    if (allProgress.isEmpty) return 'meet';

    int meetMissing = 0, thinkMissing = 0, talkMissing = 0;
    int writeMissing = 0, drawMissing = 0;

    for (final wp in allProgress.values) {
      if (!wp.meetCompleted) meetMissing++;
      if (wp.thinkStars < 2) thinkMissing++;
      if (!wp.talkCompleted) talkMissing++;
      if (!wp.writeCompleted) writeMissing++;
      if (!wp.drawCompleted) drawMissing++;
    }

    final weaknesses = {
      'meet': meetMissing,
      'think': thinkMissing,
      'talk': talkMissing,
      'write': writeMissing,
      'draw': drawMissing,
    };

    final sorted = weaknesses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }

  /// Get weak areas as list of strings for dashboard display
  List<String> getWeakAreas(String childId) {
    final allProgress = _storage.getAllWordProgress(childId);
    if (allProgress.isEmpty) return [];

    int meetMissing = 0, thinkMissing = 0, talkMissing = 0;
    int writeMissing = 0, drawMissing = 0;
    int total = allProgress.length;

    for (final wp in allProgress.values) {
      if (!wp.meetCompleted) meetMissing++;
      if (wp.thinkStars < 2) thinkMissing++;
      if (!wp.talkCompleted) talkMissing++;
      if (!wp.writeCompleted) writeMissing++;
      if (!wp.drawCompleted) drawMissing++;
    }

    final areas = <String>[];
    if (meetMissing > total * 0.5) areas.add('Listening');
    if (thinkMissing > total * 0.5) areas.add('Thinking');
    if (talkMissing > total * 0.5) areas.add('Speaking');
    if (writeMissing > total * 0.5) areas.add('Writing');
    if (drawMissing > total * 0.5) areas.add('Drawing');
    return areas;
  }
}
