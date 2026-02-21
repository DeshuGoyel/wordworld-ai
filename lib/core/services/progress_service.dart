import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/models.dart';
import '../../data/seed/content_seed.dart';
import 'storage_service.dart';

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService(ref.read(storageServiceProvider));
});

class ProgressService {
  final StorageService _storage;

  ProgressService(this._storage);

  WordProgress getProgress(String childId, String wordId) {
    return _storage.getWordProgress(childId, wordId) ??
        WordProgress(wordId: wordId);
  }

  Future<void> completeTab(String childId, String wordId, String tab) async {
    var progress = getProgress(childId, wordId);

    switch (tab) {
      case 'meet':
        progress = progress.copyWith(meetCompleted: true);
        break;
      case 'think':
        progress = progress.copyWith(
          thinkStars: (progress.thinkStars + 1).clamp(0, 2),
        );
        break;
      case 'talk':
        progress = progress.copyWith(talkCompleted: true);
        break;
      case 'write':
        progress = progress.copyWith(writeCompleted: true);
        break;
      case 'draw':
        progress = progress.copyWith(drawCompleted: true);
        break;
      case 'story':
        progress = progress.copyWith(storyCompleted: true);
        break;
    }

    await _storage.saveWordProgress(childId, progress);
    await _updateChildStars(childId);
  }

  Future<void> _updateChildStars(String childId) async {
    final allProgress = _storage.getAllWordProgress(childId);
    int totalStars = 0;
    for (final wp in allProgress.values) {
      totalStars += wp.totalStars;
    }

    final child = _storage.getChild(childId);
    if (child != null) {
      await _storage.saveChild(child.copyWith(totalStars: totalStars));
    }
  }

  int getTotalStars(String childId) {
    final allProgress = _storage.getAllWordProgress(childId);
    int total = 0;
    for (final wp in allProgress.values) {
      total += wp.totalStars;
    }
    return total;
  }

  int getLetterStars(String childId, String letter) {
    final words = ContentSeed.getWordsForLetter(letter);
    int total = 0;
    for (final word in words) {
      final wp = getProgress(childId, word.id);
      total += wp.totalStars;
    }
    return total;
  }

  bool isLetterMastered(String childId, String letter) {
    final words = ContentSeed.getWordsForLetter(letter);
    return words.every((w) => getProgress(childId, w.id).isMastered);
  }

  int getMasteredWordsCount(String childId) {
    final allProgress = _storage.getAllWordProgress(childId);
    return allProgress.values.where((wp) => wp.isMastered).length;
  }

  int getMasteredLettersCount(String childId) {
    int count = 0;
    for (int i = 0; i < 26; i++) {
      final letter = String.fromCharCode(65 + i);
      if (isLetterMastered(childId, letter)) count++;
    }
    return count;
  }

  Map<String, double> getSkillsBreakdown(String childId) {
    final allProgress = _storage.getAllWordProgress(childId);
    if (allProgress.isEmpty) {
      return {
        'listen': 0.0, 'think': 0.0, 'speak': 0.0,
        'write': 0.0, 'draw': 0.0,
      };
    }

    int meetTotal = 0, thinkTotal = 0, talkTotal = 0;
    int writeTotal = 0, drawTotal = 0;
    int count = allProgress.length;

    for (final wp in allProgress.values) {
      meetTotal += wp.meetCompleted ? 1 : 0;
      thinkTotal += wp.thinkStars;
      talkTotal += wp.talkCompleted ? 1 : 0;
      writeTotal += wp.writeCompleted ? 1 : 0;
      drawTotal += wp.drawCompleted ? 1 : 0;
    }

    return {
      'listen': (meetTotal / count).clamp(0.0, 1.0),
      'think': (thinkTotal / (count * 2)).clamp(0.0, 1.0),
      'speak': (talkTotal / count).clamp(0.0, 1.0),
      'write': (writeTotal / count).clamp(0.0, 1.0),
      'draw': (drawTotal / count).clamp(0.0, 1.0),
    };
  }

  int getWordsLearnedForLetter(String childId, String letter) {
    final words = ContentSeed.getWordsForLetter(letter);
    int count = 0;
    for (final word in words) {
      final wp = getProgress(childId, word.id);
      if (wp.totalStars >= 3) count++;
    }
    return count;
  }

  bool isStoryUnlocked(String childId, String letter) {
    return getWordsLearnedForLetter(childId, letter) >= 2;
  }
}
