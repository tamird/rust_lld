#!/usr/bin/env sh

set -u

export FILE=hello_world

export RUST_PREFIX=$(rustc --print sysroot)

export LLVM=/usr/local/Cellar/llvm36/3.6.0/lib/llvm-3.6/bin
export RUSTLIB=$RUST_PREFIX/lib/rustlib/x86_64-apple-darwin/lib

echo 'Dynamic linking: hacking `clang` to make rustc use lld!'
git clean -dxf && ./rustc_dynamic.sh
echo 'Static linking: hacking `clang` to make rustc use lld!'
git clean -dxf && ./rustc_static.sh
echo 'Dynamic linking: running `rustc` and then `lld`!'
git clean -dxf && ./manual_dynamic.sh
echo 'Static linking: running `rustc` and then `lld`!'
git clean -dxf && ./manual_static.sh
