
import 'modifier.dart';

class Ch {

  final List<Modifier> modifiers;
  final int value;

  static final int transparent = 0000;

  Ch(this.value, [this.modifiers = const []]);

  @override
  int get hashCode => "Ch$value$modifiers".hashCode;

  @override
  bool operator== (dynamic other) {
    if (other is Ch) {
      return hashCode==other.hashCode;
    }
    return false;
  }

}