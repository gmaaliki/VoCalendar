import 'dart:async';
import 'package:flutter/material.dart';

class DotLoadingIndicator extends StatefulWidget {
  final Color dotColor;
  final double dotSize;
  final Duration speed;

  const DotLoadingIndicator({
    Key? key,
    this.dotColor = Colors.grey,
    this.dotSize = 14.0,
    this.speed = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _DotLoadingIndicatorState createState() => _DotLoadingIndicatorState();
}

class _DotLoadingIndicatorState extends State<DotLoadingIndicator> {
  int _dotCount = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.speed, (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4; // Cycles 0→1→2→3→0...
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${'.' * _dotCount}', // Creates "", ".", "..", "..."
      style: TextStyle(
        color: widget.dotColor,
        fontSize: widget.dotSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}