/// The decorations that can be set in escape codes using
/// the [Modifier] object
enum Decoration {
  /// Sets the text to be bold
  bold,
  /// In theory should make the text fainter, however this will not be visible
  /// on all terminals
  faint,
  /// Sets the text to be faint
  italic,
  /// Sets the text to be underlined
  underline,
  /// This will make the text blink visible and invisible
  blinking,
  /// Inverts the foreground and background colours
  inverse,
  /// Hides the text
  hidden,
  /// Places a strikethrough through the text
  strikethrough
}