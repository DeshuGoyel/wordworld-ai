import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../core/services/purchase_service.dart';
import '../../shared/widgets/shared_widgets.dart';

class PaywallSheet extends ConsumerWidget {
  final String featureName;

  const PaywallSheet({super.key, required this.featureName});

  static Future<bool> checkAndShow(BuildContext context, WidgetRef ref, String feature) async {
    final purchaseService = ref.read(purchaseServiceProvider);
    if (purchaseService.isPremium) return true;

    // Show sheet
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PaywallSheet(featureName: feature),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),
          const Icon(Icons.auto_awesome, color: AppColors.primary, size: 64),
          const SizedBox(height: 16),
          Text(
            'Unlock $featureName',
            style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Get LearnVerse Premium to unlock $featureName, unlimited AI Stories, Print Center, and detailed Parent Insights!',
            style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          DuoButton(
            text: 'Unlock Premium (\$4.99/mo)',
            color: AppColors.primary,
            onPressed: () async {
               await ref.read(purchaseServiceProvider).upgradeToPremium();
               if (context.mounted) {
                 Navigator.pop(context, true);
               }
            },
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Maybe Later', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
