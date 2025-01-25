import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/emotion_check.dart';
import '../models/emotion_type.dart';
import '../providers/check_in_provider.dart';
import '../widgets/emotion_selector.dart';
import '../widgets/intensity_slider.dart';
import '../widgets/check_in_note.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  EmotionType? selectedEmotion;
  int intensity = 3;
  final noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void onSubmit() {
    if (selectedEmotion == null) return;

    final check = EmotionCheck(
      id: const Uuid().v4(),
      emotion: selectedEmotion!,
      intensity: intensity,
      note: noteController.text.trim(),
      timestamp: DateTime.now(),
    );

    ref.read(checkInProvider.notifier).addCheckIn(check);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Cómo te sientes?'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EmotionSelector(
            selectedEmotion: selectedEmotion,
            onEmotionSelected: (emotion) {
              setState(() => selectedEmotion = emotion);
            },
          ),
          const SizedBox(height: 24),
          if (selectedEmotion != null) ...[
            IntensitySlider(
              value: intensity,
              onChanged: (value) {
                setState(() => intensity = value);
              },
            ),
            const SizedBox(height: 24),
            CheckInNote(controller: noteController),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onSubmit,
              child: const Text('Guardar'),
            ),
          ],
        ],
      ),
    );
  }
} 