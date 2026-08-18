import 'package:cs_elective_2/data/fruits.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FruitListPage extends StatelessWidget {
  const FruitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruits'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: fruits.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final fruit = fruits[index];
          return ListTile(
            leading: Text(
              fruit.emoji,
              style: const TextStyle(fontSize: 32),
            ),
            title: Text(
              fruit.name[0].toUpperCase() + fruit.name.substring(1),
            ),
            subtitle: Text(fruit.description),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/fruit/${fruit.name}'),
          );
        },
      ),
    );
  }
}
