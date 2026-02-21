import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hearts system for focus (ages 5–7)
class HeartsService {
  int _hearts = 3;
  static const int maxHearts = 3;
  static const Duration refillTime = Duration(minutes: 30);
  DateTime? _lastLostAt;
  bool _enabled = true;

  int get hearts => _hearts;
  bool get hasHearts => _hearts > 0;
  bool get isEnabled => _enabled;
  bool get isFull => _hearts >= maxHearts;

  /// Lose a heart on wrong answer
  bool loseHeart() {
    if (!_enabled || _hearts <= 0) return false;
    _hearts--;
    _lastLostAt = DateTime.now();
    return true;
  }

  /// Refill one heart (timer-based or reward)
  void refillOne() {
    if (_hearts < maxHearts) _hearts++;
  }

  /// Full refill
  void refillAll() => _hearts = maxHearts;

  /// Check if enough time passed for auto-refill
  void checkAutoRefill() {
    if (_hearts >= maxHearts || _lastLostAt == null) return;
    final elapsed = DateTime.now().difference(_lastLostAt!);
    final refills = elapsed.inMinutes ~/ refillTime.inMinutes;
    if (refills > 0) {
      _hearts = (_hearts + refills).clamp(0, maxHearts);
      _lastLostAt = DateTime.now();
    }
  }

  /// Parent can toggle hearts system
  void setEnabled(bool enabled) => _enabled = enabled;

  /// Minutes until next refill
  int get minutesUntilRefill {
    if (_hearts >= maxHearts || _lastLostAt == null) return 0;
    final elapsed = DateTime.now().difference(_lastLostAt!);
    final remaining = refillTime.inMinutes - (elapsed.inMinutes % refillTime.inMinutes);
    return remaining;
  }
}

final heartsServiceProvider = Provider<HeartsService>((ref) => HeartsService());
