
import '../enums/colour.dart';
import '../enums/decoration.dart';

///Represents an escape code that can applied to a [Ch]
///
///Any escape code can be added through its' default constructor,
///or you can use any of the static methods for some pre-set ones
class Modifier {

  /// The actual escape code this modifier represents
  final String escapeCode;

  static final String _g = "\x1b[";

  /// Creates a modifier object with a pre-set escape code
  Modifier(this.escapeCode);

  /// Creates an escape code that will set the foreground color of a [Ch]
  static Modifier fg(Colour colour) {
    return Modifier("$_g${colour.toAnsi()}m");
  }

  /// Creates an escape code that will set the background color of a [Ch]
  static Modifier bg(Colour colour) {
    return Modifier("$_g${colour.toAnsi(fg:false)}m");
  }

  /// Creates an escape code that can set a decoration of a [Ch], such as
  /// bold or underlined
  static Modifier decoration(Decoration decoration) {
    return Modifier("$_g${_dec(decoration)}m");
  }

  /// Creates an escape code that can set the foreground and background color of a [Ch]
  static Modifier colour({Colour fg = Colour.brightwhite, Colour bg = Colour.black}) {
    return Modifier("\x1b[${fg.toAnsi()};${bg.toAnsi(fg:false)}m");
  }

  @override
  String toString() {
    return escapeCode;
  }


  static int _dec(Decoration decoration) {
    switch (decoration) {
      
      case Decoration.bold: return 1;
      case Decoration.faint: return 2;
      case Decoration.italic: return 3;
      case Decoration.underline: return 4;
      case Decoration.blinking: return 5;
      case Decoration.inverse: return 7;
      case Decoration.hidden: return 8;
      case Decoration.strikethrough: return 9;
    }
  }

}