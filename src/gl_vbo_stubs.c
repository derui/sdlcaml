/*
  Implenmenting function for Sdlcaml of OpenGL bindings.
*/
#include <stdio.h>

#include "gl.afx.h"

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/callback.h>
#include <caml/bigarray.h>
#include "common.h"

#if GL3_ENABLE
#include "gl_vbo_enable.inc"
#else
#include "gl_vbo_disable.inc"
#endif
