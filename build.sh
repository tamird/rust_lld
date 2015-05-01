#!/usr/bin/env sh

set -eu

FILE=hello_world

RUST_PREFIX=/Users/tamird/src/rust-build/x86_64-apple-darwin/stage2

LLVM=/usr/local/Cellar/llvm36/3.6.0/lib/llvm-3.6/bin
RUSTLIB=$RUST_PREFIX/lib/rustlib/x86_64-apple-darwin/lib

mkdir -p target # `lld` doesn't like creating directories
ln -sf $LLVM/lld target/ld

# -B is an undocumented flag that tells clang to look for `ld` in a custom
# location. https://stackoverflow.com/questions/10286850/using-llvm-linker-when-using-clang-cmake/22843589#22843589
rustc $FILE.rs -C link-args="-v -B $PWD/target -Wl,-flavor,darwin" -o target/$FILE
target/$FILE

: '
rustc --emit obj -Z no-landing-pads -C no-stack-check $FILE.rs
$LLVM/lld -flavor darwin -arch x86_64 $FILE.o $RUSTLIB/libmorestack.a -L $RUSTLIB -lstd-4e7c5e5c -lSystem -lcompiler-rt -o target/$FILE
DYLD_LIBRARY_PATH=$RUSTLIB target/$FILE
'
