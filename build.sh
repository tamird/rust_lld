#!/usr/bin/env sh

set -eu

FILE=hello_world

RUST_PREFIX=/Users/tamird/src/rust-build/x86_64-apple-darwin/stage2

LLVM=/usr/local/Cellar/llvm36/3.6.0/lib/llvm-3.6/bin
RUSTLIB=$RUST_PREFIX/lib/rustlib/x86_64-apple-darwin/lib

mkdir -p target # `lld` doesn't like creating directories

rustc --emit obj -Z no-landing-pads -C no-stack-check $FILE.rs
$LLVM/lld -flavor darwin -arch x86_64 $FILE.o $RUSTLIB/libmorestack.a -L $RUSTLIB -lstd-4e7c5e5c -lSystem -lcompiler-rt -o target/$FILE
DYLD_LIBRARY_PATH=$RUSTLIB target/$FILE
