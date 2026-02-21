import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/onboarding/login_screen.dart';
import '../../features/onboarding/signup_screen.dart';
import '../../features/onboarding/child_setup_screen.dart';
import '../../features/onboarding/language_select_screen.dart';
import '../../features/onboarding/user_type_screen.dart';
import '../../features/onboarding/parent_onboarding_screen.dart';
import '../../features/onboarding/teacher_onboarding_screen.dart';
import '../../features/kid/home/kid_home_screen.dart';
import '../../features/kid/letter_world/letter_world_screen.dart';
import '../../features/kid/word_world/word_world_screen.dart';
import '../../features/kid/rewards/rewards_screen.dart';
import '../../features/kid/subject_world/subject_world_screen.dart';
import '../../features/kid/language/grammar/grammar_world_screen.dart';
import '../../features/kid/language/grammar/noun_module.dart';
import '../../features/kid/language/grammar/verb_module.dart';
import '../../features/kid/language/grammar/adjective_module.dart';
import '../../features/kid/language/grammar/sentence_builder_screen.dart';
import '../../features/kid/language/grammar/fill_blank_screen.dart';
import '../../features/kid/math/math_world_screen.dart';
import '../../features/kid/evs/evs_world_screen.dart';
import '../../features/kid/values/values_world_screen.dart';
import '../../features/kid/story/ai_story_generator_screen.dart';
import '../../features/parent/dashboard/parent_dashboard_screen.dart';
import '../../features/parent/settings/parent_settings_screen.dart';
import '../../features/parent/print_center/print_center_screen.dart';
import '../../features/teacher/dashboard/teacher_dashboard_screen.dart';
import '../../features/teacher/class_tools/class_tools_screen.dart';
import '../../features/kid/chatbot/ask_buddy_screen.dart';
import '../../features/parent/settings/ai_settings_screen.dart';
import '../../features/membership/membership_screen.dart';
import '../../features/kid/exercises/exercise_hub_screen.dart';
import '../../features/kid/exercises/exercise_player_screen.dart';
import '../../features/kid/language/phonics/phonics_screen.dart';
import '../../features/kid/language/sight_words/sight_words_screen.dart';
import '../../features/kid/language/reading/reading_screen.dart';
import '../../features/kid/language/writing/story_writing_screen.dart';
import '../../features/kid/coding/coding_world_screen.dart';
import '../../features/kid/art/art_world_screen.dart';
import '../../features/kid/math/advanced_math_screen.dart';
import '../../features/kid/evs/advanced_evs_screen.dart';
import '../../features/kid/activities/physical_activity_screen.dart';
import '../../features/kid/shared/lesson_card_screen.dart';
import '../../features/kid/social/leaderboard_screen.dart';

/// Custom slide+fade page transition (300ms)
CustomTransitionPage<void> _buildPage(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.05, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
      );
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      // ═══════════ ONBOARDING ═══════════
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => _buildPage(const SplashScreen(), state),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        pageBuilder: (context, state) => _buildPage(const WelcomeScreen(), state),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => _buildPage(const LoginScreen(), state),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder: (context, state) => _buildPage(const SignupScreen(), state),
      ),
      GoRoute(
        path: '/child-setup',
        name: 'child-setup',
        pageBuilder: (context, state) => _buildPage(const ChildSetupScreen(), state),
      ),
      GoRoute(
        path: '/language-select',
        name: 'language-select',
        pageBuilder: (context, state) => _buildPage(const LanguageSelectScreen(), state),
      ),
      GoRoute(
        path: '/user-type',
        name: 'user-type',
        pageBuilder: (context, state) => _buildPage(const UserTypeScreen(), state),
      ),
      GoRoute(
        path: '/parent-onboarding',
        name: 'parent-onboarding',
        pageBuilder: (context, state) => _buildPage(const ParentOnboardingScreen(), state),
      ),
      GoRoute(
        path: '/teacher-onboarding',
        name: 'teacher-onboarding',
        pageBuilder: (context, state) => _buildPage(const TeacherOnboardingScreen(), state),
      ),

      // ═══════════ KID MODE ═══════════
      GoRoute(
        path: '/kid-home',
        name: 'kid-home',
        pageBuilder: (context, state) => _buildPage(const KidHomeScreen(), state),
      ),
      GoRoute(
        path: '/letter/:letter',
        name: 'letter-world',
        pageBuilder: (context, state) {
          final letter = state.pathParameters['letter'] ?? 'A';
          return _buildPage(LetterWorldScreen(letter: letter), state);
        },
      ),
      GoRoute(
        path: '/word/:wordId',
        name: 'word-world',
        pageBuilder: (context, state) {
          final wordId = state.pathParameters['wordId'] ?? '';
          return _buildPage(WordWorldScreen(wordId: wordId), state);
        },
      ),
      GoRoute(
        path: '/rewards',
        name: 'rewards',
        pageBuilder: (context, state) => _buildPage(const RewardsScreen(), state),
      ),

      // ═══════════ SUBJECT WORLDS ═══════════
      GoRoute(
        path: '/subject/:subjectId',
        name: 'subject-world',
        pageBuilder: (context, state) {
          final subjectId = state.pathParameters['subjectId'] ?? 'language';
          return _buildPage(SubjectWorldScreen(subjectId: subjectId), state);
        },
      ),

      // ═══════════ GRAMMAR ═══════════
      GoRoute(
        path: '/grammar',
        name: 'grammar',
        pageBuilder: (context, state) => _buildPage(const GrammarWorldScreen(), state),
      ),
      GoRoute(
        path: '/grammar/nouns',
        name: 'grammar-nouns',
        pageBuilder: (context, state) => _buildPage(const NounModuleScreen(), state),
      ),
      GoRoute(
        path: '/grammar/verbs',
        name: 'grammar-verbs',
        pageBuilder: (context, state) => _buildPage(const VerbModuleScreen(), state),
      ),
      GoRoute(
        path: '/grammar/adjectives',
        name: 'grammar-adjectives',
        pageBuilder: (context, state) => _buildPage(const AdjectiveModuleScreen(), state),
      ),
      GoRoute(
        path: '/grammar/prepositions',
        name: 'grammar-prepositions',
        pageBuilder: (context, state) => _buildPage(const NounModuleScreen(), state), // Reuse noun for now
      ),
      GoRoute(
        path: '/grammar/pronouns',
        name: 'grammar-pronouns',
        pageBuilder: (context, state) => _buildPage(const NounModuleScreen(), state), // Reuse noun for now
      ),
      GoRoute(
        path: '/grammar/sentences',
        name: 'grammar-sentences',
        pageBuilder: (context, state) => _buildPage(const SentenceBuilderScreen(), state),
      ),
      GoRoute(
        path: '/grammar/fill-blank',
        name: 'grammar-fill-blank',
        pageBuilder: (context, state) => _buildPage(const FillBlankScreen(), state),
      ),

      // ═══════════ MATH ═══════════
      GoRoute(
        path: '/math',
        name: 'math-world',
        pageBuilder: (context, state) => _buildPage(const MathWorldScreen(), state),
      ),

      // ═══════════ EVS ═══════════
      GoRoute(
        path: '/evs',
        name: 'evs-world',
        pageBuilder: (context, state) => _buildPage(const EVSWorldScreen(), state),
      ),

      // ═══════════ VALUES ═══════════
      GoRoute(
        path: '/values',
        name: 'values-world',
        pageBuilder: (context, state) => _buildPage(const ValuesWorldScreen(), state),
      ),

      // ═══════════ AI STORY ═══════════
      GoRoute(
        path: '/ai-story',
        name: 'ai-story',
        pageBuilder: (context, state) => _buildPage(const AIStoryGeneratorScreen(), state),
      ),

      // ═══════════ PARENT MODE ═══════════
      GoRoute(
        path: '/parent-dashboard',
        name: 'parent-dashboard',
        pageBuilder: (context, state) => _buildPage(const ParentDashboardScreen(), state),
      ),
      GoRoute(
        path: '/parent-settings',
        name: 'parent-settings',
        pageBuilder: (context, state) => _buildPage(const ParentSettingsScreen(), state),
      ),
      GoRoute(
        path: '/print-center',
        name: 'print-center',
        pageBuilder: (context, state) => _buildPage(const PrintCenterScreen(), state),
      ),

      // ═══════════ TEACHER MODE ═══════════
      GoRoute(
        path: '/teacher-dashboard',
        name: 'teacher-dashboard',
        pageBuilder: (context, state) => _buildPage(const TeacherDashboardScreen(), state),
      ),
      GoRoute(
        path: '/class-tools',
        name: 'class-tools',
        pageBuilder: (context, state) => _buildPage(const ClassToolsScreen(), state),
      ),

      // ═══════════ AI FEATURES ═══════════
      GoRoute(
        path: '/ask-buddy',
        name: 'ask-buddy',
        pageBuilder: (context, state) => _buildPage(const AskBuddyScreen(), state),
      ),
      GoRoute(
        path: '/ai-settings',
        name: 'ai-settings',
        pageBuilder: (context, state) => _buildPage(const AISettingsScreen(), state),
      ),

      // ═══════════ MEMBERSHIP ═══════════
      GoRoute(
        path: '/membership',
        name: 'membership',
        pageBuilder: (context, state) => _buildPage(const MembershipScreen(), state),
      ),

      // ═══════════ EXERCISES ═══════════
      GoRoute(
        path: '/exercise-hub/:subject',
        name: 'exercise-hub',
        pageBuilder: (context, state) {
          final subject = state.pathParameters['subject'] ?? 'grammar';
          return _buildPage(ExerciseHubScreen(subject: subject), state);
        },
      ),
      GoRoute(
        path: '/exercises/:subject/:topic',
        name: 'exercise-player',
        pageBuilder: (context, state) {
          final subject = state.pathParameters['subject'] ?? 'grammar';
          final topic = state.pathParameters['topic'] ?? 'nouns';
          return _buildPage(ExercisePlayerScreen(subject: subject, topic: topic), state);
        },
      ),

      // ═══════════ V2 — LANGUAGE ═══════════
      GoRoute(
        path: '/phonics',
        name: 'phonics',
        pageBuilder: (context, state) => _buildPage(const PhonicsScreen(), state),
      ),
      GoRoute(
        path: '/sight-words',
        name: 'sight-words',
        pageBuilder: (context, state) => _buildPage(const SightWordsScreen(), state),
      ),
      GoRoute(
        path: '/reading',
        name: 'reading',
        pageBuilder: (context, state) => _buildPage(const ReadingScreen(), state),
      ),
      GoRoute(
        path: '/story-writing',
        name: 'story-writing',
        pageBuilder: (context, state) => _buildPage(const StoryWritingScreen(), state),
      ),

      // ═══════════ V2 — CODING & ART ═══════════
      GoRoute(
        path: '/coding',
        name: 'coding-world',
        pageBuilder: (context, state) => _buildPage(const CodingWorldScreen(), state),
      ),
      GoRoute(
        path: '/art',
        name: 'art-world',
        pageBuilder: (context, state) => _buildPage(const ArtWorldScreen(), state),
      ),

      // ═══════════ V2 — ADVANCED SUBJECTS ═══════════
      GoRoute(
        path: '/advanced-math',
        name: 'advanced-math',
        pageBuilder: (context, state) => _buildPage(const AdvancedMathScreen(), state),
      ),
      GoRoute(
        path: '/advanced-evs',
        name: 'advanced-evs',
        pageBuilder: (context, state) => _buildPage(const AdvancedEVSScreen(), state),
      ),

      // ═══════════ V2 — ACTIVITIES & SOCIAL ═══════════
      GoRoute(
        path: '/physical-activity',
        name: 'physical-activity',
        pageBuilder: (context, state) => _buildPage(const PhysicalActivityScreen(), state),
      ),
      GoRoute(
        path: '/lesson-cards/:subject/:topic',
        name: 'lesson-cards',
        pageBuilder: (context, state) {
          final subject = state.pathParameters['subject'] ?? 'grammar';
          final topic = state.pathParameters['topic'] ?? 'nouns';
          return _buildPage(LessonCardScreen(subject: subject, topic: topic), state);
        },
      ),
      GoRoute(
        path: '/leaderboard',
        name: 'leaderboard',
        pageBuilder: (context, state) => _buildPage(const LeaderboardScreen(), state),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
