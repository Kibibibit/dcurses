import 'dart:async';
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


  late StreamSubscription _streamSubscription;

  late Completer _completer;

  Screen() {
    _lines = stdout.terminalLines;
    _columns = stdout.terminalColumns;
    stdscr = Window(stdscrLabel, 0, 0, _columns, _lines);
    _buffer = emptyBuffer(_lines, _columns);
    _lastBuffer = emptyBuffer(_lines, _columns);
    stdin.echoMode = false;
    stdin.lineMode = false;
    _completer = Completer();
    hideCursor();
    clear();
    refresh();

  }

  Future<void> run() async {
    _streamSubscription = stdin.listen((event) =>_onKey(event));
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

  Set<String> get windows => _windows.keys.toSet();

  void addWindow(Window window) {
    window.screen = this;
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

  void _onKey(List<int> codes) {
    _completer.complete(Key.fromCodes(codes));
    _completer = Completer();
  }

  Future<Key> getch() async {    
    return await _completer.future.then((value) => value);
  }

  void close() {
    _streamSubscription.cancel();
  }
}
