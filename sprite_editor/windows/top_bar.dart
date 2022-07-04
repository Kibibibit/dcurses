
import 'package:dcurses/dcurses.dart';

import 'editor_window.dart';

class TopBar extends EditorWindow {
  TopBar(String label, int y, int x, int columns, int lines) : super(label, y, x, columns, lines);
  
  @override
  Set<String> getHotkeys() {
    return {};
  }
  
  @override
  void onHotkey(String hotkey) {
  }
  
}