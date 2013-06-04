/* define macros for getting process address of some functions.   */
#ifdef _WIN32                           /* for windows */
#include <windows.h>
#include <glext.h>

#define CHECK_FUNC(func, proto) \
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


/* This implements OpenGL wrapper for OCaml APIs are higher than OpenGL3.0. */

CAMLprim value gl_api_glAttachShader(value shader, value program) {
  CAMLparam2(shader, program);
  CHECK_FUNC(glAttachShader, PFNGLATTACHSHADERPROC);
  glAttachShader(Int_val(program), Int_val(shader));
  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBindAttribLocation(value program, value index, value name) {
  CAMLparam3(program, index, name);

  CHECK_FUNC(glBindAttribLocation, PFNGLBINDATTRIBLOCATIONPROC);
  glBindAttribLocation(Int_val(program), Int_val(index),
                       String_val(name));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBindFragDataLocation(value program, value color, value name) {
  CAMLparam3(program, color, name);

  CHECK_FUNC(glBindFragDataLocation, PFNGLBINDFRAGDATALOCATIONPROC);
  glBindFragDataLocation(Int_val(program), Int_val(color), String_val(name));
  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBindFragDataLocationIndexed(value program, value color, value index, value name) {
  CAMLparam4(program, color, index, name);

  CHECK_FUNC(glBindFragDataLocationIndexed, PFNGLBINDFRAGDATALOCATIONINDEXEDPROC);
  glBindFragDataLocationIndexed(Int_val(program), Int_val(color), Int_val(index),
                                String_val(name));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBindFramebuffer(value target, value buffer) {
  CAMLparam2(target, buffer);
  CHECK_FUNC(glBindFramebuffer, PFNGLBINDFRAMEBUFFERPROC);
#include "enums/frame_buffer_type.inc"

  glBindFramebuffer(frame_buffer_type[Int_val(target)], Int_val(buffer));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBindRenderbuffer(value buffer) {
  CAMLparam1(buffer);

  CHECK_FUNC(glBindRenderbuffer, PFNGLBINDRENDERBUFFERPROC);
  glBindRenderbuffer(GL_RENDERBUFFER, Int_val(buffer));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBindSampler(value target, value sampler) {
  CAMLparam2(target, sampler);

  CHECK_FUNC(glBindSampler, PFNGLBINDSAMPLERPROC);
  glBindSampler(Int_val(target), Int_val(sampler));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBindVertexArray(value vao) {
  CAMLparam1(vao);

  CHECK_FUNC(glBindVertexArray, PFNGLBINDVERTEXARRAYPROC);
  glBindVertexArray(Int_val(vao));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBlendEquationSeparate(value rgb, value alpha) {
  CAMLparam2(rgb, alpha);
#include "enums/equation_mode.inc"

  CHECK_FUNC(glBlendEquationSeparate, PFNGLBLENDEQUATIONSEPARATEPROC);
  glBlendEquationSeparate(equation_mode[Int_val(rgb)], equation_mode[Int_val(alpha)]);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBlendFuncSeparate(value src_rgb, value dst_rgb, value src_alpha,
                                          value dst_alpha) {
  CAMLparam4(src_rgb, dst_rgb, src_alpha, dst_alpha);
#include "enums/func_equation_mode.inc"

  CHECK_FUNC(glBlendFuncSeparate, PFNGLBLENDFUNCSEPARATEPROC);
  glBlendFuncSeparate(func_equation_mode[Int_val(src_rgb)],
                      func_equation_mode[Int_val(dst_rgb)],
                      func_equation_mode[Int_val(src_alpha)],
                      func_equation_mode[Int_val(dst_alpha)]);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBlitFramebuffer_native(value sx0, value sy0, value sx1, value sy1,
                                               value dx0, value dy0, value dx1, value dy1,
                                               value mask, value filter) {
  CAMLparam5(sx0, sy0, sx1, sy1, dx0);
  CAMLxparam5(dy0, dx1, dy1, mask, filter);

  CHECK_FUNC(glBlitFramebuffer, PFNGLBLITFRAMEBUFFERPROC);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glBlitFramebuffer_bytecode(int argc, value* argv) {
  return gl_api_glBlitFramebuffer_native(argv[0], argv[1], argv[2], argv[3],
                                         argv[4], argv[5], argv[6], argv[7],
                                         argv[8], argv[9]);
}

CAMLprim value gl_api_glCheckFramebufferStatus(value query) {
  CAMLparam1(query);
#include "enums/frame_buffer_type.inc"
#include "enums/status_type.inc"

  CHECK_FUNC(glCheckFramebufferStatus, PFNGLCHECKFRAMEBUFFERSTATUSPROC);
  GLenum v = glCheckFramebufferStatus(frame_buffer_type[Int_val(query)]);

  for (int i = 0; i < sizeof(status_type) / sizeof(status_type[0]); ++i) {
    if (status_type[i] == v) {
      CAMLreturn(Val_int(i));
    }
  }

  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glClampColor(value clamp) {
  CAMLparam1(clamp);

  CHECK_FUNC(glClampColor, PFNGLCLAMPCOLORPROC);
  glClampColor(GL_CLAMP_READ_COLOR, Bool_val(clamp));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glClearBuffer_color(value drawbuffer, value r, value g, value b,
                                          value alpha) {
  CAMLparam5(drawbuffer, r, g, b, alpha);

  CHECK_FUNC(glClearBufferfv, PFNGLCLEARBUFFERFVPROC);
  float val[4] = {Double_val(r), Double_val(g), Double_val(b), Double_val(alpha)};

  glClearBufferfv(GL_COLOR, Int_val(drawbuffer), val);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glClearBuffer_depth(value val) {
  CAMLparam1(val);

  CHECK_FUNC(glClearBufferfv, PFNGLCLEARBUFFERFVPROC);
  float v = Double_val(val);
  glClearBufferfv(GL_DEPTH, 0, &v);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glClearBuffer_stencil(value val) {
  CAMLparam1(val);

  CHECK_FUNC(glClearBufferfv, PFNGLCLEARBUFFERFVPROC);
  float v = val;
  glClearBufferfv(GL_STENCIL, 0, &v);
  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glCompileShader(value shader) {
  CAMLparam1(shader);

  CHECK_FUNC(glCompileShader, PFNGLCOMPILESHADERPROC);
  glCompileShader(Int_val(shader));
  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glCreateProgram(value unit) {
  CAMLparam1(unit);

  CHECK_FUNC(glCreateProgram, PFNGLCREATEPROGRAMPROC);
  GLuint program = glCreateProgram();

  CAMLreturn(Val_int(program));
}

CAMLprim value gl_api_glCreateShader(value type) {
  CAMLparam1(type);
#include "enums/shader_type.inc"

  CHECK_FUNC(glCreateShader, PFNGLCREATESHADERPROC);

  GLuint shader = glCreateShader(shader_type[Int_val(type)]);

  CAMLreturn(Val_int(shader));
}

CAMLprim value gl_api_glDeleteBuffers(value size, value buffer) {
  CAMLparam2(size, buffer);

  CHECK_FUNC(glDeleteBuffers, PFNGLDELETEBUFFERSPROC);

  GLuint *array = malloc(Int_val(size) * sizeof(GLuint));
  for (int i = 0; i < Int_val(size); ++i) {
    value v = head(buffer);
    array[i] = Int_val(v);
    buffer = tail(buffer);
  }

  glDeleteBuffers(Int_val(size), array);
  free(array);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glDeleteFramebuffers(value size, value buffers) {
  CAMLparam2(size, buffers);

  CHECK_FUNC(glDeleteFramebuffers, PFNGLDELETEFRAMEBUFFERSPROC);
  GLuint *array = malloc(Int_val(size) * sizeof(GLuint));
  for (int i = 0; i < Int_val(size); ++i) {
    value v = head(buffers);
    array[i] = Int_val(v);
    buffers = tail(buffers);
  }

  glDeleteFramebuffers(Int_val(size), array);
  free(array);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glDeleteProgram(value program) {
  CAMLparam1(program);

  CHECK_FUNC(glDeleteProgram, PFNGLDELETEPROGRAMPROC);
  glDeleteProgram(Int_val(program));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glDeleteRenderbuffers(value size, value buffers) {
  CAMLparam2(size, buffers);

  CHECK_FUNC(glDeleteRenderbuffers, PFNGLDELETERENDERBUFFERSPROC);

  GLuint *array = malloc(Int_val(size) * sizeof(GLuint));
  for (int i = 0; i < Int_val(size); ++i) {
    value v = head(buffers);
    array[i] = Int_val(v);
    buffers = tail(buffers);
  }

  glDeleteRenderbuffers(Int_val(size), array);
  free(array);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glDeleteSamplers(value size, value samplers) {
  CAMLparam2(size, samplers);

  CHECK_FUNC(glDeleteSamplers, PFNGLDELETESAMPLERSPROC);

  GLuint *array = malloc(Int_val(size) * sizeof(GLuint));
  for (int i = 0; i < Int_val(size); ++i) {
    value v = head(samplers);
    array[i] = Int_val(v);
    samplers = tail(samplers);
  }

  glDeleteSamplers(Int_val(size), array);
  free(array);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glDeleteShader(value shader) {
  CAMLparam1(shader);

  CHECK_FUNC(glDeleteShader, PFNGLDELETESHADERPROC);
  glDeleteShader(Int_val(shader));
  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glDeleteVertexArrays(value size, value buffers) {
  CAMLparam2(size, buffers);

  CHECK_FUNC(glDeleteVertexArrays, PFNGLDELETEVERTEXARRAYSPROC);
  GLuint *array = malloc(Int_val(size) * sizeof(GLuint));
  for (int i = 0; i < Int_val(size); ++i) {
    value v = head(buffers);
    array[i] = Int_val(v);
    buffers = tail(buffers);
  }

  glDeleteVertexArrays(Int_val(size), array);
  free(array);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glDetachShader(value program, value shader) {
  CAMLparam2(program, shader);

  CHECK_FUNC(glDetachShader, PFNGLDETACHSHADERPROC);
  glDetachShader(Int_val(program), Int_val(shader));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glDrawBuffers(value modes) {
  CAMLparam1(modes);

  CHECK_FUNC(glDrawBuffers, PFNGLDRAWBUFFERSPROC);
  int len = caml_array_length(modes);
  GLenum* array = malloc(len * sizeof(GLenum));
  for (int i = 0; i < len; ++i) {
    array[i] = Int_val(Field(modes, i));
  }
  glDrawBuffers(len, array);
  free(array);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glEnableVertexAttribArray(value index) {
  CAMLparam1(index);

  CHECK_FUNC(glEnableVertexAttribArray, PFNGLENABLEVERTEXATTRIBARRAYPROC);
  glEnableVertexAttribArray(Int_val(index));
  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glDisableVertexAttribArray(value index) {
  CAMLparam1(index);

  CHECK_FUNC(glDisableVertexAttribArray, PFNGLDISABLEVERTEXATTRIBARRAYPROC);
  glDisableVertexAttribArray(Int_val(index));
  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glFramebufferRenderbuffer_attachment(value target, value attachment, value render) {
  CAMLparam3(target, attachment, render);
#include "enums/frame_buffer_type.inc"

  CHECK_FUNC(glFramebufferRenderbuffer, PFNGLFRAMEBUFFERRENDERBUFFERPROC);
  glFramebufferRenderbuffer(frame_buffer_type[Int_val(target)],
                            GL_COLOR_ATTACHMENT0 + Int_val(attachment), GL_RENDERBUFFER,
                            Int_val(render));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glFramebufferRenderbuffer_depth(value target, value render) {
  CAMLparam2(target, render);
#include "enums/frame_buffer_type.inc"

  CHECK_FUNC(glFramebufferRenderbuffer, PFNGLFRAMEBUFFERRENDERBUFFERPROC);
  glFramebufferRenderbuffer(frame_buffer_type[Int_val(target)],
                            GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER,
                            Int_val(render));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glFramebufferRenderbuffer_stencil(value target, value render) {
  CAMLparam2(target, render);
#include "enums/frame_buffer_type.inc"

  CHECK_FUNC(glFramebufferRenderbuffer, PFNGLFRAMEBUFFERRENDERBUFFERPROC);
  glFramebufferRenderbuffer(frame_buffer_type[Int_val(target)],
                            GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER,
                            Int_val(render));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glFramebufferRenderbuffer_depth_stencil(value target, value render) {
  CAMLparam2(target, render);
#include "enums/frame_buffer_type.inc"

  CHECK_FUNC(glFramebufferRenderbuffer, PFNGLFRAMEBUFFERRENDERBUFFERPROC);
  glFramebufferRenderbuffer(frame_buffer_type[Int_val(target)],
                            GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER,
                            Int_val(render));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glFramebufferTextureLayer_attachment(
    value target, value attachment, value texture, value level, value layer) {

  CAMLparam5(target, attachment, texture, level, layer);
#include "enums/frame_buffer_type.inc"
  CHECK_FUNC(glFramebufferTextureLayer, PFNGLFRAMEBUFFERTEXTURELAYERPROC);

  glFramebufferTextureLayer(frame_buffer_type[Int_val(target)],
                            GL_COLOR_ATTACHMENT0 + Int_val(attachment),
                            Int_val(texture), Int_val(level), Int_val(layer));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glFramebufferTextureLayer_depth(
    value target, value texture, value level, value layer) {

  CAMLparam4(target, texture, level, layer);
#include "enums/frame_buffer_type.inc"
  CHECK_FUNC(glFramebufferTextureLayer, PFNGLFRAMEBUFFERTEXTURELAYERPROC);

  glFramebufferTextureLayer(frame_buffer_type[Int_val(target)],
                            GL_DEPTH_ATTACHMENT,
                            Int_val(texture), Int_val(level), Int_val(layer));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glFramebufferTextureLayer_stencil(
    value target, value texture, value level, value layer) {

  CAMLparam4(target, texture, level, layer);
#include "enums/frame_buffer_type.inc"
  CHECK_FUNC(glFramebufferTextureLayer, PFNGLFRAMEBUFFERTEXTURELAYERPROC);

  glFramebufferTextureLayer(frame_buffer_type[Int_val(target)],
                            GL_STENCIL_ATTACHMENT,
                            Int_val(texture), Int_val(level), Int_val(layer));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glFramebufferTextureLayer_depth_stencil(
    value target, value texture, value level, value layer) {

  CAMLparam4(target, texture, level, layer);
#include "enums/frame_buffer_type.inc"
  CHECK_FUNC(glFramebufferTextureLayer, PFNGLFRAMEBUFFERTEXTURELAYERPROC);

  glFramebufferTextureLayer(frame_buffer_type[Int_val(target)],
                            GL_DEPTH_STENCIL_ATTACHMENT,
                            Int_val(texture), Int_val(level), Int_val(layer));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glGenFramebuffer(value unit) {
  CAMLparam1(unit);
  CHECK_FUNC(glGenFramebuffers, PFNGLGENFRAMEBUFFERSPROC);

  GLuint buffer;
  glGenFramebuffers(1, &buffer);

  CAMLreturn(Val_int(buffer));
}

CAMLprim value gl_api_glGenFramebuffers(value size) {
  CAMLparam1(size);
  CAMLlocal1(list);
  CHECK_FUNC(glGenFramebuffers, PFNGLGENFRAMEBUFFERSPROC);

  list = Val_unit;

  GLuint *buffer =  malloc(Int_val(size) * sizeof(GLuint));
  glGenFramebuffers(Int_val(size), buffer);

  for (int i = 0; i < Int_val(size); ++i) {
    list = add_head(list, Val_int(buffer[i]));
  }
  free(buffer);

  CAMLreturn(list);
}

CAMLprim value gl_api_glGenRenderbuffer(value unit) {
  CAMLparam1(unit);
  CHECK_FUNC(glGenRenderbuffers, PFNGLGENRENDERBUFFERSPROC);
  GLuint buffer;
  glGenRenderbuffers(1, &buffer);

  CAMLreturn(Val_int(buffer));
}

CAMLprim value gl_api_glGenRenderbuffers(value size) {
  CAMLparam1(size);
  CAMLlocal1(list);
  CHECK_FUNC(glGenRenderbuffers, PFNGLGENRENDERBUFFERSPROC);
  list = Val_unit;

  GLuint *buffer =  malloc(Int_val(size) * sizeof(GLuint));
  glGenRenderbuffers(Int_val(size), buffer);

  for (int i = 0; i < Int_val(size); ++i) {
    list = add_head(list, Val_int(buffer[i]));
  }
  free(buffer);

  CAMLreturn(list);
}

CAMLprim value gl_api_glGenSampler(value unit) {
  CAMLparam1(unit);
  GLuint sampler;
  CHECK_FUNC(glGenSamplers, PFNGLGENSAMPLERSPROC);
  glGenSamplers(1, &sampler);
  CAMLreturn(Val_int(sampler));
}

CAMLprim value gl_api_glGenSamplers(value size) {
  CAMLparam1(size);
  CAMLlocal1(list);
  CHECK_FUNC(glGenSamplers, PFNGLGENSAMPLERSPROC);

  list = Val_unit;

  GLuint *buffer =  malloc(Int_val(size) * sizeof(GLuint));
  glGenSamplers(Int_val(size), buffer);

  for (int i = 0; i < Int_val(size); ++i) {
    list = add_head(list, Val_int(buffer[i]));
  }
  free(buffer);

  CAMLreturn(list);
}

CAMLprim value gl_api_glGenVertexArray(value unit) {
  CAMLparam1(unit);
  GLuint buffer;
  CHECK_FUNC(glGenVertexArrays, PFNGLGENVERTEXARRAYSPROC);
  glGenVertexArrays(1, &buffer);

  CAMLreturn(Val_int(buffer));
}

CAMLprim value gl_api_glGenVertexArrays(value size) {
  CAMLparam1(size);
  CAMLlocal1(list);
  CHECK_FUNC(glGenVertexArrays, PFNGLGENVERTEXARRAYSPROC);
  list = Val_unit;

  GLuint *buffer =  malloc(Int_val(size) * sizeof(GLuint));
  glGenVertexArrays(Int_val(size), buffer);

  for (int i = 0; i < Int_val(size); ++i) {
    list = add_head(list, Val_int(buffer[i]));
  }
  free(buffer);

  CAMLreturn(list);
}

CAMLprim value gl_api_glGenerateMipmap(value target) {
  CAMLparam1(target);

#include "enums/mipmap_type.inc"
  CHECK_FUNC(glGenerateMipmap, PFNGLGENERATEMIPMAPPROC);
  glGenerateMipmap(mipmap_type[Int_val(target)]);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glGetActiveAttrib_length(value program, value index) {
  CAMLparam2(program, index);
  CHECK_FUNC(glGetActiveAttrib, PFNGLGETACTIVEATTRIBPROC);
  GLsizei length;
  glGetActiveAttrib(Int_val(program), Int_val(index), 0, &length, NULL, NULL, NULL);

  CAMLreturn(Val_int(length));
}
CAMLprim value gl_api_glGetActiveAttrib_size(value program, value index) {
  CAMLparam2(program, index);
  CHECK_FUNC(glGetActiveAttrib, PFNGLGETACTIVEATTRIBPROC);
  GLsizei size;
  glGetActiveAttrib(Int_val(program), Int_val(index), 0, NULL, &size, NULL, NULL);

  CAMLreturn(Val_int(size));
}

CAMLprim value gl_api_glGetActiveAttrib_type(value program, value index) {
  CAMLparam2(program, index);
  GLenum type;
  CHECK_FUNC(glGetActiveAttrib, PFNGLGETACTIVEATTRIBPROC);
  glGetActiveAttrib(Int_val(program), Int_val(index), 0, NULL, NULL, &type, NULL);

#include "enums/attrib_type.inc"

  for (int i = 0; i < sizeof(attrib_type) / sizeof(attrib_type[0]); ++i) {
    if (attrib_type[i] == type) {
      CAMLreturn(Val_int(i));
    }
  }

  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetActiveAttrib_name(value program, value index) {
  CAMLparam2(program, index);
  CAMLlocal1(string);
  CHECK_FUNC(glGetActiveAttrib, PFNGLGETACTIVEATTRIBPROC);
  GLsizei length;

  glGetActiveAttrib(Int_val(program), Int_val(index), 0, &length, NULL, NULL, NULL);
  GLchar* str = malloc((length + 1) * sizeof(GLchar));
  glGetActiveAttrib(Int_val(program), Int_val(index), length + 1, NULL, NULL, NULL,
                    str);

  string = caml_copy_string(str);
  free(str);

  CAMLreturn(string);
}

CAMLprim value gl_api_glGetActiveUniform_length(value program, value index) {
  CAMLparam2(program, index);
  CHECK_FUNC(glGetActiveUniform, PFNGLGETACTIVEUNIFORMPROC);

  GLsizei length;
  glGetActiveUniform(Int_val(program), Int_val(index), 0, &length, NULL, NULL, NULL);

  CAMLreturn(Val_int(length));
}

CAMLprim value gl_api_glGetActiveUniform_type(value program, value index) {
  CAMLparam2(program, index);
  CHECK_FUNC(glGetActiveUniform, PFNGLGETACTIVEUNIFORMPROC);

  GLenum type;
  glGetActiveUniform(Int_val(program), Int_val(index), 0, NULL, NULL, &type, NULL);

#include "enums/attrib_type.inc"

  for (int i = 0; i < sizeof(attrib_type) / sizeof(attrib_type[0]); ++i) {
    if (attrib_type[i] == type) {
      CAMLreturn(Val_int(i));
    }
  }

  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetActiveUniform_name(value program, value index) {
  CAMLparam2(program, index);
  CAMLlocal1(string);
  CHECK_FUNC(glGetActiveUniform, PFNGLGETACTIVEUNIFORMPROC);
  GLsizei length;

  glGetActiveUniform(Int_val(program), Int_val(index), 0, &length, NULL, NULL, NULL);
  GLchar* str = malloc((length + 1) * sizeof(GLchar));
  glGetActiveUniform(Int_val(program), Int_val(index), length + 1, NULL, NULL, NULL,
                     str);

  string = caml_copy_string(str);
  free(str);

  CAMLreturn(string);
}

CAMLprim value gl_api_glGetActiveUniformBlock(value program, value index, value pname) {
  CAMLparam3(program, index, pname);
#include "enums/uniform_block_type.inc"
  GLint param;
  CHECK_FUNC(glGetActiveUniformBlockiv, PFNGLGETACTIVEUNIFORMBLOCKIVPROC);
  glGetActiveUniformBlockiv(Int_val(program), Int_val(index),
                            uniform_block_type[Int_val(pname)], &param);

  CAMLreturn(Val_int(param));
}

CAMLprim value gl_api_glGetActiveUniformBlock_indices(value program, value index) {
  CAMLparam2(program, index);
  CAMLlocal1(res);
  CHECK_FUNC(glGetActiveUniformBlockiv, PFNGLGETACTIVEUNIFORMBLOCKIVPROC);
  GLint length;
  glGetActiveUniformBlockiv(Int_val(program), Int_val(index),
                            GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS, &length);
  GLint *params = stat_alloc(length * sizeof(GLint));

  glGetActiveUniformBlockiv(Int_val(program), Int_val(index),
                            GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES, params);

  res = alloc_bigarray_dims(
      BIGARRAY_INT32 | BIGARRAY_C_LAYOUT | BIGARRAY_MANAGED,
      1, params, length);

  CAMLreturn(res);
}

CAMLprim value gl_api_glGetActiveUniformBlockName(value program, value index) {
  CAMLparam2(program, index);
  CAMLlocal1(string);
  CHECK_FUNC(glGetActiveUniformBlockName, PFNGLGETACTIVEUNIFORMBLOCKNAMEPROC);

  GLsizei length;
  glGetActiveUniformBlockName(Int_val(program), Int_val(index), 0,
                              &length, NULL);
  GLchar* str = malloc(length * sizeof(GLchar));
  glGetActiveUniformBlockName(Int_val(program), Int_val(index), length,
                              NULL, str);
  string = caml_copy_string(str);
  free(str);

  CAMLreturn(string);
}

CAMLprim value gl_api_glGetActiveUniformName(value program, value index) {
  CAMLparam2(program, index);
  CAMLlocal1(string);
  CHECK_FUNC(glGetActiveUniformName, PFNGLGETACTIVEUNIFORMNAMEPROC);

  GLsizei length;
  glGetActiveUniformName(Int_val(program), Int_val(index), 0,
                              &length, NULL);
  GLchar* str = malloc(length * sizeof(GLchar));
  glGetActiveUniformName(Int_val(program), Int_val(index), length,
                         NULL, str);
  string = caml_copy_string(str);
  free(str);

  CAMLreturn(string);
}

CAMLprim value gl_api_glGetActiveUniforms_type(value program, value index) {
  CAMLparam2(program, index);

  CHECK_FUNC(glGetActiveUniformsiv, PFNGLGETACTIVEUNIFORMSIVPROC);
#include "enums/uniform_type.inc"

  GLuint v_index = Int_val(index);
  GLint param;
  glGetActiveUniformsiv(Int_val(program), 1, &v_index, GL_UNIFORM_TYPE,
                        &param);

  for (int i = 0; i < sizeof(uniform_type) / sizeof(uniform_type[0]); ++i) {
    if (uniform_type[i] == param) {
      CAMLreturn(Val_int(i));
    }
  }

  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetAttachedShaders(value program) {
  CAMLparam1(program);
  CAMLlocal1(list);
  list = Val_unit;
  CHECK_FUNC(glGetProgramiv, PFNGLGETPROGRAMIVPROC);
  CHECK_FUNC(glGetAttachedShaders, PFNGLGETATTACHEDSHADERSPROC);

  GLint shaders;
  GLint count;
  glGetProgramiv(Int_val(program), GL_ATTACHED_SHADERS, &shaders);

  GLuint *shader = malloc(count * sizeof(GLuint));

  glGetAttachedShaders(Int_val(program), shaders, &count, shader);
  for (int i = 0; i < count; ++i) {
    list = add_head(list, Val_int(shader[i]));
  }
  free(shader);

  CAMLreturn(list);
}

CAMLprim value gl_api_glGetAttribLocation(value program, value name) {
  CAMLparam2(program, name);
  CHECK_FUNC(glGetAttribLocation, PFNGLGETATTRIBLOCATIONPROC);

  GLint i = glGetAttribLocation(Int_val(program), String_val(name));

  CAMLreturn(Val_int(i));
}

CAMLprim value gl_api_glGetFragDataIndex(value program, value name) {
  CAMLparam2(program, name);
  CHECK_FUNC(glGetFragDataIndex, PFNGLGETFRAGDATAINDEXPROC);
  GLint index = glGetFragDataIndex(Int_val(program), String_val(name));

  CAMLreturn(Val_int(index));
}

CAMLprim value gl_api_glGetFragDataLocation(value program, value name) {
  CAMLparam2(program, name);
  CHECK_FUNC(glGetFragDataLocation, PFNGLGETFRAGDATALOCATIONPROC);
  GLint location = glGetFragDataLocation(Int_val(program), String_val(name));

  CAMLreturn(Val_int(location));
}

CAMLprim value gl_api_glGetMultisample(value index) {
  CAMLparam1(index);
  CAMLlocal1(res);
  CHECK_FUNC(glGetMultisamplefv, PFNGLGETMULTISAMPLEFVPROC);

  res = caml_alloc(2, 0);
  float v[2];
  glGetMultisamplefv(GL_SAMPLE_POSITION, Int_val(index), v);
  Store_field(res, 0, caml_copy_double(v[0]));
  Store_field(res, 1, caml_copy_double(v[1]));
  CAMLreturn(res);
}

CAMLprim value gl_api_glGetProgramInfoLog(value program) {
  CAMLparam1(program);
  CAMLlocal1(res);
  CHECK_FUNC(glGetProgramiv, PFNGLGETPROGRAMIVPROC);
  CHECK_FUNC(glGetProgramInfoLog, PFNGLGETPROGRAMINFOLOGPROC);

  GLsizei length;
  glGetProgramiv(Int_val(program), GL_INFO_LOG_LENGTH, &length);
  GLchar* string = malloc(length * sizeof(GLchar));

  glGetProgramInfoLog(Int_val(program), length, &length, string);
  res = caml_copy_string(string);
  free(string);

  CAMLreturn(res);
}

CAMLprim value gl_api_glGetRenderbufferParameter(value param) {
  CAMLparam1(param);
  GLint data;

#include "enums/renderbuffer_parameter_type.inc"
  CHECK_FUNC(glGetRenderbufferParameteriv, PFNGLGETRENDERBUFFERPARAMETERIVPROC);

  glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                               renderbuffer_parameter_type[Int_val(param)],
                               &data);

  CAMLreturn(Val_int(data));
}

CAMLprim value gl_api_glGetSamplerParameter_min_filter(value sampler) {
  CAMLparam1(sampler);
#include "enums/sampler_min_filter_type.inc"
  GLint data;
  CHECK_FUNC(glGetSamplerParameteriv, PFNGLGETSAMPLERPARAMETERIVPROC);
  glGetSamplerParameteriv(Int_val(sampler), GL_TEXTURE_MIN_FILTER, &data);

  for (int i = 0; i < sizeof(sampler_min_filter_type) / sizeof(sampler_min_filter_type[0]); ++i) {
    if (sampler_min_filter_type[i] == data) {
      CAMLreturn(Val_int(i));
    }
  }
  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetSamplerParameter_mag_filter(value sampler) {
  CAMLparam1(sampler);
  CHECK_FUNC(glGetSamplerParameteriv, PFNGLGETSAMPLERPARAMETERIVPROC);
#include "enums/sampler_mag_filter_type.inc"
  GLint data;
  glGetSamplerParameteriv(Int_val(sampler), GL_TEXTURE_MAG_FILTER, &data);

  for (int i = 0; i < sizeof(sampler_mag_filter_type) / sizeof(sampler_mag_filter_type[0]); ++i) {
    if (sampler_mag_filter_type[i] == data) {
      CAMLreturn(Val_int(i));
    }
  }
  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetSamplerParameter_lod(value sampler, value lod) {
  CAMLparam2(sampler, lod);
  CHECK_FUNC(glGetSamplerParameteriv, PFNGLGETSAMPLERPARAMETERIVPROC);
#include "enums/sampler_lod_type.inc"
  GLint data;
  glGetSamplerParameteriv(Int_val(sampler), sampler_lod_type[Int_val(lod)], &data);

  CAMLreturn(Val_int(data));
}

CAMLprim value gl_api_glGetSamplerParameter_wrap(value sampler, value pname) {
  CAMLparam2(sampler, pname);
  CHECK_FUNC(glGetSamplerParameteriv, PFNGLGETSAMPLERPARAMETERIVPROC);
#include "enums/sampler_wrap_type.inc"
#include "enums/sampler_wrap_func.inc"

  GLint data;
  glGetSamplerParameteriv(Int_val(sampler), sampler_wrap_type[Int_val(pname)], &data);

  for (int i = 0; i < sizeof(sampler_wrap_func) / sizeof(sampler_wrap_func[0]); ++i) {
    if (sampler_wrap_func[i] == data) {
      CAMLreturn(Val_int(i));
    }
  }
  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetSamplerParameter_compare_mode(value sampler) {
  CAMLparam1(sampler);
  CHECK_FUNC(glGetSamplerParameteriv, PFNGLGETSAMPLERPARAMETERIVPROC);
#include "enums/sampler_compare_mode.inc"
  GLint data;
  glGetSamplerParameteriv(Int_val(sampler), GL_TEXTURE_COMPARE_MODE, &data);

  for (int i = 0; i < sizeof(sampler_compare_mode) / sizeof(sampler_compare_mode[0]); ++i) {
    if (sampler_compare_mode[i] == data) {
      CAMLreturn(Val_int(i));
    }
  }
  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetSamplerParameter_compare_func(value sampler) {
  CAMLparam1(sampler);
  CHECK_FUNC(glGetSamplerParameteriv, PFNGLGETSAMPLERPARAMETERIVPROC);
#include "enums/sampler_compare_func.inc"
  GLint data;
  glGetSamplerParameteriv(Int_val(sampler), GL_TEXTURE_COMPARE_FUNC, &data);

  for (int i = 0; i < sizeof(sampler_compare_func) / sizeof(sampler_compare_func[0]); ++i) {
    if (sampler_compare_func[i] == data) {
      CAMLreturn(Val_int(i));
    }
  }
  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetSamplerParameter_color(value sampler) {
  CAMLparam1(sampler);
  CAMLlocal1(res);
  CHECK_FUNC(glGetSamplerParameterfv, PFNGLGETSAMPLERPARAMETERFVPROC);
  GLfloat data[4];
  glGetSamplerParameterfv(Int_val(sampler), GL_TEXTURE_COMPARE_FUNC, data);

  res = caml_alloc(4, 0);
  Store_field(res, 0, caml_copy_double(data[0]));
  Store_field(res, 1, caml_copy_double(data[1]));
  Store_field(res, 2, caml_copy_double(data[2]));
  Store_field(res, 3, caml_copy_double(data[3]));

  CAMLreturn(res);
}

CAMLprim value gl_api_glGetShader_type(value shader) {
  CAMLparam1(shader);

  GLint type;
#include "enums/shader_type.inc"
  CHECK_FUNC(glGetShaderiv, PFNGLGETSHADERIVPROC);

  glGetShaderiv(Int_val(shader), GL_SHADER_TYPE, &type);

  for (int i = 0; i < sizeof(shader_type) / sizeof(shader_type[0]); ++i) {
    if (shader_type[i] == type) {
      CAMLreturn(Val_int(i));
    }
  }
  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetShader_bool(value shader, value pname) {
  CAMLparam2(shader, pname);
#include "enums/get_shader_bool.inc"
  CHECK_FUNC(glGetShaderiv, PFNGLGETSHADERIVPROC);

  GLint data;
  glGetShaderiv(Int_val(shader), get_shader_bool[Int_val(pname)], &data);

  CAMLreturn(Val_bool(data));
}

CAMLprim value gl_api_glGetShader_int(value shader, value pname) {
  CAMLparam2(shader, pname);
#include "enums/get_shader_int.inc"
  CHECK_FUNC(glGetShaderiv, PFNGLGETSHADERIVPROC);

  GLint data;
  glGetShaderiv(Int_val(shader), get_shader_int[Int_val(pname)], &data);

  CAMLreturn(Val_int(data));
}

CAMLprim value gl_api_glGetShaderInfoLog(value shader) {
  CAMLparam1(shader);
  CAMLlocal1(string);
  CHECK_FUNC(glGetShaderiv, PFNGLGETSHADERIVPROC);
  CHECK_FUNC(glGetShaderInfoLog, PFNGLGETSHADERINFOLOGPROC);

  GLsizei length;
  glGetShaderiv(Int_val(shader), GL_INFO_LOG_LENGTH, &length);
  GLchar *str = malloc(length * sizeof(GLchar));
  glGetShaderInfoLog(Int_val(shader), length, NULL, str);
  string = caml_copy_string(str);
  free(str);
  CAMLreturn(string);
}

CAMLprim value gl_api_glGetShaderSource(value shader) {
  CAMLparam1(shader);
  CAMLlocal1(string);
  CHECK_FUNC(glGetShaderSource, PFNGLGETSHADERSOURCEPROC);

  GLsizei length;
  glGetShaderSource(Int_val(shader), 0, &length, NULL);
  GLchar *str = malloc(length * sizeof(GLchar));
  glGetShaderSource(Int_val(shader), length, NULL, str);
  string = caml_copy_string(str);
  free(str);
  CAMLreturn(string);
}

CAMLprim value gl_api_glGetUniformf1(value program, value location) {
  CAMLparam2(program, location);
  CHECK_FUNC(glGetUniformfv, PFNGLGETUNIFORMFVPROC);

  float v[1];
  glGetUniformfv(Int_val(program), Int_val(location), v);

  CAMLreturn(caml_copy_double(v[0]));
}

CAMLprim value gl_api_glGetUniformf2(value program, value location) {
  CAMLparam2(program, location);
  CAMLlocal1(res);
  CHECK_FUNC(glGetUniformfv, PFNGLGETUNIFORMFVPROC);

  float v[2];
  glGetUniformfv(Int_val(program), Int_val(location), v);
  res = caml_alloc(2, 0);
  Store_field(res, 0, caml_copy_double(v[0]));
  Store_field(res, 1, caml_copy_double(v[1]));

  CAMLreturn(res);
}

CAMLprim value gl_api_glGetUniformf3(value program, value location) {
  CAMLparam2(program, location);
  CAMLlocal1(res);
  CHECK_FUNC(glGetUniformfv, PFNGLGETUNIFORMFVPROC);

  float v[3];
  glGetUniformfv(Int_val(program), Int_val(location), v);
  res = caml_alloc(3, 0);
  Store_field(res, 0, caml_copy_double(v[0]));
  Store_field(res, 1, caml_copy_double(v[1]));
  Store_field(res, 2, caml_copy_double(v[2]));

  CAMLreturn(res);
}

CAMLprim value gl_api_glGetUniformf4(value program, value location) {
  CAMLparam2(program, location);
  CAMLlocal1(res);
  CHECK_FUNC(glGetUniformfv, PFNGLGETUNIFORMFVPROC);

  float v[4];
  glGetUniformfv(Int_val(program), Int_val(location), v);
  res = caml_alloc(4, 0);
  Store_field(res, 0, caml_copy_double(v[0]));
  Store_field(res, 1, caml_copy_double(v[1]));
  Store_field(res, 2, caml_copy_double(v[2]));
  Store_field(res, 3, caml_copy_double(v[3]));

  CAMLreturn(res);
}

CAMLprim value gl_api_glGetUniformi1(value program, value location) {
  CAMLparam2(program, location);
  CHECK_FUNC(glGetUniformiv, PFNGLGETUNIFORMIVPROC);

  int v[1];
  glGetUniformiv(Int_val(program), Int_val(location), v);

  CAMLreturn(Int_val(v[0]));
}

CAMLprim value gl_api_glGetUniformi2(value program, value location) {
  CAMLparam2(program, location);
  CAMLlocal1(res);
  CHECK_FUNC(glGetUniformiv, PFNGLGETUNIFORMIVPROC);

  int v[2];
  glGetUniformiv(Int_val(program), Int_val(location), v);
  res = caml_alloc(2, 0);
  Store_field(res, 0, Int_val(v[0]));
  Store_field(res, 1, Int_val(v[1]));

  CAMLreturn(res);
}

CAMLprim value gl_api_glGetUniformi3(value program, value location) {
  CAMLparam2(program, location);
  CAMLlocal1(res);
  CHECK_FUNC(glGetUniformiv, PFNGLGETUNIFORMIVPROC);

  int v[3];
  glGetUniformiv(Int_val(program), Int_val(location), v);
  res = caml_alloc(3, 0);
  Store_field(res, 0, Int_val(v[0]));
  Store_field(res, 1, Int_val(v[1]));
  Store_field(res, 2, Int_val(v[2]));

  CAMLreturn(res);
}

CAMLprim value gl_api_glGetUniformi4(value program, value location) {
  CAMLparam2(program, location);
  CAMLlocal1(res);
  CHECK_FUNC(glGetUniformiv, PFNGLGETUNIFORMIVPROC);

  int v[4];
  glGetUniformiv(Int_val(program), Int_val(location), v);
  res = caml_alloc(4, 0);
  Store_field(res, 0, Int_val(v[0]));
  Store_field(res, 1, Int_val(v[1]));
  Store_field(res, 2, Int_val(v[2]));
  Store_field(res, 3, Int_val(v[3]));

  CAMLreturn(res);
}


CAMLprim value gl_api_glGetUniformui1(value program, value location) {
  CAMLparam2(program, location);
  CHECK_FUNC(glGetUniformuiv, PFNGLGETUNIFORMUIVPROC);

  unsigned int v[1];
  glGetUniformuiv(Int_val(program), Int_val(location), v);

  CAMLreturn(Int_val(v[0]));
}

CAMLprim value gl_api_glGetUniformui2(value program, value location) {
  CAMLparam2(program, location);
  CAMLlocal1(res);
  CHECK_FUNC(glGetUniformuiv, PFNGLGETUNIFORMUIVPROC);

  unsigned int v[2];
  glGetUniformuiv(Int_val(program), Int_val(location), v);
  res = caml_alloc(2, 0);
  Store_field(res, 0, Int_val(v[0]));
  Store_field(res, 1, Int_val(v[1]));

  CAMLreturn(res);
}

CAMLprim value gl_api_glGetUniformui3(value program, value location) {
  CAMLparam2(program, location);
  CAMLlocal1(res);
  CHECK_FUNC(glGetUniformuiv, PFNGLGETUNIFORMUIVPROC);

  unsigned int v[3];
  glGetUniformuiv(Int_val(program), Int_val(location), v);
  res = caml_alloc(3, 0);
  Store_field(res, 0, Int_val(v[0]));
  Store_field(res, 1, Int_val(v[1]));
  Store_field(res, 2, Int_val(v[2]));

  CAMLreturn(res);
}

CAMLprim value gl_api_glGetUniformui4(value program, value location) {
  CAMLparam2(program, location);
  CAMLlocal1(res);
  CHECK_FUNC(glGetUniformuiv, PFNGLGETUNIFORMUIVPROC);

  unsigned int v[4];
  glGetUniformuiv(Int_val(program), Int_val(location), v);
  res = caml_alloc(4, 0);
  Store_field(res, 0, Int_val(v[0]));
  Store_field(res, 1, Int_val(v[1]));
  Store_field(res, 2, Int_val(v[2]));
  Store_field(res, 3, Int_val(v[3]));

  CAMLreturn(res);
}

CAMLprim value gl_api_glGetUniformBlockIndex(value program, value name) {
  CAMLparam2(program, name);
  CHECK_FUNC(glGetUniformBlockIndex, PFNGLGETUNIFORMBLOCKINDEXPROC);

  GLuint v = glGetUniformBlockIndex(Int_val(program), String_val(name));

  CAMLreturn(Val_int(v));
}

CAMLprim value gl_api_glGetUniformIndices(value program, value names, value count) {
  CAMLparam3(program, names, count);
  CAMLlocal2(v, res);
  CHECK_FUNC(glGetUniformIndices, PFNGLGETUNIFORMINDICESPROC);

  GLchar** uniform_names = malloc(Int_val(count) * sizeof(GLchar*));
  for (int i = 0; i < Int_val(count); ++i) {
    v = head(names);
    names = tail(names);
    uniform_names[i] = String_val(v);
  }
  GLuint* indices = malloc(Int_val(count) * sizeof(GLuint));
  glGetUniformIndices(Int_val(program), Int_val(count), (const char**)uniform_names, indices);

  res = Val_unit;
  for (int i = 0; i < Int_val(count); ++i) {
    res = add_head(res, Val_int(indices[i]));
  }
  free(uniform_names);
  free(indices);

  CAMLreturn(res);
}

CAMLprim value gl_api_glGetUniformLocation(value program, value name) {
  CAMLparam2(program, name);
  CHECK_FUNC(glGetUniformLocation, PFNGLGETUNIFORMLOCATIONPROC);

  GLuint v = glGetUniformLocation(Int_val(program), String_val(name));

  CAMLreturn(Val_int(v));
}

CAMLprim value gl_api_glGetVertexAttrib_bool(value index, value pname) {
  CAMLparam2(index, pname);
  CHECK_FUNC(glGetVertexAttribiv, PFNGLGETVERTEXATTRIBIVPROC);
#include "enums/get_vertex_attrib_bool.inc"

  GLint v;
  glGetVertexAttribiv(Int_val(index), get_vertex_attrib_bool[Int_val(pname)], &v);

  CAMLreturn(Val_int(v));
}

CAMLprim value gl_api_glGetVertexAttrib_int(value index, value pname) {
  CAMLparam2(index, pname);
  CHECK_FUNC(glGetVertexAttribiv, PFNGLGETVERTEXATTRIBIVPROC);
#include "enums/get_vertex_attrib_int.inc"

  GLint v;
  glGetVertexAttribiv(Int_val(index), get_vertex_attrib_int[Int_val(pname)], &v);

  CAMLreturn(Val_int(v));
}

CAMLprim value gl_api_glGetVertexAttrib_vertex(value index) {
  CAMLparam1(index);
  CAMLlocal1(res);
  CHECK_FUNC(glGetVertexAttribfv, PFNGLGETVERTEXATTRIBFVPROC);
  res = caml_alloc(4, 0);

  float v[4];
  glGetVertexAttribfv(Int_val(index), GL_CURRENT_VERTEX_ATTRIB, v);
  Store_field(res, 0, caml_copy_double(v[0]));
  Store_field(res, 1, caml_copy_double(v[1]));
  Store_field(res, 2, caml_copy_double(v[2]));
  Store_field(res, 3, caml_copy_double(v[3]));

  CAMLreturn(res);
}


CAMLprim value gl_api_glIsFramebuffer(value framebuffer) {
  CAMLparam1(framebuffer);
  CHECK_FUNC(glIsFramebuffer, PFNGLISFRAMEBUFFERPROC);

  GLboolean v = glIsFramebuffer(Int_val(framebuffer));

  CAMLreturn(Val_bool(v));
}

CAMLprim value gl_api_glIsProgram(value program) {
  CAMLparam1(program);
  CHECK_FUNC(glIsProgram, PFNGLISPROGRAMPROC);

  GLboolean v = glIsProgram(Int_val(program));

  CAMLreturn(Val_bool(v));
}

CAMLprim value gl_api_glIsRenderbuffer(value renderbuffer) {
  CAMLparam1(renderbuffer);
  CHECK_FUNC(glIsRenderbuffer, PFNGLISRENDERBUFFERPROC);

  GLboolean v = glIsRenderbuffer(Int_val(renderbuffer));

  CAMLreturn(Val_bool(v));
}

CAMLprim value gl_api_glIsSampler(value sampler) {
  CAMLparam1(sampler);
  CHECK_FUNC(glIsSampler, PFNGLISSAMPLERPROC);

  GLboolean v = glIsSampler(Int_val(sampler));

  CAMLreturn(Val_bool(v));
}

CAMLprim value gl_api_glIsShader(value shader) {
  CAMLparam1(shader);
  CHECK_FUNC(glIsShader, PFNGLISSHADERPROC);

  GLboolean v = glIsShader(Int_val(shader));

  CAMLreturn(Val_bool(v));
}

CAMLprim value gl_api_glIsVertexArray(value vbo) {
  CAMLparam1(vbo);
  CHECK_FUNC(glIsVertexArray, PFNGLISVERTEXARRAYPROC);

  GLboolean v = glIsVertexArray(Int_val(vbo));

  CAMLreturn(Val_bool(v));
}

CAMLprim value gl_api_glLinkProgram(value program) {
  CAMLparam1(program);
  CHECK_FUNC(glLinkProgram, PFNGLLINKPROGRAMPROC);

  glLinkProgram(Int_val(program));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glMultiDrawElements(value mode, value elements_type, value list,
                                          value primcount) {
  CAMLparam4(mode, elements_type, list, primcount);
  CAMLlocal2(v, t);
  CHECK_FUNC(glMultiDrawElements, PFNGLMULTIDRAWELEMENTSPROC);
  v = list;
#include "enums/draw_mode.inc"
#include "enums/draw_elements_type.inc"

  int count = 0;
  while (is_not_nil(list)) {
    v = tail(v);
    count++;
  }

  void** datas = malloc(count * sizeof(void*));
  GLsizei *sizes = malloc(count * sizeof(GLsizei));
  v = list;
  int i = 0;
  while (is_not_nil(list)) {
    t = head(v);
    datas[i] = Caml_ba_data_val(t);
    sizes[i] = Caml_ba_array_val(t)->dim[0];
    v = tail(v);
  }

  glMultiDrawElements(draw_mode[Int_val(mode)], sizes,
                      draw_elements_type[Int_val(elements_type)], (const void**)datas, Int_val(primcount));

  free(datas);
  free(sizes);
  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glPointParameter(value val) {
  CAMLparam1(val);
  CHECK_FUNC(glPointParameterf, PFNGLPOINTPARAMETERFPROC);

  glPointParameterf(GL_POINT_FADE_THRESHOLD_SIZE, Double_val(val));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glPointParameter_coord(value param) {
  CAMLparam1(param);
  CHECK_FUNC(glPointParameteri, PFNGLPOINTPARAMETERIPROC);
#include "enums/coord_origin.inc"

  glPointParameteri(GL_POINT_SPRITE_COORD_ORIGIN,
                    coord_origin[Int_val(param)]);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glPrimitiveRestartIndex(value param) {
  CAMLparam1(param);
  CHECK_FUNC(glPrimitiveRestartIndex, PFNGLPRIMITIVERESTARTINDEXPROC);
  glPrimitiveRestartIndex(Int_val(param));
  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glProvokingVertex(value provoke) {
  CAMLparam1(provoke);
  CHECK_FUNC(glProvokingVertex, PFNGLPROVOKINGVERTEXPROC);
#include "enums/provoking_type.inc"

  glProvokingVertex(provoking_type[Int_val(provoke)]);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glRenderbufferStorageMultisample(value samples, value internalformat,
                                                       value width, value height) {
  CAMLparam4(samples, internalformat, width, height);
  CHECK_FUNC(glRenderbufferStorageMultisample, PFNGLRENDERBUFFERSTORAGEMULTISAMPLEPROC);
#include "enums/internal_format.inc"

  glRenderbufferStorageMultisample(GL_RENDERBUFFER, Int_val(samples),
                                   internal_format[Int_val(internalformat)],
                                   Int_val(width), Int_val(height));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glSampleMask(value masknumber, value mask) {
  CAMLparam2(masknumber, mask);
  CHECK_FUNC(glSampleMaski, PFNGLSAMPLEMASKIPROC);

  glSampleMaski(Int_val(masknumber), Int_val(mask));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glSamplerParameter(value sampler, value pname, value val) {
  CAMLparam3(sampler, pname, val);
  CHECK_FUNC(glSamplerParameteri, PFNGLSAMPLERPARAMETERIPROC);
#include "enums/sampler_lod_type.inc"

  glSamplerParameteri(Int_val(sampler), sampler_lod_type[Int_val(pname)],
                      Int_val(val));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glShaderSource(value shader, value source) {
  CAMLparam2(shader, source);
  CHECK_FUNC(glShaderSource, PFNGLSHADERSOURCEPROC);

  const char* c = String_val(source);
  int length = caml_string_length(source);
  glShaderSource(Int_val(shader), 1 , &c, &length);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glStencilFuncSeparate(value face, value func, value func_ref, value mask) {
  CAMLparam4(face, func, func_ref, mask);
  CHECK_FUNC(glStencilFuncSeparate, PFNGLSTENCILFUNCSEPARATEPROC);
#include "enums/cull_face_mode.inc"
#include "enums/compare_func.inc"

  glStencilFuncSeparate(cull_face_mode[Int_val(face)], compare_func[Int_val(mask)], Int_val(func_ref),
                        Int_val(mask));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glStencilMaskSeparate(value face, value mask) {
  CAMLparam2(face, mask);
  CHECK_FUNC(glStencilMaskSeparate, PFNGLSTENCILMASKSEPARATEPROC);
#include "enums/cull_face_mode.inc"

  glStencilMaskSeparate(cull_face_mode[Int_val(face)], Int_val(mask));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glStencilOpSeparate(value face, value fail, value zfail, value zpass) {
  CAMLparam4(face, fail, zfail, zpass);
  CHECK_FUNC(glStencilOpSeparate, PFNGLSTENCILOPSEPARATEPROC);
#include "enums/face_mode.inc"
#include "enums/stencil_op.inc"

  glStencilOpSeparate(face_mode[Int_val(face)], stencil_op[Int_val(fail)],
                      stencil_op[Int_val(zfail)], stencil_op[Int_val(zpass)]);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glTransformFeedbackVaryings(value program, value varyings,
                                                  value buffer_mode) {
  CAMLparam3(program, varyings, buffer_mode);
  CAMLlocal2(tmp, tmp_list);
  CHECK_FUNC(glTransformFeedbackVaryings, PFNGLTRANSFORMFEEDBACKVARYINGSPROC);
#include "enums/transform_buffer_mode.inc"

  tmp_list = varyings;
  int count = 0;
  while (is_not_nil(tmp_list)) {
    tmp_list = tail(tmp_list);
    ++count;
  }
  GLchar** strings = malloc(count * sizeof(GLchar*));
  tmp_list = varyings;
  for (int i = 0; i < count; ++i, tmp_list = tail(tmp_list)) {
    strings[i] = String_val(head(tmp_list));
  }

  glTransformFeedbackVaryings(Int_val(program), count,
                              (const GLchar**)strings, transform_buffer_mode[Int_val(buffer_mode)]);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniform1f(value location, value val) {
  CAMLparam2(location, val);
  CHECK_FUNC(glUniform1f, PFNGLUNIFORM1FPROC);

  glUniform1f(Int_val(location), Double_val(val));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniform2f(value location, value val) {
  CAMLparam2(location, val);
  CHECK_FUNC(glUniform2f, PFNGLUNIFORM2FPROC);

  glUniform2f(Int_val(location), Double_val(Field(val, 0)),
              Double_val(Field(val, 1)));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniform3f(value location, value val) {
  CAMLparam2(location, val);
  CHECK_FUNC(glUniform3f, PFNGLUNIFORM3FPROC);

  glUniform3f(Int_val(location), Double_val(Field(val, 0)),
              Double_val(Field(val, 1)), Double_val(Field(val, 2)));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniform4f(value location, value val) {
  CAMLparam2(location, val);
  CHECK_FUNC(glUniform4f, PFNGLUNIFORM4FPROC);

  glUniform4f(Int_val(location), Double_val(Field(val, 0)),
              Double_val(Field(val, 1)), Double_val(Field(val, 2)),
              Double_val(Field(val, 3)));

  CAMLreturn(Val_unit);
}


CAMLprim value gl_api_glUniform1ui(value location, value val) {
  CAMLparam2(location, val);
  CHECK_FUNC(glUniform1ui, PFNGLUNIFORM1UIPROC);

  glUniform1ui(Int_val(location), Int_val(val));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniform2ui(value location, value val) {
  CAMLparam2(location, val);
  CHECK_FUNC(glUniform2ui, PFNGLUNIFORM2UIPROC);

  glUniform2ui(Int_val(location), Int_val(Field(val, 0)),
               Int_val(Field(val, 1)));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniform3ui(value location, value val) {
  CAMLparam2(location, val);
  CHECK_FUNC(glUniform3ui, PFNGLUNIFORM3UIPROC);

  glUniform3ui(Int_val(location), Int_val(Field(val, 0)),
               Int_val(Field(val, 1)), Int_val(Field(val, 2)));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniform4ui(value location, value val) {
  CAMLparam2(location, val);
  CHECK_FUNC(glUniform4ui, PFNGLUNIFORM4UIPROC);

  glUniform4ui(Int_val(location), Int_val(Field(val, 0)),
               Int_val(Field(val, 1)), Int_val(Field(val, 2)),
               Int_val(Field(val, 3)));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniformMatrix(value location, value transpose, value val) {
  CAMLparam3(location, transpose, val);
  CHECK_FUNC(glUniformMatrix2fv, PFNGLUNIFORMMATRIX2FVPROC);
  CHECK_FUNC(glUniformMatrix3fv, PFNGLUNIFORMMATRIX3FVPROC);
  CHECK_FUNC(glUniformMatrix4fv, PFNGLUNIFORMMATRIX4FVPROC);

  GLboolean gl_transpose = GL_FALSE;
  if (is_some(transpose) && Field(transpose, 0) == Val_true) {
    gl_transpose = GL_TRUE;
  }

  int count = Caml_ba_array_val(val)->dim[0];
  switch (count) {
    case 4:
      glUniformMatrix2fv(Int_val(location), 1, gl_transpose,
                         Caml_ba_data_val(val));
      break;
    case 9:
      glUniformMatrix3fv(Int_val(location), 1, gl_transpose,
                         Caml_ba_data_val(val));
      break;
    case 16:
      glUniformMatrix4fv(Int_val(location), 1, gl_transpose,
                         Caml_ba_data_val(val));
      break;
    default: caml_failwith("glUniformMatrix can give only 2x2, 3x3 or 4x4 matrix.");
  }

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniformMatrix2x3(value location, value transpose, value val) {
  CAMLparam3(location, transpose, val);
  CHECK_FUNC(glUniformMatrix2x3fv, PFNGLUNIFORMMATRIX2X3FVPROC);
  GLboolean gl_transpose = GL_FALSE;
  if (is_some(transpose) && Field(transpose, 0) == Val_true) {
    gl_transpose = GL_TRUE;
  }

  int count = Caml_ba_array_val(val)->dim[0];
  glUniformMatrix2x3fv(Int_val(location), count, gl_transpose,
                       Caml_ba_data_val(val));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniformMatrix3x2(value location, value transpose, value val) {
  CAMLparam3(location, transpose, val);
  CHECK_FUNC(glUniformMatrix3x2fv, PFNGLUNIFORMMATRIX3X2FVPROC);
  GLboolean gl_transpose = GL_FALSE;
  if (is_some(transpose) && Field(transpose, 0) == Val_true) {
    gl_transpose = GL_TRUE;
  }

  int count = Caml_ba_array_val(val)->dim[0];
  glUniformMatrix3x2fv(Int_val(location), count, gl_transpose,
                       Caml_ba_data_val(val));

  CAMLreturn(Val_unit);

}

CAMLprim value gl_api_glUniformMatrix2x4(value location, value transpose, value val) {
  CAMLparam3(location, transpose, val);
  CHECK_FUNC(glUniformMatrix2x4fv, PFNGLUNIFORMMATRIX2X4FVPROC);
  GLboolean gl_transpose = GL_FALSE;
  if (is_some(transpose) && Field(transpose, 0) == Val_true) {
    gl_transpose = GL_TRUE;
  }

  int count = Caml_ba_array_val(val)->dim[0];
  glUniformMatrix2x4fv(Int_val(location), count, gl_transpose,
                       Caml_ba_data_val(val));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniformMatrix4x2(value location, value transpose, value val) {
  CAMLparam3(location, transpose, val);
  CHECK_FUNC(glUniformMatrix4x2fv, PFNGLUNIFORMMATRIX4X2FVPROC);
  GLboolean gl_transpose = GL_FALSE;
  if (is_some(transpose) && Field(transpose, 0) == Val_true) {
    gl_transpose = GL_TRUE;
  }

  int count = Caml_ba_array_val(val)->dim[0];
  glUniformMatrix4x2fv(Int_val(location), count, gl_transpose,
                       Caml_ba_data_val(val));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniformMatrix3x4(value location, value transpose, value val) {
  CAMLparam3(location, transpose, val);
  CHECK_FUNC(glUniformMatrix3x4fv, PFNGLUNIFORMMATRIX3X4FVPROC);
  GLboolean gl_transpose = GL_FALSE;
  if (is_some(transpose) && Field(transpose, 0) == Val_true) {
    gl_transpose = GL_TRUE;
  }

  int count = Caml_ba_array_val(val)->dim[0];
  glUniformMatrix3x4fv(Int_val(location), count, gl_transpose,
                       Caml_ba_data_val(val));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniformMatrix4x3(value location, value transpose, value val) {
  CAMLparam3(location, transpose, val);
  CHECK_FUNC(glUniformMatrix4x3fv, PFNGLUNIFORMMATRIX4X3FVPROC);
  GLboolean gl_transpose = GL_FALSE;
  if (is_some(transpose) && Field(transpose, 0) == Val_true) {
    gl_transpose = GL_TRUE;
  }

  int count = Caml_ba_array_val(val)->dim[0];
  glUniformMatrix4x3fv(Int_val(location), count, gl_transpose,
                       Caml_ba_data_val(val));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUniformBlockBinding(value program, value index, value binding) {
  CAMLparam3(program, index, binding);
  CHECK_FUNC(glUniformBlockBinding, PFNGLUNIFORMBLOCKBINDINGPROC);

  glUniformBlockBinding(Int_val(program), Int_val(index), Int_val(binding));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glUseProgram(value program) {
  CAMLparam1(program);
  CHECK_FUNC(glUseProgram, PFNGLUSEPROGRAMPROC);

  glUseProgram(Int_val(program));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glValidateProgram(value program) {
  CAMLparam1(program);
  CHECK_FUNC(glValidateProgram, PFNGLVALIDATEPROGRAMPROC);

  glValidateProgram(Int_val(program));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glVertexAttribf(value index, value data) {
  CAMLparam2(index, data);
  CHECK_FUNC(glVertexAttrib1fv, PFNGLVERTEXATTRIB1FVPROC);
  CHECK_FUNC(glVertexAttrib2fv, PFNGLVERTEXATTRIB2FVPROC);
  CHECK_FUNC(glVertexAttrib3fv, PFNGLVERTEXATTRIB3FVPROC);
  CHECK_FUNC(glVertexAttrib4fv, PFNGLVERTEXATTRIB4FVPROC);

  int count = Caml_ba_array_val(data)->dim[0];
  switch (count) {
    case 1:
      glVertexAttrib1fv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 2:
      glVertexAttrib2fv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 3:
      glVertexAttrib3fv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 4:
      glVertexAttrib4fv(Int_val(index), Caml_ba_data_val(data));
      break;
  }

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glVertexAttribi(value index, value data) {
  CAMLparam2(index, data);
  CHECK_FUNC(glVertexAttribI1iv, PFNGLVERTEXATTRIBI1IVPROC);
  CHECK_FUNC(glVertexAttribI2iv, PFNGLVERTEXATTRIBI2IVPROC);
  CHECK_FUNC(glVertexAttribI3iv, PFNGLVERTEXATTRIBI3IVPROC);
  CHECK_FUNC(glVertexAttribI4iv, PFNGLVERTEXATTRIBI4IVPROC);

  int count = Caml_ba_array_val(data)->dim[0];
  switch (count) {
    case 1:
      glVertexAttribI1iv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 2:
      glVertexAttribI2iv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 3:
      glVertexAttribI3iv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 4:
      glVertexAttribI4iv(Int_val(index), Caml_ba_data_val(data));
      break;
  }

  CAMLreturn(Val_unit);
}
CAMLprim value gl_api_glVertexAttribui(value index, value data) {
  CAMLparam2(index, data);
  CHECK_FUNC(glVertexAttribI1uiv, PFNGLVERTEXATTRIBI1UIVPROC);
  CHECK_FUNC(glVertexAttribI2uiv, PFNGLVERTEXATTRIBI2UIVPROC);
  CHECK_FUNC(glVertexAttribI3uiv, PFNGLVERTEXATTRIBI3UIVPROC);
  CHECK_FUNC(glVertexAttribI4uiv, PFNGLVERTEXATTRIBI4UIVPROC);

  int count = Caml_ba_array_val(data)->dim[0];
  switch (count) {
    case 1:
      glVertexAttribI1uiv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 2:
      glVertexAttribI2uiv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 3:
      glVertexAttribI3uiv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 4:
      glVertexAttribI4uiv(Int_val(index), Caml_ba_data_val(data));
      break;
  }

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glVertexAttribs(value index, value data) {
  CAMLparam2(index, data);
  CHECK_FUNC(glVertexAttrib1sv, PFNGLVERTEXATTRIB1SVPROC);
  CHECK_FUNC(glVertexAttrib2sv, PFNGLVERTEXATTRIB2SVPROC);
  CHECK_FUNC(glVertexAttrib3sv, PFNGLVERTEXATTRIB3SVPROC);
  CHECK_FUNC(glVertexAttrib4sv, PFNGLVERTEXATTRIB4SVPROC);

  int count = Caml_ba_array_val(data)->dim[0];
  switch (count) {
    case 1:
      glVertexAttrib1sv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 2:
      glVertexAttrib2sv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 3:
      glVertexAttrib3sv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 4:
      glVertexAttrib4sv(Int_val(index), Caml_ba_data_val(data));
      break;
  }
  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glVertexAttribd(value index, value data) {
  CAMLparam2(index, data);
  CHECK_FUNC(glVertexAttrib1dv, PFNGLVERTEXATTRIB1DVPROC);
  CHECK_FUNC(glVertexAttrib2dv, PFNGLVERTEXATTRIB2DVPROC);
  CHECK_FUNC(glVertexAttrib3dv, PFNGLVERTEXATTRIB3DVPROC);
  CHECK_FUNC(glVertexAttrib4dv, PFNGLVERTEXATTRIB4DVPROC);

  int count = Caml_ba_array_val(data)->dim[0];
  switch (count) {
    case 1:
      glVertexAttrib1dv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 2:
      glVertexAttrib2dv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 3:
      glVertexAttrib3dv(Int_val(index), Caml_ba_data_val(data));
      break;
    case 4:
      glVertexAttrib4dv(Int_val(index), Caml_ba_data_val(data));
      break;
  }

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glVertexAttribDivisor(value index, value divisor) {
  CAMLparam2(index, divisor);
  CHECK_FUNC(glVertexAttribDivisor, PFNGLVERTEXATTRIBDIVISORPROC);

  glVertexAttribDivisor(Int_val(index), Int_val(divisor));

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glVertexAttribPointer(value index, value size,
                                            value vert_type, value normalize,
                                            value stride) {
  CAMLparam5(index, size, vert_type, normalize, stride);
  CHECK_FUNC(glVertexAttribPointer, PFNGLVERTEXATTRIBPOINTERPROC);
#include "enums/vertattr_type.inc"

  glVertexAttribPointer(Int_val(index), Int_val(size),
                        vertattr_type[Int_val(vert_type)], Bool_val(normalize),
                        Int_val(stride), NULL);

  CAMLreturn(Val_unit);
}

CAMLprim value gl_api_glGetFramebufferAttachmentParameter_type_color(
    value target, value num) {

  CAMLparam2(target, num);
  CHECK_FUNC(glGetFramebufferAttachmentParameteriv, PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC);
#include "enums/frame_buffer_type.inc"
#include "enums/attachment_object_type.inc"

  GLint param;
  glGetFramebufferAttachmentParameteriv(frame_buffer_type[Int_val(target)],
      GL_COLOR_ATTACHMENT0 + Int_val(num), GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE,
      &param);

  for (int i = 0; i < sizeof(attachment_object_type) / sizeof(attachment_object_type[0]); ++i) {
    if (attachment_object_type[i] == param) {
      CAMLreturn(Val_int(i));
    }
  }

  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetFramebufferAttachmentParameter_type_other(
  value target, value attachment) {

  CAMLparam2(target, attachment);
  CHECK_FUNC(glGetFramebufferAttachmentParameteriv, PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC);
#include "enums/frame_buffer_type.inc"
#include "enums/attachment_type.inc"
#include "enums/attachment_object_type.inc"

  GLint param;
  glGetFramebufferAttachmentParameteriv(frame_buffer_type[Int_val(target)],
                                        attachment_type[Int_val(attachment)], GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE,
                                        &param);

  for (int i = 0; i < sizeof(attachment_object_type) / sizeof(attachment_object_type[0]); ++i) {
    if (attachment_object_type[i] == param) {
      CAMLreturn(Val_int(i));
    }
  }

  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetFramebufferAttachmentParameter_int_color(
    value target, value num, value pname) {

  CAMLparam3(target, num, pname);
  CHECK_FUNC(glGetFramebufferAttachmentParameteriv, PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC);
#include "enums/frame_buffer_type.inc"
#include "enums/get_attachment_int.inc"

  GLint param;
  glGetFramebufferAttachmentParameteriv(frame_buffer_type[Int_val(target)],
      GL_COLOR_ATTACHMENT0 + Int_val(num),
      get_attachment_int[Int_val(pname)], &param);

  CAMLreturn(Val_int(param));
}

  CAMLprim value gl_api_glGetFramebufferAttachmentParameter_int_other(
  value target, value attachment, value pname) {

  CAMLparam3(target, attachment, pname);
  CHECK_FUNC(glGetFramebufferAttachmentParameteriv, PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC);
#include "enums/frame_buffer_type.inc"
#include "enums/get_attachment_int.inc"
#include "enums/attachment_type.inc"

  GLint param;
  glGetFramebufferAttachmentParameteriv(frame_buffer_type[Int_val(target)],
                                        attachment_type[Int_val(attachment)],
                                        get_attachment_int[Int_val(pname)], &param);

  CAMLreturn(Val_int(param));
}

CAMLprim value gl_api_glGetFramebufferAttachmentParameter_component_color(
    value target, value num) {

  CAMLparam2(target, num);
  CHECK_FUNC(glGetFramebufferAttachmentParameteriv, PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC);
#include "enums/frame_buffer_type.inc"
#include "enums/attachment_component_type.inc"

  GLint param;
  glGetFramebufferAttachmentParameteriv(frame_buffer_type[Int_val(target)],
      GL_COLOR_ATTACHMENT0 + Int_val(num),
      GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE,
      &param);

  for (int i = 0; i < sizeof(attachment_component_type) / sizeof(attachment_component_type[0]); ++i) {
  if (attachment_component_type[i] == param) {
  CAMLreturn(Val_int(i));
}
}

  CAMLreturn(Val_int(0));
}

  CAMLprim value gl_api_glGetFramebufferAttachmentParameter_component_other(
  value target, value attachment) {

  CAMLparam2(target, attachment);
  CHECK_FUNC(glGetFramebufferAttachmentParameteriv, PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC);
#include "enums/frame_buffer_type.inc"
#include "enums/attachment_component_type.inc"
#include "enums/attachment_type.inc"

  GLint param;
  glGetFramebufferAttachmentParameteriv(frame_buffer_type[Int_val(target)],
                                        attachment_type[Int_val(attachment)],
                                        GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE,
                                        &param);

  for (int i = 0; i < sizeof(attachment_component_type) / sizeof(attachment_component_type[0]); ++i) {
    if (attachment_component_type[i] == param) {
      CAMLreturn(Val_int(i));
    }
  }

  CAMLreturn(Val_int(0));
}

CAMLprim value gl_api_glGetFramebufferAttachmentParameter_encoding_color(
    value target, value num) {

  CAMLparam2(target, num);
  CHECK_FUNC(glGetFramebufferAttachmentParameteriv, PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC);
#include "enums/frame_buffer_type.inc"
#include "enums/attachment_encoding_type.inc"

  GLint param;
  glGetFramebufferAttachmentParameteriv(frame_buffer_type[Int_val(target)],
      GL_COLOR_ATTACHMENT0 + Int_val(num),
      GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING, &param);

  for (int i = 0; i < sizeof(attachment_encoding_type) / sizeof(attachment_encoding_type[0]); ++i) {
  if (attachment_encoding_type[i] == param) {
  CAMLreturn(Val_int(i));
}
}

  CAMLreturn(Val_int(0));
}

  CAMLprim value gl_api_glGetFramebufferAttachmentParameter_encoding_other(
  value target, value attachment) {

  CAMLparam2(target, attachment);
  CHECK_FUNC(glGetFramebufferAttachmentParameteriv, PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC);
#include "enums/frame_buffer_type.inc"
#include "enums/attachment_encoding_type.inc"
#include "enums/attachment_type.inc"

  GLint param;
  glGetFramebufferAttachmentParameteriv(frame_buffer_type[Int_val(target)],
                                        attachment_type[Int_val(attachment)],
                                        GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING, &param);

  for (int i = 0; i < sizeof(attachment_encoding_type) / sizeof(attachment_encoding_type[0]); ++i) {
    if (attachment_encoding_type[i] == param) {
      CAMLreturn(Val_int(i));
    }
  }

  CAMLreturn(Val_int(0));
}
