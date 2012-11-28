sdlcaml
=======

SDL binding for OCaml.

This library needs other libraries to build where your works:
- OMake
  Better build system as compatible for make, created by OCaml.
- SDL1.2
  SDL Library. The sdlcaml only support 1.2.*, not 1.3.* or higher.
- SDL_mixer
  Mixer library for SDL. This library certainly need to build.
- ocamlfind
  Very useful library when build ocaml program/library.

However, building sdlcaml is very difficult... . If you cound not build this,
please use compiled-library instead of it.

build
=====
You are already preparing to build this library, To do build process accordance with follows.

1. enter to directory where you decompress archive.
2. type `omake' or `omake all'
3. build successful if there are not any error messages on console.
4. type `sudo omake install', then install library and all files to use with ocamlfind.

Another, type `omake doc' if you want to get documents of Sdlcaml.