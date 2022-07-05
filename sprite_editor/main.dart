


import 'editor.dart';

Future main() async{

  Editor editor = Editor();

  await editor.run();

  editor.close();

}
