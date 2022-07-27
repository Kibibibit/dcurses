
import '../../dcurses.dart';


class Stdscr extends Window {
  Stdscr(String label, int y, int x, int columns, int lines) : super(label, y, x, columns, lines);

  @override
  void resize() {
    lines = screen!.lines;
    columns = screen!.columns;
  }

  
}