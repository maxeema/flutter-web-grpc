///
/// Copyright 2024 (c) Max Shemetov, https://github.com/maxeema
///
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import 'data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'flutter_web_client_grpc_demo_app'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    grpcData.listen(context, () {
      if (grpcData.value.hasError && !grpcData.value.isLoading) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
                content: Text('Please, ensure that grpc server is ran.\n'
                    'It is located in the "dart_server_grpc_demo" folder.')),
          );
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: Watch((context) {
                return grpcData.value.map(
                  loading: () => const Text('Loading gRPC response...'),
                  reloading: () => const Text('Reloading gRPC response...'),
                  refreshing: () => const Text('Refreshing gRPC response...'),
                  data: (data) => Text(
                    'gRPC response: $data',
                    textAlign: TextAlign.center,
                  ),
                  error: (error) {
                    print('error, signalGrpcData.value: ${grpcData.value}');
                    print(
                        'error, signalGrpcData.previousValue: ${grpcData.previousValue}');
                    return Text('Caught error! $error');
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: grpcData.refresh,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
