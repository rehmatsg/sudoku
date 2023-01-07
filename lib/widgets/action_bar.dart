import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sudoku/models/sudoku.dart';

class ActionBar extends StatefulWidget {

  const ActionBar({super.key, required this.game});

  final SudokuGame game;

  @override
  State<ActionBar> createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {

  late final SudokuGame game;

  void onGameChange() => setState(() {});

  @override
  void initState() {
    game = widget.game;
    game.addListener(onGameChange);
    super.initState();
  }

  @override
  void dispose() {
    game.removeListener(onGameChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              game.level.icon,
              color: Theme.of(context).textTheme.subtitle1?.color,
              size: Theme.of(context).textTheme.subtitle1?.fontSize,
            ),
            SizedBox(width: 3,),
            Text(
              game.level.name,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.star,
              color: Theme.of(context).textTheme.subtitle1?.color,
              size: Theme.of(context).textTheme.subtitle1?.fontSize,
            ),
            SizedBox(width: 3,),
            Text(
              '400',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.circleWavyWarning,
              color: Theme.of(context).textTheme.subtitle1?.color,
              size: Theme.of(context).textTheme.subtitle1?.fontSize,
            ),
            SizedBox(width: 3,),
            Text(
              '${game.errorCount}/3',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ],
    );
  }

}