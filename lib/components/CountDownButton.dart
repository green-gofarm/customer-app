import 'dart:async';
import 'package:flutter/material.dart';

class CountdownText extends StatefulWidget {
  final DateTime expiredTime;
  final TextStyle? style;

  CountdownText({required this.expiredTime, this.style});

  @override
  _CountdownTextState createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  Timer? _timer;
  Duration? _remainingTime;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = widget.expiredTime.difference(DateTime.now());

    if (_remainingTime!.isNegative) {
      _remainingTime = Duration.zero;
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _remainingTime = _remainingTime! - Duration(seconds: 1);
          if (_remainingTime!.isNegative) {
            _remainingTime = Duration.zero;
            timer.cancel();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_remainingTime!.inHours}:${(_remainingTime!.inMinutes % 60).toString().padLeft(2, '0')}:${(_remainingTime!.inSeconds % 60).toString().padLeft(2, '0')}',
      style: widget.style ?? TextStyle(fontSize: 16),
    );
  }
}
