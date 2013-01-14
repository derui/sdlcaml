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
#include "gl_api_stubs_gl3_enable.inc"
#include "gl_api_legacy_compatibility.inc"
#else
#include "gl_api_stubs_gl3_disable.inc"
#include "gl_api_legacy.inc"
#endif

int ml_find_flag(GLenum *array, int size, GLenum query) {
  for (int i = 0; i < size; ++i) {
    if (array[i] == query) {
      return i;
    }
  }
  caml_failwith("key not found in a array");
  return -1;
}

#define t_prim CAMLprim value

t_prim gl_api_glClearColor(value _v_red, value _v_green, value _v_blue,
                                    value _v_alpha) {
  CAMLparam4(_v_red, _v_green, _v_blue, _v_alpha);
  float red; /*in*/
  float green; /*in*/
  float blue; /*in*/
  float alpha; /*in*/
  red = Double_val(_v_red);
  green = Double_val(_v_green);
  blue = Double_val(_v_blue);
  alpha = Double_val(_v_alpha);
  glClearColor(red, green, blue, alpha);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glClear(value _v_mask) {
  CAMLparam1(_v_mask);
  CAMLlocal1(v);
  unsigned int flags = 0;
#include "enums/clear_mask.inc"

  while (is_not_nil(_v_mask)) {
    v = head(_v_mask);
    flags |= clear_mask[Int_val(v)];
    _v_mask = tail(_v_mask);
  }

  glClear(flags);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glColorMask(value _v_red, value _v_green, value _v_blue,
                                   value _v_alpha) {
  CAMLparam4(_v_red, _v_green, _v_blue, _v_alpha);
  unsigned char red; /*in*/
  unsigned char green; /*in*/
  unsigned char blue; /*in*/
  unsigned char alpha; /*in*/
  red = Int_val(_v_red);
  green = Int_val(_v_green);
  blue = Int_val(_v_blue);
  alpha = Int_val(_v_alpha);
  glColorMask(red, green, blue, alpha);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glBlendFunc(value _v_sfactor, value _v_dfactor) {
  CAMLparam2(_v_sfactor, _v_dfactor);
#include "enums/blend_src_func.inc"
#include "enums/blend_dst_func.inc"

  glBlendFunc(blend_src_func[Int_val(_v_sfactor)],
              blend_dst_func[Int_val(_v_dfactor)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glLogicOp(value _v_opcode) {
  CAMLparam1(_v_opcode);
#include "enums/logic_opcode.inc"

  glLogicOp(logic_opcode[Int_val(_v_opcode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glCullFace(value _v_mode) {
  CAMLparam1(_v_mode);
#include "enums/cull_face_mode.inc"

  glCullFace(cull_face_mode[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glFrontFace(value _v_mode) {
  CAMLparam1(_v_mode);
#include "enums/ccw.inc"
  glFrontFace(ccw[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPointSize(value _v_size) {
  CAMLparam1(_v_size);

  float size = Double_val(_v_size);
  glPointSize(size);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glLineWidth(value _v_width) {
  CAMLparam1(_v_width);
  float width; /*in*/
  width = Double_val(_v_width);
  glLineWidth(width);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPolygonMode(value _v_face, value _v_mode) {
  CAMLparam2(_v_face, _v_mode);
#include "enums/cull_face_mode.inc"
#include "enums/poly_face_mode.inc"

  glPolygonMode(cull_face_mode[Int_val(_v_face)],
                poly_face_mode[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPolygonOffset(value _v_factor, value _v_units) {
  CAMLparam2(_v_factor, _v_units);
  float factor; /*in*/
  float units; /*in*/
  factor = Double_val(_v_factor);
  units = Double_val(_v_units);
  glPolygonOffset(factor, units);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glScissor(value _v_x, value _v_y, value _v_width, value _v_height) {
  CAMLparam4(_v_x, _v_y, _v_width, _v_height);
  int x; /*in*/
  int y; /*in*/
  int width; /*in*/
  int height; /*in*/
  x = Int_val(_v_x);
  y = Int_val(_v_y);
  width = Int_val(_v_width);
  height = Int_val(_v_height);
  glScissor(x, y, width, height);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glDrawBuffer(value _v_mode) {
  CAMLparam1(_v_mode);
#include "enums/draw_buffer_mode.inc"

  glDrawBuffer(draw_buffer_mode[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glDrawBuffer_aux(value aux) {
  CAMLparam1(aux);

  glDrawBuffer(GL_AUX0 + Int_val(aux));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glReadBuffer(value _v_mode) {
  CAMLparam1(_v_mode);
#include "enums/read_buffer_mode.inc"

  glReadBuffer(read_buffer_mode[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glReadBuffer_aux(value aux) {
  CAMLparam1(aux);

  glReadBuffer(GL_AUX0 + Int_val(aux));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glEnable(value _v_cap) {
  CAMLparam1(_v_cap);
#include "enums/enable_mode.inc"

  glEnable(enable_mode[Int_val(_v_cap)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glDisable(value _v_cap) {
  CAMLparam1(_v_cap);
#include "enums/enable_mode.inc"

  glDisable(enable_mode[Int_val(_v_cap)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glIsEnabled(value _v_cap) {
  CAMLparam1(_v_cap);
#include "enums/enable_mode.inc"

  unsigned char _res;
  value _vres;

  _res = glIsEnabled(enable_mode[Int_val(_v_cap)]);
  _vres = Val_bool(_res);
  CAMLreturn(_vres);
}

t_prim gl_api_glGetBoolean1(value _v_pname) {
  CAMLparam1(_v_pname);
#include "enums/get_boolean_1.inc"

  GLboolean params; /*out*/
  value _vres;

  glGetBooleanv(get_boolean_1[Int_val(_v_pname)], &params);
  _vres = Val_bool(params);
  CAMLreturn(_vres);
}

t_prim gl_api_glGetBoolean4(value _v_pname) {
  CAMLparam1(_v_pname);
  CAMLlocal1(res);
#include "enums/get_boolean_4.inc"

  GLboolean params[4]; /*out*/

  glGetBooleanv(get_boolean_4[Int_val(_v_pname)], params);
  res = caml_alloc(4, 0);
  Store_field(res, 0, Val_bool(params[0]));
  Store_field(res, 1, Val_bool(params[1]));
  Store_field(res, 2, Val_bool(params[2]));
  Store_field(res, 3, Val_bool(params[3]));
  CAMLreturn(res);
}

t_prim gl_api_glGetFloat1(value _v_pname) {
  CAMLparam1(_v_pname);
#include "enums/get_value_1.inc"

  float *params; /*out*/
  float _c1;
  value _vres;

  params = &_c1;
  glGetFloatv(get_value_1[Int_val(_v_pname)], params);
  _vres = copy_double(*params);
  CAMLreturn(_vres);
}

t_prim gl_api_glGetFloat2(value _v_pname) {
  CAMLparam1(_v_pname);
  CAMLlocal1(res);
#include "enums/get_value_2.inc"

  float params[2]; /*out*/

  glGetFloatv(get_value_2[Int_val(_v_pname)], params);
  res = caml_alloc(2 * Double_wosize, Double_array_tag);
  Store_double_field(res, 0, caml_copy_double(params[0]));
  Store_double_field(res, 1, caml_copy_double(params[1]));
  CAMLreturn(res);
}

t_prim gl_api_glGetFloat3(value _v_pname) {
  CAMLparam1(_v_pname);
  CAMLlocal1(res);

  float params[3]; /*out*/

  glGetFloatv(GL_CURRENT_NORMAL, params);
  res = caml_alloc(3 * Double_wosize, Double_array_tag);
  Store_double_field(res, 0, caml_copy_double(params[0]));
  Store_double_field(res, 1, caml_copy_double(params[1]));
  Store_double_field(res, 2, caml_copy_double(params[2]));
  CAMLreturn(res);
}

t_prim gl_api_glGetFloat4(value _v_pname) {
  CAMLparam1(_v_pname);
  CAMLlocal1(res);
#include "enums/get_value_4.inc"

  float params[4]; /*out*/

  glGetFloatv(get_value_4[Int_val(_v_pname)], params);
  res = caml_alloc(4 * Double_wosize, Double_array_tag);
  Store_double_field(res, 0, caml_copy_double(params[0]));
  Store_double_field(res, 1, caml_copy_double(params[1]));
  Store_double_field(res, 2, caml_copy_double(params[2]));
  Store_double_field(res, 3, caml_copy_double(params[3]));
  CAMLreturn(res);
}

t_prim gl_api_glGetInteger1(value _v_pname) {
  CAMLparam1(_v_pname);
  int *params; /*out*/
  int _c1;
  value _vres;
#include "enums/get_value_1.inc"

  params = &_c1;
  glGetIntegerv(get_value_1[Int_val(_v_pname)], params);
  _vres = Val_int(*params);
  CAMLreturn(_vres);
}

t_prim gl_api_glGetInteger2(value _v_pname) {
  CAMLparam1(_v_pname);
  CAMLlocal1(res);
  int params[2]; /*out*/
#include "enums/get_value_2.inc"

  glGetIntegerv(get_value_2[Int_val(_v_pname)], params);
  res = caml_alloc(2, 0);
  Store_field(res, 0, Val_int(params[0]));
  Store_field(res, 1, Val_int(params[1]));
  CAMLreturn(res);
}

t_prim gl_api_glGetInteger3(value _v_pname) {
  CAMLparam1(_v_pname);
  CAMLlocal1(res);
  int params[3]; /*out*/

  glGetIntegerv(GL_CURRENT_NORMAL, params);
  res = caml_alloc(3, 0);
  Store_field(res, 0, Val_int(params[0]));
  Store_field(res, 1, Val_int(params[1]));
  Store_field(res, 2, Val_int(params[2]));
  CAMLreturn(res);
}

t_prim gl_api_glGetInteger4(value _v_pname) {
  CAMLparam1(_v_pname);
  CAMLlocal1(res);
  int params[4]; /*out*/
#include "enums/get_value_4.inc"

  glGetIntegerv(get_value_4[Int_val(_v_pname)], params);
  res = caml_alloc(4, 0);
  Store_field(res, 0, Val_int(params[0]));
  Store_field(res, 1, Val_int(params[1]));
  Store_field(res, 2, Val_int(params[2]));
  Store_field(res, 3, Val_int(params[3]));
  CAMLreturn(res);
}

t_prim gl_api_glGetMatrix(value _v_pname) {
  CAMLparam1(_v_pname);
  CAMLlocal1(res);
  float params[16]; /*out*/
#include "enums/get_matrix.inc"

  glGetFloatv(get_matrix[Int_val(_v_pname)], params);
  res = caml_alloc(16 * Double_wosize, Double_array_tag);
  for (int i = 0; i < 16; ++i) {
    Store_double_field(res, i, params[i]);
  }

  CAMLreturn(res);
}

t_prim gl_api_glGetError(value _unit) {
  CAMLparam0();
  int _res;
#include "enums/get_error.inc"

  _res = glGetError();
  for (int i = 0; i < sizeof(get_error) / sizeof(get_error[0]); ++i) {
    if (get_error[i] == _res) {
      CAMLreturn(Val_int(i));
    }
  }
  CAMLreturn(Val_int(0));
}

t_prim gl_api_glGetString(value _v_name) {
  CAMLparam1(_v_name);
#include "enums/get_string.inc"

  unsigned char const *_res;
  value _vres;

  _res = glGetString(get_string[Int_val(_v_name)]);
  _vres = caml_copy_string((char const *)_res);
  CAMLreturn(_vres);
}

t_prim gl_api_glFinish(value _unit) {
  CAMLparam0();
  glFinish();
  CAMLreturn(Val_unit);
}

t_prim gl_api_glFlush(value _unit) {
  CAMLparam0();
  glFlush();
  CAMLreturn(Val_unit);
}

t_prim gl_api_glHint(value _v_target, value _v_mode) {
  CAMLparam2(_v_target, _v_mode);
#include "enums/hint_target.inc"
#include "enums/hint_mode.inc"

  glHint(hint_target[Int_val(_v_target)],
         hint_mode[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glClearDepth(value _v_depth) {
  CAMLparam1(_v_depth);
  double depth = Double_val(_v_depth);
  glClearDepth(depth);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glDepthFunc(value _v_func) {
  CAMLparam1(_v_func);
#include "enums/compare_func.inc"

  glDepthFunc(compare_func[Int_val(_v_func)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glDepthMask(value _v_flag) {
  CAMLparam1(_v_flag);
  glDepthMask(Val_bool(_v_flag));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glDepthRange(value _v_near_val, value _v_far_val) {
  CAMLparam2(_v_near_val, _v_far_val);
  double near_val = Double_val(_v_near_val);
  double far_val = Double_val(_v_far_val);
  glDepthRange(near_val, far_val);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glViewport(value _v_x, value _v_y, value _v_width,
                                  value _v_height) {
  CAMLparam4(_v_x, _v_y, _v_width, _v_height);
  int x; /*in*/
  int y; /*in*/
  int width; /*in*/
  int height; /*in*/
  x = Int_val(_v_x);
  y = Int_val(_v_y);
  width = Int_val(_v_width);
  height = Int_val(_v_height);
  glViewport(x, y, width, height);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glDrawArrays(value _v_mode, value _v_first,
                                    value _v_count) {
  CAMLparam3(_v_mode, _v_first, _v_count);
#include "enums/draw_mode.inc"

  int first; /*in*/
  int count; /*in*/
  first = Int_val(_v_first);
  count = Int_val(_v_count);
  glDrawArrays(draw_mode[Int_val(_v_mode)], first, count);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPixelStoreb(value _v_pname, value _v_param) {
  CAMLparam2(_v_pname, _v_param);
#include "enums/pixel_store_boolean.inc"

  glPixelStorei(pixel_store_boolean[Int_val(_v_pname)], Bool_val(_v_param));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPixelStorei(value _v_pname, value _v_param) {
  CAMLparam2(_v_pname, _v_param);
#include "enums/pixel_store_integer.inc"

  glPixelStorei(pixel_store_integer[Int_val(_v_pname)], Int_val(_v_param));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPixelStore_align(value _v_pname, value _v_param) {
  CAMLparam2(_v_pname, _v_param);
#include "enums/pixel_store_align.inc"

  glPixelStorei(pixel_store_align[Int_val(_v_pname)], 1 << Int_val(_v_param));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glStencilFunc(value _v_func, value _v_ref, value _v_mask) {
  CAMLparam3(_v_func, _v_ref, _v_mask);
#include "enums/compare_func.inc"

  int ref; /*in*/
  unsigned int mask; /*in*/
  ref = Int_val(_v_ref);
  mask = Int_val(_v_mask);
  glStencilFunc(compare_func[Int_val(_v_func)], ref, mask);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glStencilMask(value _v_mask) {
  CAMLparam1(_v_mask);
  unsigned int mask; /*in*/
  mask = Int_val(_v_mask);
  glStencilMask(mask);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glStencilOp(value _v_fail, value _v_zfail, value _v_zpass) {
  CAMLparam3(_v_fail, _v_zfail, _v_zpass);
#include "enums/stencil_op.inc"

  glStencilOp(stencil_op[Int_val(_v_fail)],
              stencil_op[Int_val(_v_zfail)],
              stencil_op[Int_val(_v_zpass)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glClearStencil(value _v_s) {
  CAMLparam1(_v_s);
  int s; /*in*/
  s = Int_val(_v_s);
  glClearStencil(s);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexParameter1(value _v_target, value _v_pname,
                                       value _v_param) {
  CAMLparam3(_v_target, _v_pname, _v_param);
#include "enums/texture_image_type.inc"
#include "enums/tex_parameter_1.inc"

  float param; /*in*/
  param = Double_val(_v_param);
  glTexParameterf(texture_image_type[Int_val(_v_target)],
                  tex_parameter_1[Int_val(_v_pname)], param);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexParameter4(value _v_target,
                                       value _v_param) {
  CAMLparam2(_v_target, _v_param);
#include "enums/texture_image_type.inc"

  GLfloat param[4];
  param[0] = Double_val(Field(_v_param, 0));
  param[1] = Double_val(Field(_v_param, 1));
  param[2] = Double_val(Field(_v_param, 2));
  param[3] = Double_val(Field(_v_param, 3));

  glTexParameterfv(texture_image_type[Int_val(_v_target)],
                   GL_TEXTURE_BORDER_COLOR, param);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexParameter_filter(value _v_target, value _v_pname,
                                             value _v_param) {
  CAMLparam3(_v_target, _v_pname, _v_param);
#include "enums/texture_image_type.inc"
#include "enums/tex_parameter_filter.inc"
#include "enums/tex_parameter_filter_type.inc"

  glTexParameteri(texture_image_type[Int_val(_v_target)],
                  tex_parameter_filter[Int_val(_v_pname)],
                  tex_parameter_filter_type[Int_val(_v_param)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexParameter_wrap(value _v_target, value _v_pname,
                                           value _v_param) {
  CAMLparam3(_v_target, _v_pname, _v_param);
#include "enums/texture_image_type.inc"
#include "enums/tex_parameter_wrap.inc"
#include "enums/tex_parameter_wrap_type.inc"

  glTexParameteri(texture_image_type[Int_val(_v_target)],
                  tex_parameter_wrap[Int_val(_v_pname)],
                  tex_parameter_wrap_type[Int_val(_v_param)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glGetTexParameter1(value _v_target, value _v_pname) {
  CAMLparam2(_v_target, _v_pname);
  float params[1]; /*in*/

#include "enums/texture_image_type.inc"
#include "enums/tex_parameter_1.inc"

  glGetTexParameterfv(texture_image_type[Int_val(_v_target)],
                      tex_parameter_1[Int_val(_v_pname)], params);
  CAMLreturn(copy_double(params[0]));
}

t_prim gl_api_glGetTexParameter4(value _v_target) {
  CAMLparam1(_v_target);
  CAMLlocal1(res);
  float params[4]; /*in*/

#include "enums/texture_image_type.inc"

  glGetTexParameterfv(texture_image_type[Int_val(_v_target)],
                      GL_TEXTURE_BORDER_COLOR, params);

  res = caml_alloc(4 * Double_wosize, Double_array_tag);
  Store_double_field(res, 0, params[0]);
  Store_double_field(res, 1, params[1]);
  Store_double_field(res, 2, params[2]);
  Store_double_field(res, 3, params[3]);
  CAMLreturn(res);
}

t_prim gl_api_glGetTexParameter_filter(value _v_target, value _v_pname) {
  CAMLparam2(_v_target, _v_pname);
  float params[1]; /*in*/

#include "enums/texture_image_type.inc"
#include "enums/tex_parameter_filter.inc"
#include "enums/tex_parameter_filter_type.inc"

  glGetTexParameterfv(texture_image_type[Int_val(_v_target)],
                      tex_parameter_filter[Int_val(_v_pname)], params);


  CAMLreturn(Val_int(ml_find_flag(tex_parameter_filter_type,
                                  sizeof(tex_parameter_filter_type), params[0])));
}

t_prim gl_api_glGetTexParameter_wrap(value _v_target, value _v_pname) {
  CAMLparam2(_v_target, _v_pname);
  float params[1]; /*in*/

#include "enums/texture_image_type.inc"
#include "enums/tex_parameter_wrap.inc"
#include "enums/tex_parameter_wrap_type.inc"

  glGetTexParameterfv(texture_image_type[Int_val(_v_target)],
                      tex_parameter_wrap[Int_val(_v_pname)], params);


  CAMLreturn(Val_int(ml_find_flag(tex_parameter_wrap_type,
                                  sizeof(tex_parameter_wrap_type), params[0])));
}

t_prim gl_api_glGenTextures(value _v_n) {
  CAMLparam1(_v_n);
  CAMLlocal1(_vres);
  int n; /*in*/
  unsigned int *textures; /*out*/

  n = Int_val(_v_n);
  textures = malloc(n * sizeof(unsigned int ));
  glGenTextures(n, textures);

  _vres = caml_alloc(n, 0);
  for (int i = 0; i < n; ++i) {
    Store_field(_vres, i, Val_int(textures[i]));
  }
  free(textures);

  CAMLreturn(_vres);
}

t_prim gl_api_glDeleteTextures(value _v_n, value _v_textures) {
  CAMLparam2(_v_n, _v_textures);
  int n; /*in*/
  n = Int_val(_v_n);
  unsigned int *textures = malloc(n * sizeof (unsigned int));
  for (int i = 0; i < n; ++i) {
    textures[i] = Int_val(Field(_v_textures, i));
  }

  glDeleteTextures(n, textures);
  free(textures);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glBindTexture(value _v_target, value _v_texture) {
  CAMLparam2(_v_target, _v_texture);
#include "enums/texture_image_type.inc"

  glBindTexture(texture_image_type[Int_val(_v_target)], Int_val(_v_texture));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glIsTexture(value _v_texture) {
  CAMLparam1(_v_texture);
  unsigned int texture; /*in*/
  unsigned char _res;

  texture = Int_val(_v_texture);
  _res = glIsTexture(texture);
  CAMLreturn(Val_bool(_res));
}

t_prim gl_api_glCopyTexImage1D(value _v_level, value _v_internalformat,
                                        value _v_x, value _v_y, value _v_width,
                                        value _v_border) {
  CAMLparam5(_v_level, _v_internalformat, _v_x, _v_y, _v_width);
  CAMLxparam1(_v_border);
  #include "enums/internal_format.inc"

  int level; /*in*/
  int x; /*in*/
  int y; /*in*/
  int width; /*in*/
  int border; /*in*/
  level = Int_val(_v_level);
  x = Int_val(_v_x);
  y = Int_val(_v_y);
  width = Int_val(_v_width);
  border = Int_val(_v_border);
  glCopyTexImage1D(GL_TEXTURE_1D, level, internal_format[Int_val(_v_internalformat)],
                   x, y, width, border);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glCopyTexImage1D_bytecode(value * argv, int argn) {
  return gl_api_glCopyTexImage1D(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

t_prim gl_api_glCopyTexImage2D(value _v_level, value _v_internalformat,
                               value _v_x, value _v_y, value _v_width,
                               value _v_height, value _v_border) {
  CAMLparam5(_v_level, _v_internalformat, _v_x, _v_y, _v_width);
  CAMLxparam2(_v_height, _v_border);
  #include "enums/internal_format.inc"

  int level; /*in*/
  int x; /*in*/
  int y; /*in*/
  int width; /*in*/
  int height; /*in*/
  int border; /*in*/
  level = Int_val(_v_level);
  x = Int_val(_v_x);
  y = Int_val(_v_y);
  width = Int_val(_v_width);
  height = Int_val(_v_height);
  border = Int_val(_v_border);
  glCopyTexImage2D(GL_TEXTURE_2D, level, internal_format[Int_val(_v_internalformat)],
                   x, y, width, height, border);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glCopyTexImage2D_bytecode(value * argv, int argn)
{
  return gl_api_glCopyTexImage2D(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6]);
}

t_prim gl_api_glCopyTexSubImage1D(value _v_level, value _v_xoffset,
                                           value _v_x, value _v_y, value _v_width) {
  CAMLparam5(_v_level, _v_xoffset, _v_x, _v_y, _v_width);
  int level; /*in*/
  int xoffset; /*in*/
  int x; /*in*/
  int y; /*in*/
  int width; /*in*/
  level = Int_val(_v_level);
  xoffset = Int_val(_v_xoffset);
  x = Int_val(_v_x);
  y = Int_val(_v_y);
  width = Int_val(_v_width);
  glCopyTexSubImage1D(GL_TEXTURE_1D, level, xoffset, x, y, width);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glCopyTexSubImage2D(value _v_level, value _v_xoffset,
                                           value _v_yoffset, value _v_x, value _v_y,
                                           value _v_width, value _v_height) {
  CAMLparam5(_v_level, _v_xoffset, _v_yoffset, _v_x, _v_y);
  CAMLxparam2(_v_width, _v_height);
  int level; /*in*/
  int xoffset; /*in*/
  int yoffset; /*in*/
  int x; /*in*/
  int y; /*in*/
  int width; /*in*/
  int height; /*in*/
  level = Int_val(_v_level);
  xoffset = Int_val(_v_xoffset);
  yoffset = Int_val(_v_yoffset);
  x = Int_val(_v_x);
  y = Int_val(_v_y);
  width = Int_val(_v_width);
  height = Int_val(_v_height);
  glCopyTexSubImage2D(GL_TEXTURE_2D, level, xoffset, yoffset, x, y, width, height);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glCopyTexSubImage2D_bytecode(value * argv, int argn)
{
  return gl_api_glCopyTexSubImage2D(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6]);
}

t_prim gl_api_glCopyTexSubImage3D(value _v_level, value _v_xoffset,
                                           value _v_yoffset, value _v_zoffset,
                                           value _v_x, value _v_y,
                                           value _v_width, value _v_height) {
  CAMLparam5(_v_level, _v_xoffset, _v_yoffset, _v_zoffset, _v_x);
  CAMLxparam3(_v_y, _v_width, _v_height);
  int level; /*in*/
  int xoffset; /*in*/
  int yoffset; /*in*/
  int zoffset; /*in*/
  int x; /*in*/
  int y; /*in*/
  int width; /*in*/
  int height; /*in*/
  level = Int_val(_v_level);
  xoffset = Int_val(_v_xoffset);
  yoffset = Int_val(_v_yoffset);
  zoffset = Int_val(_v_zoffset);
  x = Int_val(_v_x);
  y = Int_val(_v_y);
  width = Int_val(_v_width);
  height = Int_val(_v_height);
  glCopyTexSubImage3D(GL_TEXTURE_3D, level, xoffset, yoffset, zoffset, x, y, width, height);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glCopyTexSubImage3D_bytecode(value * argv, int argn) {
  return gl_api_glCopyTexSubImage3D(argv[0], argv[1], argv[2], argv[3],
                                             argv[4], argv[5], argv[6], argv[7]);
}

t_prim gl_api_glBlendEquation(value _v_mode) {
  CAMLparam1(_v_mode);
  #include "enums/blend_func.inc"

  glBlendEquation(blend_func[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glBlendColor(value _v_red, value _v_green, value _v_blue,
                                    value _v_alpha) {
  CAMLparam4(_v_red, _v_green, _v_blue, _v_alpha);
  float red; /*in*/
  float green; /*in*/
  float blue; /*in*/
  float alpha; /*in*/
  red = Double_val(_v_red);
  green = Double_val(_v_green);
  blue = Double_val(_v_blue);
  alpha = Double_val(_v_alpha);
  glBlendColor(red, green, blue, alpha);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glActiveTexture(value _v_texture) {
  CAMLparam1(_v_texture);
  glActiveTexture(GL_TEXTURE0 + Int_val(_v_texture));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glSampleCoverage(value _v_value, value _v_invert) {
  CAMLparam2(_v_value, _v_invert);
  float val; /*in*/
  unsigned char invert; /*in*/
  val = Double_val(_v_value);
  invert = Bool_val(_v_invert);
  glSampleCoverage(val, invert);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glDrawElements(value mode, value elements_type, value indices) {
  CAMLparam3(mode, elements_type, indices);
#include "enums/draw_mode.inc"
#include "enums/draw_elements_type.inc"

  glDrawElements(draw_mode[Int_val(mode)],
                 Caml_ba_array_val(indices)->dim[0],
                 draw_elements_type[Int_val(elements_type)],
                 Caml_ba_data_val(indices));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glReadPixels_native(value x, value y, value width, value height, value format, value pixel_type,
                                  value pointer) {
  CAMLparam5(x, y, width, height, format);
  CAMLxparam2(pixel_type, pointer);
  CAMLlocal1(barray);
#include "enums/read_pixel_format.inc"
#include "enums/read_pixel_type.inc"

  glReadPixels(Int_val(x), Int_val(y), Int_val(width), Int_val(height),
               read_pixel_format[Int_val(format)],
               read_pixel_type[Int_val(pixel_type)],
               Caml_ba_data_val(pointer));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glReadPixels_bytecode(value *argv, int argc) {
  return gl_api_glReadPixels_native(
      argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6]);

}

t_prim gl_api_glGetTexLevelParameter_format(value target, value level) {
  CAMLparam2(target, level);
#include "enums/texlevel_target.inc"
#include "enums/internal_format.inc"

  GLint val;
  glGetTexLevelParameteriv(texlevel_target[Int_val(target)],
                           Int_val(level),
                           GL_TEXTURE_INTERNAL_FORMAT,
                           &val);
  for (int i = 0; i < sizeof(internal_format); ++i) {
    if (internal_format[i] == val) {
      CAMLreturn(Val_int(i));
    }
  }
  CAMLreturn(Val_int(-1));
}

t_prim gl_api_glGetTexLevelParameter(value target, value level, value pname) {
  CAMLparam3(target, level, pname);
#include "enums/texlevel_target.inc"
#include "enums/internal_format.inc"

  int v;
  glGetTexLevelParameteriv(texlevel_target[Int_val(target)],
                           Int_val(level),
                           internal_format[Int_val(pname)],
                           &v);

  CAMLreturn(Val_int(v));
}

t_prim gl_api_glTexImage1D_native(value target, value level, value internalformat,
                                  value width, value border, value format, value type, value data) {
  CAMLparam5(target, level, internalformat, width, border);
  CAMLxparam3(format, type, data);
#include "enums/image_1d_type.inc"
#include "enums/internal_format.inc"
#include "enums/texture_format.inc"
#include "enums/texture_type.inc"

  glTexImage1D(image_1d_type[Int_val(target)],
               Int_val(level), internal_format[Int_val(internalformat)],
               Int_val(width), Int_val(border),
               texture_format[Int_val(format)],
               texture_type[Int_val(type)],
               (const GLvoid*)Caml_ba_data_val(data));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexImage1D_bytecode(value *argv, int argc) {
  return gl_api_glTexImage1D_native(
      argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6], argv[7]);
}

t_prim gl_api_glTexImage2D_native(value target, value level, value internalformat,
                                  value width, value height, value border,
                                  value format, value type, value data) {
  CAMLparam5(target, level, internalformat, width, border);
  CAMLxparam4(height, format, type, data);
#include "enums/image_2d_type.inc"
#include "enums/internal_format.inc"
#include "enums/texture_format.inc"
#include "enums/texture_type.inc"

  glTexImage2D(image_2d_type[Int_val(target)],
               Int_val(level), internal_format[Int_val(internalformat)],
               Int_val(width), Int_val(height),
               Int_val(border),
               texture_format[Int_val(format)],
               texture_type[Int_val(type)],
               (const GLvoid*)Caml_ba_data_val(data));

  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexImage2D_bytecode(value *argv, int argc) {
  return gl_api_glTexImage2D_native(
      argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6], argv[7], argv[8]);
}

t_prim gl_api_glTexImage3D_native(value target, value level, value internalformat,
                                  value width, value height, value depth, value border,
                                  value format, value type, value data) {
  CAMLparam5(target, level, internalformat, width, border);
  CAMLxparam5(height, depth, format, data, type);
#include "enums/image_3d_type.inc"
#include "enums/internal_format.inc"
#include "enums/texture_format.inc"
#include "enums/texture_type.inc"

  glTexImage3D(image_3d_type[Int_val(target)],
               Int_val(level), internal_format[Int_val(internalformat)],
               Int_val(width), Int_val(height), Int_val(depth),
               Int_val(border),
               texture_format[Int_val(format)],
               texture_type[Int_val(type)],
               (const GLvoid*)Caml_ba_data_val(data));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexImage3D_bytecode(value *argv, int argc) {
  return gl_api_glTexImage3D_native(
      argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6],
      argv[7], argv[8], argv[9]);
}

t_prim gl_api_glTexSubImage1D_native(value level, value xoffset,
                                     value width, value format, value type, value data) {
  CAMLparam5(level, xoffset, width, format, type);
  CAMLxparam1(data);
#include "enums/texture_format.inc"
#include "enums/texture_type.inc"

  glTexSubImage1D(GL_TEXTURE_1D,
                  Int_val(level), Int_val(xoffset),
                  Int_val(width),
                  texture_format[Int_val(format)],
                  texture_type[Int_val(type)],
                  Caml_ba_data_val(data));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexSubImage1D_bytecode(value *argv, int argc) {
  return gl_api_glTexSubImage1D_native(
      argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

t_prim gl_api_glTexSubImage2D_native(value level, value xoffset, value yoffset,
                                     value width, value height, value format, value type, value data) {
  CAMLparam5(level, xoffset, yoffset, width, height);
  CAMLxparam3(format, type, data);
#include "enums/texture_format.inc"
#include "enums/texture_type.inc"

  glTexSubImage2D(GL_TEXTURE_2D,
                  Int_val(level), Int_val(xoffset), Int_val(yoffset),
                  Int_val(width), Int_val(height),
                  texture_format[Int_val(format)],
                  texture_type[Int_val(type)],
                  Caml_ba_data_val(data));

  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexSubImage2D_bytecode(value *argv, int argc) {
  return gl_api_glTexSubImage2D_native(
      argv[0], argv[1], argv[2], argv[3], argv[4], argv[5],
      argv[6], argv[7]);
}

t_prim gl_api_glTexSubImage3D_native(value level,
                                     value xoffset, value yoffset, value zoffset,
                                     value width, value height, value depth,
                                     value format, value type, value data) {
  CAMLparam5(level, xoffset, yoffset, zoffset, width);
  CAMLxparam5(height, depth, format, type, data);

#include "enums/texture_format.inc"
#include "enums/texture_type.inc"

  glTexSubImage3D(GL_TEXTURE_3D,
                  Int_val(level), Int_val(xoffset), Int_val(yoffset), Int_val(zoffset),
                  Int_val(width), Int_val(height), Int_val(depth),
                  texture_format[Int_val(format)],
                  texture_type[Int_val(type)],
                  Caml_ba_data_val(data));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexSubImage3D_bytecode(value *argv, int argc) {
  return gl_api_glTexSubImage3D_native(
      argv[0], argv[1], argv[2], argv[3], argv[4], argv[5],
      argv[6], argv[7], argv[8], argv[9]);
}

t_prim gl_api_glDrawRangeElements(value mode, value start, value end, value type, value indices) {
  CAMLparam5(mode, start, end, type, indices);
#include "enums/draw_mode.inc"
#include "enums/index_type.inc"

  glDrawRangeElements(draw_mode[Int_val(mode)],
                      Int_val(start), Int_val(end), Caml_ba_array_val(indices)->dim[0],
                      index_type[Int_val(type)],
                      Caml_ba_data_val(indices));
  CAMLreturn(Val_unit);
}
