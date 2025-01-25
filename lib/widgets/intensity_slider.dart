import 'package:flutter/material.dart';

class IntensitySlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const IntensitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Con qué intensidad?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: value.toString(),
          onChanged: (newValue) => onChanged(newValue.round()),
        ),
      ],
    );
  }

  String _getIntensityLabel(int value) {
    return switch (value) {
      1 => 'Muy baja',
      2 => 'Baja',
      3 => 'Media',
      4 => 'Alta',
      5 => 'Muy alta',
      _ => '',
    };
  }
} 