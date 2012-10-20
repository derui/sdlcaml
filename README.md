sdlcaml
=======

SDL binding for OCaml.

This library needs other libraries to build where your works:
- OMake
  Better build system as compatible for make, created by OCaml.
- SDL1.2
  SDL Library. The sdlcaml only support 1.2.*, not 1.3.* or higher.
- camlidl
  Using IDL file conversion.
- ocamlfind
  Very useful library when build ocaml program/library.

However, building sdlcaml is very difficult... . If you cound not build this,
please use compiled-library instead of it.
