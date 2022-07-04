

import 'dart:io';

import 'package:dcurses/dcurses.dart';

void main() async {


  Screen screen = Screen();

  screen.clear();
  screen.refresh();

  for (int i = 0; i < 4; i++) {
    String value = screen.getch();
    stdout.writeln(value);
  }
  


}