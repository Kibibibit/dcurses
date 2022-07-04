import 'package:dcurses/dcurses.dart';

import 'editor_mode.dart';
import 'windows/editor_window.dart';
import 'windows/main_window.dart';
import 'windows/palette_window.dart';
import 'windows/tool_window.dart';
import 'windows/top_bar.dart';

class Editor {
  final int _topBarHeight = 4;
  final int _toolWindowWidth = 7;
  final int _paletteWindowWidth = 20;

  late int _focusX, _focusY;

  late Screen _screen;
  late Window _toolWindow;
  late Window _mainWindow;
  late Window _paletteWindow;
  late Window _topBar;

  bool running = false;

  String? focusedWindow = "mainwindow";

  Map<String, String> _hotkeys = {};

  EditorMode editorMode = EditorMode.focused;

  Editor() {
    _focusX = 1;
    _focusY = 1;
    _screen = Screen();
    _topBar = TopBar("topbar", 0, 0, _screen.columns, _topBarHeight)
      ..border = Border.thin();
    _toolWindow = ToolWindow("toolwindow", _topBarHeight, 0, _toolWindowWidth,
        _screen.lines - _topBarHeight)
      ..border = Border.rounded();
    _mainWindow = MainWindow(
        "mainwindow",
        _topBarHeight,
        _toolWindowWidth,
        _screen.columns - _toolWindowWidth - _paletteWindowWidth,
        _screen.lines - _topBarHeight)
      ..border = Border.double();
    _paletteWindow = PaletteWindow(
        "palettewindow",
        _topBarHeight,
        _mainWindow.x + _mainWindow.columns,
        _paletteWindowWidth,
        _screen.lines - _topBarHeight)
      ..border = Border.rounded();
    _screen.addWindow(_toolWindow);
    _screen.addWindow(_mainWindow);
    _screen.addWindow(_paletteWindow);
    _screen.addWindow(_topBar);

    for (String w in _screen.windows) {
      if (_screen.get(w) is EditorWindow) {
        Set<String> keys = ((_screen.get(w) as EditorWindow).getHotkeys());
        for (String key in keys) {
          _hotkeys[w] = key;
        }
      }
    }

    _screen.refresh();
  }

  void run() {
    running = true;
    while (running) {
      _focus();
      String key = _screen.getch();

      

      switch (editorMode) {
        case EditorMode.unfocused:
          _unfocused(key);
          break;
        case EditorMode.focused:
          _focused(key);
          break;
      }
    }

    _cleanup();
  }

  void _unfocused(String key) {
    
    switch (key) {
      case Key.upArrow:
        _focusY--;
        break;
      case Key.downArrow:
        _focusY++;
        break;
      case Key.leftArrow:
        if (_focusY == 1) {
          _focusX--;
        }
        break;
      case Key.rightArrow:
        if (_focusY == 1) {
          _focusX++;
        }
        break;
      case Key.home:
        _focusX = 1;
        _focusY = 1;
        break;
      case Key.enter:
        editorMode = EditorMode.focused;
        return;
    }

    if (_focusY < 0) {
      _focusY = 1;
    }
    if (_focusY > 1) {
      _focusY = 0;
    }
    if (_focusX < 0) {
      _focusX = 2;
    }
    if (_focusX > 2) {
      _focusX = 0;
    }

    if (_focusY == 0) {
      focusedWindow = _topBar.label;
    } else {
      if (_focusX == 0) {
        focusedWindow = _toolWindow.label;
      } else if (_focusX == 1) {
        focusedWindow = _mainWindow.label;
      } else {
        focusedWindow = _paletteWindow.label;
      }
    }
  }

  void _focused(String key) {
    if (key == Key.backspace) {
      editorMode = EditorMode.unfocused;
      return;
    }
  }

  void _cleanup() {
    _screen.clear();
  }

  void _focus() {
    for (String window in _screen.windows) {
      if (window == focusedWindow) {
        _screen.get(window)!.border =
            Border.double([Modifier.fg(Colour.white)]);
      } else {
        _screen.get(window)!.border = Border.thin([Modifier.fg(editorMode == EditorMode.unfocused ? Colour.gray : Colour.white)]);
      }
    }
    _screen.refresh();
  }
}
