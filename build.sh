#!/usr/bin/env sh

set -u

# brew install llvm --HEAD --with-lld

export FILE=hello_world

export LLVM=$(brew --prefix llvm)/bin
export RUSTLIB=$(rustc --print sysroot)/lib/rustlib/x86_64-apple-darwin/lib

clean() {
  git clean -dxfq && mkdir -p target
}

print() {
  tput smso
  echo $*
  tput sgr0
}

clean

print 'Dynamic linking: vanilla `rustc`...'
rustc $FILE.rs -C prefer-dynamic -o target/$FILE && DYLD_LIBRARY_PATH=$RUSTLIB target/$FILE
clean && echo
print 'Static linking: vanilla `rustc`...'
rustc $FILE.rs -o target/$FILE && target/$FILE
clean && echo
print 'Dynamic linking: running `rustc` and then `ld`...'
rustc --emit obj $FILE.rs -o target/$FILE.o && ld -demangle -dynamic -arch x86_64 -o target/$FILE -L$RUSTLIB target/$FILE.o -dead_strip -l$(find $RUSTLIB -name libstd-*.dylib | head -n1 | sed s,$RUSTLIB/lib,, | sed s,\.dylib$,,) -lSystem -lpthread -lc -lm -rpath @loader_path/../../rust-build/x86_64-apple-darwin/stage2/lib/rustlib/x86_64-apple-darwin/lib -rpath /usr/local/lib/rustlib/x86_64-apple-darwin/lib -lcompiler-rt && DYLD_LIBRARY_PATH=$RUSTLIB target/$FILE
clean && echo
print 'Static linking: running `rustc` and then `ld`...'
rustc --emit obj $FILE.rs -o target/$FILE.o && ld -demangle -dynamic -arch x86_64 -o target/$FILE -L$RUSTLIB target/$FILE.o -dead_strip $RUSTLIB/lib{core,std,alloc,collections,rustc_unicode}*.rlib -lSystem -lpthread -lc -lm -lcompiler-rt && target/$FILE
clean && echo
print 'Dynamic linking: hacking `clang` to make rustc use `lld`...'
./rustc_dynamic.sh
clean && echo
print 'Static linking: hacking `clang` to make rustc use `lld`...'
./rustc_static.sh
clean && echo
print 'Dynamic linking: running `rustc` and then `lld`...'
./manual_dynamic.sh
echo
print 'Static linking: running `rustc` and then `lld`...'
./manual_static.sh
