import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState(); // 1
}

class _CounterPageState extends State<CounterPage> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    print('initState — runs ONCE, when State object is created'); // 2
    // good place for: subscriptions, controllers, one-time setup
  }

  @override
  Widget build(BuildContext context) {
    print('build — runs on EVERY rebuild'); // 3
    return Scaffold(
      appBar: AppBar(automaticallyImplyActions: true),
      body: Center(child: Text('Count: $count')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // 4
            count++;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    print('dispose — runs ONCE, when State is removed forever'); // 5
    // cleanup: cancel subscriptions, dispose controllers
    super.dispose();
  }
}
