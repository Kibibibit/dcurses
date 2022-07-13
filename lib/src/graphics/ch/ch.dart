
import 'modifier.dart';

/// Represents a single character on the terminal.
/// 
/// Can contain as many modifiers as you want, but only a single unicode value.
class Ch {

  /// The modifiers that will be applied to this [Ch]
  final List<Modifier> modifiers;
  /// The value of the character that it will display
  final int value;

  /// This is treated as a transparent tile, and will be ignored
  /// if trying to draw over another non-transparent [Ch]
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