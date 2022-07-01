import '../graphics/ch/ch.dart';

class Sprite {
  late List<List<Ch>> _data;
  late int _x, _y;
  late int _lines, _columns;

  Sprite(int y, int x, List<List<Ch>> data) {
    _x = x;
    _y = y;
    _lines = data.length;
    _columns = data.first.length;
    _data = data;
  }

  int get x => _x;
  void set x(int x) => _x = x;

  int get y => _y;
  void set y(int y) => _y = y;

  int get lines => _lines;
  int get columns => _columns;
  List<List<Ch>> get data => _data;
}
