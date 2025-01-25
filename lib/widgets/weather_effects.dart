import 'package:flutter/material.dart';
import 'dart:math' as math;

class _SunnyEffect extends StatelessWidget {
  final double intensity;

  const _SunnyEffect({required this.intensity});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SunPainter(intensity: intensity),
      size: Size.infinite,
    );
  }
}

class _SunPainter extends CustomPainter {
  final double intensity;

  _SunPainter({required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.8, size.height * 0.2);
    final radius = size.width * 0.1;

    final sunPaint = Paint()
      ..color = Colors.yellow.withOpacity(intensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    
    canvas.drawCircle(center, radius, sunPaint);

    final rayPaint = Paint()
      ..color = Colors.yellow.withOpacity(intensity * 0.3)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 12; i++) {
      final angle = i * math.pi / 6;
      final rayLength = radius * (1.5 + math.sin(DateTime.now().millisecondsSinceEpoch / 500) * 0.2);
      
      canvas.drawLine(
        center + Offset(math.cos(angle) * radius, math.sin(angle) * radius),
        center + Offset(math.cos(angle) * rayLength, math.sin(angle) * rayLength),
        rayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_SunPainter oldDelegate) => oldDelegate.intensity != intensity;
}

class _RainyEffect extends StatelessWidget {
  final double intensity;

  const _RainyEffect({required this.intensity});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RainPainter(intensity: intensity),
      size: Size.infinite,
    );
  }
}

class _RainPainter extends CustomPainter {
  final double intensity;
  final _random = math.Random();

  _RainPainter({required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3 * intensity)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final dropCount = (300 * intensity).round();
    
    for (var i = 0; i < dropCount; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final length = 10.0 + _random.nextDouble() * 10;
      
      canvas.drawLine(
        Offset(x, y),
        Offset(x - 2, y + length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RainPainter oldDelegate) => oldDelegate.intensity != intensity;
}

// Implementar los demás efectos de clima... 