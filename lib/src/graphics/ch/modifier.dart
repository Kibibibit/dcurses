
import '../enums/colour.dart';
import '../enums/decoration.dart';

class Modifier {
  final String escapeCode;

  static final String _g = "\x1b[";

  Modifier(this.escapeCode);

  static Modifier fg(Colour colour) {
    return Modifier("$_g${_fg(colour)}m");
  }

  static Modifier bg(Colour colour) {
    return Modifier("$_g${_bg(colour)}m");
  }

  static Modifier decoration(Decoration decoration) {
    return Modifier("$_g${_dec(decoration)}m");
  }

  static Modifier colour({Colour fg = Colour.white, Colour bg = Colour.black}) {
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
      case Colour.lightgray: return 37;
      case Colour.gray: return 90;
      case Colour.darkred: return 91;
      case Colour.darkgreen: return 92;
      case Colour.yellow: return 93;
      case Colour.darkblue: return 94;
      case Colour.purple: return 95;
      case Colour.darkcyan: return 96;
      case Colour.white: return 97;
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
      case Colour.lightgray: return 47;
      case Colour.gray: return 100;
      case Colour.darkred: return 101;
      case Colour.darkgreen: return 102;
      case Colour.yellow: return 103;
      case Colour.darkblue: return 104;
      case Colour.purple: return 105;
      case Colour.darkcyan: return 106;
      case Colour.white: return 107;
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