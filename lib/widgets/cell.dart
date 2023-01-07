import 'package:flutter/material.dart';
import 'package:sudoku/models/sudoku.dart';
import 'package:sudoku_api/sudoku_api.dart';

import '../rehmat.dart';

class CellWidget extends StatefulWidget {

  const CellWidget({
    super.key,
    required this.cell,
    required this.game
  });

  final Cell cell;
  final SudokuGame game;

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> {

  late final Cell cell;
  late final SudokuGame game;

  bool get isSelected => game.selected == cell;
  bool get isRelatedToSelection {
    if (game.selected.position!.grid!.x == cell.position!.grid!.x) return true;
    else if (game.selected.position!.grid!.y == cell.position!.grid!.y) return true;
    else if (game.selected.position!.segment!.x == cell.position!.segment!.x && game.selected.position!.segment!.y == cell.position!.segment!.y) return true;
    else return false;
  }

  int? get highlightedValue {
    int? val = game.selected.getValue();
    if (val != null && val != 0) return val;
    else return null;
  }
  bool get isValueHighlighted {
    if (game.selected.getValue() == null || game.selected.getValue()! == 0) return false;
    else if (cell.getValue() == game.selected.getValue() && game.selected != cell) return true;
    else return false;
  }

  void onGameChange() => setState(() {});

  @override
  void initState() {
    cell = widget.cell;
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
    return Listener(
      onPointerDown: (event) => game.select(cell),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: border
        ),
        child: game.isPaused ? null : Center(
          child: showValue ? Text(
            value!,
            style: textStyle,
          ) : (
            hasNotes ? Padding(
              padding: const EdgeInsets.all(1.5),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (context, index) {
                  int val = cell.getMarkup()!.elementAt(index);
                  return Center(
                    child: Text(
                      val.toString(),
                      style: TextStyle(
                        color: highlightedValue == val ? Palette.of(context).onBackground : Palette.of(context).onBackground.withOpacity(0.5),
                        fontSize: 10,
                        fontFamily: 'Satoshi',
                        fontWeight: highlightedValue == val ? FontWeight.w900 : FontWeight.w500
                      ),
                    ),
                  );
                },
                itemCount: cell.getMarkup()!.length,
              ),
            ) : null
          ),
        ),
      ),
    );
  }

  String? get value => cell.getValue()?.toString();

  bool get showValue => value != null && value != '0';

  bool get hasNotes => cell.getMarkup() != null && cell.getMarkup()!.isNotEmpty;

  bool get hasError => cell.valid() == false;

  TextStyle get textStyle => TextStyle(
    color: hasError ? Palette.of(context).error : Palette.of(context).onBackground,
    fontSize: 30,
    height: 0.66,
    fontFamily: 'Satoshi',
    fontWeight: isValueHighlighted ? FontWeight.w800 : FontWeight.w500,
  );

  Color get color {
    if (game.inAnimation.contains(cell)) return Palette.of(context).tertiaryContainer;
    if (game.inAnimation.isNotEmpty) return Palette.of(context).background;
    if (game.isPaused) return Palette.of(context).background;
    if (isSelected) return Palette.of(context).primaryContainer;
    else if (isRelatedToSelection) return Palette.of(context).surface;
    else if (isValueHighlighted) return Palette.of(context).onBackground.withOpacity(0.05);
    else return Palette.of(context).background;
  }

  Border get border => Border(
    bottom: bottomBorder(),
    right: rightBorder(),
    left: leftBorder(),
    top: topBorder()
  );

  BorderSide _generateCommonBorderSide() => BorderSide(
    color: Palette.of(context).outline,
    width: 0.5
  );

  BorderSide _generateSpecialBorderSide() => BorderSide(
    color: Palette.of(context).outline,
    width: 1
  );

  BorderSide bottomBorder() {
    if (cell.position!.grid!.x == 2 || cell.position!.grid!.x == 5) return _generateSpecialBorderSide();
    else if (cell.position!.grid!.x == 8) return BorderSide.none;
    else return _generateCommonBorderSide();
  }

  BorderSide rightBorder() {
    if (cell.position!.grid!.y == 2 || cell.position!.grid!.y == 5) return _generateSpecialBorderSide();
    else if (cell.position!.grid!.y == 8) return BorderSide.none;
    else return _generateCommonBorderSide();
  }

  BorderSide leftBorder() {
    if (cell.position!.grid!.y == 3 || cell.position!.grid!.y == 6) return _generateSpecialBorderSide();
    else if (cell.position!.grid!.y == 0) return BorderSide.none;
    else return _generateCommonBorderSide();
  }

  BorderSide topBorder() {
    if (cell.position!.grid!.x == 3 || cell.position!.grid!.x == 6) return _generateSpecialBorderSide();
    else if (cell.position!.grid!.x == 0) return BorderSide.none;
    else return _generateCommonBorderSide();
  }
  
}