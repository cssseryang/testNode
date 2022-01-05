#!/bin/bash

# exit when any command fails
set -x -e

CLANG_FORMAT="${CLANG_FORMAT:-clang-format}"

if ! [ -x "$(command -v "$CLANG_FORMAT")" ]; then
  echo "Warn: $CLANG_FORMAT is not installed." >&2
  # TODO(https://yolabsio.atlassian.net/browse/DEVOPS-305):
  # Print error and uncomment this when clang-format is installed.
  # exit 1
else
  PROTO_DIR=src
  PROTO_FILES=$(find $PROTO_DIR -name *.proto)
  "$CLANG_FORMAT" --Werror --dry-run $PROTO_FILES
fi

# TODO(steve): Set this up to run from TC build.
docker run --volume "$(pwd):/workspace" --workdir /workspace bufbuild/buf lint
docker image rm -f bufbuild/buf:latest

set -

echo "lint passed!"
