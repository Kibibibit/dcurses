import 'package:dcurses/dcurses.dart';

import '../editor.dart';
import '../tool.dart';
import 'editor_window.dart';

class ToolWindow extends EditorWindow {

  ToolWindow(Editor editor, String label, int y, int x, int columns, int lines)
      : super(editor, label, y, x, columns, lines);

  final Map<Tool, Key> _hotkeys = {Tool.pencil: Key.fromChar("D"), Tool.eraser: Key.fromChar("E")};

  final Map<Tool, int> _icons = {Tool.pencil: 0x270E, Tool.eraser: 0x232B};

  @override
  void draw() {
    cy = 1;
    for (Tool t in Tool.values) {
      cx = centerX - 1;
      Modifier mod = t == editor.tool ? Modifier.colour(fg:Colour.black, bg:Colour.brightwhite) : Modifier.colour();
      addStr(" ${String.fromCharCode(_icons[t] ?? 10)} ",[mod]);
      cx = centerX - 1;
      cy++;
      addStr("(${_hotkeys[t]?.string ?? "_"})",[mod]);
      cy += 2;
    }
  }
  
  @override
  Set<Key> getHotkeys() {
    return _hotkeys.values.toSet();
  }
  
  @override
  void onHotkey(Key hotkey) {
    for (Tool t in _hotkeys.keys) {
      if (_hotkeys[t] == hotkey) {
        editor.tool = t;
        break;
      }
    }
  }
  
  @override
  void onKey(Key key) {

    int tIndex = Tool.values.indexOf(editor.tool);

    if (key == Key.upArrow) {
      tIndex--;
    } else if (key == Key.downArrow) {
      tIndex++;
    }

    if (tIndex < 0) {
      tIndex = Tool.values.length - 1;
    }
    if (tIndex >= Tool.values.length) {
      tIndex = 0;
    }

    editor.tool = Tool.values[tIndex];
  }
  
  @override
  void onFocusGain() {
  }
  
  @override
  void onFocusLoss() {
  }
}
