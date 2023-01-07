import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sprung/sprung.dart';
import 'package:sudoku/models/sudoku.dart';

import '../rehmat.dart';

class Numpad extends StatefulWidget {

  const Numpad({super.key, required this.game});

  final SudokuGame game;

  @override
  State<Numpad> createState() => _NumpadState();
}

class _NumpadState extends State<Numpad> {

  late final SudokuGame game;

  void onGameUpdate() => setState(() {});

  @override
  void initState() {
    game = widget.game;
    game.addListener(onGameUpdate);
    super.initState();
  }

  @override
  void dispose() {
    game.removeListener(onGameUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: kAnimationDuration,
      curve: Sprung.overDamped,
      child: Builder(
        builder: (context) {
          if (game.isPaused) return SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PlatformInkWell(
                    onTap: () => game.togglePauseResume(),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Palette.of(context).primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        PhosphorIcons.play,
                        color: Palette.of(context).onPrimaryContainer,
                      ),
                    ),
                  ),
                  SizedBox(width: 9),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Game Paused',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'Click to resume',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
          return GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1.1
            ),
            itemBuilder: (context, index) => NumButton(
              key: ValueKey(index),
              value: index == 9 ? null : index + 1,
              game: game
            ),
            itemCount: 10,
          );
        },
      ),
    );
  }

}

class NumButton extends StatelessWidget {

  const NumButton({super.key, required this.value, required this.game});

  final int? value;
  final SudokuGame game;

  @override
  Widget build(BuildContext context) {
    return (value == null || game.isValueRemaining(value!)) ? GestureDetector(
      onTap: () {
        game.setValue(value);
        TapFeedback.light();
      },
      onLongPress: () {
        game.setValue(value, forceNote: true);
        TapFeedback.normal();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Palette.of(context).outline,
            width: 0.5
          )
        ),
        child: game.isPaused ? null : Center(
          child: value != null ? Text(
            '$value',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontFamily: 'Satoshi',
            )
          ) : Icon(
            Icons.backspace_outlined,
            size: Theme.of(context).textTheme.headlineLarge?.fontSize,
            color: Palette.of(context).primary,
          ),
        ),
      ),
    ) : Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Palette.of(context).outline,
          width: 0.5
        )
      ),
    );
  }
}