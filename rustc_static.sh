#!/usr/bin/env sh

set -eu

ln -s "$LLVM"/lld target/ld

rustc "$FILE".rs -C link-args="-v -B . -Wl,-flavor,darwin,-syslibroot,/" -o target/"$FILE"

cat "$LD_PROCLINE_FILE"

target/"$FILE"
