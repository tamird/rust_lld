#!/usr/bin/env sh

set -eu

rustc --emit obj $FILE.rs -o target/$FILE.o

STD=$(find $RUSTLIB -name libstd-*.dylib | head -n1 | sed s,$RUSTLIB/lib,, | sed s,\.dylib$,,)

$LLVM/lld -flavor darwin -demangle -dynamic -arch x86_64 -o target/hello_world -L$RUSTLIB target/hello_world.o -force_load $RUSTLIB/libmorestack.a -dead_strip -l$STD -lSystem -lpthread -lc -lm -rpath @loader_path/../../rust-build/x86_64-apple-darwin/stage2/lib/rustlib/x86_64-apple-darwin/lib -rpath /usr/local/lib/rustlib/x86_64-apple-darwin/lib -lcompiler-rt

DYLD_LIBRARY_PATH=$RUSTLIB target/$FILE
