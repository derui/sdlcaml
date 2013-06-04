/* This implements OpenGL wrapper for OCaml APIs are higher than OpenGL3.0. */

/* define macros for getting process address of some functions.   */
#ifdef _WIN32                           /* for windows */
#include <windows.h>
#include <glext.h>

#define CHECK_ADDRESS(func, proto) \
  static proto func = NULL; \
  static unsigned int func##_is_loaded = 0; \
  if (!func##_is_loaded) { \
    func = (proto) wglGetProcAddress(#func); \
    if (func == NULL) { caml_failwith("Unable to load " #func);} \
    else func##_is_loaded = 1; \
  }
#else  /* for MacOS X */
#if defined(__APPLE__) && !defined(VMDMESA)
#include <mach-o/dyld.h>
#include <string.h>

void * MyNSGLGetProcAddress (const char* name) {
  NSSymbol symbol;
  char *symbolName;
  symbolName = malloc(strlen(name) + 2);
  strcpy(symbolName + 1, name);
  symbolName[0] = '_';
  symbol = NULL;
  if (NSIsSymbolNameDefined(symbolName)) {
    symbol = NSLookupAndBindSymbol(symbolName);
  }
  free(symbolName);
  return symbol ? NSAddressOfSymbol(symbol) : NULL;
}

#define CHECK_FUNC(func, proto) \
  static proto func = NULL; \
  static unsigned int func##_is_loaded = 0; \
  if (!func##_is_loaded) { \
    func = (proto) NSIsSymbolNameDefined(#func); \
    if (func == NULL) { caml_failwith("Unable to load " #func);} \
    else func##_is_loaded = 1; \
  }
#else /* for *nix. */

#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>

/* If using nVidia, do not this need? */
#define CHECK_FUNC(func, proto) \
  static proto func = NULL; \
  static unsigned int func##_is_loaded = 0; \
  if (!func##_is_loaded) { \
    func = (proto) glXGetProcAddress(#func); \
    if (func == NULL) { caml_failwith("Unable to load " #func);} \
    else func##_is_loaded = 1; \
  }
#endif
#endif

CAMLprim value gl_api_glBindBuffer(value target, value buffer) {
  CAMLparam2(target, buffer);
#include "enums/buffer_type.inc"
  CHECK_FUNC(glBindBuffer, PFNGLBINDBUFFERPROC);

  glBindBuffer(buffer_type[Int_val(target)], Int_val(buffer));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBufferData(value target, value size, value data, value usage) {
  CAMLparam4(target, size, data, usage);
#include "enums/target_type.inc"
#include "enums/usage_type.inc"

  CHECK_FUNC(glBufferData, PFNGLBUFFERDATAPROC);

  glBufferData(target_type[Int_val(target)], Int_val(size),
               Caml_ba_data_val(data),
               usage_type[Int_val(usage)]);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBufferSubData(value target, value offset, value size,
                                      value data) {
  CAMLparam4(target, offset, size, data);
#include "enums/target_type.inc"

  CHECK_FUNC(glBufferSubData, PFNGLBUFFERSUBDATAPROC);

  glBufferSubData(target_type[Int_val(target)], Int_val(offset),
                  Int_val(size), Caml_ba_data_val(data));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glGenBuffer(value unit) {
  CAMLparam1(unit);

  GLuint buffer;

  CHECK_FUNC(glGenBuffers, PFNGLGENBUFFERSPROC);
  glGenBuffers(1, &buffer);

  CAMLreturn(Val_int(buffer));
}

CAMLprim value gl_api_glGenBuffers(value size) {
  CAMLparam1(size);
  CAMLlocal1(list);

  list = Val_unit;
  CHECK_FUNC(glGenBuffers, PFNGLGENBUFFERSPROC);

  GLuint *buffer =  malloc(Int_val(size) * sizeof(GLuint));
  glGenBuffers(Int_val(size), buffer);

  for (int i = 0; i < Int_val(size); ++i) {
    list = add_head(list, Val_int(buffer[i]));
  }
  free(buffer);

  CAMLreturn(list);
}

CAMLprim value gl_api_glGetBufferParameter_access(value target) {
  CAMLparam1(target);
#include "enums/buffer_type.inc"
#include "enums/access_type.inc"
  CHECK_FUNC(glGetBufferParameteriv, PFNGLGETBUFFERPARAMETERIVPROC);

  GLint data;
  glGetBufferParameteriv(buffer_type[Int_val(target)], GL_BUFFER_ACCESS,
                         &data);
  for (int i = 0; i < sizeof(access_type) / sizeof(access_type[0]); ++i) {
    if (access_type[i] == data) {
      CAMLreturn(Val_int(i));
    }
  }

  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetBufferParameter_mapped(value target) {
  CAMLparam1(target);
#include "enums/buffer_type.inc"
  CHECK_FUNC(glGetBufferParameteriv, PFNGLGETBUFFERPARAMETERIVPROC);
  GLint data;
  glGetBufferParameteriv(buffer_type[Int_val(target)], GL_BUFFER_MAPPED,
                         &data);

  CAMLreturn(Val_bool(data));
}

CAMLprim value gl_api_glGetBufferParameter_size(value target) {
  CAMLparam1(target);
#include "enums/buffer_type.inc"
CHECK_FUNC(glGetBufferParameteriv, PFNGLGETBUFFERPARAMETERIVPROC);
  GLint data;
  glGetBufferParameteriv(buffer_type[Int_val(target)], GL_BUFFER_SIZE,
                         &data);

  CAMLreturn(Val_int(data));
}

CAMLprim value gl_api_glGetBufferParameter_usage(value target) {
  CAMLparam1(target);

#include "enums/buffer_type.inc"
#include "enums/buffer_usage_type.inc"
CHECK_FUNC(glGetBufferParameteriv, PFNGLGETBUFFERPARAMETERIVPROC);

  GLint data;
  glGetBufferParameteriv(buffer_type[Int_val(target)], GL_BUFFER_USAGE,
                         &data);
  for (int i = 0; i < sizeof(buffer_usage_type) / sizeof(buffer_usage_type[0]); ++i) {
    if (buffer_usage_type[i] == data) {
      CAMLreturn(Val_int(i));
    }
  }
  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetBufferSubData(value target, value offset, value size) {
  CAMLparam3(target, offset, size);
  CAMLlocal1(res);

#include "enums/buffer_type.inc"
  CHECK_FUNC(glGetBufferSubData, PFNGLGETBUFFERSUBDATAPROC);

  unsigned char* data = stat_alloc(Int_val(size) * sizeof(unsigned char));
  glGetBufferSubData(buffer_type[Int_val(target)], Int_val(offset), Int_val(size),
                     data);
  res = alloc_bigarray_dims(
      BIGARRAY_UINT8 | BIGARRAY_C_LAYOUT | BIGARRAY_MANAGED,
      1, data, Int_val(size));

  CAMLreturn(res);
}

CAMLprim value gl_api_glIsBuffer(value buffer) {
  CAMLparam1(buffer);
  CHECK_FUNC(glIsBuffer, PFNGLISBUFFERPROC);

  GLboolean v = glIsBuffer(Int_val(buffer));

  CAMLreturn(Val_bool(v));
}

CAMLprim value gl_api_glCopyBufferSubData(value read, value write, value readoffset,
                                          value writeoffset, value size) {
  CAMLparam5(read, write, readoffset, writeoffset, size);
#include "enums/target_type.inc"
  CHECK_FUNC(glCopyBufferSubData, PFNGLCOPYBUFFERSUBDATAPROC);

  glCopyBufferSubData(target_type[Int_val(read)], target_type[Int_val(write)],
                      Int_val(readoffset), Int_val(writeoffset), Int_val(size));
  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glFlushMappedBufferRange(value target, value offset, value length) {
  CAMLparam3(target, offset, length);

#include "enums/target_type.inc"
  CHECK_FUNC(glFlushMappedBufferRange, PFNGLFLUSHMAPPEDBUFFERRANGEPROC);

  glFlushMappedBufferRange(target_type[Int_val(target)], Int_val(offset), Int_val(length));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glTexBuffer(value internalformat, value buffer) {
  CAMLparam2(internalformat, buffer);
#include "enums/internal_format.inc"
  CHECK_FUNC(glTexBuffer, PFNGLTEXBUFFERPROC);

  glTexBuffer(GL_TEXTURE_BUFFER, internal_format[Int_val(internalformat)],
              Int_val(buffer));

  CAMLreturn(Val_unit);
}
