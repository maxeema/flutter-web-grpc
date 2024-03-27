# flutter-web-grpc sample

<b>Flutter Web gRPC sample</b> (Dart gRPC-backend, Flutter Web front-end)

<h3>Problem (still reproduces on Flutter 3.19.4)</h3>
In Flutter Web app normal gRPC calls fails when interract directly with a gRPC server. To make it work we will use Envoy.

<h3>About the repo</h3>
A sample of a Flutter Web app that utilizes the "grpc" packages from pub.dev.
We will use a proxy called Envoy, that makes gRPC calls work from Flutter Web app.
<br/><br/>
Note: The samples work on localhost without authentication.
So, instead of direct calls to a gRPC server we will communicate with it via Envoy like this: Flutter Web App - Envoy - gRPC server. For Flutter native, mobile or Dart console apps we don't need Envoy.

<h3>About my Runtime - Linux</h3>
This repo and samples I wrote and tested on Ubuntu 20.04.4 LTS (see "howto.txt" for more details).

<h3>Requirements</h3>
Flutter 3.19.4<br/>
Dart SDK version: 3.3.2 (stable)<br/>
Envoy 1.18.2<br/>

<h3>Optional Requirements:</h3>
libprotoc 26.0 (used to compile *.proto files)

### Proto sources
Located at the "protos/" dir.

### Compiled protos
Located at the "shared/src/generated/protos/" dir compiled by "protoc" (libprotoc 26.0).
Execute "make gen-protos" to re-generate "protos/*.proto" files and update proto binaries in all dependant projects.

<h3>1. Run the gRPC server (in our sample it is a Dart gRPC server)</h3>

It will bind localhost:50051 (see dart_server_grpc_demo/bin/dart_server_grpc_demo.dart and envoy.yaml for the configuration)

> cd dart_server_grpc_demo/

> dart pub get

> dart bin/dart_server_grpc_demo.dart

<h3>2. Run Envoy (a proxy that makes gRPC Web calls work)</h3>

It will bind localhost:50052 and communicate with gRPC server at localhost:50051 (see envoy.yaml for the configuration)

> envoy -c envoy.yaml

<h3>3. Run the web app and ensure gRPC calls works</h3>

Afer run the Flutter app, click the "Refresh" button at the bottom right corner to call gRPC and the result will appear at the center of the screen.
<br/><br/>
You should see *Hello, flutter 1!*, after next click *Hello, flutter 2!*, and so on.

> cd flutter_web_client_grpc_demo_app/

> flutter run -d chrome

<h3>*4 (optionally). Ensure gRPC works with and without Envoy in the Flutter native app on Linux</h3>

Afer run the Flutter app, click the "Refresh" button at the bottom right corner to call gRPC and the result will appear at the center of the screen (try port 50051 or 50052 in the flutter_web_client_grpc_demo_app/lib/main.dart file).
<br/><br/>
You should see *Hello, flutter 1!*, after next click *Hello, flutter 2!*, and so on.

> cd flutter_web_client_grpc_demo_app/

> flutter run -d linux

<h3>*5 (optionally). Ensure gRPC works with and without Envoy in the Dart console app</h3>

The Dart console app works well with a direct gRPC server, as well as via Envoy (try port 50051 or 50052 in the dart_client_grpc_demo/bin/dart_client_grpc_demo.dart file).
<br/><br/>
You should see the output: *Greeter client received: Hello, dart!*

> cd dart_client_grpc_demo/

> dart pub get

> dart bin/dart_client_grpc_demo.dart


© Max Shemetov, 2024, MIT License
