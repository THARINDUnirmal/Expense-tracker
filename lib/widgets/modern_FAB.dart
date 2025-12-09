import 'dart:ui';
import 'package:flutter/material.dart';

class ModernFAB extends StatefulWidget {
  final VoidCallback onPressed;

  const ModernFAB({super.key, required this.onPressed});

  @override
  State<ModernFAB> createState() => _ModernFABState();
}

class _ModernFABState extends State<ModernFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // repeat forever

    // Ripple grows
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Ripple fades away
    _opacityAnim = Tween<double>(
      begin: 0.35,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // WATER RIPPLE ANIMATION
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnim.value,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurpleAccent.withOpacity(
                      _opacityAnim.value,
                    ),
                  ),
                ),
              );
            },
          ),

          // MAIN FAB (Glass + Glow)
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Material(
                color: Colors.deepPurple.withOpacity(0.7),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: widget.onPressed,
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 62,
                    height: 62,
                    child: Icon(
                      Icons.add_rounded,
                      size: 34,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
