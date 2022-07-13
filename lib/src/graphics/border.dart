import '../utils/code_unit_of.dart';
import 'ch/ch.dart';
import 'ch/modifier.dart';

/// Represents a border around a [Window]. Each of the [Ch] objects
/// making up each part of the border can be set, and the border can have a
/// list of [Modifier]s
class Border {
  static Border blank([List<Modifier> modifiers = const[]]) => Border(" ", " ", " ", " ", " ", " ", " ", " ", modifiers);
  static Border thin([List<Modifier> modifiers = const[]]) => Border("─", "─", "│", "│", "┌", "┐", "└", "┘", modifiers);
  static Border rounded([List<Modifier> modifiers = const[]]) => Border("─", "─", "│", "│", "╭", "╮", "╰", "╯", modifiers);
  static Border thick([List<Modifier> modifiers = const[]]) => Border("━","━","┃","┃","┏","┓","┗","┛",modifiers);
  static Border double([List<Modifier> modifiers = const[]]) => Border("═","═","║","║","╔","╗","╚","╝",modifiers);

  /// The modifiers that will be applied to the border
  late final List<Modifier> modifiers;

  /// `th`, `bh`, `lv`, `rv`, `tl`, `tr`, `bl` and `br` each represent
  /// a character that makes up the border.
  /// 
  /// ```
  ///       th
  /// tl +------+ tr
  ///    |      |
  /// lv |      | rv
  ///    |      |
  /// bl +------+ br
  ///       bh
  /// ```
  late final Ch th, bh, lv, rv, tl, tr, bl, br;

  Border(String th, String bh, String lv, String rv, String tl, String tr,
      String bl, String br, [this.modifiers = const []]) {
    this.th = Ch(codeUnitOf(th),modifiers);
    this.bh = Ch(codeUnitOf(bh),modifiers);
    this.lv = Ch(codeUnitOf(lv),modifiers);
    this.rv = Ch(codeUnitOf(rv),modifiers);
    this.tl = Ch(codeUnitOf(tl),modifiers);
    this.tr = Ch(codeUnitOf(tr),modifiers);
    this.bl = Ch(codeUnitOf(bl),modifiers);
    this.br = Ch(codeUnitOf(br),modifiers);
  }
}
