Rust with LLD!
==============

Requirements:
- LLVM 3.6 with LLD. Currently must be sourced from my fork of homebrew-versions. See:
  - https://github.com/Homebrew/homebrew-versions/pull/808
  - https://github.com/Homebrew/homebrew/pull/37260
- Rust (tested with 2015-04-30 nightly) installed to $RUST_PREFIX

It works! Thanks @alexchandel!

```
$ ./build.sh
hello world!
```
