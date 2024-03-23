.PHONY: all

all: gen-protos

gen-protos:
	@echo "Generating Proto files..."
	@protoc --dart_out=grpc:shared/src/generated/protos -Iprotos protos/*.proto
	@echo "Copying generated proto files to projects..."
	@cp -a shared/src/generated/protos/* dart_client_grpc_demo/lib/generated/protos/
	@cp -a shared/src/generated/protos/* dart_server_grpc_demo/lib/generated/protos/
	@cp -a shared/src/generated/protos/* flutter_web_client_grpc_demo_app/lib/generated/protos/
