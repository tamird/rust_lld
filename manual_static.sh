#!/usr/bin/env sh

set -eu

rustc --emit obj $FILE.rs -o target/$FILE.o

$LLVM/lld -flavor darwin -demangle -dynamic -arch x86_64 -o target/hello_world -L$RUSTLIB target/hello_world.o -force_load $RUSTLIB/libmorestack.a -dead_strip $RUSTLIB/lib{core,std,alloc,collections,rustc_unicode}*.rlib -lSystem -lpthread -lc -lm -lcompiler-rt

target/$FILE
