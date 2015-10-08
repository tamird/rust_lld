#!/usr/bin/env sh

set -eu

ln -s $LLVM/lld target/ld

rustc $FILE.rs -C prefer-dynamic -C link-args="-v -B $PWD/target -Wl,-flavor,darwin" -o target/$FILE

DYLD_LIBRARY_PATH=$RUSTLIB target/$FILE
