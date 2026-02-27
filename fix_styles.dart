import 'dart:io';

void main() {
  final files = [
    'lib/features/story_generator/story_generator_screen.dart',
    'lib/features/story_generator/story_player_screen.dart',
    'lib/features/kid/word_world/story/story_tab.dart',
  ];

  for (var path in files) {
    final file = File(path);
    if (!file.existsSync()) continue;
    String content = file.readAsStringSync();

    // WordCard3D onTap
    content = content.replaceAll('onTap: () {},', '');
    
    // progressProvider
    content = content.replaceAll('progressServiceProvider', 'progressProvider');

    // AppTextStyles -> AppFonts
    content = content.replaceAll("AppTextStyles.heading1", "AppFonts.headingStyle(size: 32)");
    content = content.replaceAll("AppTextStyles.heading1.copyWith(fontSize: 24)", "AppFonts.headingStyle(size: 24)");
    content = content.replaceAll("AppTextStyles.heading2", "AppFonts.headingStyle(size: 24)");
    content = content.replaceAll("AppTextStyles.heading2.copyWith(color: AppColors.primary)", "AppFonts.headingStyle(size: 24, color: AppColors.primary)");
    content = content.replaceAll("AppTextStyles.heading3", "AppFonts.headingStyle(size: 20)");
    content = content.replaceAll("AppTextStyles.heading3.copyWith(color: AppColors.textMedium)", "AppFonts.headingStyle(size: 20, color: AppColors.textMedium)");
    content = content.replaceAll("AppTextStyles.heading3.copyWith(color: AppColors.success, fontSize: 14)", "AppFonts.headingStyle(size: 14, color: AppColors.success)");
    
    content = content.replaceAll("AppTextStyles.body1", "AppFonts.bodyStyle(size: 16)");
    content = content.replaceAll("AppTextStyles.body1.copyWith(fontSize: 18)", "AppFonts.bodyStyle(size: 18)");
    content = content.replaceAll("AppTextStyles.body1.copyWith(", "AppFonts.bodyStyle(");
    
    content = content.replaceAll("AppTextStyles.body2", "AppFonts.bodyStyle(size: 14)");
    content = content.replaceAll("AppTextStyles.body2.copyWith(", "AppFonts.bodyStyle(");
    
    content = content.replaceAll("AppTextStyles.kidHindi", "AppFonts.bodyStyle(size: 16)");
    content = content.replaceAll("AppTextStyles.kidHindi.copyWith(color: AppColors.textMedium, fontSize: 16)", "AppFonts.bodyStyle(size: 16, color: AppColors.textMedium)");
    content = content.replaceAll("AppTextStyles.kidHindi.copyWith(color: AppColors.textMedium)", "AppFonts.bodyStyle(size: 16, color: AppColors.textMedium)");

    // PrimaryButton3D fixes
    content = content.replaceAll("fontSize: 14,", "");
    content = content.replaceAll("color: AppColors.secondary,", "solidColor: AppColors.secondary,");

    // StoryScene ambiguous import
    if (path.contains('story_player_screen.dart')) {
        content = content.replaceAll(
          "import '../../../../data/models/models.dart';", 
          "import '../../../../data/models/models.dart' hide StoryScene;");
          
        content = content.replaceAll("TTSService.instance.speakAsGyani", "TTSService.instance.speak");
    }

    file.writeAsStringSync(content);
  }
  print("Fixed styles.");
}
