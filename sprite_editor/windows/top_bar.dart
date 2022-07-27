import 'package:dcurses/dcurses.dart';

import '../editor.dart';
import 'editor_window.dart';

class TopBar extends EditorWindow {
  TopBar(Editor editor, String label, int y, int x, int columns, int lines)
      : super(editor, label, y, x, columns, lines);


  @override
  Set<Key> getHotkeys() {
    return {Key.f1, Key.f2};
  }

  @override
  void onHotkey(Key hotkey) {
    if (hotkey == Key.f1) {
      _saveSprite();
    } else if (hotkey == Key.f2) {
      _loadSprite();
    }
  }

  @override
  void onKey(Key key) {}

  @override
  void draw() {

  }
  
  @override
  void onFocusGain() {
  }
  
  @override
  void onFocusLoss() {
  }


  void _saveSprite() {

  }

  void _loadSprite() {
    
  }
}
