///
/// Copyright 2024 (c) Max Shemetov, https://github.com/maxeema
///
import 'package:dart_client_grpc_demo/generated/protos/hello.pbgrpc.dart';
import 'package:grpc/grpc.dart';

Future<void> main(List<String> args) async {
  print('> Start (a secure example that uses JWT authorization');
  print(' Preparing channel...');
  final channel = ClientChannel(
    // A host name without http or https where grpc server is ran
    'your-domain.com',
    // In production it is normally 443, but we are on a local machine as an example.
    port: 443,
    options: ChannelOptions(
      credentials: ChannelCredentials.secure(),
    ),
  );

  print(' Preparing client...');
  const jwtToken = 'PUT_YOUR_JWT_TOKEN_HERE';
  final client = GreeterClient(
    channel,
    options: CallOptions(
      metadata: {'authorization': 'Bearer $jwtToken'},
    ),
  );

  final name = args.isNotEmpty ? args[0] : 'dart';

  try {
    print(' Calling grpc method...');
    final response = await client.sayHello(
      HelloRequest()..name = name,
    );
    print(' :) Got grpc response: ${response.message}');
  } catch (e) {
    print(' :( Got error: $e');
  } finally {
    print(' Shutting down the channel...');
    await channel.shutdown().then((_) {}, onError: (e) {
      print(' Failed to shutdown the channel! Error is: $e');
    });
  }
  print('> End');
}
