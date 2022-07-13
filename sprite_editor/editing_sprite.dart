
import 'package:dcurses/dcurses.dart';

class EditingSprite {

  int columns;
  int lines;
  late List<List<Ch>> data;

  static EditingSprite loadSprite(Sprite sprite) {
    return EditingSprite(sprite.columns, sprite.lines, sprite.data);
  }

  EditingSprite(this.columns, this.lines, List<List<Ch>>? data) {
    this.data = data ?? List.generate(lines, (_) => List.generate(columns, (_) => Ch(Ch.transparent)));
  }


}