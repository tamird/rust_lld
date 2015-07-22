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

print 'Dynamic linking: vanilla `rustc`...'
clean && rustc $FILE.rs -C prefer-dynamic -o target/$FILE && DYLD_LIBRARY_PATH=$RUSTLIB target/$FILE
echo
print 'Static linking: vanilla `rustc`...'
clean && rustc $FILE.rs -o target/$FILE && target/$FILE
echo
print 'Dynamic linking: running `rustc` and then `ld`...'
clean && rustc --emit obj $FILE.rs -o target/$FILE.o && ld -demangle -dynamic -arch x86_64 -o target/hello_world -L$RUSTLIB target/hello_world.o -force_load $RUSTLIB/libmorestack.a -dead_strip -l$(find $RUSTLIB -name libstd-*.dylib | head -n1 | sed s,$RUSTLIB/lib,, | sed s,\.dylib$,,) -lSystem -lpthread -lc -lm -rpath @loader_path/../../rust-build/x86_64-apple-darwin/stage2/lib/rustlib/x86_64-apple-darwin/lib -rpath /usr/local/lib/rustlib/x86_64-apple-darwin/lib -lcompiler-rt && DYLD_LIBRARY_PATH=$RUSTLIB target/$FILE
echo
print 'Static linking: running `rustc` and then `ld`...'
clean && rustc --emit obj $FILE.rs -o target/$FILE.o && ld -demangle -dynamic -arch x86_64 -o target/hello_world -L$RUSTLIB target/hello_world.o -force_load $RUSTLIB/libmorestack.a -dead_strip $RUSTLIB/lib{core,std,alloc,collections,rustc_unicode}*.rlib -lSystem -lpthread -lc -lm -lcompiler-rt && target/$FILE
echo
print 'Dynamic linking: hacking `clang` to make rustc use `lld`...'
clean && ./rustc_dynamic.sh
echo
print 'Static linking: hacking `clang` to make rustc use `lld`...'
clean && ./rustc_static.sh
echo
print 'Dynamic linking: running `rustc` and then `lld`...'
clean && ./manual_dynamic.sh
echo
print 'Static linking: running `rustc` and then `lld`...'
clean && ./manual_static.sh
