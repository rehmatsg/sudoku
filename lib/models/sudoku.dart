import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sudoku_api/sudoku_api.dart';

import '../rehmat.dart';

class SudokuGame extends ChangeNotifier {

  SudokuGame._({
    required this.puzzle,
    required this.level
  }) {
    selected = puzzle.board()!.cellAt(Position(row: 0, column: 0));
    puzzle.startStopwatch();
  }

  static Future<SudokuGame?> create(BuildContext context) async {
    DifficultyLevel? level = await showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Select Difficulty'),
        actions: [
          CupertinoActionSheetAction(
            child: Text('Easy'),
            onPressed: () => Navigator.pop(context, DifficultyLevel.easy),
          ),
          CupertinoActionSheetAction(
            child: Text('Medium'),
            onPressed: () => Navigator.pop(context, DifficultyLevel.medium),
          ),
          CupertinoActionSheetAction(
            child: Text('Hard'),
            onPressed: () => Navigator.pop(context, DifficultyLevel.hard),
          ),
          CupertinoActionSheetAction(
            child: Text('Expert'),
            onPressed: () => Navigator.pop(context, DifficultyLevel.expert),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context, null),
        ),
      )
    );
    if (level == null) return null;
    PuzzleOptions puzzleOptions = new PuzzleOptions(
      clues: level.clues,
      name: "Sudoku",
    );
    Puzzle puzzle = new Puzzle(puzzleOptions);
    await puzzle.generate();
    return SudokuGame._(
      puzzle: puzzle,
      level: level
    );
  }

  final Puzzle puzzle;

  /// Determines the difficulty level of the game.
  /// The difficulty level determines the number of clues a new game starts with
  final DifficultyLevel level;

  GameState state = GameState.running;

  bool get isPaused => state == GameState.paused;

  void togglePauseResume() {
    if (state == GameState.running) {
      puzzle.stopStopwatch();
      state = GameState.paused;
    } else if (state == GameState.paused) {
      puzzle.startStopwatch();
      state = GameState.running;
    }
    notifyListeners();
  }

  void pause() {
    if (puzzle.isStopwatchRunning) puzzle.stopStopwatch();
    state = GameState.paused;
    notifyListeners();
  }

  void resume() {
    if (!puzzle.isStopwatchRunning) puzzle.startStopwatch();
    state = GameState.running;
    notifyListeners();
  }

  /// Returns the duration since the game started.
  Duration get timeElapsed => puzzle.getTimeElapsed();

  bool _enableNotes = false;
  bool get notes => _enableNotes;

  void toggleNotes() {
    _enableNotes = !_enableNotes;
    notifyListeners();
  }

  int errorCount = 0;

  late Cell selected;

  void select(Cell cell) {
    selected = cell;
    notifyListeners();
  }

  List<Cell> inAnimation = [];

  void animate([List<int>? indices]) {
    if (indices == null) {
      inAnimation.clear();
      notifyListeners();
      return;
    }
    inAnimation.clear();
    inAnimation = indices.map((index) => puzzle.board()!.cellAt(Position(index: index))).toList();
    notifyListeners();
  }

  void setValue(int? value, {
    bool forceNote = false
  }) {
    if (isPaused) return;
    if (selected.prefill() ?? false) return;
    if (value == null) {
      if (selected.getMarkup() != null && selected.getMarkup()!.isNotEmpty) selected.removeLastMarkup();
      selected.setValue(value);
      selected.setValidity(true);
    } else {
      if (_enableNotes || forceNote) {
        if ((selected.getMarkup()?.contains(value) ?? false)) selected.removeMarkup(value);
        else selected.addMarkup(value);
      } else {
        if (selected.getMarkup() != null && selected.getMarkup()!.isNotEmpty) selected.clearMarkup();
        bool isValid = puzzle.solvedBoard()!.cellAt(selected.position!).getValue() == value;
        if (!isValid) {
          errorCount++;
          if (errorCount >= 3) {
            puzzle.stopStopwatch();
            state = GameState.failed;
          }
        }
        selected.setValue(value);
        selected.setValidity(isValid);
      }
    }
    if (isComplete) {
      puzzle.stopStopwatch();
      state = GameState.completed;
    }
    notifyListeners();
  }

  bool get isComplete {
    for (int i = 0; i < 81; i++) {
      Cell cell = puzzle.board()!.cellAt(Position(index: i));
      Cell solvedCell = puzzle.solvedBoard()!.cellAt(Position(index: i));
      if (cell.getValue() != solvedCell.getValue()) return false;
    }
    return true;
  }

  Future<void> share(BuildContext context) async {
    String data = _compress(puzzle.toMap().toString());
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Palette.of(context).background.withOpacity(0.2),
      isScrollControlled: true,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SafeArea(
                top: true,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(PhosphorIcons.x),
                    )
                  ],
                )
              ),
              Spacer(),
              QrImage(
                data: data,
                backgroundColor: Colors.white,
                size: MediaQuery.of(context).size.width/2,
              ),
              Spacer(),
              SafeArea(
                top: false,
                left: false,
                right: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Palette.of(context).primaryContainer
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Icon(PhosphorIcons.circleWavyQuestion),
                        SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'Ask your friend to scan the QR code from Sudoku App to play same puzzle'
                          )
                        )
                      ],
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  String _compress(String json) {
    final enCodedJson = utf8.encode(json);
    final gZipJson = gzip.encode(enCodedJson);
    final base64Json = base64.encode(gZipJson);

    final decodeBase64Json = base64.decode(base64Json);
    final decodedZipJson = gzip.decode(decodeBase64Json);
    // ignore: unused_local_variable
    final originalJson = utf8.decode(decodedZipJson);

    return base64Json;
  }

  bool isValueRemaining(int value) {
    int count = 0;
    for (int i = 0; i < 81; i++) {
      Cell cell = puzzle.board()!.cellAt(Position(index: i));
      if (cell.getValue() == value) count++;
    }
    if (count != 9) return true;
    return false;
  }

}

enum GameState {
  running,
  paused,
  completed,
  failed
}

enum DifficultyLevel {
  easy,
  medium,
  hard,
  expert
}

extension DifficultyLevelExtension on DifficultyLevel {

  int get clues {
    switch (this) {
      case DifficultyLevel.easy:
        return 41;
      case DifficultyLevel.medium:
        return 34;
      case DifficultyLevel.hard:
        return 27;
      case DifficultyLevel.expert:
        return 20;
    }
  }

  String get name {
    switch (this) {
      case DifficultyLevel.easy:
        return 'Easy';
      case DifficultyLevel.medium:
        return 'Medium';
      case DifficultyLevel.hard:
        return 'Hard';
      case DifficultyLevel.expert:
        return 'Expert';
    }
  }

  IconData get icon {
    switch (this) {
      case DifficultyLevel.easy:
        return PhosphorIcons.smiley;
      case DifficultyLevel.medium:
        return PhosphorIcons.smileyMeh;
      case DifficultyLevel.hard:
        return PhosphorIcons.smileyNervous;
      case DifficultyLevel.expert:
        return PhosphorIcons.smileyBlank;
    }
  }

}