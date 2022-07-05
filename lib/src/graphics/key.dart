import 'dart:convert';

class Key {

  static final String _unknown = "KEY_UNKNOWN";    

  static const Key tab = Key._([0x09], "KEY_TAB");
  static const Key enter = Key._([0x0A], "KEY_ENTER");
  static const Key esc = Key._([0x1b], "KEY_ESCAPE");
  static const Key backspace = Key._([0x7f], "KEY_BACKSPACE");
  static const Key delete = Key._([0x1b, 0x5b, 0x33, 0x7e], "KEY_DELETE");

  static const Key pageUp = Key._([0x1b, 0x5b, 0x35, 0x7e], "KEY_PAGE_UP");
  static const Key pageDown = Key._([0x1b, 0x5b, 0x36, 0x7e], "KEY_PAGE_DOWN");

  static const Key upArrow = Key._([0x1b, 0x5b, 0x41], "KEY_UP_ARROW");
  static const Key downArrow = Key._([0x1b, 0x5b, 0x42], "KEY_DOWN_ARROW");
  static const Key rightArrow = Key._([0x1b, 0x5b, 0x43], "KEY_RIGHT_ARROW");
  static const Key leftArrow = Key._([0x1b, 0x5b, 0x44], "KEY_LEFT_ARROW"); 

  static const Key end = Key._([0x1b, 0x5b, 0x46], "KEY_END");
  static const Key home = Key._([0x1b, 0x5b, 0x48], "KEY_HOME");

  static const Key f1 = Key._([0x1b, 0x4f, 0x50], "KEY_F1");
  static const Key f2 = Key._([0x1b, 0x4f, 0x51], "KEY_F2");
  static const Key f3 = Key._([0x1b, 0x4f, 0x52], "KEY_F3");
  static const Key f4 = Key._([0x1b, 0x4f, 0x53], "KEY_F4");
  
  final String string;
  final List<int> codes;
  
  const Key._(this.codes, this.string);

  static Key fromChar(String char) {
    return fromCodes(char.codeUnits);
  }

  static Key fromCodes(List<int> codes) {
    int first = codes.first;
    int len = codes.length;

    late String string;
    if (len == 1 && ((first > 0x01 && first < 0x20) || first == 0x7f)) {
      string = _actionMap[first] ?? _unknown;
    } else if (len > 1 && first == 0x1b) {
      if (len >= 3) {
        string = _multibyteMap[codes[1]]?[codes[2]] ?? _unknown;
      }
    } else {
      string = utf8.decode(codes);
    }

    return Key._(codes, string);
  }

  @override
  int get hashCode => "$string$codes".hashCode;

  @override
  bool operator==(Object other) {
    if (other is Key) {
      return other.hashCode == hashCode;
    }
    return false;
  }
}

Map<int, String> _actionMap ={
  0x09: Key.tab.string,
  0x0A: Key.enter.string,
  0x1b: Key.esc.string,
  0x7f: Key.backspace.string
};

Map<int, Map<int, String>> _multibyteMap = {
  0x5b: {
    0x33: Key.delete.string,
    0x35: Key.pageUp.string,
    0x36: Key.pageDown.string,
    0x41: Key.upArrow.string,
    0x42: Key.downArrow.string,
    0x43: Key.rightArrow.string,
    0x44: Key.leftArrow.string,
    0x46: Key.end.string,
    0x48: Key.home.string,
  },
  0x4F: {
    0x50: Key.f1.string,
    0x51: Key.f2.string,
    0x52: Key.f3.string,
    0x53: Key.f4.string
  }
};