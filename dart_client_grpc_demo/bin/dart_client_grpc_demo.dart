///
/// Copyright 2024 (c) Max Shemetov, https://github.com/maxeema
///
import 'package:grpc/grpc.dart';
import 'package:dart_client_grpc_demo/generated/protos/hello.pbgrpc.dart';

Future<void> main(List<String> args) async {
  final channel = ClientChannel(
    'localhost',
    port: 50051, // direct
//    port: 50052, // proxy
    options: ChannelOptions(
      credentials: ChannelCredentials.insecure(),
      codecRegistry:
          CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
    ),
  );
  final stub = GreeterClient(channel);

  final name = args.isNotEmpty ? args[0] : 'dart';

  try {
    final response = await stub.sayHello(
      HelloRequest()..name = name,
      options: CallOptions(compression: const GzipCodec()),
    );
    print('Greeter client received: ${response.message}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}


