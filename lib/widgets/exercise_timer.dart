import 'package:flutter/material.dart';
import 'dart:async';

class ExerciseTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback onComplete;

  const ExerciseTimer({
    super.key,
    required this.duration,
    required this.onComplete,
  });

  @override
  State<ExerciseTimer> createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends State<ExerciseTimer> {
  late Timer _timer;
  late Duration _remaining;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining = Duration(seconds: _remaining.inSeconds - 1);
        } else {
          _timer.cancel();
          _isRunning = false;
          widget.onComplete();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _remaining = widget.duration;
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: CircularProgressIndicator(
                value: _remaining.inSeconds / widget.duration.inSeconds,
                strokeWidth: 8,
              ),
            ),
            Text(
              _formatDuration(_remaining),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: _resetTimer,
              icon: const Icon(Icons.refresh),
              iconSize: 32,
            ),
            IconButton(
              onPressed: _isRunning ? _pauseTimer : _startTimer,
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              iconSize: 48,
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
} 