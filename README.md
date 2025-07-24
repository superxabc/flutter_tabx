# flutter_tabx

`flutter_tabx` 是一个 Flutter 组件库，专注于为“页面内部内容切换”场景（如资讯流、电商分类等）提供高度可定制的 TabBar 和 TabView。它 **不适用** 于页面级导航或底部导航栏。

## 核心特性

-   **状态管理**: 通过 `TabXController` 进行集中式状态管理。
-   **真正的懒加载**: `TabXView` 支持 `builder` 模式，实现页面按需构建，优化内存使用。
-   **动态增删 Tab**: `TabXController` 支持动态修改标签数量，`TabXBar` 和 `TabXView` 会自动适应。
-   **自定义页面切换动画**: `TabXView` 提供 `pageTransitionBuilder` 属性，允许开发者自定义页面间的过渡动画。
-   **页面缓存**: 子页面可以保持活动状态（keep alive），以在切换标签时保留其状态。
-   **可定制化 UI**: `TabXBar` 支持高度自定义，并自动适应主题。

## 安装

在 `pubspec.yaml` 文件的 `dependencies` 部分添加 `flutter_tabx`，通过 Git 引用：

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_tabx:
    git:
      url: https://github.com/superxabc/flutter_tabx.git
      ref: main # 或者您希望引用的分支/标签/提交哈希
```

然后运行 `flutter pub get`。

## 使用示例

`flutter_tabx` 的核心是 `TabXController`、`TabXBar` 和 `TabXView`。

### 基本用法

```dart
import 'package:flutter/material.dart';
import 'package:flutter_tabx/flutter_tabx.dart';

class BasicUsageExample extends StatefulWidget {
  const BasicUsageExample({super.key});

  @override
  State<BasicUsageExample> createState() => _BasicUsageExampleState();
}

class _BasicUsageExampleState extends State<BasicUsageExample> {
  late TabXController _tabXController;

  @override
  void initState() {
    super.initState();
    _tabXController = TabXController(length: 3);
  }

  @override
  void dispose() {
    _tabXController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabX Basic Example'),
        bottom: TabXBar(
          controller: _tabXController,
          tabs: const [
            TabXItem(text: 'Tab 1'),
            TabXItem(text: 'Tab 2'),
            TabXItem(text: 'Tab 3'),
          ],
        ),
      ),
      body: TabXView(
        controller: _tabXController,
        children: const [
          Center(child: Text('Content of Tab 1')),
          Center(child: Text('Content of Tab 2')),
          Center(child: Text('Content of Tab 3')),
        ],
      ),
    );
  }
}
```

### 懒加载 (Lazy Loading)

使用 `TabXView.builder` 构造函数实现页面内容的懒加载，这对于包含大量页面的场景非常有用。

```dart
import 'package:flutter/material.dart';
import 'package:flutter_tabx/flutter_tabx.dart';

class LazyLoadingExample extends StatefulWidget {
  const LazyLoadingExample({super.key});

  @override
  State<LazyLoadingExample> createState() => _LazyLoadingExampleState();
}

class _LazyLoadingExampleState extends State<LazyLoadingExample> {
  late TabXController _tabXController;
  final int _tabCount = 10; // 假设有10个Tab

  @override
  void initState() {
    super.initState();
    _tabXController = TabXController(length: _tabCount);
  }

  @override
  void dispose() {
    _tabXController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabX Lazy Loading Example'),
        bottom: TabXBar(
          controller: _tabXController,
          isScrollable: true, // 当Tab数量多时，设置为可滚动
          tabs: List.generate(_tabCount, (index) => TabXItem(text: 'Tab ${index + 1}')),
        ),
      ),
      body: TabXView.builder(
        controller: _tabXController,
        itemCount: _tabCount,
        itemBuilder: (context, index) {
          // 只有当页面可见时才构建其内容
          print('Building page ${index + 1}');
          return Center(child: Text('Content of Tab ${index + 1}'));
        },
        keepAlive: true, // 保持页面状态，切换回来时不会重新构建
      ),
    );
  }
}
```

### 动态增删 Tab

`TabXController` 允许您在运行时动态更改 Tab 的数量。

```dart
import 'package:flutter/material.dart';
import 'package:flutter_tabx/flutter_tabx.dart';

class DynamicTabsExample extends StatefulWidget {
  const DynamicTabsExample({super.key});

  @override
  State<DynamicTabsExample> createState() => _DynamicTabsExampleState();
}

class _DynamicTabsExampleState extends State<DynamicTabsExample> {
  late TabXController _tabXController;
  int _currentTabCount = 3;

  @override
  void initState() {
    super.initState();
    _tabXController = TabXController(length: _currentTabCount);
  }

  @override
  void dispose() {
    _tabXController.dispose();
    super.dispose();
  }

  void _addTab() {
    setState(() {
      _currentTabCount++;
      _tabXController.updateLength(_currentTabCount);
    });
  }

  void _removeTab() {
    if (_currentTabCount > 1) {
      setState(() {
        _currentTabCount--;
        _tabXController.updateLength(_currentTabCount);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabX Dynamic Tabs Example'),
        bottom: TabXBar(
          controller: _tabXController,
          tabs: List.generate(_currentTabCount, (index) => TabXItem(text: 'Tab ${index + 1}')),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabXView.builder(
              controller: _tabXController,
              itemCount: _currentTabCount,
              itemBuilder: (context, index) => Center(child: Text('Content of Tab ${index + 1}')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _addTab,
                  child: const Text('Add Tab'),
                ),
                ElevatedButton(
                  onPressed: _removeTab,
                  child: const Text('Remove Tab'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 自定义页面切换动画

通过 `TabXView` 的 `pageTransitionBuilder` 属性可以实现自定义的页面过渡动画。

```dart
import 'package:flutter/material.dart';
import 'package:flutter_tabx/flutter_tabx.dart';
import 'dart:math' as math;

class CustomTransitionExample extends StatefulWidget {
  const CustomTransitionExample({super.key});

  @override
  State<CustomTransitionExample> createState() => _CustomTransitionExampleState();
}

class _CustomTransitionExampleState extends State<CustomTransitionExample> {
  late TabXController _tabXController;

  @override
  void initState() {
    super.initState();
    _tabXController = TabXController(length: 3);
  }

  @override
  void dispose() {
    _tabXController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabX Custom Transition Example'),
        bottom: TabXBar(
          controller: _tabXController,
          tabs: const [
            TabXItem(text: 'Tab A'),
            TabXItem(text: 'Tab B'),
            TabXItem(text: 'Tab C'),
          ],
        ),
      ),
      body: TabXView(
        controller: _tabXController,
        children: const [
          Center(child: Text('Page A')),
          Center(child: Text('Page B')),
          Center(child: Text('Page C')),
        ],
        pageTransitionBuilder: (context, child, position) {
          // 示例：旋转过渡动画
          final rotation = Tween<double>(begin: 0.0, end: math.pi / 2).transform(position.abs());
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(position < 0 ? rotation : -rotation),
            alignment: position < 0 ? Alignment.centerRight : Alignment.centerLeft,
            child: child,
          );
        },
      ),
    );
  }
}
```

## 运行测试

要运行 `flutter_tabx` 的测试，请在项目根目录下执行以下命令：

```bash
flutter test
```

这将运行 `test/tabx_controller_test.dart` 和 `test/tabx_widgets_test.dart` 中的所有测试。

## 贡献

欢迎贡献！如果您有任何功能请求或错误报告，请在 GitHub 仓库中提交 Issue 或 Pull Request。

**GitHub 仓库**: [https://github.com/superxabc/flutter_tabx](https://github.com/superxabc/flutter_tabx)