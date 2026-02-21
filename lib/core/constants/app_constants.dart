class AppConstants {
  // App info
  static const String appName = 'LearnVerse';
  static const String appVersion = '1.0.0';

  // Age bands
  static const int minAge = 2;
  static const int maxAge = 7;
  static const int talkTabMinAge = 5;

  // Content
  static const int wordsPerLetter = 4;
  static const int activeLetterCount = 26; // A-Z
  static const int totalLetters = 26;
  static const int storyUnlockWordCount = 2;

  // Rewards
  static const int starsForHat = 10;
  static const int starsForBackground = 20;
  static const int starsForSpecial = 50;
  static const int starsForCrown = 100;

  // Session
  static const int defaultSessionMinutes = 30;
  static const int minSessionMinutes = 10;
  static const int maxSessionMinutes = 60;

  // Stars per tab
  static const int meetStars = 1;
  static const int thinkStarsMax = 2;
  static const int talkStars = 1;
  static const int writeStars = 1;
  static const int drawStars = 1;
  static const int storyStars = 1;

  // Talk tab
  static const double talkPassThreshold = 0.6;

  // Active letters (full A-Z)
  static const List<String> activeLetters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z',
  ];

  static const List<String> allLetters = activeLetters;

  // Phonetics
  static const Map<String, String> letterPhonetics = {
    'A': '/æ/ as in Apple', 'B': '/b/ as in Ball',
    'C': '/k/ as in Cat', 'D': '/d/ as in Dog',
    'E': '/ɛ/ as in Elephant', 'F': '/f/ as in Fish',
    'G': '/g/ as in Grapes', 'H': '/h/ as in Hat',
    'I': '/ɪ/ as in Ice Cream', 'J': '/dʒ/ as in Jellyfish',
    'K': '/k/ as in Kite', 'L': '/l/ as in Lion',
    'M': '/m/ as in Moon', 'N': '/n/ as in Nest',
    'O': '/ɒ/ as in Owl', 'P': '/p/ as in Penguin',
    'Q': '/kw/ as in Queen', 'R': '/r/ as in Rabbit',
    'S': '/s/ as in Sun', 'T': '/t/ as in Tiger',
    'U': '/ʌ/ as in Umbrella', 'V': '/v/ as in Violin',
    'W': '/w/ as in Whale', 'X': '/ks/ as in Xylophone',
    'Y': '/j/ as in Yak', 'Z': '/z/ as in Zebra',
  };

  // Emojis for tabs
  static const String meetEmoji = '🎬';
  static const String thinkEmoji = '🧠';
  static const String talkEmoji = '🎤';
  static const String writeEmoji = '✍️';
  static const String drawEmoji = '🎨';
  static const String storyEmoji = '📖';
}
