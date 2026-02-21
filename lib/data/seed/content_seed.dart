import '../models/models.dart';
import 'words_a.dart';
import 'words_b.dart';
import 'words_c.dart';
import 'words_d.dart';
import 'words_e.dart';
import 'words_f.dart';
import 'words_g.dart';
import 'words_h.dart';
import 'words_i.dart';
import 'words_j.dart';
import 'words_k.dart';
import 'words_l.dart';
import 'words_m.dart';
import 'words_n.dart';
import 'words_o.dart';
import 'words_p.dart';
import 'words_q.dart';
import 'words_r.dart';
import 'words_s.dart';
import 'words_t.dart';
import 'words_u.dart';
import 'words_v.dart';
import 'words_w.dart';
import 'words_x.dart';
import 'words_y.dart';
import 'words_z.dart';

class ContentSeed {
  static final List<String> _activeLetters = [
    'A','B','C','D','E','F','G','H','I','J','K','L','M',
    'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
  ];

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
    switch (letter) {
      case 'A': return WordsA.words;
      case 'B': return WordsB.words;
      case 'C': return WordsC.words;
      case 'D': return WordsD.words;
      case 'E': return WordsE.words;
      case 'F': return WordsF.words;
      case 'G': return WordsG.words;
      case 'H': return WordsH.words;
      case 'I': return WordsI.words;
      case 'J': return WordsJ.words;
      case 'K': return WordsK.words;
      case 'L': return WordsL.words;
      case 'M': return WordsM.words;
      case 'N': return WordsN.words;
      case 'O': return WordsO.words;
      case 'P': return WordsP.words;
      case 'Q': return WordsQ.words;
      case 'R': return WordsR.words;
      case 'S': return WordsS.words;
      case 'T': return WordsT.words;
      case 'U': return WordsU.words;
      case 'V': return WordsV.words;
      case 'W': return WordsW.words;
      case 'X': return WordsX.words;
      case 'Y': return WordsY.words;
      case 'Z': return WordsZ.words;
      default: return [];
    }
  }

  static List<WordData> getAllActiveWords() {
    final words = <WordData>[];
    for (final l in _activeLetters) {
      words.addAll(getWordsForLetter(l));
    }
    return words;
  }

  static WordData? getWordById(String id) {
    for (final w in getAllActiveWords()) {
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
