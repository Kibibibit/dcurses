import '../../dcurses.dart';


class Window {
  static int _lastZ = 0;

  late int lines, columns;
  late int x, y;

  late List<List<Ch>> _buffer;
  late List<List<Ch>> _lastBuffer;
  int cy = 1;
  int cx = 1;
  int z = ++_lastZ;

  String label;

  Screen? screen;

  Border? border;

  bool borderFirst = false;

  Window(this.label, this.y, this.x, this.columns, this.lines) {
    _buffer = emptyBuffer(lines, columns);
    _lastBuffer = emptyBuffer(lines, columns);
  }


  List<List<Ch>> get buffer => _genBuffer(_buffer);
  List<List<Ch>> get lastBuffer => _genBuffer(_lastBuffer);

  
  void resize() {}

  bool onScreen(int y, int x) =>
      (x < columns) && (x >= 0) && y < lines && y >= 0;

  List<List<Ch>> _genBuffer(List<List<Ch>> b) {

    List<List<Ch>>? out;

    if (borderFirst) {
      out = _addBorder(b);
    }
    out = cloneList(out ?? b);
    if (!borderFirst) {
      out = _addBorder(out);
    }
    
    return out;
  }

  List<List<Ch>> _addBorder(List<List<Ch>> b) {
    List<List<Ch>> out = cloneList(b);
    if (border != null) {
      for (int x = 0; x < columns; x++) {
        out[0][x] = border!.th;
        out[lines - 1][x] = border!.bh;
      }
      for (int y = 0; y < lines; y++) {
        out[y][0] = border!.lv;
        out[y][columns - 1] = border!.rv;
      }
      out[0][0] = border!.tl;
      out[0][columns - 1] = border!.tr;
      out[lines - 1][0] = border!.bl;
      out[lines - 1][columns - 1] = border!.br;
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

  void add(Ch ch) {
    if (onScreen(cy, cx)) {
      _buffer[cy][cx] = ch;
    }
  }

  void remove() {
    if (onScreen(cy, cx)) {
      _buffer[cy][cx] = Ch(_buffer[cy][cx].value, [Modifier.decoration(Decoration.hidden)]);
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
      cx = x;
      cy++;
      if (!onScreen(cy, cx)) {
        cy--;
        break;
      }
    }
  }

  void updateBuffer() {
    for (int y = 0; y < lines; y++) {
      for (int x = 0; x < columns; x++) {
        _lastBuffer[y][x] = _buffer[y][x];
      }
    }
  }
}
