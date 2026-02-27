import 'dart:convert';
import 'dart:io';

import 'package:learn_app/data/seed/content_seed.dart';
import 'package:learn_app/data/models/models.dart';

Map<String, dynamic> scriptLineToJson(ScriptLine line) => {
  'speaker': line.speaker,
  'textEn': line.textEn,
  'textHi': line.textHi,
};

Map<String, dynamic> meetContentToJson(MeetContent content) => {
  'linesYoung': content.linesYoung.map(scriptLineToJson).toList(),
  'linesOlder': content.linesOlder.map(scriptLineToJson).toList(),
};

Map<String, dynamic> thinkGameToJson(ThinkGame game) => {
  'id': game.id,
  'type': game.type,
  'title': game.title,
  'instruction': game.instruction,
  'instructionHi': game.instructionHi,
  'ageMin': game.ageMin,
  'ageMax': game.ageMax,
  'config': game.config,
};

Map<String, dynamic> talkLineToJson(TalkLine line) => {
  'textEn': line.textEn,
  'textHi': line.textHi,
  'sampleAudioRef': line.sampleAudioRef,
};

Map<String, dynamic> strokeDataToJson(StrokeData stroke) => {
  'points': stroke.points,
  'direction': stroke.direction,
};

Map<String, dynamic> writeContentToJson(WriteContent content) => {
  'letters': content.letters,
  'word': content.word,
  'letterStrokes': content.letterStrokes.map(strokeDataToJson).toList(),
  'wordStrokes': content.wordStrokes.map(strokeDataToJson).toList(),
};

Map<String, dynamic> drawStepToJson(DrawStep step) => {
  'stepNumber': step.stepNumber,
  'instruction': step.instruction,
  'instructionHi': step.instructionHi,
  'shape': step.shape,
  'position': step.position,
};

Map<String, dynamic> drawContentToJson(DrawContent content) => {
  'steps': content.steps.map(drawStepToJson).toList(),
  'finalDescription': content.finalDescription,
};

Map<String, dynamic> storyChoiceToJson(StoryChoice choice) => {
  'questionEn': choice.questionEn,
  'questionHi': choice.questionHi,
  'option1En': choice.option1En,
  'option1Hi': choice.option1Hi,
  'option2En': choice.option2En,
  'option2Hi': choice.option2Hi,
  'correctOption': choice.correctOption,
};

Map<String, dynamic> storySceneToJson(StoryScene scene) => {
  'sceneNumber': scene.sceneNumber,
  'textEn': scene.textEn,
  'textHi': scene.textHi,
  'backgroundDesc': scene.backgroundDesc,
  'characters': scene.characters,
  'choice': scene.choice != null ? storyChoiceToJson(scene.choice!) : null,
};

Map<String, dynamic> storyContentToJson(StoryContent content) => {
  'title': content.title,
  'titleHi': content.titleHi,
  'scenes': content.scenes.map(storySceneToJson).toList(),
  'moral': content.moral,
  'moralHi': content.moralHi,
};

Map<String, dynamic> wordDataToJson(WordData word) => {
  'id': word.id,
  'word': word.word,
  'wordHi': word.wordHi,
  'letter': word.letter,
  'emoji': word.emoji,
  'description': word.description,
  'descriptionHi': word.descriptionHi,
  'category': word.category,
  'meetContent': meetContentToJson(word.meetContent),
  'thinkGames': word.thinkGames.map(thinkGameToJson).toList(),
  'writeContent': writeContentToJson(word.writeContent),
  'drawContent': drawContentToJson(word.drawContent),
  'storyContent': word.storyContent != null ? storyContentToJson(word.storyContent!) : null,
  'talkLines': word.talkLines.map(talkLineToJson).toList(),
};

void main() async {
  final List<WordData> allWords = ContentSeed.getAllActiveWords();
  final List<Map<String, dynamic>> jsonList = allWords.map(wordDataToJson).toList();
  
  final jsonString = JsonEncoder.withIndent('  ').convert(jsonList);
  
  final file = File('assets/data/words.json');
  if (!await file.parent.exists()) {
    await file.parent.create(recursive: true);
  }
  await file.writeAsString(jsonString);
  print('Successfully wrote ${allWords.length} words to assets/data/words.json!');
}
