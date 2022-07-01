import '../graphics/ch/ch.dart';
import 'constants.dart';

List<List<Ch>> emptyBuffer(int lines, int columns) => List.generate(lines, (_) => List.generate(columns, (_)=>Constants.blank));