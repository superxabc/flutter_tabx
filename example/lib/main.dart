import 'package:flutter/material.dart';
import 'package:flutter_tabx/flutter_tabx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TabX Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TabXController _controller;
  int _currentLength = 3;

  @override
  void initState() {
    super.initState();
    _controller = TabXController(length: _currentLength);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter TabX Demo'),
      ),
      body: Column(
        children: [
          TabXBar(
            controller: _controller,
            tabs: List.generate(
                _currentLength, (index) => TabXItem(text: 'Tab ${index + 1}')),
            isScrollable: true,
          ),
          Expanded(
            child: TabXView.builder(
              controller: _controller,
              itemCount: _currentLength,
              keepAlive: true,
              itemBuilder: (context, index) {
                return Center(
                  child: Text('Page ${index + 1}'),
                );
              },
              pageTransitionBuilder: (context, child, position) {
                final scale =
                    1.0 - position.abs() * 0.2; // Scale from 1.0 to 0.8
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (_currentLength > 1) {
                  _currentLength--;
                  _controller.updateLength(_currentLength);
                }
              });
            },
            heroTag: 'decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _currentLength++;
                _controller.updateLength(_currentLength);
              });
            },
            heroTag: 'increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
