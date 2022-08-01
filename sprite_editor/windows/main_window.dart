import 'package:dcurses/dcurses.dart';

import '../editor.dart';
import '../utils/wrap.dart';
import 'editor_window.dart';

class MainWindow extends EditorWindow {
  MainWindow(Editor editor, String label, int y, int x, int columns, int lines)
      : super(editor, label, y, x, columns, lines);

  final List<Ch> _backgrounds = [
    Ch(0x259a, [Modifier.colour(fg: Colour.brightblack, bg: Colour.white)]),
    Ch(0x259a, [Modifier.colour(fg: Colour.brightblack)]),
    Ch(0x00A0, [Modifier.colour(fg: Colour.black, bg: Colour.black)])
  ];

  int _background = 0;

  @override
  Set<Key> getHotkeys() {
    return {Key.fromChar("["), Key.fromChar("]")};
  }

  @override
  void onHotkey(Key hotkey) {
    if (hotkey == Key.fromChar("[")) {
      _background = wrap(_background - 1, _backgrounds.length);
    } else if (hotkey == Key.fromChar("]")) {
      _background = wrap(_background + 1, _backgrounds.length);
    }
  }

  @override
  void onKey(Key key) {}

  @override
  void onDraw() {
    _drawSprite();
    _drawBackgroundSelect();
  }

  void _drawBackgroundSelect() {
    int i = 0;

    for (Ch c in _backgrounds) {
      cx = columns - _backgrounds.length + i - 1;
      cy = 1;
      if (i == _background) {
        add(Ch(0x25C9));
      } else {
        add(Ch(0x25CB));
      }

      cx = columns - _backgrounds.length + i - 1;
      cy = 2;

      addStr(String.fromCharCode(c.value), c.modifiers);

      i++;
    }
  }

  void _drawSprite() {
    if (editor.editingSprite != null) {
      int _sx = 4;
      int _sy = 4;

      for (int sx = _sx; sx < editor.editingSprite!.columns + _sx; sx++) {
        for (int sy = _sy; sy < editor.editingSprite!.lines + _sy; sy++) {
          cx = sx;
          cy = sy;
          if (editor.editingSprite!.data[sy][sx].value == Ch.transparent) {
            add(_backgrounds[_background]);
          } else {
            add(editor.editingSprite!.data[sy][sx]);
          }
          
        }
      }
    } else {
      cx = centerX;
      cy = centerY;
      String message = "No sprite loaded!";
      cx -= (message.length / 2).floor();
      addStr(message);
    }
  }

  @override
  void onFocusGain() {}

  @override
  void onFocusLoss() {}
}
