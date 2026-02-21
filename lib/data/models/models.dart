// Data Models for LearnVerse

class ChildProfile {
  final String id;
  final String name;
  final int age;
  final String avatarId;
  final String languageMode; // 'en', 'hi', 'en_hi'
  final int totalStars;
  final int streakDays;
  final DateTime? lastActiveDate;
  final Map<String, bool> unlockedAvatarItems;

  ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    this.avatarId = 'avatar_1',
    this.languageMode = 'en_hi',
    this.totalStars = 0,
    this.streakDays = 0,
    this.lastActiveDate,
    this.unlockedAvatarItems = const {},
  });

  int get ageBand => age <= 4 ? 1 : 2; // Band 1: 2-4, Band 2: 5-7

  ChildProfile copyWith({
    String? name,
    int? age,
    String? avatarId,
    String? languageMode,
    int? totalStars,
    int? streakDays,
    DateTime? lastActiveDate,
    Map<String, bool>? unlockedAvatarItems,
  }) {
    return ChildProfile(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      avatarId: avatarId ?? this.avatarId,
      languageMode: languageMode ?? this.languageMode,
      totalStars: totalStars ?? this.totalStars,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      unlockedAvatarItems: unlockedAvatarItems ?? this.unlockedAvatarItems,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'avatarId': avatarId,
    'languageMode': languageMode,
    'totalStars': totalStars,
    'streakDays': streakDays,
    'lastActiveDate': lastActiveDate?.toIso8601String(),
    'unlockedAvatarItems': unlockedAvatarItems,
  };

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    age: json['age'] ?? 4,
    avatarId: json['avatarId'] ?? 'avatar_1',
    languageMode: json['languageMode'] ?? 'en_hi',
    totalStars: json['totalStars'] ?? 0,
    streakDays: json['streakDays'] ?? 0,
    lastActiveDate: json['lastActiveDate'] != null
        ? DateTime.parse(json['lastActiveDate'])
        : null,
    unlockedAvatarItems: Map<String, bool>.from(
      json['unlockedAvatarItems'] ?? {},
    ),
  );
}

class AppUser {
  final String id;
  final String name;
  final String type; // 'parent' or 'teacher'
  final String pin;
  final String? schoolName;
  final String? className;
  final List<String> childIds;

  AppUser({
    required this.id,
    required this.name,
    required this.type,
    required this.pin,
    this.schoolName,
    this.className,
    this.childIds = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'pin': pin,
    'schoolName': schoolName,
    'className': className,
    'childIds': childIds,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    type: json['type'] ?? 'parent',
    pin: json['pin'] ?? '0000',
    schoolName: json['schoolName'],
    className: json['className'],
    childIds: List<String>.from(json['childIds'] ?? []),
  );
}

class LetterData {
  final String letter;
  final String phonetic;
  final String phoneticExample;
  final List<WordData> words;
  final bool isActive;

  LetterData({
    required this.letter,
    required this.phonetic,
    required this.phoneticExample,
    required this.words,
    this.isActive = true,
  });
}

class WordData {
  final String id;
  final String word;
  final String wordHi;
  final String letter;
  final String emoji;
  final String description;
  final String descriptionHi;
  final String category;
  final MeetContent meetContent;
  final List<ThinkGame> thinkGames;
  final WriteContent writeContent;
  final DrawContent drawContent;
  final StoryContent? storyContent;
  final List<TalkLine> talkLines;

  WordData({
    required this.id,
    required this.word,
    required this.wordHi,
    required this.letter,
    required this.emoji,
    required this.description,
    required this.descriptionHi,
    required this.category,
    required this.meetContent,
    required this.thinkGames,
    required this.writeContent,
    required this.drawContent,
    this.storyContent,
    this.talkLines = const [],
  });
}

class MeetContent {
  final List<ScriptLine> linesYoung; // age 2-4
  final List<ScriptLine> linesOlder; // age 5-7

  MeetContent({
    required this.linesYoung,
    required this.linesOlder,
  });
}

class ScriptLine {
  final String speaker; // 'character', 'narrator'
  final String textEn;
  final String textHi;

  ScriptLine({
    required this.speaker,
    required this.textEn,
    required this.textHi,
  });
}

class TalkLine {
  final String textEn;
  final String textHi;
  final String sampleAudioRef;

  TalkLine({
    required this.textEn,
    required this.textHi,
    this.sampleAudioRef = '',
  });
}

class ThinkGame {
  final String id;
  final String type; // 'find', 'match', 'sort', 'memory', 'pattern'
  final String title;
  final String instruction;
  final String instructionHi;
  final int ageMin;
  final int ageMax;
  final Map<String, dynamic> config;

  ThinkGame({
    required this.id,
    required this.type,
    required this.title,
    required this.instruction,
    required this.instructionHi,
    this.ageMin = 2,
    this.ageMax = 7,
    required this.config,
  });
}

class WriteContent {
  final List<String> letters; // letters to trace
  final String word; // word to trace
  final List<StrokeData> letterStrokes;
  final List<StrokeData> wordStrokes;

  WriteContent({
    required this.letters,
    required this.word,
    this.letterStrokes = const [],
    this.wordStrokes = const [],
  });
}

class StrokeData {
  final List<Map<String, double>> points;
  final String direction; // 'down', 'right', 'curve_right', etc.

  StrokeData({
    required this.points,
    required this.direction,
  });
}

class DrawContent {
  final List<DrawStep> steps;
  final String finalDescription;

  DrawContent({
    required this.steps,
    required this.finalDescription,
  });
}

class DrawStep {
  final int stepNumber;
  final String instruction;
  final String instructionHi;
  final String shape; // 'circle', 'oval', 'line', 'curve', 'rectangle'
  final Map<String, double>? position; // relative x,y,width,height

  DrawStep({
    required this.stepNumber,
    required this.instruction,
    required this.instructionHi,
    required this.shape,
    this.position,
  });
}

class StoryContent {
  final String title;
  final String titleHi;
  final List<StoryScene> scenes;
  final String moral;
  final String moralHi;

  StoryContent({
    required this.title,
    required this.titleHi,
    required this.scenes,
    required this.moral,
    required this.moralHi,
  });
}

class StoryScene {
  final int sceneNumber;
  final String textEn;
  final String textHi;
  final String backgroundDesc;
  final List<String> characters;
  final StoryChoice? choice;

  StoryScene({
    required this.sceneNumber,
    required this.textEn,
    required this.textHi,
    required this.backgroundDesc,
    this.characters = const [],
    this.choice,
  });
}

class StoryChoice {
  final String questionEn;
  final String questionHi;
  final String option1En;
  final String option1Hi;
  final String option2En;
  final String option2Hi;
  final int correctOption; // 1 or 2

  StoryChoice({
    required this.questionEn,
    required this.questionHi,
    required this.option1En,
    required this.option1Hi,
    required this.option2En,
    required this.option2Hi,
    this.correctOption = 1,
  });
}

class Activity {
  final String id;
  final String childId;
  final String wordId;
  final String tab; // 'meet', 'think', 'talk', 'write', 'draw', 'story'
  final int score;
  final int durationSeconds;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  Activity({
    required this.id,
    required this.childId,
    required this.wordId,
    required this.tab,
    required this.score,
    required this.durationSeconds,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'childId': childId,
    'wordId': wordId,
    'tab': tab,
    'score': score,
    'durationSeconds': durationSeconds,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json['id'] ?? '',
    childId: json['childId'] ?? '',
    wordId: json['wordId'] ?? '',
    tab: json['tab'] ?? '',
    score: json['score'] ?? 0,
    durationSeconds: json['durationSeconds'] ?? 0,
    timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    metadata: json['metadata'],
  );
}

class WordProgress {
  final String wordId;
  final bool meetCompleted;
  final int thinkStars; // 0-2
  final bool talkCompleted;
  final bool writeCompleted;
  final bool drawCompleted;
  final bool storyCompleted;

  WordProgress({
    required this.wordId,
    this.meetCompleted = false,
    this.thinkStars = 0,
    this.talkCompleted = false,
    this.writeCompleted = false,
    this.drawCompleted = false,
    this.storyCompleted = false,
  });

  int get totalStars {
    int stars = 0;
    if (meetCompleted) stars += 1;
    stars += thinkStars;
    if (talkCompleted) stars += 1;
    if (writeCompleted) stars += 1;
    if (drawCompleted) stars += 1;
    if (storyCompleted) stars += 1;
    return stars;
  }

  int get maxStars => 7; // 1+2+1+1+1+1

  bool get isMastered => totalStars >= 5; // At least 5 out of 7

  WordProgress copyWith({
    bool? meetCompleted,
    int? thinkStars,
    bool? talkCompleted,
    bool? writeCompleted,
    bool? drawCompleted,
    bool? storyCompleted,
  }) {
    return WordProgress(
      wordId: wordId,
      meetCompleted: meetCompleted ?? this.meetCompleted,
      thinkStars: thinkStars ?? this.thinkStars,
      talkCompleted: talkCompleted ?? this.talkCompleted,
      writeCompleted: writeCompleted ?? this.writeCompleted,
      drawCompleted: drawCompleted ?? this.drawCompleted,
      storyCompleted: storyCompleted ?? this.storyCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'wordId': wordId,
    'meetCompleted': meetCompleted,
    'thinkStars': thinkStars,
    'talkCompleted': talkCompleted,
    'writeCompleted': writeCompleted,
    'drawCompleted': drawCompleted,
    'storyCompleted': storyCompleted,
  };

  factory WordProgress.fromJson(Map<String, dynamic> json) => WordProgress(
    wordId: json['wordId'] ?? '',
    meetCompleted: json['meetCompleted'] ?? false,
    thinkStars: json['thinkStars'] ?? 0,
    talkCompleted: json['talkCompleted'] ?? false,
    writeCompleted: json['writeCompleted'] ?? false,
    drawCompleted: json['drawCompleted'] ?? false,
    storyCompleted: json['storyCompleted'] ?? false,
  );
}
