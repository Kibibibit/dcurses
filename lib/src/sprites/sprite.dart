import '../graphics/ch/ch.dart';

class Sprite {
  late List<List<Ch>> _data;
  late int x, y;
  late int _lines, _columns;

  Sprite(this.x, this.y, List<List<Ch>> data) {
    _lines = data.length;
    _columns = data.first.length;
    _data = data;
  }

  int get lines => _lines;
  int get columns => _columns;
  List<List<Ch>> get data => _data;
}
