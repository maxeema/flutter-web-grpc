///
/// Copyright 2024 (c) Max Shemetov, https://github.com/maxeema
///
import 'package:dart_client_grpc_demo/generated/protos/hello.pbgrpc.dart';
import 'package:grpc/grpc.dart';

Future<void> main(List<String> args) async {
  print('> Start (an insecure, without any authorization)');
  print(' Preparing ClientChannel()...');
  final channel = ClientChannel(
    'localhost',
    // A direct port or a local grpc server (according to the project definition)
    // In production it is normally 443, but we are on a local machine as an example.
    port: 50051,
    // The Envoy's 50052 port on a local machine (according to the project definition)
    // You can just uncomment and test, but there is no need because this port
    // is for web-grpc calls primarily that don't work with a direct grpc port.
    // port: 50052,
    options: ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );

  print(' Preparing GreeterClient()...');
  final client = GreeterClient(channel);

  final name = args.isNotEmpty ? args[0] : 'dart';

  try {
    print(' Calling grpc method: client.sayHello()...');
    final response = await client.sayHello(
      HelloRequest()..name = name,
      // options: CallOptions(compression: const GzipCodec()),
    );
    print(' :) Got response: ${response.message}');
  } catch (e) {
    print(' :( Got error: $e');
  } finally {
    print(' Calling channel.shutdown()...');
    await channel.shutdown().then((_) {}, onError: (e) {
      print(' Failed to shutdown the channel! Error is: $e');
    });
  }
  print('> End');
}
