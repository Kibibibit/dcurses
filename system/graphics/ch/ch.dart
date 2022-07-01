
import 'modifier.dart';

class Ch {

  final List<Modifier> modifiers;
  final int value;

  Ch(this.value, [this.modifiers = const []]);

  @override
  bool operator== (dynamic other) {
    if (other is Ch) {
      return value == other.value;
    }
    return false;
  }

}