class Key {
  static final String upArrow = "KEY_UP_ARROW";
  static final String downArrow = "KEY_DOWN_ARROW";
  static final String leftArrow = "KEY_LEFT_ARROW";
  static final String rightArrow = "KEY_RIGHT_ARROW";
  static final String home = "KEY_HOME";
  static final String end = "KEY_END";
  static final String delete = "KEY_DELETE";
  static final String pageUp = "KEY_PAGE_UP";
  static final String pageDown = "KEY_PAGE_DOWN";
  static final String unknown = "KEY_UNKNOWN";

  static final int multibyteHeader = 27;

  static final int _special = 91;
  static final Set<int> fourByteKeys = {51, 53, 54};

  static String getKey(List<int> keys) {
    return _keys[keys[1]]?[keys[2]] ?? Key.unknown;
  }

  static final Map<int, Map<int, String>> _keys = {
    _special: {
      51: Key.delete,
      53: Key.pageUp,
      54: Key.pageDown,
      65: Key.upArrow,
      66: Key.downArrow,
      67: Key.rightArrow,
      68: Key.leftArrow,
      70: Key.home,
      72: Key.end
    },
  };
}
