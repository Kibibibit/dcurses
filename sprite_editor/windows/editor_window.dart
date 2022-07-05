
import 'package:dcurses/dcurses.dart';

abstract class EditorWindow extends Window {

  EditorWindow(String label, int y, int x, int columns, int lines) : super(label, y, x, columns, lines) {
    drawWindow();
  }


  int get centerX => (columns / 2).floor();
  int get centerY => (lines / 2).floor();

  Set<Key> getHotkeys();
  void onHotkey(Key hotkey);
  void onKey(Key key);
  void drawWindow();

}