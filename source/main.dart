import 'package:flutter/material.dart';
import 'package:solid_annotations/extensions.dart';
import 'package:solid_annotations/solid_annotations.dart';

final routes = <String, WidgetBuilder>{
  '/state': (_) => CounterPage(),
  '/effect': (_) => EffectExample(),
  '/query': (_) => QueryExample(),
};

final routeToNameRegex = RegExp('(?:^/|-)([a-zA-Z])');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solid Demo',
      home: const MainPage(),
      routes: routes,
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: routes.length,
        itemBuilder: (BuildContext context, int index) {
          final route = routes.keys.elementAt(index);

          final name = route.replaceAllMapped(
            routeToNameRegex,
            (match) => match.group(0)!.substring(1).toUpperCase(),
          );

          return Material(
            child: ListTile(
              title: Text(name),
              onTap: () {
                Navigator.of(context).pushNamed(route);
              },
            ),
          );
        },
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  CounterPage({super.key});

  // @SolidState(name: 'customName')
  @SolidState()
  int counter = 0;

  @SolidState()
  int get doubleCounter => counter * 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Computed')),
      body: Center(
        child: Text('Counter: $counter, DoubleCounter: $doubleCounter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter++,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EffectExample extends StatelessWidget {
  EffectExample({super.key});

  @SolidState()
  int counter = 0;

  @SolidEffect()
  void logCounter() {
    print('Counter changed: $counter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Effect')),
      body: Center(child: Text('Counter: $counter')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter++,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class QueryExample extends StatelessWidget {
  QueryExample({super.key});

  @SolidState()
  String? userId;

  @SolidState()
  String? authToken;

  @SolidQuery()
  Future<String?> fetchData() async {
    if (userId == null || authToken == null) return null;
    await Future<void>.delayed(const Duration(seconds: 1));
    return 'Fetched Data for $userId';
  }

  // @SolidQuery(debounce: Duration(seconds: 1))

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Query')),
      body: Center(
        child: Column(
          spacing: 8,
          children: [
            const Text('Complex SolidQuery example'),
            fetchData().when(
              ready: (data) {
                if (data == null) {
                  return const Text('No user ID provided');
                }
                return Text(data);
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
          authToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
