import 'dart:io';
import 'package:dcurses/src/graphics/key.dart';

import '../utils/empty_buffer.dart';
import 'ch/ch.dart';
import 'ch/modifier.dart';
import 'window.dart';

class Screen {
  static final String stdscrLabel = ":::STDSCR:::";
  final Map<String, Window> _windows = {};

  late final Window stdscr;
  late final int _lines, _columns;

  late List<List<Ch>> _buffer;
  late List<List<Ch>> _lastBuffer;

  int get lines => _lines;
  int get columns => _columns;

  Screen() {
    _lines = stdout.terminalLines;
    _columns = stdout.terminalColumns;
    stdscr = Window(stdscrLabel, 0, 0, _columns, _lines);
    _buffer = emptyBuffer(_lines, _columns);
    _lastBuffer = emptyBuffer(_lines, _columns);
    stdin.echoMode = false;
    stdin.lineMode = false;
    hideCursor();
    clear();
    refresh();
  }

  List<Window> _sortWindows() {
    List<Window> windows = _windows.values.toList();
    windows.sort(((a, b) => a.z.compareTo(b.z)));
    return windows;
  }

  bool _onScreen(int y, int x) => stdscr.onScreen(y, x);

  Window? get(String label) {
    return _windows[label];
  }

  void addWindow(Window window) {
    _windows[window.label] = window;
  }

  void showCursor() {
    stdout.write('\x1b[?25h');
  }

  void hideCursor() {
    stdout.write('\x1b[?25l');
  }

  void clear() {
    _lastBuffer = emptyBuffer(lines, columns);
    _buffer = emptyBuffer(lines, columns);
    stdout.write('\x1b[H\x1b[2J\x1b[0m');
  }

  String getch([int buffers = 1]) {
    List<int> codes = [];
    while (buffers > 0) {
      int byte = stdin.readByteSync();
      // If the first byte is 27, we will be getting a few more bytes
      if (byte == Key.multibyteHeader) {
        buffers = 3;
      }
      // If the key is page up/down or delete, we're going to get a final trailing 126 which we can't use
      if (Key.fourByteKeys.contains(byte)) {
        stdin.readByteSync();
      }
      buffers--;
      codes.add(byte);
    }
    if (codes.length > 1) {
      String out = Key.getKey(codes);
      if (out == Key.unknown) {
        return getch();
      }
      return out;
    } else {
      return String.fromCharCodes(codes);
    }
  }

  void refresh() {
    List<Window> windows = _sortWindows();

    windows.insert(0, stdscr);

    for (Window window in windows) {
      for (int y = 0; y < window.lines; y++) {
        for (int x = 0; x < window.columns; x++) {
          int xx = window.x + x;
          int yy = window.y + y;

          if (_onScreen(yy, xx)) {
            _buffer[yy][xx] = window.buffer[y][x];
          }
        }
      }

      window.updateBuffer();
    }

    for (int y = 0; y < _lines; y++) {
      for (int x = 0; x < _columns; x++) {
        if (_lastBuffer[y][x] != _buffer[y][x] &&
            _buffer[y][x].value != Ch.transparent) {
          stdout.write('\x1b[${y + 1};${x + 1}H');
          for (Modifier mod in _buffer[y][x].modifiers) {
            stdout.write(mod.escapeCode);
          }
          stdout.writeCharCode(_buffer[y][x].value);
          stdout.write('\x1b[0m');
        }
        _lastBuffer[y][x] = _buffer[y][x];
      }
    }
  }
}