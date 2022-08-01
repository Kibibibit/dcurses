import '../../dcurses.dart';

class Stdscr extends Window {
  late final void Function() _onDraw;

  Stdscr(String label, int y, int x, int columns, int lines, void Function() onDraw)
      : super(label, y, x, columns, lines) {
        _onDraw = onDraw;
      }

  @override
  void onDraw() {
    _onDraw();
  }
}
