import 'package:flutter/material.dart';

import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

import 'package:flutter_web_client_grpc_demo_app/generated/protos/hello.pbgrpc.dart';

void main() {
  runApp(const MyApp());
}

Future<String> callGrpc(List<String> args) async {
  print('callGrpc()...');
  final channel = GrpcOrGrpcWebClientChannel.toSingleEndpoint(
    host:'localhost',
//    port: 50051, // direct
    port: 50052, // proxy
    transportSecure: false,
  );
  final stub = GreeterClient(channel);
  final name = args.isNotEmpty ? args.join(' ') : 'flutter';
  try {
    final response = await stub.sayHello(
      HelloRequest()..name = name,
      options: CallOptions(compression: const GzipCodec()),
    );
    print('Greeter client received: ${response.message}');
    return response.message;
  } catch (e) {
    print('Caught error: $e');
    return '$e';
  } finally {
    await channel.shutdown();
  }
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  
  String? grpcResponse;
  Object? key;
  
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      _executeCallGrpc();
    });
  }
  
  _executeCallGrpc() {
    _counter++;
    key = Object();
    final keyRef = key;
    setState(() => grpcResponse = null);
    callGrpc(['flutter', '$_counter']).then((response) async {
      await Future.delayed(Duration(seconds:1));
      if (mounted && key == keyRef) {
        setState(() => grpcResponse = response);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                grpcResponse ?? 'Waiting for gRPC response',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _executeCallGrpc,
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
