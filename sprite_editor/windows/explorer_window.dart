
import 'dart:io';

import 'package:dcurses/dcurses.dart';

import '../editor.dart';
import 'editor_window.dart';

class ExplorerWindow extends EditorWindow {
  ExplorerWindow(Editor editor, String label, int y, int x, int columns, int lines) : super(editor, label, y, x, columns, lines) {
    z = 100000;
    border = Border.double();
  }

  Directory current = Directory.current;
  int selected = 0;
  List<FileSystemEntity> items = [];

  @override
  void onDraw() {
    _drawAsync();
  }

  void _drawAsync() {
    items = current.listSync().toList();
    
    items = items.where((element) => (element is Directory || element.path.endsWith(".sprite"))).toList();
    items.sort(((a, b) {
      if (a is Directory && b is! Directory) {
        return -1;
      }
      if (b is Directory && a is! Directory) {
        return 1;
      }
      return a.path.compareTo(b.path);
    }));

    int longestLength = 0;

    for (FileSystemEntity file in items) {
      if (file.absolute.path.length > longestLength) {
        longestLength = file.absolute.path.length;
      }
    }

    cy = 2;
    int i = 0;


    for (FileSystemEntity file in items) {
      cx = 2;
      addStr(file.absolute.path.padRight(longestLength), _color(file, i));
      cy++;
      i++;
    }
  }

  List<Modifier> _color(FileSystemEntity file, int index) {
    List<Modifier> out = [];

    Colour fg = Colour.brightwhite;
    Colour bg = Colour.black;

    if (file is Directory) {
      fg = Colour.cyan;
      out.add(Modifier.decoration(Decoration.bold));
    }
    if (index == selected) {
      Colour t = fg;
      fg = bg;
      bg = t;
    }
    out.add(Modifier.colour(fg:fg, bg:bg));
    return out;
  }


  @override
  Set<Key> getHotkeys() {
    return {};
  }

  @override
  void onFocusGain() {
  }

  @override
  void onFocusLoss() {
  }

  @override
  void onHotkey(Key hotkey) {
  }

  void _updateRanges() {
    items = current.listSync().toList();
    items = items.where((element) => (element is Directory || element.path.endsWith(".sprite"))).toList();
    if (selected < 0) {
      selected = items.length-1;
    }
    if (selected >= items.length) {
      selected = 0;
    }

  }

  @override
  void onKey(Key key) {
    if (key == Key.upArrow) {
      selected--;
    }
    if (key == Key.downArrow) {
      selected++;
    }
    
    _updateRanges();

    if (key == Key.enter) {
      if (items[selected] is Directory) {
        current = items[selected] as Directory;
      }
    }
    if (key == Key.backspace) {
      current = current.parent;
    }

    _updateRanges();
  }
  
}