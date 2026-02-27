import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/audio_service.dart';

class Tappable extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool playSound;
  final bool haptic;
  
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final GestureDragStartCallback? onPanStart;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragEndCallback? onPanEnd;

  const Tappable({
    super.key,
    required this.child,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.playSound = true,
    this.haptic = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onTap: () {
        if (playSound) {
          AudioService.instance.play(SoundType.tap);
        }
        if (haptic) {
          HapticFeedback.lightImpact();
        }
        onTap?.call();
      },
      child: child,
    );
  }
}
