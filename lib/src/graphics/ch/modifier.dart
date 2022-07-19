
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
    return Modifier("$_g${_fg(colour)}m");
  }

  /// Creates an escape code that will set the background color of a [Ch]
  static Modifier bg(Colour colour) {
    return Modifier("$_g${_bg(colour)}m");
  }

  /// Creates an escape code that can set a decoration of a [Ch], such as
  /// bold or underlined
  static Modifier decoration(Decoration decoration) {
    return Modifier("$_g${_dec(decoration)}m");
  }

  /// Creates an escape code that can set the foreground and background color of a [Ch]
  static Modifier colour({Colour fg = Colour.brightwhite, Colour bg = Colour.black}) {
    return Modifier("\x1b[${_fg(fg)};${_bg(bg)}m");
  }

  @override
  String toString() {
    return escapeCode;
  }

  

  static int _fg(Colour colour) {
    switch (colour) {
      case Colour.black: return 30;
      case Colour.red: return 31;
      case Colour.green: return 32;
      case Colour.orange: return 33;
      case Colour.blue: return 34;
      case Colour.magenta: return 35;
      case Colour.cyan: return 36;
      case Colour.white: return 37;
      case Colour.brightblack: return 90;
      case Colour.brightred: return 91;
      case Colour.brightgreen: return 92;
      case Colour.brightorange: return 93;
      case Colour.brightblue: return 94;
      case Colour.brightpurple: return 95;
      case Colour.brightcyan: return 96;
      case Colour.brightwhite: return 97;
    }
  }

  static int _bg(Colour colour) {
    switch (colour) {
      case Colour.black: return 40;
      case Colour.red: return 41;
      case Colour.green: return 42;
      case Colour.orange: return 43;
      case Colour.blue: return 44;
      case Colour.magenta: return 45;
      case Colour.cyan: return 46;
      case Colour.white: return 47;
      case Colour.brightblack: return 100;
      case Colour.brightred: return 101;
      case Colour.brightgreen: return 102;
      case Colour.brightorange: return 103;
      case Colour.brightblue: return 104;
      case Colour.brightpurple: return 105;
      case Colour.brightcyan: return 106;
      case Colour.brightwhite: return 107;
    }
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