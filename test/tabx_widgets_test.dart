import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tabx/flutter_tabx.dart';

void main() {
  group('TabXBar and TabXView', () {
    testWidgets('TabXBar and TabXView synchronize correctly',
        (WidgetTester tester) async {
      final controller = TabXController(length: 3);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Test App'),
            ),
            body: Column(
              children: [
                TabXBar(
                  controller: controller,
                  tabs: const [
                    TabXItem(text: 'Tab 1'),
                    TabXItem(text: 'Tab 2'),
                    TabXItem(text: 'Tab 3'),
                  ],
                ),
                Expanded(
                  child: TabXView(
                    controller: controller,
                    children: const [
                      Center(child: Text('Page 1')),
                      Center(child: Text('Page 2')),
                      Center(child: Text('Page 3')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Page 1'), findsOneWidget);
      expect(find.text('Page 2'),
          findsNothing); // Page 2 should not be visible initially

      // Tap on Tab 2
      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(controller.index, 1);
      expect(find.text('Page 2'), findsOneWidget);
      expect(find.text('Page 1'), findsNothing);

      // Swipe to Tab 3
      await tester.drag(find.text('Page 2'), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      expect(controller.index, 2);
      expect(find.text('Page 3'), findsOneWidget);
      expect(find.text('Page 2'), findsNothing);
    });

    testWidgets('TabXView.builder lazy loads correctly',
        (WidgetTester tester) async {
      final controller = TabXController(length: 3);
      final List<String> builtPages = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TabXView.builder(
              controller: controller,
              itemCount: 3,
              itemBuilder: (context, index) {
                builtPages.add('Page ${index + 1}');
                return Center(child: Text('Page ${index + 1}'));
              },
            ),
          ),
        ),
      );

      // Only the initial page should be built
      expect(builtPages, contains('Page 1'));
      // PageView preloads adjacent pages, so Page 2 might also be built
      expect(builtPages.length, lessThanOrEqualTo(2));

      // Swipe to the next page
      await tester.drag(find.text('Page 1'), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      expect(builtPages, contains('Page 2'));
      expect(builtPages.length, lessThanOrEqualTo(3));
    });

    testWidgets('Dynamic tab length updates correctly',
        (WidgetTester tester) async {
      final controller = TabXController(length: 2);

      await tester.pumpWidget(
        _TestApp(
          controller: controller,
          builder: (context, currentController) {
            return Column(
              children: [
                TabXBar(
                  controller: currentController,
                  tabs: List.generate(currentController.length,
                      (index) => TabXItem(text: 'Tab ${index + 1}')),
                ),
                Expanded(
                  child: TabXView.builder(
                    controller: currentController,
                    itemCount: currentController.length,
                    itemBuilder: (context, index) =>
                        Center(child: Text('Page ${index + 1}')),
                  ),
                ),
              ],
            );
          },
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsNothing);

      // Increase length
      controller.updateLength(3);
      await tester.pumpAndSettle(); // Pump to rebuild _TestApp with new length

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
      expect(controller.index, 0); // Should remain at 0 if within bounds

      // Decrease length, current index out of bounds
      controller.index = 2;
      controller.updateLength(1);
      await tester.pumpAndSettle(); // Pump to rebuild _TestApp with new length

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsNothing);
      expect(find.text('Tab 3'), findsNothing);
      expect(controller.index, 0); // Should adjust to 0
    });
  });
}

// Helper widget to rebuild its child when controller's length changes
class _TestApp extends StatefulWidget {
  final TabXController controller;
  final Widget Function(BuildContext context, TabXController controller)
      builder;

  const _TestApp({
    required this.controller,
    required this.builder,
  });

  @override
  State<_TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<_TestApp> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    // Only rebuild if the length changed, as index changes are handled internally by TabBar/PageView
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: widget.builder(context, widget.controller),
      ),
    );
  }
}
