import 'dart:math';
import 'package:flutter/material.dart';

enum ParticleType { stars, circles, sparks }

class ParticleSystem extends StatefulWidget {
  final bool isPlaying;
  final Color color;
  final int count;        
  final double radius;    
  final ParticleType type;

  const ParticleSystem({
    super.key,
    required this.isPlaying,
    required this.color,
    this.count = 20,
    this.radius = 80,
    this.type = ParticleType.circles,
  });

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _random = Random();
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _generateParticles();
    if (widget.isPlaying) {
      _controller.forward(from: 0);
    }
  }

  void _generateParticles() {
    _particles = List.generate(widget.count, (index) {
      return _Particle(
        angle: _random.nextDouble() * 2 * pi,
        speed: _random.nextDouble() * 50 + 20,
        size: _random.nextDouble() * 7 + 3,
        rotationSpeed: (_random.nextDouble() - 0.5) * 4 * pi,
      );
    });
  }

  @override
  void didUpdateWidget(ParticleSystem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _generateParticles();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (!_controller.isAnimating && _controller.isCompleted) {
          return const SizedBox.shrink(); 
        }
        return CustomPaint(
          size: Size(widget.radius * 2, widget.radius * 2),
          painter: _ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.color,
            type: widget.type,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double angle;
  final double speed;
  final double size;
  final double rotationSpeed;

  _Particle({
    required this.angle, 
    required this.speed, 
    required this.size, 
    required this.rotationSpeed
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;
  final ParticleType type;

  _ParticlePainter({
    required this.particles, 
    required this.progress, 
    required this.color, 
    required this.type
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color.withOpacity((1 - progress).clamp(0.0, 1.0));

    for (var p in particles) {
      final distance = p.speed * progress;
      final gravityOffset = Offset(0, 50 * progress * progress);
      final offset = Offset(cos(p.angle) * distance, sin(p.angle) * distance) + gravityOffset;
      final pos = center + offset;

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(p.rotationSpeed * progress);
      
      if (type == ParticleType.stars) {
        _drawStar(canvas, paint, p.size);
      } else if (type == ParticleType.circles) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size / 2), paint);
      }
      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, Paint paint, double size) {
    final path = Path();
    final halfSize = size / 2;
    path.moveTo(0, -halfSize);
    path.lineTo(halfSize * 0.3, -halfSize * 0.3);
    path.lineTo(halfSize, 0);
    path.lineTo(halfSize * 0.3, halfSize * 0.3);
    path.lineTo(0, halfSize);
    path.lineTo(-halfSize * 0.3, halfSize * 0.3);
    path.lineTo(-halfSize, 0);
    path.lineTo(-halfSize * 0.3, -halfSize * 0.3);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
