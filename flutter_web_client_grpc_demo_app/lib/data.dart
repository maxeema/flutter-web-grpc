
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:signals/signals.dart';

import 'generated/protos/hello.pbgrpc.dart';

var _counter = 1;

final grpcData = futureSignal(() => callGrpc(['flutter', '$_counter']));

Future<String> callGrpc(List<String> args) async {
  print('callGrpc()...');
  // emulate some network delay
  await Future.delayed(const Duration(milliseconds: 1000));
  // lets go
  final channel = GrpcOrGrpcWebClientChannel.toSingleEndpoint(
    host: 'localhost',
    // A dedicated Envoy port for the web-grpc calls assuming that Envoy is ran
    // according to the project's README.
    port: 50052,
    transportSecure: false,
  );
  final stub = GreeterClient(channel);
  final name = args.isNotEmpty ? args.join(' ') : 'flutter';
  try {
    final response = await stub.sayHello(
      HelloRequest()..name = name,
      options: CallOptions(
        // Note! If a server supports GzipCodec compression enable it here,
        // but not all services support it, so you might remove/comment this.
        compression: const GzipCodec(),
      ),
    );
    print('Greeter client received: ${response.message}');
    _counter++;
    return response.message;
  } catch (e) {
    print('Caught error: $e');
    rethrow;
  } finally {
    await channel.shutdown();
  }
}