import 'dart:convert';
import '../../../data/models/objectbox.dart';
import 'objectbox_models.dart';

class StoryData {
  final String title;
  final String titleHi;
  final List<StoryScene> scenes;
  final String moralEn;
  final String moralHi;
  final String heroName;
  final String heroEmoji;
  final DateTime createdAt;

  const StoryData({
    required this.title,
    required this.titleHi,
    required this.scenes,
    required this.moralEn,
    required this.moralHi,
    required this.heroName,
    required this.heroEmoji,
    required this.createdAt,
  });

  factory StoryData.fromJson(
      Map<String, dynamic> json,
      {required String heroName,
       required String heroEmoji}) {
    return StoryData(
      title: (json['title'] as String?) 
        ?? '$heroName\'s Adventure',
      titleHi: (json['title_hi'] as String?) 
        ?? '$heroName का कारनामा',
      scenes: ((json['scenes'] as List?) ?? [])
        .map((s) => StoryScene.fromJson(
          s as Map<String, dynamic>))
        .toList(),
      moralEn: (json['moral_en'] as String?) 
        ?? 'Be brave and kind!',
      moralHi: (json['moral_hi'] as String?) 
        ?? 'बहादुर और दयालु बनो!',
      heroName: heroName,
      heroEmoji: heroEmoji,
      createdAt: DateTime.now(),
    );
  }

  // Offline fallback factory:
  factory StoryData.fallback({
    required String heroName,
    required String heroEmoji,
    required String childName,
  }) {
    return StoryData(
      title: '$heroName\'s Big Day',
      titleHi: '$heroName का बड़ा दिन',
      heroName: heroName,
      heroEmoji: heroEmoji,
      createdAt: DateTime.now(),
      moralEn: 'Be brave and try new things!',
      moralHi: 'बहादुर बनो और नई चीज़ें आज़माओ!',
      scenes: [
        StoryScene(
          id: 1,
          textEn: '$heroName woke up happy one morning! '
            '"Today will be a great day!" $heroEmoji said.',
          textHi: '$heroName एक सुबह खुशी से उठा! '
            '"आज बहुत अच्छा दिन होगा!" $heroEmoji ने कहा।',
          emotion: 'happy',
          hasChoice: false,
        ),
        StoryScene(
          id: 2,
          textEn: '$heroName went outside and saw a '
            'little bird that was lost. '
            '"I need help!" said the bird.',
          textHi: '$heroName बाहर गया और एक छोटी '
            'चिड़िया देखी जो खो गई थी। '
            '"मुझे मदद चाहिए!" चिड़िया ने कहा।',
          emotion: 'surprised',
          hasChoice: false,
        ),
        StoryScene(
          id: 3,
          textEn: '"Should I help the bird find '
            'its home?" thought $heroName.',
          textHi: '"क्या मुझे चिड़िया को घर '
            'ढूंढने में मदद करनी चाहिए?" '
            '$heroName ने सोचा।',
          emotion: 'thinking',
          hasChoice: true,
          choice: StoryChoice(
            questionEn: 'What should $heroName do?',
            questionHi: '$heroName को क्या करना चाहिए?',
            optionAEn: 'Help the bird find its home',
            optionAHi: 'चिड़िया को घर ढूंढने में मदद करो',
            optionBEn: 'Continue playing alone',
            optionBHi: 'अकेले खेलते रहो',
          ),
        ),
        StoryScene(
          id: 4,
          textEn: '$heroName helped the little bird! '
            'Together they searched until they '
            'found the bird\'s cozy nest.',
          textHi: '$heroName ने छोटी चिड़िया '
            'की मदद की! मिलकर उन्होंने '
            'चिड़िया का घोंसला ढूंढ लिया।',
          emotion: 'excited',
          hasChoice: false,
        ),
        StoryScene(
          id: 5,
          textEn: '"Thank you, $heroName! '
            'You are my best friend!" '
            'sang the happy bird. $childName '
            'smiled and clapped! 🎉',
          textHi: '"धन्यवाद, $heroName! '
            'तुम मेरे सबसे अच्छे दोस्त हो!" '
            'खुश चिड़िया ने गाया। '
            '$childName ने मुस्कुराकर '
            'ताली बजाई! 🎉',
          emotion: 'proud',
          hasChoice: false,
        ),
      ],
    );
  }

  // Save to ObjectBox:
  StoryEntity toEntity() => StoryEntity()
    ..title = title
    ..titleHi = titleHi
    ..heroName = heroName
    ..moralEn = moralEn
    ..moralHi = moralHi
    ..scenesJson = jsonEncode(
      scenes.map((s) => s.toJson()).toList())
    ..createdAt = createdAt
    ..isShared = false;
}

class StoryScene {
  final int id;
  final String textEn;
  final String textHi;
  final String emotion;
  final bool hasChoice;
  final StoryChoice? choice;

  const StoryScene({
    required this.id,
    required this.textEn,
    required this.textHi,
    required this.emotion,
    required this.hasChoice,
    this.choice,
  });

  factory StoryScene.fromJson(
      Map<String, dynamic> json) {
    return StoryScene(
      id: (json['id'] as int?) ?? 0,
      textEn: (json['text_en'] as String?) ?? '',
      textHi: (json['text_hi'] as String?) ?? '',
      emotion: (json['emotion'] as String?) 
        ?? 'happy',
      hasChoice: (json['has_choice'] as bool?) 
        ?? false,
      choice: json['has_choice'] == true && 
              json['choice'] != null
        ? StoryChoice.fromJson(
            json['choice'] as Map<String, dynamic>)
        : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text_en': textEn,
    'text_hi': textHi,
    'emotion': emotion,
    'has_choice': hasChoice,
    if (choice != null) 
      'choice': choice!.toJson(),
  };

  // Emotion → Gyani reaction emoji:
  String get gyaniEmoji => switch(emotion) {
    'happy'     => '🦉😄',
    'excited'   => '🦉🎉',
    'sad'       => '🦉😢',
    'worried'   => '🦉😟',
    'surprised' => '🦉😮',
    'thinking'  => '🦉🤔',
    'proud'     => '🦉🌟',
    _           => '🦉',
  };
}

class StoryChoice {
  final String questionEn;
  final String questionHi;
  final String optionAEn;
  final String optionAHi;
  final String optionBEn;
  final String optionBHi;

  const StoryChoice({
    required this.questionEn,
    required this.questionHi,
    required this.optionAEn,
    required this.optionAHi,
    required this.optionBEn,
    required this.optionBHi,
  });

  factory StoryChoice.fromJson(
      Map<String, dynamic> json) {
    return StoryChoice(
      questionEn: json['question_en'] ?? '',
      questionHi: json['question_hi'] ?? '',
      optionAEn: json['option_a_en'] ?? '',
      optionAHi: json['option_a_hi'] ?? '',
      optionBEn: json['option_b_en'] ?? '',
      optionBHi: json['option_b_hi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'question_en': questionEn,
    'question_hi': questionHi,
    'option_a_en': optionAEn,
    'option_a_hi': optionAHi,
    'option_b_en': optionBEn,
    'option_b_hi': optionBHi,
  };
}
