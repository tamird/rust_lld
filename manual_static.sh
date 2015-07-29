#!/usr/bin/env sh

set -eu

oFile=${FILE}_static.o

rustc --emit obj $FILE.rs -o target/$oFile

$LLVM/lld -flavor darwin -demangle -dynamic -arch x86_64 -o target/$FILE -L$RUSTLIB target/$oFile -force_load $RUSTLIB/libmorestack.a -dead_strip $RUSTLIB/lib{core,std,alloc,collections,rustc_unicode}*.rlib -lSystem -lpthread -lc -lm -lcompiler-rt

target/$FILE
