import 'package:flutter/material.dart';

class CheckInNote extends StatelessWidget {
  final TextEditingController controller;

  const CheckInNote({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Notas (opcional)',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 3,
          maxLength: 200,
          decoration: InputDecoration(
            hintText: '¿Quieres agregar algún detalle sobre cómo te sientes?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
        ),
      ],
    );
  }
} 