///
/// Copyright 2024 (c) Max Shemetov, https://github.com/maxeema
///
import 'package:grpc/grpc.dart';
import 'package:dart_server_grpc_demo/generated/protos/hello.pbgrpc.dart';

class GreeterService extends GreeterServiceBase {
  @override
  Future<HelloReply> sayHello(ServiceCall call, HelloRequest request) async {
    print('called sayHello() with request.name = ${request.name}');
    return HelloReply()..message = 'Hello, ${request.name}!';
  }

  @override
  Future<HelloReply> sayHelloAgain(ServiceCall call, HelloRequest request) async {
    print('called sayHelloAgain() with request.name = ${request.name}');
    return HelloReply()..message = 'Hello again, ${request.name}!';
  }
}

Future<void> main(List<String> args) async {
  final server = Server.create(
    services: [GreeterService()],
    codecRegistry: CodecRegistry(codecs: const [GzipCodec(), /*IdentityCodec()*/]),
  );
  await server.serve(port: 50051);
  print('Server listening on port ${server.port}...');
}

