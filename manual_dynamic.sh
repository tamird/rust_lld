#!/usr/bin/env sh

set -eu

oFile=${FILE}_dynamic.o

ln -s "$LLVM"/lld target/ld

rustc --emit obj "$FILE".rs -o target/"$oFile"

./ld -flavor darwin -demangle -dynamic -arch x86_64 -o target/"$FILE" -L"$RUSTLIB" target/"$oFile" -dead_strip -l"$STD" -lSystem -lpthread -lc -lm -rpath "$RUSTLIB" -lcompiler-rt

target/"$FILE"
