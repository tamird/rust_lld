#!/usr/bin/env sh

set -eu

ln -s $LLVM/lld target/ld

rustc $FILE.rs -C link-args="-v -B . -Wl,-flavor,darwin" -o target/$FILE -C prefer-dynamic

DYLD_LIBRARY_PATH=$RUSTLIB target/$FILE
