import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sudoku/models/sudoku.dart';
import 'package:url_launcher/url_launcher.dart';

import '../rehmat.dart';
import 'game.dart';

class LandingPage extends StatefulWidget {
  
  LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.github),
          onPressed: () => launchUrl(Uri(path: 'https://github.com/rehmatsg')),
          tooltip: 'GitHub - @rehmatsg',
        ),
      ),
      body: Column(
        children: [
          Spacer(),
          Center(
            child: Text(
              'Sudoku',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w900,
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 6
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24
                ),
              ),
              onPressed: () async {
                SudokuGame? game = await SudokuGame.create(context);
                if (game != null) AppRouter.push(context, page: GameScreen(game: game));
              },
              child: Text('Start Game')
            )
          ),
          Spacer(),
          Container(
            padding: const EdgeInsets.only(
              top: 12,
              left: 12,
              right: 12,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Palette.of(context).outline,
                  width: 0
                )
              ),
              color: Palette.of(context).surfaceVariant
            ),
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This software is licensed under the MIT License, which allows users to use, modify, and distribute the software for any purpose, without having to worry about licensing fees or other restrictions.',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _IconButton(
                        onPressed: () => launchUrl(Uri(path: 'https://github.com/rehmatsg/sudoku')),
                        icon: FontAwesomeIcons.github,
                        tooltip: 'GitHub - rehmatsg/sudoku',
                      ),
                      _IconButton(
                        onPressed: () => launchUrl(Uri(path: 'https://twitter.com/rehmatsg')),
                        icon: FontAwesomeIcons.twitter,
                        tooltip: 'Twitter - rehmatsg',
                      ),
                      _IconButton(
                        onPressed: () => launchUrl(Uri(path: 'https://instagram.com/rehmatsg')),
                        icon: FontAwesomeIcons.instagram,
                        tooltip: 'Instagram - rehmatsg',
                      ),
                      _IconButton(
                        onPressed: () => launchUrl(Uri(path: 'https://github.com/rehmatsg/sudoku/blob/master/LICENSE')),
                        icon: Icons.open_in_new,
                        tooltip: 'View License',
                      ),
                    ],
                  )
                ],
              )
            ),
          ),
        ],
      ),
    );
  }

}

class _IconButton extends StatelessWidget {

  const _IconButton({required this.icon, required this.onPressed, this.tooltip});

  final IconData icon;
  final Function() onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () {
          TapFeedback.light();
          onPressed();
        },
        child: Icon(
          icon,
        ),
      ),
    );
  }
}