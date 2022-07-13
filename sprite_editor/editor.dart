import 'package:dcurses/dcurses.dart';

import 'editing_sprite.dart';
import 'editor_mode.dart';
import 'tool.dart';
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

  Tool tool = Tool.pencil;

  bool running = false;
  bool _exploring = false;

  String? focusedWindow = "mainwindow";

  final Map<Key, String> _hotkeys = {};

  EditorMode editorMode = EditorMode.focused;

  EditingSprite? editingSprite;

  Editor() {
    _focusX = 1;
    _focusY = 1;
    _screen = Screen();
    _topBar = TopBar(this, "topbar", 0, 0, _screen.columns, _topBarHeight)
      ..border = Border.thin();
    _toolWindow = ToolWindow(this, "toolwindow", _topBarHeight, 0,
        _toolWindowWidth, _screen.lines - _topBarHeight)
      ..border = Border.rounded();
    _mainWindow = MainWindow(
        this,
        "mainwindow",
        _topBarHeight,
        _toolWindowWidth,
        _screen.columns - _toolWindowWidth - _paletteWindowWidth,
        _screen.lines - _topBarHeight)
      ..border = Border.double();
    _paletteWindow = PaletteWindow(
        this,
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
        Set<Key> keys = ((_screen.get(w) as EditorWindow).getHotkeys());
        for (Key key in keys) {
          _hotkeys[key] = w;
        }
        (_screen.get(w) as EditorWindow).drawWindow();
      }
    }

    _screen.refresh();
  }

  Future<void> run() async {
    _screen.run();
    running = true;
    while (running) {
      if (_exploring) {
        
        return;
      }
      _focus();
      Key key = await _screen.getch();

      if (key == Key.home && focusedWindow != _mainWindow.label) {
        editorMode = EditorMode.focused;
        focusedWindow = _mainWindow.label;
        _focusX = 1;
        _focusY = 1;
        continue;
      }

      if (_hotkeys.containsKey(key)) {
        Window? w = _screen.get(_hotkeys[key] ?? "");
        if (w != null && w is EditorWindow) {
          (w).onHotkey(key);
          w.drawWindow();
          _screen.refresh();
          continue;
        }
      }

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

  void _unfocused(Key key) {
    if (key == Key.upArrow) {
      _focusY--;
    } else if (key == Key.downArrow) {
      _focusY++;
    } else if (key == Key.leftArrow) {
      if (_focusY == 1) {
        _focusX--;
      }
    } else if (key == Key.rightArrow) {
      if (_focusY == 1) {
        _focusX++;
      }
    } else if (key == Key.enter) {
      editorMode = EditorMode.focused;
      return;
    } else {
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

  void _focused(Key key) {
    if (key == Key.esc) {
      editorMode = EditorMode.unfocused;
      return;
    }
    if (focusedWindow != null) {
      Window? w = _screen.get(focusedWindow!);
      if (w != null && w is EditorWindow) {
        w.onKey(key);
        w.drawWindow();
        _screen.refresh();
      }
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
        _screen.get(window)!.border = Border.thin([
          Modifier.fg(
              editorMode == EditorMode.unfocused ? Colour.gray : Colour.white)
        ]);
      }
    }
    _screen.refresh();
  }

  void close() {
    _screen.close();
  }
}
