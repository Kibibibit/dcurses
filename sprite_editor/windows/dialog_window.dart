
import 'package:dcurses/dcurses.dart';

import 'editor_window.dart';

class DialogWindow extends EditorWindow {

  String message;
  Map<String, String Function()> options;
  

  DialogWindow(this.message, this.options, String label, int y, int x, int columns, int lines) : super(label, y, x, columns, lines) {
    z = 99999;
    border = Border.rounded();
  }

  @override
  void drawWindow() {
  }

  @override
  Set<Key> getHotkeys() {
    throw UnimplementedError();
  }

  @override
  void onHotkey(Key hotkey) {
  }

  @override
  void onKey(Key key) {
  }
  
}