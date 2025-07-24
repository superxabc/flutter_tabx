import 'package:flutter/material.dart';
import '../controller/tabx_controller.dart';
import 'tabx_item.dart';

/// A highly customizable TabBar widget that synchronizes with a [TabXController].
///
/// [TabXBar] is designed to work in conjunction with [TabXView] to provide
/// a flexible and dynamic tab-based navigation experience.
/// It supports dynamic tab counts, custom indicators, and theme adaptation.
class TabXBar extends StatefulWidget implements PreferredSizeWidget {
  /// The controller that manages the selected tab index and total tab count.
  final TabXController controller;

  /// The list of [TabXItem] widgets to display as tabs.
  /// The length of this list should match the `controller.length`.
  final List<TabXItem> tabs;

  /// The decoration for the tab indicator.
  /// If null, a default [UnderlineTabIndicator] will be used, adapting to the current theme.
  final Decoration? indicator;

  /// The color of the selected tab's label.
  /// If null, it defaults to `Theme.of(context).tabBarTheme.labelColor`.
  final Color? labelColor;

  /// The color of the unselected tab's label.
  /// If null, it defaults to `Theme.of(context).tabBarTheme.unselectedLabelColor`.
  final Color? unselectedLabelColor;

  /// Whether the tab bar should be scrollable.
  /// If true, tabs will not be compressed when there are many of them.
  final bool isScrollable;

  /// The background color of the tab bar.
  /// If null, it defaults to `Theme.of(context).canvasColor`.
  final Color? backgroundColor;

  /// Creates a [TabXBar].
  const TabXBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.indicator,
    this.labelColor,
    this.unselectedLabelColor,
    this.isScrollable = false,
    this.backgroundColor,
  });

  @override
  State<TabXBar> createState() => _TabXBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TabXBarState extends State<TabXBar> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = _createTabController();
    widget.controller.addListener(_onTabXControllerChanged);
  }

  TabController _createTabController() {
    return TabController(
      length: widget.controller.length,
      vsync: this,
      initialIndex: widget.controller.index,
    );
  }

  void _onTabXControllerChanged() {
    if (widget.controller.length != _tabController.length) {
      _tabController.dispose();
      setState(() {
        _tabController = _createTabController();
      });
    } else if (widget.controller.index != _tabController.index) {
      _tabController.animateTo(widget.controller.index);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabXControllerChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabBarTheme = theme.tabBarTheme;

    return Material(
      color: widget.backgroundColor ?? theme.canvasColor,
      child: TabBar(
        controller: _tabController,
        tabs: widget.tabs,
        indicator: widget.indicator ??
            UnderlineTabIndicator(
              borderSide: BorderSide(
                color: theme.indicatorColor,
                width: 2.0,
              ),
            ),
        labelColor: widget.labelColor ?? tabBarTheme.labelColor,
        unselectedLabelColor:
            widget.unselectedLabelColor ?? tabBarTheme.unselectedLabelColor,
        isScrollable: widget.isScrollable,
        onTap: (index) {
          widget.controller.index = index;
        },
      ),
    );
  }
}
