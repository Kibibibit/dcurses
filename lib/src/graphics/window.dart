

import '../../dcurses.dart';

class Window {

  static int _lastZ = 0;

  late int _lines, _columns;
  late int x, y;

  late List<List<Ch>> _buffer;
  late List<List<Ch>> _lastBuffer;
  int cy = 1;
  int cx = 1;
  int z = ++_lastZ;

  String label;

  Screen? screen;

  Border? border;

  Window(this.label, this.y, this.x, int columns, int lines) {
    _lines = lines;
    _columns = columns;
    _buffer = emptyBuffer(lines, columns);
    _lastBuffer = emptyBuffer(lines, columns);
    
  }

  int get lines => _lines;
  int get columns => _columns;


  List<List<Ch>> get buffer => _genBuffer(_buffer);
  List<List<Ch>> get lastBuffer => _genBuffer(_lastBuffer);

  

  bool onScreen(int y, int x) =>
      (x < columns) && (x >= 0) && y < lines && y >= 0;

  List<List<Ch>> _genBuffer(List<List<Ch>> b) {
    List<List<Ch>> out = cloneList(b);

    if (border != null) {
      for (int x = 0; x < _columns; x++) {
        _buffer[0][x] = border!.th;
        _buffer[_lines-1][x] = border!.bh;
      }
      for (int y = 0; y < _lines; y++) {
        _buffer[y][0] = border!.lv;
        _buffer[y][_columns-1] = border!.rv;
      }
      _buffer[0][0] = border!.tl;
      _buffer[0][_columns -1] = border!.tr;
      _buffer[_lines-1][0] = border!.bl;
      _buffer[_lines-1][_columns-1] = border!.br;
    }

    return out;
  }

  void clear() {
    _buffer = emptyBuffer(lines, columns);
    _lastBuffer = emptyBuffer(lines, columns);
  }

  void addStr(String string, [List<Modifier> modifiers = const []]) {
    for (int c in string.codeUnits) {
      Ch ch = Ch(c, modifiers);
      if (onScreen(cy, cx)) {
        _buffer[cy][cx] = ch;
        cx++;
        if (!onScreen(cy, cx)) {
          cx--;
          break;
        }
      }
    }
  }

  void addSprite(Sprite sprite) {
    int x = cx;
    for (List<Ch> line in sprite.data) {
      for (Ch ch in line) {
        if (onScreen(cy, cx)) {
          _buffer[cy][cx] = ch;
          cx++;
        }
      }
      cx=x;
      cy++;
      if (!onScreen(cy, cx)) {
        cy--;
        break;
      }
    }
  }

  void updateBuffer() {
    for (int y = 0; y < _lines; y++) {
      for (int x = 0; x < _columns; x++) {
        _lastBuffer[y][x] = _buffer[y][x];
      }
    }
  }
  
}