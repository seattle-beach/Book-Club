# Testing in Haskell

This is an attempt at TDD in Haskell. There was a lot of yak shaving involved in getting the bits of code you see here.

## This is a Stack project
[Stack](https://docs.haskellstack.org/en/stable/README/) is a program for developing Haskell projects. It includes a package manager with versions.

## Stack 101
### [Install Stack](https://docs.haskellstack.org/en/stable/README/#how-to-install)

### Set up your new project
Create a new directory containing all the needed files to start a project correctly. [List of available templates.](https://github.com/commercialhaskell/stack-templates) The `hspec` template will give you  sane starting point if you want to use TDD.

`stack new projectname template-name`

**All Commands From Now On Run Inside Your Stack Project Dir**

Download GHCI and all of your package dependencies.

`stack setup`

### Build your project
(This will build an .exe on Windows, a .sh on Linux)

`stack build`

### Install a package without including it as a dependency for your project 

`stack install packagename`

### Run your project via stack

`stack exec projectname`

### Get a GHCI/REPL with your dependencies

`stack ghci`

### Run tests

`stack test`

## [Stack README](https://docs.haskellstack.org/en/stable/README)

## Errors

### Warning: The following modules should be added to exposed-modules or other-modules in blah blah blah

`stack install hpack-convert` 

## HSpec
For HSpec files to be discoverable, the main Spec.hs file needs to begin with 

```
{-# OPTIONS_GHC -F -pgmF hspec-discover #-}
```

(The hspec template sets this up.)

All HSpec files must be named with the pattern _Spec.hs and be located in the /test directory of your stack directory.
