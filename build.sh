#!/usr/bin/env bash

set -eu

# brew install llvm --HEAD --with-lld

cd "$(dirname "$0")"

export FILE=hello_world

export LLVM
LLVM="$(brew --prefix llvm)"/bin
export RUSTLIB
RUSTLIB="$(rustc --print sysroot)"/lib/rustlib/x86_64-apple-darwin/lib

export STD
STD="$(find "$RUSTLIB" -name 'libstd-*.dylib' | head -n1 | sed s,"$RUSTLIB"/lib,, | sed s,\.dylib$,,)"

export LD_PROCLINE_FILE=target/ld_procline

clean() {
  git clean -dxfq && mkdir -p target
}

print() {
  tput smso
  echo "$*"
  tput sgr0
}

clean

set +e

print 'Dynamic linking: vanilla rustc...'
rustc $FILE.rs -C link-args="-v -B ." -o target/$FILE -C prefer-dynamic && cat "$LD_PROCLINE_FILE" && target/$FILE
clean && echo
print 'Static linking: vanilla rustc...'
rustc $FILE.rs -C link-args="-v -B ." -o target/$FILE && cat "$LD_PROCLINE_FILE" && target/$FILE
clean && echo
print 'Dynamic linking: running rustc and then ld...'
rustc --emit obj "$FILE".rs -o target/$FILE.o && ld -demangle -dynamic -arch x86_64 -o target/$FILE -L"$RUSTLIB" target/$FILE.o -dead_strip -l"$STD" -lSystem -lpthread -lc -lm -rpath "$RUSTLIB" -lcompiler-rt && target/$FILE
clean && echo
print 'Static linking: running rustc and then ld...'
rustc --emit obj "$FILE".rs -o target/$FILE.o && ld -demangle -dynamic -arch x86_64 -o target/$FILE -L"$RUSTLIB" target/$FILE.o -dead_strip "$RUSTLIB"/lib{core,std,alloc,collections,rustc_unicode}*.rlib -lSystem -lpthread -lc -lm -lcompiler-rt && target/$FILE
clean && echo
print 'Dynamic linking: hacking clang to make rustc use lld...'
./rustc_dynamic.sh
clean && echo
print 'Static linking: hacking clang to make rustc use lld...'
./rustc_static.sh
clean && echo
print 'Dynamic linking: running rustc and then lld...'
./manual_dynamic.sh
clean && echo
print 'Static linking: running rustc and then lld...'
./manual_static.sh
