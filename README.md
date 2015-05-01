Rust with LLD!
==============

Requirements:
- LLVM 3.6 with LLD. Available on OSX via homebrew-versions (not yet homebrew proper). See: https://github.com/Homebrew/homebrew/pull/37260
- Rust (tested with 2015-04-30 nightly) installed to $RUST_PREFIX

Note: `lld` segfaults sometimes when lots of unused symbols are linked. `rustc` likes to pass `-lpthread -lc -lm` even when those are not used, so this is a problem. The scripts in this repo `rustc_{dynamic,static}.sh` hijack clang's call to `ld` by passing the undocumented flag `-B` - this usually fails because of the aforementioned segfault.

What works:
Dynamic linking! See `manual_dynamic.sh`.

What doesn't work:
Static linking. See `manual_static.sh`.

`lld` produces a binary that immediately dies:
```
$ target/hello_world
Bus error: 10
```

Digging deeper yields:
```
lldb target/hello_world
(lldb) target create "target/hello_world"
Current executable set to 'target/hello_world' (x86_64).
(lldb) run
Process 39886 launched: '/Users/tamird/src/rust_lld/target/hello_world' (x86_64)
Process 39886 stopped
* thread #1: tid = 0x338d11, 0x0000000100001db3 hello_world`rt::lang_start::h5ce5aec5764596439Pv + 259, queue = 'com.apple.main-thread', stop reason = EXC_BAD_ACCESS (code=2, address=0x100001dba)
    frame #0: 0x0000000100001db3 hello_world`rt::lang_start::h5ce5aec5764596439Pv + 259
hello_world`rt::lang_start::h5ce5aec5764596439Pv + 259:
-> 0x100001db3:  movq   %rbx, (%rip)              ; rt::lang_start::h5ce5aec5764596439Pv + 266
   0x100001dba:  movl   $0x1d, %edi
   0x100001dbf:  callq  0x100001dc4               ; rt::lang_start::h5ce5aec5764596439Pv + 276
   0x100001dc4:  cmpq   $-0x1, %rax
(lldb)
```
