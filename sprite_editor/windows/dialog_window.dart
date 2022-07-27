
import 'package:dcurses/dcurses.dart';

import '../editor.dart';
import 'editor_window.dart';

class DialogWindow extends EditorWindow {

  String message;
  Map<String, String Function()> options;
  

  DialogWindow(this.message, this.options, Editor editor, String label, int y, int x, int columns, int lines) : super(editor, label, y, x, columns, lines) {
    z = 99999;
    border = Border.rounded();
  }

  @override
  void draw() {
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
  
  @override
  void onFocusGain() {
  }
  
  @override
  void onFocusLoss() {
  }
  
}