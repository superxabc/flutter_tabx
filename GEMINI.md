# Gemini 项目概述: flutter_tabx

## 1. 项目摘要

`flutter_tabx` 是一个 Flutter 组件库，专注于为“页面内部内容切换”场景（如资讯流、电商分类等）提供高度可定制的 TabBar 和 TabView。它 **不适用** 于页面级导航或底部导航栏。

## 2. 核心组件

项目包含以下主要组件：

- **`TabXController`**: 基于 `ChangeNotifier` 的控制器，用于管理标签状态、处理标签页切换并监听变更。
- **`TabXBar`**: 负责渲染标签页的组件。它支持自定义样式、指示器和布局（水平及垂直）。
- **`TabXView`**: 显示所选标签对应页面的内容容器。它支持懒加载、状态缓存 (`keepAlive`) 和自定义过渡动画。
- **`TabXItem`**: 代表单个标签项，可以使用构建器（builder）进行自定义。

## 3. 关键特性

- **状态管理**: 通过 `TabXController` 进行集中式状态管理。
- **真正的懒加载**: `TabXView` 支持 `builder` 模式，实现页面按需构建，优化内存使用。
- **动态增删 Tab**: `TabXController` 支持动态修改标签数量，`TabXBar` 和 `TabXView` 会自动适应。
- **自定义页面切换动画**: `TabXView` 提供 `pageTransitionBuilder` 属性，允许开发者自定义页面间的过渡动画。
- **页面缓存**: 子页面可以保持活动状态（keep alive），以在切换标签时保留其状态。
- **可定制化 UI**: `TabXBar` 支持高度自定义，并自动适应主题。
- **生命周期钩子**: 为子页面提供了解其何时可见的钩子（例如 `onTabVisible`）。

## 4. 技术栈与依赖

- **语言**: Dart
- **框架**: Flutter
- **状态管理**: `ChangeNotifier`
- **核心依赖**:
  - `flutter/sdk`

## 5. 如何运行测试

项目计划为以下领域编写单元测试（注意：具体的测试命令尚未定义）：

- **控制器逻辑**: 验证 `TabXController` 中的状态变更。
- **视图行为**: 测试 `TabXView` 中的 `lazyLoad` 和 `keepAlive` 功能。
- **UI 渲染**: 确保 `TabXBar` 能根据控制器状态正确渲染。
- **指示器动画**: 测试指示器位置与标签变化的同步性。

## 6. 代码风格与约定

- 遵循标准的 Dart 和 Flutter 社区代码风格指南。
- 架构强调在 UI (`TabXBar`, `TabXView`)、状态 (`TabXController`) 和数据模型之间保持清晰的关注点分离。