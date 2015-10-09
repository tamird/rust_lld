#!/usr/bin/env sh

set -eu

oFile=${FILE}_dynamic.o

ln -s $LLVM/lld target/ld

rustc --emit obj $FILE.rs -o target/$oFile

STD=$(find $RUSTLIB -name libstd-*.dylib | head -n1 | sed s,$RUSTLIB/lib,, | sed s,\.dylib$,,)

./ld -flavor darwin -demangle -dynamic -arch x86_64 -o target/$FILE -L$RUSTLIB target/$oFile -dead_strip -l$STD -lSystem -lpthread -lc -lm -rpath @loader_path/../../rust-build/x86_64-apple-darwin/stage2/lib/rustlib/x86_64-apple-darwin/lib -rpath /usr/local/lib/rustlib/x86_64-apple-darwin/lib -lcompiler-rt

DYLD_LIBRARY_PATH=$RUSTLIB target/$FILE
