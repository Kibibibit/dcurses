
import 'package:dcurses/src/utils/cloneable.dart';

import 'is_subtype.dart';

List<T> cloneList<T>(List<T> list) {

  if (isSubtype<T,Cloneable>()) {
    return _cloneList(list as List<Cloneable>) as List<T>;
  }
  return List.generate(list.length, (index) {
      if (T is List) {
        return cloneList(list[index] as List) as T;
      } else {
        return list[index];
      }
    });
}


List<Cloneable> _cloneList(List<Cloneable> list) => List.generate(list.length, (index) => (list[index].clone()));
