import 'package:flutter/material.dart';
import 'package:sudoku/models/sudoku.dart';
import 'package:sudoku_api/sudoku_api.dart';

import '../rehmat.dart';

class SudokuBoard extends StatefulWidget {

  const SudokuBoard({super.key, required this.game});

  final SudokuGame game;

  @override
  State<SudokuBoard> createState() => _SudokuBoardState();
}

class _SudokuBoardState extends State<SudokuBoard> {

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => CellWidget(
        key: ValueKey(index),
        cell: widget.game.puzzle.board()!.cellAt(Position(index: index)),
        game: widget.game
      ),
      itemCount: 81,
    );
  }

}