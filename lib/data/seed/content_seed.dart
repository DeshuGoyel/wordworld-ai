import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

class ContentSeed {
  static final List<String> _activeLetters = [
    'A','B','C','D','E','F','G','H','I','J','K','L','M',
    'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
  ];

  static List<WordData> _allWords = [];

  static Future<void> init() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/words.json');
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      _allWords = jsonList.map((e) => WordData.fromJson(e)).toList();
    } catch (e) {
      print('Error loading words.json: \$e');
      _allWords = [];
    }
  }

  static List<LetterData> getAllLetters() {
    return _activeLetters.map((l) => LetterData(
      letter: l,
      phonetic: _phonetics[l] ?? '',
      phoneticExample: _examples[l] ?? '',
      words: getWordsForLetter(l),
      isActive: true,
    )).toList();
  }

  static List<WordData> getWordsForLetter(String letter) {
    return _allWords.where((w) => w.letter.toUpperCase() == letter.toUpperCase()).toList();
  }

  static List<WordData> getAllActiveWords() {
    return _allWords;
  }

  static WordData? getWordById(String id) {
    for (final w in _allWords) {
      if (w.id == id) return w;
    }
    return null;
  }

  static final Map<String, String> _phonetics = {
    'A': '/æ/', 'B': '/b/', 'C': '/k/', 'D': '/d/',
    'E': '/ɛ/', 'F': '/f/', 'G': '/g/', 'H': '/h/',
    'I': '/ɪ/', 'J': '/dʒ/', 'K': '/k/', 'L': '/l/',
    'M': '/m/', 'N': '/n/', 'O': '/ɒ/', 'P': '/p/',
    'Q': '/kw/', 'R': '/r/', 'S': '/s/', 'T': '/t/',
    'U': '/ʌ/', 'V': '/v/', 'W': '/w/', 'X': '/ks/',
    'Y': '/j/', 'Z': '/z/',
  };

  static final Map<String, String> _examples = {
    'A': 'Apple', 'B': 'Ball', 'C': 'Cat', 'D': 'Dog',
    'E': 'Elephant', 'F': 'Fish', 'G': 'Grapes', 'H': 'Hat',
    'I': 'Ice Cream', 'J': 'Jellyfish', 'K': 'Kite', 'L': 'Lion',
    'M': 'Moon', 'N': 'Nest', 'O': 'Owl', 'P': 'Penguin',
    'Q': 'Queen', 'R': 'Rabbit', 'S': 'Sun', 'T': 'Tiger',
    'U': 'Umbrella', 'V': 'Violin', 'W': 'Whale', 'X': 'Xylophone',
    'Y': 'Yak', 'Z': 'Zebra',
  };
}
