

import 'dart:io';

import '../graphics/ch/ch.dart';
import '../graphics/ch/modifier.dart';
import 'sprite.dart';

class SpriteManager {

  static final String _spriteFolder = "sprites/";
  static final String _ext = ".sprite";

  static late Map<String, List<List<Ch>>> _spriteData;

  SpriteManager();

  static void load() {
    _spriteData = {};
    Directory dir = Directory(_spriteFolder);
    dir.listSync().forEach((element)  {
      if (element is File && element.path.endsWith(_ext)) {
        
        String parentName = element.parent.absolute.path + "/";
        String spriteName = element.absolute.path;
        String name = spriteName.split(parentName)[1].split(_ext).first;
        print("Adding $name");

        File file = File(spriteName);
        List<String> lines = file.readAsLinesSync();
        _spriteData[name] = _makeSpriteData(lines);

      }
    });
  }

  static List<List<Ch>> _makeSpriteData(List<String> raw) {
    List<String> size = raw.first.split(";");
    int columns = int.parse(size.first);
    int lines = int.parse(size.last);

    raw = raw.sublist(1);

    List<List<Ch>> data = [];

    for (int line = 0; line < lines; line++) {
      List<Ch> lineData = [];
      for (int column = 0; column < columns; column ++) {
        Modifier mod = Modifier(raw.first.replaceFirst("\\", "\x1b"));
        raw = raw.sublist(1);
        lineData.add(Ch(int.parse(raw.first, radix:16), [mod]));
        raw = raw.sublist(1);
      }
      if (raw.length > 1) {
        raw = raw.sublist(1);
      }
      
      data.add(lineData);
    }

    return data;
  }

  static Sprite? get(String name, [int y = 0, int x = 0]) {
    return _spriteData[name] != null ? Sprite(y, x, _spriteData[name]!) : null;
  }

}