import '../../dcurses.dart';

class Stdscr extends Window {
  final void Function() _onDraw;

  Stdscr(String label, int y, int x, int columns, int lines, this._onDraw)
      : super(label, y, x, columns, lines);

  @override
  void onDraw() {
    _onDraw();
  }
}
