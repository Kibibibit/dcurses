import 'package:dcurses/dcurses.dart';

import '../editor.dart';
import 'editor_window.dart';

class PaletteWindow extends EditorWindow {
  PaletteWindow(Editor editor, String label, int y, int x, int columns, int lines) : super(editor, label, y, x, columns, lines);
  
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
   @override
  void onDraw() {}
  
  @override
  void onFocusGain() {
  }
  
  @override
  void onFocusLoss() {
  }
  
}