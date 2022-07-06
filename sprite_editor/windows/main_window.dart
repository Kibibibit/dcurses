import 'package:dcurses/dcurses.dart';

import '../editor.dart';
import '../utils/wrap.dart';
import 'editor_window.dart';

class MainWindow extends EditorWindow {
  MainWindow(String label, int y, int x, int columns, int lines)
      : super(label, y, x, columns, lines);

  final List<Ch> _backgrounds = [
    Ch(0x259a, [Modifier.colour(fg: Colour.gray, bg: Colour.lightgray)]),
    Ch(0x259a, [Modifier.colour(fg: Colour.gray)]),
    Ch(0x00A0, [Modifier.colour(fg: Colour.black, bg: Colour.black)])
  ];

  int _background = 0;

  @override
  Set<Key> getHotkeys() {
    return {
      Key.fromChar("["),
      Key.fromChar("]")
    };
  }

  @override
  void onHotkey(Key hotkey) {
    if (hotkey == Key.fromChar("[")) {
      _background = wrap(_background-1, _backgrounds.length);
    } else if (hotkey == Key.fromChar("]")) {
      _background = wrap(_background+1, _backgrounds.length);
    }
  }

  @override
  void onKey(Key key) {}

  @override
  void drawWindow() {
    
    _drawBackground();
    _drawBackgroundSelect();
    
  }

  void _drawBackgroundSelect() {
    int i = 0;

    for (Ch c in _backgrounds) {
      cx = columns - _backgrounds.length + i - 1;
      cy = 1;

      if (i == _background) {
        addStr(String.fromCharCode(0x25a3));
      } else {
        addStr(String.fromCharCode(0x25a1));
      }

      cx = columns - _backgrounds.length + i - 1;
      cy = 2;

      addStr(String.fromCharCode(c.value), c.modifiers);

      i++;
    }
  }

  void _drawBackground() {
    int _sx = 4;
    int _sy = 4;

    for (int sx = _sx; sx < Editor.spriteWidth + _sx; sx++) {
      for (int sy = _sy; sy < Editor.spriteHeight + _sy; sy++) {

        cx = sx;
        cy = sy;

        add(_backgrounds[_background]);
      }
    }
  }
  
  @override
  void onFocusGain() {
  }
  
  @override
  void onFocusLoss() {
  }
}
