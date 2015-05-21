#!/usr/bin/env sh

set -u

# LLVM cmake
# cmake -G "Unix Makefiles" ../llvm -DCMAKE_C_FLAGS_RELEASE= -DCMAKE_CXX_FLAGS_RELEASE= -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -Wno-dev

export FILE=hello_world

export LLVM=/usr/local/opt/llvm/bin
export RUSTLIB=$(rustc --print sysroot)/lib/rustlib/x86_64-apple-darwin/lib

clean() {
  git clean -dxfq && mkdir -p target
}

print() {
  tput smso
  echo $*
  tput sgr0
}

print 'Dynamic linking: hacking `clang` to make rustc use lld...'
clean && ./rustc_dynamic.sh
print 'Static linking: hacking `clang` to make rustc use lld...'
clean && ./rustc_static.sh
print 'Dynamic linking: running `rustc` and then `lld`...'
clean && ./manual_dynamic.sh
print 'Static linking: running `rustc` and then `lld`...'
clean && ./manual_static.sh
