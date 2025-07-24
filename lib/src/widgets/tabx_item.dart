import 'package:flutter/material.dart';

/// Represents a single tab item to be used within a [TabXBar].
///
/// A [TabXItem] can display text, an icon, or a custom child widget.
/// It is typically used to define the appearance of individual tabs in the tab bar.
class TabXItem extends StatelessWidget {
  /// The text to display on the tab.
  final String? text;

  /// The icon to display on the tab.
  final Widget? icon;

  /// A custom child widget to display on the tab.
  /// If [child] is provided, [text] and [icon] will be ignored.
  final Widget? child;

  /// Creates a [TabXItem].
  ///
  /// At least one of [text], [icon], or [child] must be non-null.
  const TabXItem({super.key, this.text, this.icon, this.child})
      : assert(text != null || icon != null || child != null);

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return child!;
    }

    return Tab(
      text: text,
      icon: icon,
    );
  }
}
