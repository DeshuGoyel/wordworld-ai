import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Freemium gating service
enum SubscriptionTier { free, premium, school }

class FreemiumService {
  SubscriptionTier _tier = SubscriptionTier.free;

  SubscriptionTier get tier => _tier;
  bool get isPremium => _tier == SubscriptionTier.premium || _tier == SubscriptionTier.school;
  bool get isSchool => _tier == SubscriptionTier.school;

  /// Free tier limits
  static const Set<String> freeLetters = {'A', 'B', 'C'};
  static const int freePrintables = 2;
  static const Set<String> freeSubjects = {'language'};

  /// Check if a letter is accessible
  bool isLetterFree(String letter) => freeLetters.contains(letter) || isPremium;

  /// Check if a subject is accessible
  bool isSubjectFree(String subjectId) => freeSubjects.contains(subjectId) || isPremium;

  /// Check if a tab is accessible (free = Meet tab + 1 game only)
  bool isTabFree(String tabName) {
    if (isPremium) return true;
    return tabName == 'meet' || tabName == 'look';
  }

  /// Check if AI story generator is accessible
  bool get canUseStoryGenerator => isPremium;

  /// Check if full dashboard is accessible
  bool get canUseFullDashboard => isPremium;

  /// Upgrade tier
  void upgradeTo(SubscriptionTier tier) => _tier = tier;

  /// Check printable limit
  int _printablesUsed = 0;
  bool get canPrint => isPremium || _printablesUsed < freePrintables;
  void recordPrint() => _printablesUsed++;

  /// Pricing
  static const Map<String, dynamic> pricing = {
    'premium_monthly': {'price': 199, 'currency': 'INR', 'label': '₹199/month'},
    'premium_yearly': {'price': 999, 'currency': 'INR', 'label': '₹999/year'},
    'school_yearly': {'price': 4999, 'currency': 'INR', 'label': '₹4,999/class/year'},
  };
}

final freemiumServiceProvider = Provider<FreemiumService>((ref) => FreemiumService());
