#!/usr/bin/env sh

set -eu

mkdir -p target # `lld` doesn't like creating directories

ln -sf $LLVM/lld target/ld

rustc $FILE.rs -C link-args="-v -B $PWD/target -Wl,-flavor,darwin" -o target/$FILE
target/$FILE
