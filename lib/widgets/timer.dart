import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sudoku/models/sudoku.dart';

import '../rehmat.dart';

class TimerWidget extends StatefulWidget {

  const TimerWidget({super.key, required this.game});

  final SudokuGame game;

  @override
  State<TimerWidget> createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) => setState(() { }));
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Palette.of(context).outline,
          width: 1
        )
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          widget.game.togglePauseResume();
          setState(() { });
          TapFeedback.normal();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.game.isPaused ? Icons.play_arrow : Icons.pause,
              size: Theme.of(context).textTheme.titleLarge?.fontSize,
              color: Palette.of(context).primary,
            ),
            SizedBox(width: 3),
            Text(
              elapsedTime,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Palette.of(context).primary,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500
              )
            ),
          ],
        ),
      ),
    );
  }

  String get elapsedTime {
    final timeElapsed = widget.game.puzzle.getTimeElapsed();
    final minutes = timeElapsed.inMinutes;
    final seconds = timeElapsed.inSeconds - (minutes * 60);
    // add 0 to seconds and minutes if they are less than 10
    if (minutes < 10 && seconds < 10) return '0$minutes:0$seconds';
    else if (minutes < 10) return '0$minutes:$seconds';
    else if (seconds < 10) return '$minutes:0$seconds';
    else return '$minutes:$seconds';
  }

}