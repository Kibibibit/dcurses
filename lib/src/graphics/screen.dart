import 'dart:async';
import 'dart:io';
import 'package:dcurses/src/graphics/key.dart';
import 'package:dcurses/src/graphics/stdscr.dart';

import '../utils/empty_buffer.dart';
import 'ch/ch.dart';
import 'ch/modifier.dart';
import 'window.dart';

class Screen {
  static final String stdscrLabel = ":::STDSCR:::";
  final Map<String, Window> _windows = {};

  late final Window stdscr;
  late int _lines, _columns;

  late List<List<Ch>> _buffer;
  late List<List<Ch>> _lastBuffer;

  int get lines => _lines;
  int get columns => _columns;

  bool _usingListener = false;

  bool _running = false;

  bool get usingListener => _usingListener;

  late StreamSubscription _streamSubscription;
  late StreamSubscription _sigintSub;
  late StreamSubscription _sigwinchSub;
  late Completer _completer;

  StreamController<Key>? _streamController;

  Screen() {
    _lines = stdout.terminalLines;
    _columns = stdout.terminalColumns;
    stdscr = Stdscr(stdscrLabel, 0, 0, _columns, _lines);
    stdscr.screen = this;
    _buffer = emptyBuffer(_lines, _columns);
    _lastBuffer = emptyBuffer(_lines, _columns);
    stdin.echoMode = false;
    stdin.lineMode = false;
    _completer = Completer();

    clear();
    refresh();
  }

  void disableBlocking() {
    if (_running) {
      throw Exception(
          "The screen is already running and cannot disable blocking calls now");
    }
    if (_usingListener) {
      print("Alreading using listener!");
      return;
    }
    _streamController = StreamController.broadcast();
    _usingListener = true;
  }

  StreamSubscription<Key> listen(void Function(Key) onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    if (!_usingListener) {
      throw Exception(
          "The screen is in blocking mode so listeners cannot be used");
    }
    return _streamController!.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  Future<void> run() async {
    hideCursor();
    _running = true;
    _streamSubscription = stdin.listen((event) => usingListener
        ? _onKeyListen(Key.fromCodes(event))
        : _onKeyBlocking(event));
    _sigintSub = ProcessSignal.sigint.watch().listen((event) {
      close();
      exit(0);
    });
    _sigwinchSub = ProcessSignal.sigwinch.watch().listen(_onSigwinch);
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

  void _onSigwinch(ProcessSignal signal) {
    bool resize = false;
    if (_lines != stdout.terminalLines) {
      _lines = stdout.terminalLines;
      resize = true;
    }
    if (_columns != stdout.terminalColumns) {
      _columns = stdout.terminalColumns;
      resize = true;
    }
    if (resize) {
      clear();
      stdscr.resize(_lines,_columns);
      for (Window window in _windows.values) {
        window.resize(_lines,_columns);
      }
      refresh();
    }
  }

  void addWindow(Window window) {
    window.screen = this;
    _windows[window.label] = window;
  }

  void removeWindow(String label) {
    if (_windows.containsKey(label)) {
      _windows.remove(label);
    }
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
        if (_lastBuffer[y][x] != _buffer[y][x]) {
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

  void _onKeyBlocking(List<int> codes) {
    _completer.complete(Key.fromCodes(codes));
    _completer = Completer();
  }

  void _onKeyListen(Key key) {
    _streamController!.sink.add(key);
  }

  Future<Key> getch() async {
    if (!_running) {
      throw Exception("Screen isn't running yet!!");
    }
    if (usingListener) {
      throw Exception(
          "Getch is not avaiable when using non-blocking listeners");
    }
    return await _completer.future.then((value) => value);
  }

  void close() {
    if (_usingListener) {
      _streamController!.close();
    }
    _sigintSub.cancel();
    _sigwinchSub.cancel();
    _streamSubscription.cancel();
    clear();
    showCursor();
  }
}
