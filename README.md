# eclair

An experimental and minimal Datalog implementation that compiles down to LLVM.

## Features

Eclair is a minimal Datalog (for now). It only supports the following features:

- Facts containing literals (only integers are supported)
- Rules consisting of one or more clauses.
- Rules can be non-recursive, recursive or mutually recursive.

It's **alpha** software, not ready for real use. Right now it compiles to LLVM
but expect there to be bugs. Some edge cases might not be checked yet.

## Roadmap

- [x] Compile to LLVM
- [x] Release 0.0.1
- [x] Proper error handling
- [ ] LSP support
- [x] Support wildcards (`_`)
- [ ] Support other data types than integers (strings, ...), add typesystem
- [x] Support `=`
- [ ] Support negation, `!=` operator
- [ ] Support arithmetic / logical / ... operators
- [ ] Compile to WASM
- [ ] Optimizations on the AST / RA / LLVM level
- [ ] Support other underlying data structures than btree
- [ ] ...

This roadmap is not set in stone, but it gives an idea on the direction of the
project. :smile:

## Example code

Let's say we want to find out which points are reachable in a graph. We can
determine which points are reachable using the following two rules:

1. One point is reachable from another point, iff there is a direct edge between
   those two points.
2. One point is reachable from another point, iff there is a third point z such
   that there is a direct edge between 'x' and 'z', and between 'z' and 'y'.

The Eclair code below can be used to calculate the solution:

```eclair
@def edge(u32, u32).
@def reachable(u32, u32).

reachable(x, y) :-
  edge(x, y).

reachable(x, z) :-
  edge(x, y),
  reachable(y, z).
```

## Why the name?

Eclair is inspired by [Soufflé](https://souffle-lang.github.io/), a high
performance Datalog that compiles to C++. Because of the similarities, I chose a
different kind of food that I like. I mean, an eclair contains _both_ chocolate and
pudding, what's not to like!?

## Developer setup

## Nix

The easiest way to get the correct developer environment to build this project
is to use a recent enough Nix (with flakes support). The project also assumes
the following snippet is added to the `~/.direnvrc`:

```bash
use_flake() {
  watch_file flake.nix
  watch_file flake.lock
  mkdir -p $(direnv_layout_dir)
  eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
}
```

Once this is done, you can just type the command `direnv allow` and Nix will do
the heavy lifting. After Nix has finished setting up your local environment, you
can use `cabal` to build your project as usual. The Makefile contains the most
commonly used commands needed during development.

## Without Nix

You will need to install all tools yourself, manually. While this is possible,
it is not advised since you can potentially end up with a (slightly) different
environment, leading to weird to reproduce issues.
