
import 'package:dcurses/dcurses.dart';

abstract class EditorWindow extends Window {

  EditorWindow(String label, int y, int x, int columns, int lines) : super(label, y, x, columns, lines);

  Set<String> getHotkeys();
  void onHotkey(String hotkey);

}