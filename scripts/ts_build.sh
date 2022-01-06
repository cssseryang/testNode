#!/bin/bash

set -e -x

BASEDIR=$(dirname "$0")
cd ${BASEDIR}/../

PROTO_DEST=./build/proto

mkdir -p ${PROTO_DEST}

# JavaScript code generation
yarn run grpc_tools_node_protoc \
--ts_out=generate_package_definition:${PROTO_DEST} \
--js_out=import_style=commonjs,binary:${PROTO_DEST} \
--grpc_out=generate_package_definition:${PROTO_DEST} \
-I ./src \
-I src/v1/*.proto

# Strip out eval statements for CSP reasons (avoids requiring `unsafe-eval`)
# See: https://github.com/protocolbuffers/protobuf/blob/fae6773539b40b4904f2bfa8e09e69697984a65f/src/google/protobuf/compiler/js/js_generator.cc#L3644
find ${PROTO_DEST} \
-path ${PROTO_DEST}/node_modules -prune -false -o \
-name "*.js" \
-exec sed -i -e "s/var global = Function('return this')();/var global = globalThis\;/g" {} \;

# Prepare the output directory for publishing
prettier ${PROTO_DEST} --write