import 'package:learn_app/objectbox.g.dart';
import 'package:learn_app/core/models/objectbox_models.dart';

class ObjectBoxService {
  static late final Store store;
  static late final Box<ChildEntity> childBox;
  static late final Box<WordProgressEntity> progressBox;
  static late final Box<ActivityLogEntity> activityBox;
  static late final Box<StoryEntity> storyBox;
  static late final Box<AchievementEntity> achievementBox;
  
  static Future<void> init() async {
    store = await openStore();
    childBox = store.box<ChildEntity>();
    progressBox = store.box<WordProgressEntity>();
    activityBox = store.box<ActivityLogEntity>();
    storyBox = store.box<StoryEntity>();
    achievementBox = store.box<AchievementEntity>();
  }
  
  static void dispose() => store.close();
}
