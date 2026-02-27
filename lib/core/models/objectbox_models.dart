import 'package:objectbox/objectbox.dart';

@Entity()
class ChildEntity {
  @Id()
  int id = 0;
  
  late String name;
  late String avatarEmoji;
  late String ageBandStr;
  late int xp;
  late int level;
  late int streakDays;
  @Property(type: PropertyType.date)
  late DateTime? lastSessionDate;
  late int hearts;
  @Property(type: PropertyType.date)
  late DateTime? heartsLastRefill;
  late bool isPremium;
  @Property(type: PropertyType.date)
  late DateTime? premiumExpiry;
  late String languageMode;
  late String selectedAvatar;
  
  final wordProgress = ToMany<WordProgressEntity>();
  final activityLog = ToMany<ActivityLogEntity>();
  final achievements = ToMany<AchievementEntity>();
  final stories = ToMany<StoryEntity>();
}

@Entity()
class WordProgressEntity {
  @Id()
  int id = 0;
  
  late String wordId;
  late bool meetComplete;
  late bool thinkComplete;
  late bool talkComplete;
  late bool writeComplete;
  late bool drawComplete;
  late bool storyComplete;
  
  late int thinkScore;
  late int talkScore;
  late int talkClarity;
  late int talkAccuracy;
  late int talkFluency;
  late int writeScore;
  late int drawScore;
  
  late int starsEarned;
  late int totalXpEarned;
  late int attemptCount;
  @Property(type: PropertyType.date)
  late DateTime lastAttempt;
  
  bool get isMastered => starsEarned >= 3;
}

@Entity()
class ActivityLogEntity {
  @Id()
  int id = 0;
  
  late String wordId;
  late String tabName;
  late int score;
  late int xpEarned;
  late int durationSeconds;
  @Property(type: PropertyType.date)
  late DateTime timestamp;
}

@Entity()
class StoryEntity {
  @Id()
  int id = 0;
  
  late String title;
  late String titleHi;
  late String heroName;
  late String setting;
  late String problem;
  late String scenesJson;
  late String moralEn;
  late String moralHi;
  @Property(type: PropertyType.date)
  late DateTime createdAt;
  late bool isShared;
}

@Entity()
class AchievementEntity {
  @Id()
  int id = 0;
  
  late String achievementId;
  @Property(type: PropertyType.date)
  late DateTime unlockedAt;
}
