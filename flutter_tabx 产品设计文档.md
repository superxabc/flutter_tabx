# 📘 flutter_tabx 产品设计文档

---

## 目录

* [📌 产品定位说明](#-产品定位说明)
* [🎯 产品设计文档（Product Design Doc）](#-产品设计文档product-design-doc)

  * [1. 背景与目标](#1-背景与目标)
  * [2. 功能概览](#2-功能概览)
  * [3. 核心组件说明](#3-核心组件说明)
  * [4. 使用场景](#4-使用场景)
  * [5. 配置示例](#5-配置示例)
* [🧱 技术架构文档（Tech Architecture Doc）](#-技术架构文档tech-architecture-doc)

  * [1. 技术选型](#1-技术选型)
  * [2. 组件结构图](#2-组件结构图)
  * [3. 控制器设计 TabXController](#3-控制器设计-tabxcontroller)
  * [4. TabXBar 功能设计](#4-tabxbar-功能设计)
  * [5. TabXView 功能设计](#5-tabxview-功能设计)
  * [6. 使用边界与设计原则](#6-使用边界与设计原则)
  * [7. 发布与依赖管理](#7-发布与依赖管理)
* [🚀 后续规划与优化方向](#-后续规划与优化方向)

---

## 📌 产品定位说明

> `flutter_tabx` 是一个专注于“顶部频道切换”的 Flutter 组件库，封装了高可定制的 TabBar 与 TabView，适用于如资讯频道页、电商分类页等“页面内部的内容切换场景”。

> ❗**不适用于**页面级导航或底部导航（BottomTab），建议使用 Flutter 官方 `BottomNavigationBar` 或另行封装。

---

## 🎯 产品设计文档（Product Design Doc）

### 1. 背景与目标

Flutter 提供了原生的 `TabBar + TabBarView + TabController`，但实际开发中存在以下痛点：

* 样式拓展性不足（自定义指示器、标签复杂）
* 状态和交互逻辑耦合
* 与嵌套滚动、懒加载兼容性差
* 页面切换动画限制
* 缺乏生命周期钩子（如 onShow/onHide）

**目标：**
构建一套组件，支持灵活的频道切换样式、自定义动画、懒加载和页面缓存，兼容各种嵌套使用场景。

---

### 2. 功能概览

| 功能模块             | 说明                          |
| ---------------- | --------------------------- |
| `TabXBar`        | 渲染Tab标签，支持图标、文字、滑动、选中样式、指示器 |
| `TabXView`       | 内容容器，支持懒加载、缓存、切换动画、生命周期感知   |
| `TabXController` | 控制选中状态、跳转、监听变化              |
| `TabXItem`       | 单个标签项，支持 builder 构建         |
| `TabXIndicator`  | 自定义样式的滑动指示器，支持线条、块状、动画、渐变等  |

---

### 3. 核心组件说明

```dart
class TabXBar extends StatelessWidget { ... }
class TabXView extends StatefulWidget { ... }
class TabXController extends ChangeNotifier { ... }
class TabXItem extends StatelessWidget { ... }
class TabXIndicator extends StatelessWidget { ... }
```

---

### 4. 使用场景

| 场景                    | 支持情况 |
| --------------------- | ---- |
| 页面内频道切换               | ✅    |
| 顶部/中部/嵌套滚动容器中的 TabBar | ✅    |
| 滑动切换 + 动画             | ✅    |
| 指示器样式自定义              | ✅    |
| 横向/纵向Tab              | ✅    |
| 顶部吸附 + Sliver 支持      | ✅    |
| 页面缓存与懒加载              | ✅    |

---

### 5. 配置示例

```dart
final controller = TabXController(length: 3);

Column(
  children: [
    TabXBar(
      controller: controller,
      tabs: [
        TabXItem(text: '推荐', icon: Icons.star),
        TabXItem(text: '热点'),
        TabXItem(text: '关注'),
      ],
      indicator: TabXIndicator.underline(),
    ),
    Expanded(
      child: TabXView(
        controller: controller,
        lazyLoad: true,
        keepAlive: true,
        children: [
          RecommendPage(),
          HotPage(),
          FollowPage(),
        ],
      ),
    )
  ],
);
```

---
