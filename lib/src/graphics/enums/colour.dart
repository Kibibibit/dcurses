/// The colours that can be set using escape codes with
/// the [Modifier] object
class Colour {

  static final int _noColourFg = 38;
  static final int _noColourBg = 48;

  static final int _maxRGB = 5;
  static final int _maxGray = 23;

  final int code;
  final int r;
  final int g;
  final int b;
  final int gray;

  const Colour._(this.code,[this.r=0, this.g=0, this.b=0, this.gray=0]);

  static Colour standard(int code) {
    return Colour._(code);
  }

  static Colour expanded(int r, int g, int b) {
    int code = _noColourFg;
    if (r < 0 || r > _maxRGB) {
      throw Exception("r must be in range 0-5, not $r");
    }
    if (g < 0 || g > _maxRGB) {
      throw Exception("g must be in range 0-5, not $g");
    }
    if (b < 0 || b > _maxRGB) {
      throw Exception("b must be in range 0-5, not $b");
    }

    return Colour._(code,r,g,b);
  }

  static Colour grayscale(int v) {

    if (v > _maxGray) {
      throw Exception("gray must be in range 0-23, not $v");
    }

    return Colour._(_noColourFg, _maxRGB, _maxRGB, _maxRGB, v+1);
  }

  String toAnsi({bool fg = true}) {
    int out = fg ? code : code + 10;
    String outString = "$out";
    if (code == _noColourFg || code == _noColourBg) {
      int _r = r;
      int _g = g;
      int _b = b;
      int rgb = 16 + (36*_r) + (6*_g) + _b + gray;
      outString = "$out;5;$rgb";
    }
    return outString;
  }

  @override
  int get hashCode => "$code$r$g$b$gray".hashCode;

  @override
  bool operator==(Object other) {
    if (other is Colour) {
      return other.hashCode == hashCode;
    }
    return false;
  }

  static const List<Colour> defaults = [
    red,
    brightred,
    orange,
    brightorange,
    green,
    brightgreen,
    cyan,
    brightcyan,
    blue,
    brightblue,
    magenta,
    brightmagenta,
    brightwhite,
    white,
    brightblack,
    black
  ];

  static const Colour black = Colour._(30);
  static const Colour red = Colour._(31);
  static const Colour green = Colour._(32);
  static const Colour orange = Colour._(33);
  static const Colour blue = Colour._(34);
  static const Colour magenta = Colour._(35);
  static const Colour cyan = Colour._(36);
  static const Colour white = Colour._(37);

  static const Colour brightblack = Colour._(90);
  static const Colour brightred = Colour._(91);
  static const Colour brightgreen = Colour._(92);
  static const Colour brightorange = Colour._(93);
  static const Colour brightblue = Colour._(94);
  static const Colour brightmagenta = Colour._(95);
  static const Colour brightcyan = Colour._(96);
  static const Colour brightwhite = Colour._(97);
  
}
