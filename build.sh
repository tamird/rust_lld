#!/usr/bin/env sh

set -u

export FILE=hello_world

export LLVM=/usr/local/Cellar/llvm36/3.6.0/lib/llvm-3.6/bin
export RUSTLIB=$(rustc --print sysroot)/lib/rustlib/x86_64-apple-darwin/lib

echo 'Dynamic linking: hacking `clang` to make rustc use lld!'
git clean -dxf && ./rustc_dynamic.sh
echo 'Static linking: hacking `clang` to make rustc use lld!'
git clean -dxf && ./rustc_static.sh
echo 'Dynamic linking: running `rustc` and then `lld`!'
git clean -dxf && ./manual_dynamic.sh
echo 'Static linking: running `rustc` and then `lld`!'
git clean -dxf && ./manual_static.sh
