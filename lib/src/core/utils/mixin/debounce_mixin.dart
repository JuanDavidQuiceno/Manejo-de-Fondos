import 'dart:async';

/// Debounce Mixin
///
/// Provides debounce functionality for text field changes and search
/// operations.
/// Helps prevent excessive API calls or validations while user is typing.
///
/// Example usage:
/// ```dart
/// class MyWidgetState extends State<MyWidget> with DebounceMixin {
///   @override
///   void initState() {
///     super.initState();
///     _controller.addListener(() => _onTextChanged(_controller.text));
///   }
///
///   void _onTextChanged(String value) {
///     debounce(
///       duration: const Duration(milliseconds: 500),
///       callback: () => _validate(value),
///     );
///   }
///
///   @override
///   void dispose() {
///     cancelDebounce();
///     _controller.dispose();
///     super.dispose();
///   }
/// }
/// ```
mixin DebounceMixin {
  Timer? _debounceTimer;

  /// Executes a callback after a debounce delay.
  /// Cancels any pending debounce timer before starting a new one.
  ///
  /// [duration] - The delay before executing the callback
  /// [callback] - The function to execute after the delay
  void debounce({
    required Duration duration,
    required void Function() callback,
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, callback);
  }

  /// Cancels any pending debounce timer.
  /// Should be called in dispose() to prevent memory leaks.
  void cancelDebounce() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }
}
