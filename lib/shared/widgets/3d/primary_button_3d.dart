import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_app/core/services/audio_service.dart';
import 'package:learn_app/core/widgets/tappable.dart';

Color darkerShade(Color color, [double amount = 0.2]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final darker = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return darker.toColor();
}

Color lighterShade(Color color, [double amount = 0.2]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final lighter = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return lighter.toColor();
}

class PrimaryButton3D extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Gradient? gradient;
  final Color? solidColor;
  final Color? shadowColor;
  final IconData? leadingIcon;
  final double? width;
  final double height;

  const PrimaryButton3D({
    super.key,
    required this.label,
    required this.onTap,
    this.gradient,
    this.solidColor,
    this.shadowColor,
    this.leadingIcon,
    this.width,
    this.height = 58.0,
  }) : assert(gradient != null || solidColor != null, 'Provide either gradient or solidColor');

  @override
  State<PrimaryButton3D> createState() => _PrimaryButton3DState();
}

class _PrimaryButton3DState extends State<PrimaryButton3D> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.solidColor ?? Colors.blueAccent;
    final primaryGradient = widget.gradient ?? LinearGradient(
      colors: [baseColor, lighterShade(baseColor)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final darkShadow = widget.shadowColor ?? darkerShade(baseColor);

    return Tappable(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        HapticFeedback.mediumImpact();
        // Play tap sound if sound service was available synchronously, but since it's Riverpod we skip it here
        // The standard AudioService from wordworld_ai was a singleton, we'll just use Haptics for now
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Future.delayed(const Duration(milliseconds: 80), widget.onTap);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: _isPressed ? 80 : 200),
        curve: _isPressed ? Curves.easeIn : Curves.elasticOut,
        transform: Matrix4.translationValues(0, _isPressed ? 6.0 : 0.0, 0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── LAYER 1: 3D base (shadow block) ──
            Positioned(
              bottom: -6,  // sticks out below
              left: 0, 
              right: 0,
              child: Container(
                height: widget.height,
                decoration: BoxDecoration(
                  color: darkShadow,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            // ── LAYER 2: Button face ──
            Container(
              width: widget.width ?? double.infinity,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: primaryGradient,
                borderRadius: BorderRadius.circular(100),
                boxShadow: _isPressed ? [] : [
                  BoxShadow(
                    color: darkShadow.withOpacity(0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.leadingIcon != null) ...[
                    Icon(widget.leadingIcon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
