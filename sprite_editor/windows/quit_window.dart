
import 'package:dcurses/src/graphics/key.dart';

import 'editor_window.dart';

class QuitWindow extends EditorWindow {
  QuitWindow(String label, int y, int x, int columns, int lines) : super(label, y, x, columns, lines);


  @override
  void drawWindow() {
  }

  @override
  Set<Key> getHotkeys() {
    return {};
  }

  @override
  void onHotkey(Key hotkey) {
  }

  @override
  void onKey(Key key) {
  }


  
}