import 'package:cs_elective_2/data/fruits.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FruitDetailPage extends StatelessWidget {
  const FruitDetailPage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final fruit = fruitByName(name);

    if (fruit == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Not found'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No fruit matched that name.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to list'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(fruit.name[0].toUpperCase() + fruit.name.substring(1)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Color(fruit.color).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  fruit.emoji,
                  style: const TextStyle(fontSize: 120),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                fruit.name[0].toUpperCase() + fruit.name.substring(1),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                fruit.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to fruits'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
