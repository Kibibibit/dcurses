import '../../dcurses.dart';

class Stdscr extends Window {
  void Function() onDraw;

  Stdscr(String label, int y, int x, int columns, int lines, this.onDraw)
      : super(label, y, x, columns, lines);

  @override
  void draw() {
    onDraw();
  }
}
