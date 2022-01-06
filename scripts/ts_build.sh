#!/bin/bash

set -e -x

BASEDIR=$(dirname "$0")
cd ${BASEDIR}/../

PROTO_DEST=./build/proto

mkdir -p ${PROTO_DEST}
cd src/v1/
echo $PWD
# JavaScript code generation
# /Users/apple/Desktop/1215/testNode/node_modules/.bin/grpc_tools_node_protoc --js_out=import_style=commonjs,binary:. --grpc_out=generate_package_definition:. helloworld.proto

# # move not proto files away
# find ./ -maxdepth 1 -type f ! -name '*.proto' -exec mv {} ../../build/proto \;

# cd ../../
# # Strip out eval statements for CSP reasons (avoids requiring `unsafe-eval`)
# # See: https://github.com/protocolbuffers/protobuf/blob/fae6773539b40b4904f2bfa8e09e69697984a65f/src/google/protobuf/compiler/js/js_generator.cc#L3644
# find ${PROTO_DEST} \
# -path ${PROTO_DEST}/node_modules -prune -false -o \
# -name "*.js" \
# -exec sed -i -e "s/var global = Function('return this')();/var global = globalThis\;/g" {} \;

# # Prepare the output directory for publishing
# prettier ${PROTO_DEST} --write