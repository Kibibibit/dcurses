import 'package:dcurses/dcurses.dart';

void main() {
  Screen screen = Screen();

  Window testWindow = Window("test", 5, 5, 10, 5)..border=Border.double();

  screen.addWindow(testWindow);
  screen.refresh();

  while (true) {
    testWindow.cx = 1;
    testWindow.cy = 1;
    String key = screen.getch();
    if (key == Key.leftArrow) {
      testWindow.x--;
    } else if (key == Key.rightArrow) {
      testWindow.x++;
    } else if (key == Key.upArrow) {
      testWindow.y--;
    } else if (key == Key.downArrow) {
      testWindow.y++;
    }
    testWindow.addStr("${key.codeUnits}");
    screen.refresh();
  }



  
}
