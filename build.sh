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
