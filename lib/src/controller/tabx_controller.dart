import 'package:flutter/foundation.dart';

/// A controller for [TabXBar] and [TabXView] that manages the selected tab index
/// and the total number of tabs.
///
/// This controller extends [ChangeNotifier], allowing it to notify its listeners
/// (typically [TabXBar] and [TabXView]) when the selected index or the total
/// length of tabs changes.
class TabXController extends ChangeNotifier {
  int _length;
  int _index;

  /// Creates a [TabXController].
  ///
  /// The [length] parameter specifies the total number of tabs. It must be greater than 0.
  /// The [initialIndex] parameter specifies the initially selected tab index.
  /// It must be within the range [0, length - 1].
  TabXController({required int length, int initialIndex = 0})
      : assert(length > 0),
        assert(initialIndex >= 0 && initialIndex < length),
        _length = length,
        _index = initialIndex;

  /// The total number of tabs.
  ///
  /// This value can be updated dynamically using [updateLength].
  int get length => _length;

  /// The currently selected tab index.
  ///
  /// Setting a new index will notify listeners and cause [TabXBar] and [TabXView]
  /// to update their displayed content.
  int get index => _index;

  set index(int newIndex) {
    if (newIndex >= 0 && newIndex < _length && _index != newIndex) {
      _index = newIndex;
      notifyListeners();
    }
  }

  /// Updates the total number of tabs.
  ///
  /// When the length changes, if the current [index] is out of bounds,
  /// it will be adjusted to the last valid index.
  /// This method notifies listeners, causing [TabXBar] and [TabXView] to rebuild
  /// their internal controllers to reflect the new tab count.
  void updateLength(int newLength) {
    if (_length != newLength) {
      _length = newLength;
      if (_index >= _length) {
        _index = _length - 1;
      }
      notifyListeners();
    }
  }

  /// Jumps to the specified tab [index] without animation.
  ///
  /// This is a convenience method that simply sets the [index] property.
  void jumpTo(int index) {
    this.index = index;
  }

  /// Jumps to the next tab.
  ///
  /// If the current tab is the last one, it will loop back to the first tab.
  void next() {
    index = (_index + 1) % _length;
  }

  /// Jumps to the previous tab.
  ///
  /// If the current tab is the first one, it will loop back to the last tab.
  void previous() {
    index = (_index - 1 + _length) % _length;
  }
}
