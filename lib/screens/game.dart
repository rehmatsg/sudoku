import 'dart:async';
import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sudoku/models/sudoku.dart';
import 'package:sudoku/rehmat.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

class GameScreen extends StatefulWidget {

  const GameScreen({super.key, required this.game});

  final SudokuGame game;

  @override
  State<GameScreen> createState() => _GameScreenState();

}

class _GameScreenState extends State<GameScreen> {

  late SudokuGame game;

  late final StreamSubscription<FGBGType> subscription;

  void onGameChange() => setState(() {});

  @override
  void initState() {
    game = widget.game;
    game.addListener(onGameChange);
    subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.foreground) {
        // game.resume();
      } else if (event == FGBGType.background) {
        game.pause();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    game.removeListener(onGameChange);
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: TimerWidget(game: game),
            actions: [
              IconButton(
                onPressed: () {
                  game.toggleNotes();
                  setState(() {});
                  Alerts.snackbar(context, text: 'Notes ${game.notes ? 'Enabled' : 'Disabled'}');
                },
                icon: Icon(PhosphorIcons.pencil),
                tooltip: 'Toggle Notes',
              )
            ],
          ),
          body: Column(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 3
                ),
                child: ActionBar(game: game),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Palette.of(context).outline,
                      width: 2
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SudokuBoard(game: game),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              left: 6,
              right: 6,
              bottom: MediaQuery.of(context).padding.bottom + 12,
              top: 6
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Palette.of(context).outline,
                  width: 2
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Numpad(game: game)
              ),
            )
          ),
        ),
        AnimatedSwitcher(
          duration: kAnimationDuration,
          child: (game.state == GameState.completed || game.state == GameState.failed) ? BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Scaffold(
              backgroundColor: Palette.of(context).background.withOpacity(0.2),
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(PhosphorIcons.x),
                ),
              ),
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Lottie.asset(
                      game.state == GameState.completed ? 'assets/animations/success.json' : 'assets/animations/error.json',
                      repeat: false,
                      height: MediaQuery.of(context).size.width / 2.5
                    ),
                    Text(
                      game.state == GameState.completed ? 'Completed' : 'Game Over',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w900
                      )
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _GridItem(
                          icon: PhosphorIcons.clock,
                          text: 'Time: ${game.timeElapsed.inMinutes}m ${game.timeElapsed.inSeconds % 60}s'
                        ),
                        _GridItem(
                          icon: PhosphorIcons.circleWavyWarning,
                          text: 'Errors: ${game.errorCount}/3'
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: PrimaryButton(
                        child: Text(
                          game.state == GameState.completed ? 'New Game' : 'Try Again',
                        ),
                        onPressed: () async {
                          SudokuGame? _game = await SudokuGame.create(context);
                          if (_game != null) AppRouter.replace(context, page: GameScreen(game: _game));
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ) : Container(),
        ),
      ],
    );
  }

}

class _GridItem extends StatelessWidget {

  const _GridItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: Theme.of(context).textTheme.bodyLarge?.fontSize,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontFamily: 'Satoshi'
          ),
        ),
      ],
    );
  }
}