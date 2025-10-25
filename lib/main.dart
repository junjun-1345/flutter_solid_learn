import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';

final routes = <String, WidgetBuilder>{
  '/state': (_) => const CounterPage(),
  '/effect': (_) => const EffectExample(),
  '/query': (_) => const QueryExample(),
};

final routeToNameRegex = RegExp('(?:^/|-)([a-zA-Z])');

void main() {
  SolidartConfig.autoDispose = false;
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

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final counter = Signal<int>(0, name: 'counter');
  late final doubleCounter = Computed<int>(
    () => counter.value * 2,
    name: 'doubleCounter',
  );

  @override
  void dispose() {
    counter.dispose();
    doubleCounter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Computed')),
      body: Center(
        child: SignalBuilder(
          builder: (context, child) {
            return Text(
              'Counter: ${counter.value}, DoubleCounter: ${doubleCounter.value}',
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.value++,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EffectExample extends StatefulWidget {
  const EffectExample({super.key});

  @override
  State<EffectExample> createState() => _EffectExampleState();
}

class _EffectExampleState extends State<EffectExample> {
  final counter = Signal<int>(0, name: 'counter');
  late final logCounter = Effect(() {
    print('Counter changed: ${counter.value}');
  }, name: 'logCounter');

  @override
  void initState() {
    super.initState();
    logCounter;
  }

  @override
  void dispose() {
    counter.dispose();
    logCounter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Effect')),
      body: SignalBuilder(
        builder: (context, child) {
          return Center(child: Text('Counter: ${counter.value}'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.value++,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class QueryExample extends StatefulWidget {
  const QueryExample({super.key});

  @override
  State<QueryExample> createState() => _QueryExampleState();
}

class _QueryExampleState extends State<QueryExample> {
  final userId = Signal<String?>(null, name: 'userId');
  final authToken = Signal<String?>(null, name: 'authToken');
  late final fetchData = Resource<String?>(
    () async {
      if (userId.value == null || authToken.value == null) return null;
      await Future<void>.delayed(const Duration(seconds: 1));
      return 'Fetched Data for ${userId.value}';
    },
    source: Computed(
      () => (userId.value, authToken.value),
      name: 'fetchDataSource',
    ),
    name: 'fetchData',
  );

  @override
  void dispose() {
    userId.dispose();
    authToken.dispose();
    fetchData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Query')),
      body: Center(
        child: Column(
          spacing: 8,
          children: [
            const Text('Complex SolidQuery example'),
            SignalBuilder(
              builder: (context, child) {
                return fetchData().when(
                  ready: (data) {
                    if (data == null) {
                      return const Text('No user ID provided');
                    }
                    return Text(data);
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error: $error'),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userId.value = 'user_${DateTime.now().millisecondsSinceEpoch}';
          authToken.value = 'token_${DateTime.now().millisecondsSinceEpoch}';
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
