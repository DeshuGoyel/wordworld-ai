import 'package:flutter/material.dart';

class BrainMeter3D extends StatelessWidget {
  final int currentXP;
  final int maxXP;
  
  const BrainMeter3D({
    super.key, 
    required this.currentXP, 
    required this.maxXP
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentXP / maxXP).clamp(0.0, 1.0);
    
    return Column(
      children: [
        // Label row
        Row(
          children: [
            const Text("🧠", style: TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            const Text(
              "Brain Power", 
              style: TextStyle(
                fontFamily: 'Nunito', 
                fontSize: 13, 
                color: Colors.black54, 
                fontWeight: FontWeight.w800
              )
            ),
            const Spacer(),
            Text(
              "$currentXP / $maxXP XP", 
              style: const TextStyle(
                fontFamily: 'Nunito', 
                fontSize: 12, 
                fontWeight: FontWeight.w700,
                color: Colors.black54
              )
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // 3D track
        Stack(
          children: [
            // Groove (inset shadow for sunken effect):
            Container(
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFFE0D8FF),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                    spreadRadius: -2,
                  ),
                ],
              ),
            ),
            
            // Animated fill:
            LayoutBuilder(
              builder: (ctx, constraints) => AnimatedContainer(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutExpo,
                height: 22,
                width: constraints.maxWidth * progress,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C5CE7), Color(0xFFFF6B9D)],
                  ),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C5CE7).withOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Glossy top sheen:
                    Positioned(
                      top: 2, left: 8, right: 8,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.6),
                              Colors.white.withOpacity(0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
