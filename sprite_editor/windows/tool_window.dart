import 'package:dcurses/dcurses.dart';

import '../tool.dart';
import 'editor_window.dart';

class ToolWindow extends EditorWindow {
  Tool tool = Tool.pencil;

  ToolWindow(String label, int y, int x, int columns, int lines)
      : super(label, y, x, columns, lines) {
    _drawTools();
  }

  final Map<Tool, String> _hotkeys = {Tool.pencil: "D", Tool.eraser: "E"};

  final Map<Tool, int> _icons = {Tool.pencil: 0x270E, Tool.eraser: 0x232B};

  void _drawTools() {
    cy = 1;
    int center = (columns / 2).floor();
    for (Tool t in Tool.values) {
      cx = center - 1;
      Modifier mod = t == tool ? Modifier.colour(fg:Colour.black, bg:Colour.white) : Modifier.colour();
      addStr(" ${String.fromCharCode(_icons[t] ?? 10)} ",[mod]);
      cx = center - 1;
      cy++;
      addStr("(${_hotkeys[t] ?? "_"})",[mod]);
      cy += 2;
    }
  }
  
  @override
  Set<String> getHotkeys() {
    return {"D", "E"};
  }
  
  @override
  void onHotkey(String hotkey) {
    for (Tool t in _hotkeys.keys) {
      if (_hotkeys[t] == hotkey) {
        tool = t;
        break;
      }
    }
    _drawTools();
    screen?.refresh();
  }
}
