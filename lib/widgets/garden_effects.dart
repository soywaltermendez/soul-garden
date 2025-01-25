import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' show Random, pi;
import '../models/reward.dart';
import '../providers/rewards_provider.dart';

class GardenEffects extends ConsumerWidget {
  const GardenEffects({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewards = ref.watch(rewardsProvider)
        .where((r) => r.isUnlocked && r.type == RewardType.gardenEffect);
    
    return Stack(
      children: [
        for (final reward in rewards)
          switch (reward.name) {
            'Mariposas del Jardín' => const ButterflyEffect(),
            _ => const SizedBox.shrink(),
          },
      ],
    );
  }
}

class ButterflyEffect extends StatefulWidget {
  const ButterflyEffect({super.key});

  @override
  State<ButterflyEffect> createState() => _ButterflyEffectState();
}

class _ButterflyEffectState extends State<ButterflyEffect> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Butterfly> _butterflies;
  static const _butterflyCount = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    final random = Random();
    _butterflies = List.generate(
      _butterflyCount,
      (_) => Butterfly(
        position: Offset(
          random.nextDouble() * 300,
          random.nextDouble() * 500,
        ),
        direction: random.nextDouble() * 2 * pi,
        speed: 1.0 + random.nextDouble(),
      ),
    );
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
        for (final butterfly in _butterflies) {
          butterfly.update(_controller.value);
        }
        
        return CustomPaint(
          size: Size.infinite,
          painter: ButterflyPainter(_butterflies),
        );
      },
    );
  }
}

class Butterfly {
  Offset position;
  double direction;
  final double speed;
  
  Butterfly({
    required this.position,
    required this.direction,
    required this.speed,
  });

  void update(double t) {
    final dx = cos(direction + t * 2 * pi) * speed;
    final dy = sin(direction + t * 2 * pi) * speed;
    position += Offset(dx, dy);
  }
}

class ButterflyPainter extends CustomPainter {
  final List<Butterfly> butterflies;

  ButterflyPainter(this.butterflies);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    for (final butterfly in butterflies) {
      final path = Path();
      
      // Dibujar alas
      path.moveTo(butterfly.position.dx, butterfly.position.dy);
      path.quadraticBezierTo(
        butterfly.position.dx + 10,
        butterfly.position.dy - 10,
        butterfly.position.dx + 20,
        butterfly.position.dy,
      );
      path.quadraticBezierTo(
        butterfly.position.dx + 10,
        butterfly.position.dy + 10,
        butterfly.position.dx,
        butterfly.position.dy,
      );
      
      // Espejo para la otra ala
      path.moveTo(butterfly.position.dx, butterfly.position.dy);
      path.quadraticBezierTo(
        butterfly.position.dx - 10,
        butterfly.position.dy - 10,
        butterfly.position.dx - 20,
        butterfly.position.dy,
      );
      path.quadraticBezierTo(
        butterfly.position.dx - 10,
        butterfly.position.dy + 10,
        butterfly.position.dx,
        butterfly.position.dy,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 