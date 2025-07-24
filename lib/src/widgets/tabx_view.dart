import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../controller/tabx_controller.dart';

/// A builder function for creating pages on demand in [TabXView.builder].
typedef TabXViewItemBuilder = Widget Function(BuildContext context, int index);

/// A builder function for creating custom page transition animations in [TabXView].
typedef TabXViewPageTransitionBuilder = Widget Function(
    BuildContext context, Widget child, double position);

/// A content view that synchronizes with a [TabXController] and displays
/// pages corresponding to the selected tab.
///
/// [TabXView] supports lazy loading, page caching, dynamic tab counts,
/// and custom page transition animations.
class TabXView extends StatefulWidget {
  /// The controller that manages the selected tab index and total tab count.
  final TabXController controller;

  /// The list of widgets to display as pages.
  /// This constructor is used when you have a fixed list of children.
  /// Cannot be used with [itemBuilder] and [itemCount].
  final List<Widget>? children;

  /// A builder function for creating pages on demand.
  /// This constructor is used for lazy loading and dynamic page generation.
  /// Cannot be used with [children].
  final TabXViewItemBuilder? itemBuilder;

  /// The total number of pages when using [itemBuilder].
  /// Must be provided when using the [TabXView.builder] constructor.
  final int? itemCount;

  /// Whether to keep the state of the pages alive when they are not visible.
  /// Defaults to `false`.
  final bool keepAlive;

  /// How the page view scrolls.
  /// Defaults to [AlwaysScrollableScrollPhysics].
  final ScrollPhysics? physics;

  /// A builder function for creating custom page transition animations.
  /// The [position] parameter indicates the scroll position of the page,
  /// ranging from -1.0 (off-screen left) to 1.0 (off-screen right).
  final TabXViewPageTransitionBuilder? pageTransitionBuilder;

  /// Creates a [TabXView] with a fixed list of children.
  const TabXView({
    super.key,
    required this.controller,
    required this.children,
    this.keepAlive = false,
    this.physics,
    this.pageTransitionBuilder,
  })  : itemBuilder = null,
        itemCount = null,
        assert(children != null);

  /// Creates a [TabXView] with a builder function for lazy loading pages.
  const TabXView.builder({
    super.key,
    required this.controller,
    required this.itemBuilder,
    required this.itemCount,
    this.keepAlive = false,
    this.physics,
    this.pageTransitionBuilder,
  })  : children = null,
        assert(itemBuilder != null && itemCount != null);

  @override
  State<TabXView> createState() => _TabXViewState();
}

class _TabXViewState extends State<TabXView>
    with AutomaticKeepAliveClientMixin {
  late PageController _pageController;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void initState() {
    super.initState();
    _pageController = _createPageController();
    widget.controller.addListener(_onTabXControllerChanged);
  }

  PageController _createPageController() {
    return PageController(initialPage: widget.controller.index);
  }

  void _onTabXControllerChanged() {
    if (widget.controller.length !=
        (_pageController.hasClients
            ? _pageController.page?.round()
            : widget.controller.length)) {
      // If length changes, dispose and recreate PageController
      _pageController.dispose();
      setState(() {
        _pageController = _createPageController();
      });
    } else if (_pageController.hasClients &&
        _pageController.page?.round() != widget.controller.index) {
      _pageController.animateToPage(
        widget.controller.index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  void didUpdateWidget(covariant TabXView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onTabXControllerChanged);
      widget.controller.addListener(_onTabXControllerChanged);
      _onTabXControllerChanged(); // Check for changes immediately
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabXControllerChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    if (widget.children != null) {
      return PageView(
        controller: _pageController,
        physics: widget.physics,
        onPageChanged: (index) {
          widget.controller.index = index;
        },
        children: widget.children!.map((child) {
          Widget pageChild = child;
          if (widget.keepAlive) {
            pageChild = AutomaticKeepAlive(child: pageChild);
          }
          if (widget.pageTransitionBuilder != null) {
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, _) {
                final double currentPage = _pageController.page ??
                    _pageController.initialPage.toDouble();
                final double position =
                    (widget.children!.indexOf(child).toDouble() - currentPage)
                        .clamp(-1.0, 1.0);
                return widget.pageTransitionBuilder!(
                    context, pageChild, position);
              },
            );
          }
          return pageChild;
        }).toList(),
      );
    }

    // Use PageView.builder when itemBuilder is provided
    return PageView.builder(
      controller: _pageController,
      physics: widget.physics,
      itemCount: widget.itemCount,
      onPageChanged: (index) {
        widget.controller.index = index;
      },
      itemBuilder: (context, index) {
        Widget child = widget.itemBuilder!(context, index);

        if (widget.keepAlive) {
          child = AutomaticKeepAlive(child: child);
        }

        if (widget.pageTransitionBuilder != null) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, _) {
              final double currentPage =
                  _pageController.page ?? index.toDouble();
              final double position =
                  (index.toDouble() - currentPage).clamp(-1.0, 1.0);
              return widget.pageTransitionBuilder!(context, child, position);
            },
          );
        }

        return child;
      },
    );
  }
}
