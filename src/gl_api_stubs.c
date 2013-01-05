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

#if defined(GL3_ENABLE)
#include "gl_api_stubs_gl3_enable.inc"
#else
#include "gl_api_stubs_gl3_disable.inc"
#endif

int ml_find_flag(GLenum *array, int size, GLenum query) {
  for (int i = 0; i < size; ++i) {
    if (array[i] == query) {
      return i;
    }
  }
  return -1;
}

#define t_prim CAMLprim value

t_prim gl_api_glClearIndex(value _v_c) {
  CAMLparam1(_v_c);
  glClearIndex(Double_val(_v_c));
  CAMLreturn(Val_unit);
}

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

t_prim gl_api_glIndexMask(value _v_mask) {
  CAMLparam1(_v_mask);
  glIndexMask(Int_val(_v_mask));
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

t_prim gl_api_glAlphaFunc(value _v_func, value _v_ref) {
  CAMLparam2(_v_func, _v_ref);
#include "enums/compare_func.inc"
  glAlphaFunc(compare_func[Int_val(_v_func)],
              Double_val(_v_ref));
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

t_prim gl_api_glLineStipple(value _v_factor, value _v_pattern) {
  CAMLparam2(_v_factor, _v_pattern);
  int factor; /*in*/
  unsigned short pattern; /*in*/
  factor = Int_val(_v_factor);
  pattern = Int_val(_v_pattern);
  glLineStipple(factor, pattern);
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

t_prim gl_api_glPolygonStipple(value _v_mask) {
  CAMLparam1(_v_mask);
  glPolygonStipple(Caml_ba_data_val(_v_mask));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glGetPolygonStipple(value _unit) {
  CAMLparam1(_unit);
  CAMLlocal1(_vres);
  unsigned char *mask; /*out*/

  mask = stat_alloc(128 * sizeof(unsigned char ));
  glGetPolygonStipple(mask);
  _vres = alloc_bigarray_dims(
      BIGARRAY_UINT8 | BIGARRAY_C_LAYOUT | BIGARRAY_MANAGED,
      1, mask, 128);
  CAMLreturn(_vres);
}

t_prim gl_api_glEdgeFlag(value _v_flag) {
  CAMLparam1(_v_flag);
  int flag = Int_val(_v_flag);
  glEdgeFlag(flag);
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

t_prim gl_api_glClipPlane(value _v_plane, value _v_equation) {
  CAMLparam2(_v_plane, _v_equation);
#include "enums/clip_plane.inc"

  glClipPlane(clip_plane[Int_val(_v_plane)],
              Caml_ba_data_val(_v_equation));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glClipPlanei(value _v_plane, value _v_equation) {
  CAMLparam2(_v_plane, _v_equation);

  glClipPlane(GL_CLIP_PLANE0 + Int_val(_v_plane),
              Caml_ba_data_val(_v_equation));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glGetClipPlane(value _v_plane, value data) {
  CAMLparam2(_v_plane, data);
#include "enums/clip_plane.inc"

  glGetClipPlane(clip_plane[Int_val(_v_plane)],
                 Caml_ba_data_val(data));
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

t_prim gl_api_glEnableClientState(value _v_cap) {
  CAMLparam1(_v_cap);
#include "enums/client_state_mode.inc"

  glEnableClientState(client_state_mode[Int_val(_v_cap)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glDisableClientState(value _v_cap) {
  CAMLparam1(_v_cap);
#include "enums/client_state_mode.inc"

  glDisableClientState(client_state_mode[Int_val(_v_cap)]);
  CAMLreturn(Val_unit);
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

t_prim gl_api_glPushAttrib(value _v_mask) {
  CAMLparam1(_v_mask);
#include "enums/attrib_mask.inc"

  glPushAttrib(attrib_mask[Int_val(_v_mask)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPopAttrib(value _unit) {
  CAMLparam0();
  glPopAttrib();
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPushClientAttrib(value _v_mask) {
  CAMLparam1(_v_mask);
#include "enums/client_attrib_mask.inc"

  glPushClientAttrib(client_attrib_mask[Int_val(_v_mask)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPopClientAttrib(value _unit) {
  CAMLparam0();
  glPopClientAttrib();
  CAMLreturn(Val_unit);
}

t_prim gl_api_glRenderMode(value _v_mode) {
  CAMLparam1(_v_mode);
  int _res;
  value _vres;
#include "enums/render_mode.inc"

  _res = glRenderMode(render_mode[Int_val(_v_mode)]);
  _vres = Val_int(_res);
  CAMLreturn(_vres);
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

t_prim gl_api_glClearAccum(value _v_red, value _v_green,
                                    value _v_blue, value _v_alpha) {
  CAMLparam4(_v_red, _v_green, _v_blue, _v_alpha);
  float red; /*in*/
  float green; /*in*/
  float blue; /*in*/
  float alpha; /*in*/
  red = Double_val(_v_red);
  green = Double_val(_v_green);
  blue = Double_val(_v_blue);
  alpha = Double_val(_v_alpha);
  glClearAccum(red, green, blue, alpha);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glAccum(value _v_op, value _v_value) {
  CAMLparam2(_v_op, _v_value);
#include "enums/accum_op.inc"

  float val; /*in*/
  val = Double_val(_v_value);
  glAccum(accum_op[Int_val(_v_op)], val);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMatrixMode(value _v_mode) {
  CAMLparam1(_v_mode);
#include "enums/matrix_mode.inc"

  glMatrixMode(matrix_mode[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glOrtho(value _v_left, value _v_right, value _v_bottom,
                               value _v_top, value _v_near_val, value _v_far_val) {
  CAMLparam5(_v_left, _v_right, _v_bottom, _v_top, _v_near_val);
  CAMLxparam1(_v_far_val);
  double left; /*in*/
  double right; /*in*/
  double bottom; /*in*/
  double top; /*in*/
  double near_val; /*in*/
  double far_val; /*in*/
  left = Double_val(_v_left);
  right = Double_val(_v_right);
  bottom = Double_val(_v_bottom);
  top = Double_val(_v_top);
  near_val = Double_val(_v_near_val);
  far_val = Double_val(_v_far_val);
  glOrtho(left, right, bottom, top, near_val, far_val);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glOrtho_bytecode(value * argv, int argn) {
  return gl_api_glOrtho(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

t_prim gl_api_glFrustum(value _v_left, value _v_right, value _v_bottom,
                                 value _v_top, value _v_near_val, value _v_far_val) {
  CAMLparam5(_v_left, _v_right, _v_bottom, _v_top, _v_near_val);
  CAMLxparam1(_v_far_val);
  double left; /*in*/
  double right; /*in*/
  double bottom; /*in*/
  double top; /*in*/
  double near_val; /*in*/
  double far_val; /*in*/
  left = Double_val(_v_left);
  right = Double_val(_v_right);
  bottom = Double_val(_v_bottom);
  top = Double_val(_v_top);
  near_val = Double_val(_v_near_val);
  far_val = Double_val(_v_far_val);
  glFrustum(left, right, bottom, top, near_val, far_val);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glFrustum_bytecode(value * argv, int argn) {
  return gl_api_glFrustum(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
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

t_prim gl_api_glPushMatrix(value _unit) {
  CAMLparam0();
  glPushMatrix();
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPopMatrix(value _unit) {
  CAMLparam0();
  glPopMatrix();
  CAMLreturn(Val_unit);
}

t_prim gl_api_glLoadIdentity(value _unit) {
  CAMLparam0();
  glLoadIdentity();
  CAMLreturn(Val_unit);
}

t_prim gl_api_glLoadMatrix(value _v_m) {
  CAMLparam1(_v_m);
  float array[16];
  for (int i = 0; i < 16; ++i) {
    array[i] = Double_field(_v_m, i);
  }

  glLoadMatrixf(array);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMultMatrix(value _v_m) {
  CAMLparam1(_v_m);
  const int size = 16;
  float array[size];
  for (int i = 0; i < size; ++i) {
    array[i] = Double_field(_v_m, i);
  }

  glMultMatrixf(array);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glRotate(value _v_angle, value _v_x, value _v_y,
                                value _v_z) {
  CAMLparam4(_v_angle, _v_x, _v_y, _v_z);
  float angle; /*in*/
  float x; /*in*/
  float y; /*in*/
  float z; /*in*/
  angle = Double_val(_v_angle);
  x = Double_val(_v_x);
  y = Double_val(_v_y);
  z = Double_val(_v_z);
  glRotatef(angle, x, y, z);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glScale(value _v_x, value _v_y, value _v_z) {
  CAMLparam3(_v_x, _v_y, _v_z);
  float x; /*in*/
  float y; /*in*/
  float z; /*in*/
  x = Double_val(_v_x);
  y = Double_val(_v_y);
  z = Double_val(_v_z);
  glScalef(x, y, z);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTranslate(value _v_x, value _v_y, value _v_z) {
  CAMLparam3(_v_x, _v_y, _v_z);
  float x; /*in*/
  float y; /*in*/
  float z; /*in*/
  x = Double_val(_v_x);
  y = Double_val(_v_y);
  z = Double_val(_v_z);
  glTranslatef(x, y, z);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glIsList(value _v_list) {
  CAMLparam1(_v_list);
  unsigned char _res;
  value _vres;

  _res = glIsList(Int_val(_v_list));
  _vres = Val_bool(_res);
  CAMLreturn(_vres);
}

t_prim gl_api_glDeleteLists(value _v_list, value _v_range) {
  CAMLparam2(_v_list, _v_range);
  unsigned int list; /*in*/
  int range; /*in*/
  list = Int_val(_v_list);
  range = Int_val(_v_range);
  glDeleteLists(list, range);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glGenLists(value _v_range) {
  CAMLparam1(_v_range);
  int range; /*in*/
  unsigned int _res;
  value _vres;

  range = Int_val(_v_range);
  _res = glGenLists(range);
  _vres = Val_int(_res);
  CAMLreturn(_vres);
}

t_prim gl_api_glNewList(value _v_list, value _v_mode) {
  CAMLparam2(_v_list, _v_mode);
#include "enums/newlist_mode.inc"

  glNewList(Int_val(_v_list), newlist_mode[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glEndList(value _unit) {
  CAMLparam0();
  glEndList();
  CAMLreturn(Val_unit);
}

t_prim gl_api_glCallList(value _v_list) {
  CAMLparam1(_v_list);
  glCallList(Int_val(_v_list));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glListBase(value _v_base) {
  CAMLparam1(_v_base);
  glListBase(Int_val(_v_base));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glBegin(value _v_mode) {
  CAMLparam1(_v_mode);
#include "enums/draw_mode.inc"

  glBegin(draw_mode[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glEnd(value _unit) {
  CAMLparam0();
  glEnd();
  CAMLreturn(Val_unit);
}

t_prim gl_api_glVertex2(value _v_x, value _v_y) {
  CAMLparam2(_v_x, _v_y);
  float x; /*in*/
  float y; /*in*/
  x = Double_val(_v_x);
  y = Double_val(_v_y);
  glVertex2f(x, y);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glVertex2v(value _v_x) {
  CAMLparam1(_v_x);
  float x; /*in*/
  float y; /*in*/
  x = Double_val(Field(_v_x, 0));
  y = Double_val(Field(_v_x, 1));
  glVertex2f(x, y);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glVertex3(value _v_x, value _v_y, value _v_z) {
  CAMLparam3(_v_x, _v_y, _v_z);
  float x; /*in*/
  float y; /*in*/
  float z; /*in*/
  x = Double_val(_v_x);
  y = Double_val(_v_y);
  z = Double_val(_v_z);
  glVertex3f(x, y, z);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glVertex3v(value _v_x) {
  CAMLparam1(_v_x);
  float x; /*in*/
  float y; /*in*/
  float z; /*in*/
  x = Double_val(Field(_v_x, 0));
  y = Double_val(Field(_v_x, 1));
  z = Double_val(Field(_v_x, 2));
  glVertex3f(x, y, z);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glVertex4(value _v_x, value _v_y, value _v_z, value _v_w) {
  CAMLparam4(_v_x, _v_y, _v_z, _v_w);
  float x; /*in*/
  float y; /*in*/
  float z; /*in*/
  float w; /*in*/
  x = Double_val(_v_x);
  y = Double_val(_v_y);
  z = Double_val(_v_z);
  w = Double_val(_v_w);
  glVertex4f(x, y, z, w);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glVertex4v(value _v_x) {
  CAMLparam1(_v_x);
  float x; /*in*/
  float y; /*in*/
  float z; /*in*/
  float w; /*in*/
  x = Double_val(Field(_v_x, 0));
  y = Double_val(Field(_v_x, 1));
  z = Double_val(Field(_v_x, 2));
  w = Double_val(Field(_v_x, 3));
  glVertex4f(x, y, z, w);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glNormal(value _v_nx, value _v_ny, value _v_nz) {
  CAMLparam3(_v_nx, _v_ny, _v_nz);
  float nx; /*in*/
  float ny; /*in*/
  float nz; /*in*/
  nx = Double_val(_v_nx);
  ny = Double_val(_v_ny);
  nz = Double_val(_v_nz);

  glNormal3f(nx, ny, nz);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glNormalv(value _v_nx) {
  CAMLparam1(_v_nx);
  float nx; /*in*/
  float ny; /*in*/
  float nz; /*in*/
  nx = Double_val(Field(_v_nx, 0));
  ny = Double_val(Field(_v_nx, 1));
  nz = Double_val(Field(_v_nx, 2));
  glNormal3f(nx, ny, nz);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glIndex(value _v_c) {
  CAMLparam1(_v_c);
  float c; /*in*/
  c = Double_val(_v_c);
  glIndexf(c);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glColor3(value _v_red, value _v_green, value _v_blue) {
  CAMLparam3(_v_red, _v_green, _v_blue);
  float red; /*in*/
  float green; /*in*/
  float blue; /*in*/
  red = Double_val(_v_red);
  green = Double_val(_v_green);
  blue = Double_val(_v_blue);
  glColor3f(red, green, blue);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glColor3v(value _v_col) {
  CAMLparam1(_v_col);
  float red; /*in*/
  float green; /*in*/
  float blue; /*in*/
  red = Double_val(Field(_v_col, 0));
  green = Double_val(Field(_v_col, 1));
  blue = Double_val(Field(_v_col, 2));
  glColor3f(red, green, blue);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glColor4(value _v_red, value _v_green, value _v_blue,
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
  glColor4f(red, green, blue, alpha);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glColor4v(value _v_col) {
  CAMLparam1(_v_col);
  float red; /*in*/
  float green; /*in*/
  float blue; /*in*/
  float alpha; /*in*/
  red = Double_val(Field(_v_col, 0));
  green = Double_val(Field(_v_col, 1));
  blue = Double_val(Field(_v_col, 2));
  alpha = Double_val(Field(_v_col, 3));
  glColor4f(red, green, blue, alpha);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexCoord1(value _v_s) {
  CAMLparam1(_v_s);
  float s; /*in*/
  s = Double_val(_v_s);
  glTexCoord1f(s);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexCoord2(value _v_s, value _v_t) {
  CAMLparam2(_v_s, _v_t);
  float s; /*in*/
  float t; /*in*/
  s = Double_val(_v_s);
  t = Double_val(_v_t);
  glTexCoord2f(s, t);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexCoord3(value _v_s, value _v_t, value _v_r) {
  CAMLparam3(_v_s, _v_t, _v_r);
  float s; /*in*/
  float t; /*in*/
  float r; /*in*/
  s = Double_val(_v_s);
  t = Double_val(_v_t);
  r = Double_val(_v_r);
  glTexCoord3f(s, t, r);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexCoord4(value _v_s, value _v_t,
                                   value _v_r, value _v_q) {
  CAMLparam4(_v_s, _v_t, _v_r, _v_q);
  float s; /*in*/
  float t; /*in*/
  float r; /*in*/
  float q; /*in*/
  s = Double_val(_v_s);
  t = Double_val(_v_t);
  r = Double_val(_v_r);
  q = Double_val(_v_q);
  glTexCoord4f(s, t, r, q);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glRasterPos2(value _v_x, value _v_y) {
  CAMLparam2(_v_x, _v_y);
  float x; /*in*/
  float y; /*in*/
  x = Double_val(_v_x);
  y = Double_val(_v_y);
  glRasterPos2f(x, y);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glRasterPos3(value _v_x, value _v_y, value _v_z) {
  CAMLparam3(_v_x, _v_y, _v_z);
  float x; /*in*/
  float y; /*in*/
  float z; /*in*/
  x = Double_val(_v_x);
  y = Double_val(_v_y);
  z = Double_val(_v_z);
  glRasterPos3f(x, y, z);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glRasterPos4(value _v_x, value _v_y, value _v_z,
                                    value _v_w) {
  CAMLparam4(_v_x, _v_y, _v_z, _v_w);
  float x; /*in*/
  float y; /*in*/
  float z; /*in*/
  float w; /*in*/
  x = Double_val(_v_x);
  y = Double_val(_v_y);
  z = Double_val(_v_z);
  w = Double_val(_v_w);
  glRasterPos4f(x, y, z, w);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glRect(value _v_x1, value _v_y1,
                              value _v_x2, value _v_y2) {
  CAMLparam4(_v_x1, _v_y1, _v_x2, _v_y2);
  float x1; /*in*/
  float y1; /*in*/
  float x2; /*in*/
  float y2; /*in*/
  x1 = Double_val(_v_x1);
  y1 = Double_val(_v_y1);
  x2 = Double_val(_v_x2);
  y2 = Double_val(_v_y2);
  glRectf(x1, y1, x2, y2);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glArrayElement(value _v_i) {
  CAMLparam1(_v_i);
  int i; /*in*/
  i = Int_val(_v_i);
  glArrayElement(i);
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

t_prim gl_api_glShadeModel(value _v_mode) {
  CAMLparam1(_v_mode);
#include "enums/shade_mode.inc"

  glShadeModel(shade_mode[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glLight1(value _v_light, value _v_pname, value _v_param) {
  CAMLparam3(_v_light, _v_pname, _v_param);
#include "enums/set_light_1.inc"

  float param; /*in*/
  param = Double_val(_v_param);
  glLightf(GL_LIGHT0 + Int_val(_v_light),
           set_light_1[Int_val(_v_pname)], param);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glLight3(value _v_light, value _v_param) {
  CAMLparam2(_v_light, _v_param);

  float param[3]; /*in*/
  param[0] = Double_val(Field(_v_param, 0));
  param[1] = Double_val(Field(_v_param, 1));
  param[2] = Double_val(Field(_v_param, 2));
  glLightfv(GL_LIGHT0 + Int_val(_v_light),
            GL_SPOT_DIRECTION, param);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glLight4(value _v_light, value _v_pname, value _v_param) {
  CAMLparam3(_v_light, _v_pname, _v_param);
#include "enums/set_light_4.inc"

  float param[4]; /*in*/
  param[0] = Double_val(Field(_v_param, 0));
  param[1] = Double_val(Field(_v_param, 1));
  param[2] = Double_val(Field(_v_param, 2));
  param[3] = Double_val(Field(_v_param, 3));

  glLightfv(GL_LIGHT0 + Int_val(_v_light),
            set_light_4[Int_val(_v_pname)], param);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glLightModel1(value _v_pname, value _v_params) {
  CAMLparam2(_v_pname, _v_params);
#include "enums/light_model.inc"

  glLightModelf(light_model[Int_val(_v_pname)], Double_val(_v_params));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glLightModel4(value _v_params) {
  CAMLparam1(_v_params);

  float param[4];
  param[0] = Double_val(Field(_v_params, 0));
  param[1] = Double_val(Field(_v_params, 1));
  param[2] = Double_val(Field(_v_params, 2));
  param[3] = Double_val(Field(_v_params, 3));

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, param);
  CAMLreturn(Val_unit);
}


t_prim gl_api_glLightModelControl(value _v_pname) {
  CAMLparam1(_v_pname);
#include "enums/light_model_control.inc"

  glLightModelf(GL_LIGHT_MODEL_COLOR_CONTROL,
                light_model_control[Int_val(_v_pname)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMaterial1(value _v_face, value _v_param) {
  CAMLparam2(_v_face, _v_param);
#include "enums/face_mode.inc"

  glMaterialf(face_mode[Int_val(_v_face)],
              GL_SHININESS, Double_val(_v_param));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMaterial3(value _v_face, value _v_param) {
  CAMLparam2(_v_face, _v_param);
#include "enums/face_mode.inc"

  float param[3]; /*in*/
  param[0] = Double_val(Field(_v_param, 0));
  param[1] = Double_val(Field(_v_param, 1));
  param[2] = Double_val(Field(_v_param, 2));
  glMaterialfv(face_mode[Int_val(_v_face)],
               GL_COLOR_INDEXES, param);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMaterial4(value _v_face, value _v_pname, value _v_param) {
  CAMLparam3(_v_face, _v_pname, _v_param);
#include "enums/face_mode.inc"
#include "enums/material_4f.inc"

  float param[4]; /*in*/
  param[0] = Double_val(Field(_v_param, 0));
  param[1] = Double_val(Field(_v_param, 1));
  param[2] = Double_val(Field(_v_param, 2));
  param[3] = Double_val(Field(_v_param, 3));

  glMaterialfv(face_mode[Int_val(_v_face)],
               material_4f[Int_val(_v_pname)], param);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glColorMaterial(value _v_face, value _v_mode) {
  CAMLparam2(_v_face, _v_mode);
#include "enums/cull_face_mode.inc"
#include "enums/material_4f.inc"

  glColorMaterial(cull_face_mode[Int_val(_v_face)],
                  material_4f[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPixelZoom(value _v_xfactor, value _v_yfactor) {
  CAMLparam2(_v_xfactor, _v_yfactor);
  float xfactor; /*in*/
  float yfactor; /*in*/
  xfactor = Double_val(_v_xfactor);
  yfactor = Double_val(_v_yfactor);
  glPixelZoom(xfactor, yfactor);
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

t_prim gl_api_glPixelTransferb(value _v_pname, value _v_param) {
  CAMLparam2(_v_pname, _v_param);
#include "enums/pixel_transfer_boolean.inc"

  glPixelTransferf(pixel_transfer_boolean[Int_val(_v_pname)],
                   Bool_val(_v_param));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPixelTransferf(value _v_pname, value _v_param) {
  CAMLparam2(_v_pname, _v_param);
#include "enums/pixel_transfer_float.inc"

  glPixelTransferi(pixel_transfer_float[Int_val(_v_pname)],
                   Double_val(_v_param));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPixelTransferi(value _v_pname, value _v_param) {
  CAMLparam2(_v_pname, _v_param);
#include "enums/pixel_transfer_integer.inc"

  glPixelTransferi(pixel_transfer_integer[Int_val(_v_pname)],
                   Int_val(_v_param));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPixelMap(value _v_map, value _v_values) {
  CAMLparam2(_v_map, _v_values);
#include "enums/pixel_map.inc"

  int mapsize = Caml_ba_array_val(_v_values)->dim[0];

  glPixelMapfv(pixel_map[Int_val(_v_map)], mapsize, Caml_ba_data_val(_v_values));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glGetPixelMap(value _v_map, value _v_values) {
  CAMLparam2(_v_map, _v_values);
#include "enums/pixel_map.inc"

  glGetPixelMapfv(pixel_map[Int_val(_v_map)], Caml_ba_data_val(_v_values));
  CAMLreturn(Val_unit);
}


t_prim gl_api_glBitmap(value _v_width, value _v_height, value _v_xorig,
                                value _v_yorig, value _v_xmove, value _v_ymove,
                                value _v_bitmap) {
  CAMLparam5(_v_width, _v_height, _v_xorig, _v_yorig, _v_xmove);
  CAMLxparam2(_v_ymove, _v_bitmap);
  int width; /*in*/
  int height; /*in*/
  float xorig; /*in*/
  float yorig; /*in*/
  float xmove; /*in*/
  float ymove; /*in*/
  width = Int_val(_v_width);
  height = Int_val(_v_height);
  xorig = Double_val(_v_xorig);
  yorig = Double_val(_v_yorig);
  xmove = Double_val(_v_xmove);
  ymove = Double_val(_v_ymove);
  glBitmap(width, height, xorig, yorig, xmove, ymove, Caml_ba_data_val(_v_bitmap));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glBitmap_bytecode(value * argv, int argn) {
  return gl_api_glBitmap(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6]);
}

t_prim gl_api_glCopyPixels(value _v_x, value _v_y, value _v_width,
                                    value _v_height, value _v_type) {
  CAMLparam5(_v_x, _v_y, _v_width, _v_height, _v_type);
#include "enums/pixel_copy_type.inc"

  int x; /*in*/
  int y; /*in*/
  int width; /*in*/
  int height; /*in*/
  x = Int_val(_v_x);
  y = Int_val(_v_y);
  width = Int_val(_v_width);
  height = Int_val(_v_height);
  glCopyPixels(x, y, width, height, pixel_copy_type[Int_val(_v_type)]);
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

t_prim gl_api_glTexGen1(value _v_coord, value _v_func) {
  CAMLparam2(_v_coord, _v_func);
#include "enums/coord.inc"
#include "enums/texgen_func.inc"

  glTexGenf(coord[Int_val(_v_coord)], GL_TEXTURE_GEN_MODE,
            texgen_func[Int_val(_v_func)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexGen4(value _v_coord, value _v_pname, value _v_param) {
  CAMLparam3(_v_coord, _v_pname, _v_param);
#include "enums/coord.inc"
#include "enums/texgen_plane.inc"

  float param[4];
  param[0] = Double_val(Field(_v_param, 0));
  param[1] = Double_val(Field(_v_param, 1));
  param[2] = Double_val(Field(_v_param, 2));
  param[3] = Double_val(Field(_v_param, 3));
  glTexGenfv(coord[Int_val(_v_coord)], texgen_plane[Int_val(_v_pname)],
             param);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexEnv1(value _v_param) {
  CAMLparam1(_v_param);
#include "enums/texgen_env_func.inc"

  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE,
            texgen_env_func[Int_val(_v_param)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexEnv4(value _v_param) {
  CAMLparam1(_v_param);

  float param[4];
  param[0] = Double_val(Field(_v_param, 0));
  param[1] = Double_val(Field(_v_param, 1));
  param[2] = Double_val(Field(_v_param, 2));
  param[3] = Double_val(Field(_v_param, 3));
  glTexEnvfv(GL_TEXTURE_FILTER_CONTROL, GL_TEXTURE_ENV_COLOR,
             param);
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

t_prim gl_api_glPrioritizeTextures(value _v_textures,
                                   value _v_priorities) {
  CAMLparam2(_v_textures, _v_priorities);
  unsigned int *textures; /*in*/
  float const *priorities; /*in*/
  int n = caml_array_length(_v_textures);

  textures = malloc(n * sizeof(unsigned int));
  for (int i = 0; i < n; ++i) {
    textures[i] = Int_val(Field(_v_textures, i));
  }

  priorities = Caml_ba_data_val(_v_priorities);
  glPrioritizeTextures(n, textures, priorities);
  free(textures);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glAreTexturesResident(value _v_n, value _v_textures) {
  CAMLparam2(_v_n, _v_textures);
  int n; /*in*/
  unsigned int const *textures; /*in*/
  unsigned char *residences;
  unsigned char _res;

  n = Int_val(_v_n);
  textures = Caml_ba_data_val(_v_textures);
  residences = malloc(n * sizeof(unsigned char));
  _res = glAreTexturesResident(n, textures, residences);
  free(residences);
  CAMLreturn(Val_bool(_res));
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

t_prim gl_api_glMap1_1(value _v_target, value _v_u1, value _v_u2,
                                value _v_stride, value _v_order, value _v_points) {
  CAMLparam5(_v_target, _v_u1, _v_u2, _v_stride, _v_order);
  CAMLxparam1(_v_points);
#include "enums/map_target_1_1.inc"

  float u1; /*in*/
  float u2; /*in*/
  int stride; /*in*/
  int order; /*in*/
  float points[1]; /*in*/
  u1 = Double_val(_v_u1);
  u2 = Double_val(_v_u2);
  stride = Int_val(_v_stride);
  order = Int_val(_v_order);
  points[0] = Double_val(_v_points);
  glMap1f(map_target_1_1[Int_val(_v_target)], u1, u2, stride, order, points);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMap1_1_bytecode(value * argv, int argn) {
  return gl_api_glMap1_1(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

t_prim gl_api_glMap1_2(value _v_u1, value _v_u2,
                                value _v_stride, value _v_order, value _v_points) {
  CAMLparam5(_v_u1, _v_u2, _v_stride, _v_order, _v_points);

  float u1; /*in*/
  float u2; /*in*/
  int stride; /*in*/
  int order; /*in*/
  float points[2]; /*in*/
  u1 = Double_val(_v_u1);
  u2 = Double_val(_v_u2);
  stride = Int_val(_v_stride);
  order = Int_val(_v_order);
  points[0] = Double_val(Field(_v_points, 0));
  points[1] = Double_val(Field(_v_points, 1));
  glMap1f(GL_MAP1_TEXTURE_COORD_2, u1, u2, stride, order, points);
  CAMLreturn(Val_unit);
}


t_prim gl_api_glMap1_3(value _v_target, value _v_u1, value _v_u2,
                                value _v_stride, value _v_order, value _v_points) {
  CAMLparam5(_v_target, _v_u1, _v_u2, _v_stride, _v_order);
  CAMLxparam1(_v_points);
#include "enums/map_target_1_3.inc"

  float u1; /*in*/
  float u2; /*in*/
  int stride; /*in*/
  int order; /*in*/
  float points[3]; /*in*/
  u1 = Double_val(_v_u1);
  u2 = Double_val(_v_u2);
  stride = Int_val(_v_stride);
  order = Int_val(_v_order);
  points[0] = Double_val(Field(_v_points, 0));
  points[1] = Double_val(Field(_v_points, 1));
  points[2] = Double_val(Field(_v_points, 2));
  glMap1f(map_target_1_3[Int_val(_v_target)], u1, u2, stride, order, points);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMap1_3_bytecode(value * argv, int argn) {
  return gl_api_glMap1_3(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

t_prim gl_api_glMap1_4(value _v_target, value _v_u1, value _v_u2,
                                value _v_stride, value _v_order, value _v_points) {
  CAMLparam5(_v_target, _v_u1, _v_u2, _v_stride, _v_order);
  CAMLxparam1(_v_points);
#include "enums/map_target_1_4.inc"

  float u1; /*in*/
  float u2; /*in*/
  int stride; /*in*/
  int order; /*in*/
  float points[4]; /*in*/
  u1 = Double_val(_v_u1);
  u2 = Double_val(_v_u2);
  stride = Int_val(_v_stride);
  order = Int_val(_v_order);
  points[0] = Double_val(Field(_v_points, 0));
  points[1] = Double_val(Field(_v_points, 1));
  points[2] = Double_val(Field(_v_points, 2));
  points[3] = Double_val(Field(_v_points, 3));
  glMap1f(map_target_1_4[Int_val(_v_target)], u1, u2, stride, order, points);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMap1_4_bytecode(value * argv, int argn) {
  return gl_api_glMap1_4(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

t_prim gl_api_glMap2_1(value _v_target, value _v_u1, value _v_u2,
                                value _v_ustride, value _v_uorder, value _v_v1,
                                value _v_v2, value _v_vstride, value _v_vorder,
                                value _v_points) {
  CAMLparam5(_v_target, _v_u1, _v_u2, _v_ustride, _v_uorder);
  CAMLxparam5(_v_v1, _v_v2, _v_vstride, _v_vorder, _v_points);
  #include "enums/map_target_2_1.inc"

  float u1; /*in*/
  float u2; /*in*/
  int ustride; /*in*/
  int uorder; /*in*/
  float v1; /*in*/
  float v2; /*in*/
  int vstride; /*in*/
  int vorder; /*in*/
  float points[1]; /*in*/
  u1 = Double_val(_v_u1);
  u2 = Double_val(_v_u2);
  ustride = Int_val(_v_ustride);
  uorder = Int_val(_v_uorder);
  v1 = Double_val(_v_v1);
  v2 = Double_val(_v_v2);
  vstride = Int_val(_v_vstride);
  vorder = Int_val(_v_vorder);
  points[0] = Double_val(_v_points);

  glMap2f(map_target_2_1[Int_val(_v_target)], u1, u2, ustride, uorder, v1, v2,
          vstride, vorder, points);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMap2_1_bytecode(value * argv, int argn) {
  return gl_api_glMap2_1(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5],
                                  argv[6], argv[7], argv[8], argv[9]);
}

t_prim gl_api_glMap2_2(value _v_u1, value _v_u2,
                                value _v_ustride, value _v_uorder, value _v_v1,
                                value _v_v2, value _v_vstride, value _v_vorder,
                                value _v_points) {
  CAMLparam5(_v_u1, _v_u2, _v_ustride, _v_uorder, _v_v1);
  CAMLxparam4(_v_v2, _v_vstride, _v_vorder, _v_points);

  float u1; /*in*/
  float u2; /*in*/
  int ustride; /*in*/
  int uorder; /*in*/
  float v1; /*in*/
  float v2; /*in*/
  int vstride; /*in*/
  int vorder; /*in*/
  float points[2]; /*in*/
  u1 = Double_val(_v_u1);
  u2 = Double_val(_v_u2);
  ustride = Int_val(_v_ustride);
  uorder = Int_val(_v_uorder);
  v1 = Double_val(_v_v1);
  v2 = Double_val(_v_v2);
  vstride = Int_val(_v_vstride);
  vorder = Int_val(_v_vorder);

  points[0] = Double_val(Field(_v_points, 0));
  points[1] = Double_val(Field(_v_points, 1));

  glMap2f(GL_MAP2_TEXTURE_COORD_2, u1, u2, ustride, uorder, v1, v2,
          vstride, vorder, points);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMap2_2_bytecode(value * argv, int argn) {
  return gl_api_glMap2_2(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5],
                                  argv[6], argv[7], argv[8]);
}

t_prim gl_api_glMap2_3(value _v_target, value _v_u1, value _v_u2,
                                value _v_ustride, value _v_uorder, value _v_v1,
                                value _v_v2, value _v_vstride, value _v_vorder,
                                value _v_points) {
  CAMLparam5(_v_target, _v_u1, _v_u2, _v_ustride, _v_uorder);
  CAMLxparam5(_v_v1, _v_v2, _v_vstride, _v_vorder, _v_points);
  #include "enums/map_target_2_3.inc"

  float u1; /*in*/
  float u2; /*in*/
  int ustride; /*in*/
  int uorder; /*in*/
  float v1; /*in*/
  float v2; /*in*/
  int vstride; /*in*/
  int vorder; /*in*/
  float points[3]; /*in*/
  u1 = Double_val(_v_u1);
  u2 = Double_val(_v_u2);
  ustride = Int_val(_v_ustride);
  uorder = Int_val(_v_uorder);
  v1 = Double_val(_v_v1);
  v2 = Double_val(_v_v2);
  vstride = Int_val(_v_vstride);
  vorder = Int_val(_v_vorder);

  points[0] = Double_val(Field(_v_points, 0));
  points[1] = Double_val(Field(_v_points, 1));
  points[2] = Double_val(Field(_v_points, 2));

  glMap2f(map_target_2_3[Int_val(_v_target)], u1, u2, ustride, uorder, v1, v2,
          vstride, vorder, points);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMap2_3_bytecode(value * argv, int argn) {
  return gl_api_glMap2_3(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5],
                                  argv[6], argv[7], argv[8], argv[9]);
}

t_prim gl_api_glMap2_4(value _v_target, value _v_u1, value _v_u2,
                                value _v_ustride, value _v_uorder, value _v_v1,
                                value _v_v2, value _v_vstride, value _v_vorder,
                                value _v_points) {
  CAMLparam5(_v_target, _v_u1, _v_u2, _v_ustride, _v_uorder);
  CAMLxparam5(_v_v1, _v_v2, _v_vstride, _v_vorder, _v_points);
  #include "enums/map_target_2_4.inc"

  float u1; /*in*/
  float u2; /*in*/
  int ustride; /*in*/
  int uorder; /*in*/
  float v1; /*in*/
  float v2; /*in*/
  int vstride; /*in*/
  int vorder; /*in*/
  float points[3]; /*in*/
  u1 = Double_val(_v_u1);
  u2 = Double_val(_v_u2);
  ustride = Int_val(_v_ustride);
  uorder = Int_val(_v_uorder);
  v1 = Double_val(_v_v1);
  v2 = Double_val(_v_v2);
  vstride = Int_val(_v_vstride);
  vorder = Int_val(_v_vorder);

  points[0] = Double_val(Field(_v_points, 0));
  points[1] = Double_val(Field(_v_points, 1));
  points[2] = Double_val(Field(_v_points, 2));

  glMap2f(map_target_2_4[Int_val(_v_target)], u1, u2, ustride, uorder, v1, v2,
          vstride, vorder, points);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMap2_4_bytecode(value * argv, int argn) {
  return gl_api_glMap2_4(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5],
                                  argv[6], argv[7], argv[8], argv[9]);
}

t_prim gl_api_glEvalCoord1(value _v_u) {
  CAMLparam1(_v_u);
  float u; /*in*/
  u = Double_val(_v_u);
  glEvalCoord1f(u);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glEvalCoord2(value _v_u, value _v_v) {
  CAMLparam2(_v_u, _v_v);
  float u; /*in*/
  float v; /*in*/
  u = Double_val(_v_u);
  v = Double_val(_v_v);
  glEvalCoord2f(u, v);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMapGrid1(value _v_un, value _v_u1, value _v_u2) {
  CAMLparam3(_v_un, _v_u1, _v_u2);
  int un; /*in*/
  double u1; /*in*/
  double u2; /*in*/
  un = Int_val(_v_un);
  u1 = Double_val(_v_u1);
  u2 = Double_val(_v_u2);
  glMapGrid1f(un, u1, u2);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMapGrid2(value _v_un, value _v_u1, value _v_u2,
                                   value _v_vn, value _v_v1, value _v_v2) {
  CAMLparam5(_v_un, _v_u1, _v_u2, _v_vn, _v_v1);
  CAMLxparam1(_v_v2);
  int un; /*in*/
  float u1; /*in*/
  float u2; /*in*/
  int vn; /*in*/
  float v1; /*in*/
  float v2; /*in*/
  un = Int_val(_v_un);
  u1 = Double_val(_v_u1);
  u2 = Double_val(_v_u2);
  vn = Int_val(_v_vn);
  v1 = Double_val(_v_v1);
  v2 = Double_val(_v_v2);
  glMapGrid2f(un, u1, u2, vn, v1, v2);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMapGrid2_bytecode(value * argv, int argn) {
  return gl_api_glMapGrid2(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

t_prim gl_api_glEvalPoint1(value _v_i) {
  CAMLparam1(_v_i);
  int i; /*in*/
  i = Int_val(_v_i);
  glEvalPoint1(i);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glEvalPoint2(value _v_i, value _v_j) {
  CAMLparam2(_v_i, _v_j);
  int i; /*in*/
  int j; /*in*/
  i = Int_val(_v_i);
  j = Int_val(_v_j);
  glEvalPoint2(i, j);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glEvalMesh1(value _v_mode, value _v_i1, value _v_i2) {
  CAMLparam3(_v_mode, _v_i1, _v_i2);
  #include "enums/mesh_mode_1.inc"

  int i1; /*in*/
  int i2; /*in*/

  i1 = Int_val(_v_i1);
  i2 = Int_val(_v_i2);
  glEvalMesh1(mesh_mode_1[Int_val(_v_mode)], i1, i2);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glEvalMesh2(value _v_mode, value _v_i1, value _v_i2, value _v_j1,
                                   value _v_j2) {
  CAMLparam5(_v_mode, _v_i1, _v_i2, _v_j1, _v_j2);
  #include "enums/mesh_mode_2.inc"

  int i1; /*in*/
  int i2; /*in*/
  int j1; /*in*/
  int j2; /*in*/
  i1 = Int_val(_v_i1);
  i2 = Int_val(_v_i2);
  j1 = Int_val(_v_j1);
  j2 = Int_val(_v_j2);
  glEvalMesh2(mesh_mode_2[Int_val(_v_mode)], i1, i2, j1, j2);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glFog_mode(value _v_pname, value _v_param) {
  CAMLparam2(_v_pname, _v_param);
  #include "enums/fog_mode.inc"
#include "enums/fog_mode_param.inc"

  glFogi(fog_mode[Int_val(_v_pname)], fog_mode_param[Int_val(_v_param)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glFog1(value _v_pname, value _v_param) {
  CAMLparam2(_v_pname, _v_param);
  #include "enums/fog_value_type.inc"

  glFogf(fog_value_type[Int_val(_v_pname)], Double_val(_v_param));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glFog4(value _v_param) {
  CAMLparam1(_v_param);
  float param[4];
  param[0] = Double_val(Field(_v_param, 0));
  param[1] = Double_val(Field(_v_param, 1));
  param[2] = Double_val(Field(_v_param, 2));
  param[3] = Double_val(Field(_v_param, 3));

  glFogfv(GL_FOG_COLOR, param);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glSelectBuffer(value _v_size) {
  CAMLparam1(_v_size);
  CAMLlocal1(_vres);
  int size; /*in*/
  unsigned int *buffer; /*out*/

  size = Int_val(_v_size);
  buffer = stat_alloc(size * sizeof(unsigned int ));
  glSelectBuffer(size, buffer);
  _vres = alloc_bigarray_dims(
      BIGARRAY_INT32 | BIGARRAY_C_LAYOUT | BIGARRAY_MANAGED,
      1, buffer, size);
  CAMLreturn(_vres);
}

t_prim gl_api_glInitNames(value _unit) {
  CAMLparam0();
  glInitNames();
  CAMLreturn(Val_unit);
}

t_prim gl_api_glLoadName(value _v_name) {
  CAMLparam1(_v_name);
  unsigned int name; /*in*/
  name = Int_val(_v_name);
  glLoadName(name);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPushName(value _v_name) {
  CAMLparam1(_v_name);
  unsigned int name; /*in*/
  name = Int_val(_v_name);
  glPushName(name);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glPopName(value _unit) {
  CAMLparam0();
  glPopName();
  CAMLreturn(Val_unit);
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

t_prim gl_api_glHistogram(value _v_target, value _v_width,
                                   value _v_internalformat, value _v_sink) {
  CAMLparam4(_v_target, _v_width, _v_internalformat, _v_sink);
#include "enums/histogram.inc"
#include "enums/internal_format.inc"

  int width; /*in*/
  unsigned char sink; /*in*/
  width = Int_val(_v_width);
  sink = Int_val(_v_sink);
  glHistogram(histogram[Int_val(_v_target)], width,
              internal_format[Int_val(_v_internalformat)], sink);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glResetHistogram(value unit) {
  CAMLparam0();
  glResetHistogram(GL_HISTOGRAM);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glConvolutionParameter_border(value _v_target, value _v_mode) {
  CAMLparam2(_v_target, _v_mode);
  #include "enums/convolution_target.inc"
#include "enums/convolution_border_mode.inc"

  glConvolutionParameterf(convolution_target[Int_val(_v_target)],
                          GL_CONVOLUTION_BORDER_MODE,
                          convolution_border_mode[Int_val(_v_mode)]);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glConvolutionParameter(value _v_target, value _v_pname,
                                              value _v_param) {
  CAMLparam3(_v_target, _v_pname, _v_param);
#include "enums/convolution_target.inc"
#include "enums/convolution_pname.inc"

  float params[4];
  params[0] = Double_val(Field(_v_param, 0));
  params[1] = Double_val(Field(_v_param, 1));
  params[2] = Double_val(Field(_v_param, 2));
  params[3] = Double_val(Field(_v_param, 3));

  glConvolutionParameterfv(convolution_target[Int_val(_v_target)],
                           convolution_pname[Int_val(_v_pname)],
                           params);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glCopyConvolutionFilter1D(value _v_internalformat,
                                                 value _v_x, value _v_y,
                                                 value _v_width) {
  CAMLparam4(_v_internalformat, _v_x, _v_y, _v_width);
  #include "enums/internal_format.inc"

  int x; /*in*/
  int y; /*in*/
  int width; /*in*/
  x = Int_val(_v_x);
  y = Int_val(_v_y);
  width = Int_val(_v_width);
  glCopyConvolutionFilter1D(GL_CONVOLUTION_1D,
                            internal_format[Int_val(_v_internalformat)], x, y, width);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glCopyConvolutionFilter2D(value _v_internalformat,
                                                 value _v_x, value _v_y, value _v_width,
                                                 value _v_height) {
  CAMLparam5(_v_internalformat, _v_x, _v_y, _v_width, _v_height);
  #include "enums/internal_format.inc"

  int x; /*in*/
  int y; /*in*/
  int width; /*in*/
  int height; /*in*/
  x = Int_val(_v_x);
  y = Int_val(_v_y);
  width = Int_val(_v_width);
  height = Int_val(_v_height);
  glCopyConvolutionFilter2D(GL_CONVOLUTION_2D,
                            internal_format[Int_val(_v_internalformat)], x, y,
                            width, height);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glActiveTexture(value _v_texture) {
  CAMLparam1(_v_texture);
  glActiveTexture(GL_TEXTURE0 + Int_val(_v_texture));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMultiTexCoord1(value _v_target, value _v_s) {
  CAMLparam2(_v_target, _v_s);
  float s; /*in*/
  s = Double_val(_v_s);
  glMultiTexCoord1f(GL_TEXTURE0 + Int_val(_v_target), s);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMultiTexCoord2(value _v_target, value _v_s, value _v_t) {
  CAMLparam3(_v_target, _v_s, _v_t);
  float s; /*in*/
  float t; /*in*/
  s = Double_val(_v_s);
  t = Double_val(_v_t);
  glMultiTexCoord2f(GL_TEXTURE0 + Int_val(_v_target), s, t);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMultiTexCoord3(value _v_target, value _v_s,
                                        value _v_t, value _v_r) {
  CAMLparam4(_v_target, _v_s, _v_t, _v_r);
  float s; /*in*/
  float t; /*in*/
  float r; /*in*/
  s = Double_val(_v_s);
  t = Double_val(_v_t);
  r = Double_val(_v_r);
  glMultiTexCoord3f(GL_TEXTURE0 + Int_val(_v_target), s, t, r);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMultiTexCoord4(value _v_target, value _v_s, value _v_t,
                                        value _v_r, value _v_q) {
  CAMLparam5(_v_target, _v_s, _v_t, _v_r, _v_q);
  float s; /*in*/
  float t; /*in*/
  float r; /*in*/
  float q; /*in*/
  s = Double_val(_v_s);
  t = Double_val(_v_t);
  r = Double_val(_v_r);
  q = Double_val(_v_q);
  glMultiTexCoord4f(GL_TEXTURE0 + Int_val(_v_target), s, t, r, q);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glLoadTransposeMatrix(value _v_m) {
  CAMLparam1(_v_m);
  float const *m; /*in*/
  m = Caml_ba_data_val(_v_m);
  glLoadTransposeMatrixf(m);
  CAMLreturn(Val_unit);
}

t_prim gl_api_glMultTransposeMatrix(value _v_m) {
  CAMLparam1(_v_m);
  float const *m; /*in*/
  m = Caml_ba_data_val(_v_m);
  glMultTransposeMatrixf(m);
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

/* Function implementations */

t_prim gl_api_glCallLists(value n, value list_type, value lists) {
  CAMLparam3(n, list_type, lists);
#include "enums/call_list_type.inc"

  value ary = Field(lists, 1);
  glCallLists(Int_val(n), call_list_type[Int_val(list_type)],
              (const void*)(Caml_ba_array_val(ary)));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glVertexPointer2(value pointer_type, value stride, value pointer) {
  CAMLparam3(pointer_type, stride, pointer);
#include "enums/vertex_pointer_type.inc"

  glVertexPointer(2, vertex_pointer_type[Int_val(pointer_type)], Int_val(stride),
                  Caml_ba_data_val(pointer));

  CAMLreturn(Val_unit);
}

t_prim gl_api_glVertexPointer3(value size, value pointer_type, value stride, value pointer) {
  CAMLparam3(pointer_type, stride, pointer);
#include "enums/vertex_pointer_type.inc"

  glVertexPointer(3, vertex_pointer_type[Int_val(pointer_type)], Int_val(stride),
                  Caml_ba_data_val(pointer));

  CAMLreturn(Val_unit);
}

t_prim gl_api_glVertexPointer4(value size, value pointer_type, value stride, value pointer) {
  CAMLparam3(pointer_type, stride, pointer);
#include "enums/vertex_pointer_type.inc"

  glVertexPointer(4, vertex_pointer_type[Int_val(pointer_type)], Int_val(stride),
                  Caml_ba_data_val(pointer));

  CAMLreturn(Val_unit);
}

t_prim gl_api_glNormalPointer(value pointer_type, value stride, value pointer) {
  CAMLparam3(pointer_type, stride, pointer);
#include "enums/normal_pointer_type.inc"

  glNormalPointer(normal_pointer_type[Int_val(pointer_type)],
                  Int_val(stride),
                  (const void*)(Caml_ba_data_val(pointer)));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glColorPointer(value pointer_type, value stride, value pointer) {
  CAMLparam3(pointer_type, stride, pointer);
#include "enums/color_pointer_type.inc"

  glColorPointer(Caml_ba_array_val(pointer)->dim[0],
                 color_pointer_type[Int_val(pointer_type)],
                 Int_val(stride),
                 (const void*)(Caml_ba_data_val(pointer)));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glIndexPointer(value pointer_type, value stride, value pointer) {
  CAMLparam3(pointer_type, stride, pointer);
#include "enums/index_pointer_type.inc"

  glIndexPointer(index_pointer_type[Int_val(pointer_type)],
                 Int_val(stride),
                 (const void*)(Caml_ba_data_val(pointer)));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexCoordPointer1(value pointer_type, value stride, value pointer) {
  CAMLparam3(pointer_type, stride, pointer);

#include "enums/texcoord_pointer_type.inc"

  glTexCoordPointer(1,
                    texcoord_pointer_type[Int_val(pointer_type)],
                    Int_val(stride),
                    (const void*)(Caml_ba_data_val(pointer)));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexCoordPointer2(value pointer_type , value stride, value pointer) {
  CAMLparam3(pointer_type, stride, pointer);

#include "enums/texcoord_pointer_type.inc"

  glTexCoordPointer(2,
                    texcoord_pointer_type[Int_val(pointer_type)],
                    Int_val(stride),
                    (const void*)(Caml_ba_data_val(pointer)));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexCoordPointer3(value pointer_type , value stride, value pointer) {
  CAMLparam3(pointer_type, stride, pointer);

#include "enums/texcoord_pointer_type.inc"

  glTexCoordPointer(3,
                    texcoord_pointer_type[Int_val(pointer_type)],
                    Int_val(stride),
                    (const void*)(Caml_ba_data_val(pointer)));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glTexCoordPointer4(value pointer_type , value stride, value pointer) {
  CAMLparam3(pointer_type, stride, pointer);
#include "enums/texcoord_pointer_type.inc"

  glTexCoordPointer(4,
                    texcoord_pointer_type[Int_val(pointer_type)],
                    Int_val(stride),
                    (const void*)(Caml_ba_data_val(pointer)));
  CAMLreturn(Val_unit);
}

t_prim gl_api_glEdgeFlagPointer(value stride, value bool_array) {
  CAMLparam2(stride, bool_array);

  glEdgeFlagPointer(Int_val(stride),
                    Caml_ba_data_val(bool_array));
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

t_prim gl_api_glGetLight1(value light_i, value variant) {
  CAMLparam2(light_i, variant);
  float array[1];
#include "enums/get_light.inc"

  glGetLightfv(Int_val(light_i),
               get_light[Int_val(variant)],
               array);
  CAMLreturn(caml_copy_double(array[0]));
}

t_prim gl_api_glGetLight3(value light_i) {
  CAMLparam1(light_i);
  CAMLlocal1(ret);
  float array[3];

  glGetLightfv(Int_val(light_i),
               GL_SPOT_DIRECTION,
               array);
  ret = caml_alloc(3 * Double_wosize, Double_array_tag);
  Store_double_field(ret, 0, array[0]);
  Store_double_field(ret, 1, array[1]);
  Store_double_field(ret, 2, array[2]);
  CAMLreturn(ret);
}

t_prim gl_api_glGetLight4(value light_i, value variant) {
  CAMLparam2(light_i, variant);
  CAMLlocal1(ret);
  float array[4];
#include "enums/get_light.inc"

  glGetLightfv(Int_val(light_i),
               get_light[Int_val(variant)],
               array);
  ret = caml_alloc(4 * Double_wosize, Double_array_tag);
  Store_double_field(ret, 0, array[0]);
  Store_double_field(ret, 1, array[1]);
  Store_double_field(ret, 2, array[2]);
  Store_double_field(ret, 3, array[3]);
  CAMLreturn(ret);
}

t_prim gl_api_glGetMaterialf1(value face,value pname) {
  CAMLparam2(face, pname);
#include "enums/face_mode.inc"
#include "enums/material_1f.inc"

  float val[1];
  glGetMaterialfv(face_mode[Int_val(face)],
                  material_1f[Int_val(pname)],
                  val);
  CAMLreturn(caml_copy_double(val[0]));
}

t_prim gl_api_glGetMaterialf3(value face,value pname) {
  CAMLparam2(face, pname);
  CAMLlocal1(ret);
#include "enums/face_mode.inc"
#include "enums/material_3f.inc"

  float val[3];
  glGetMaterialfv(face_mode[Int_val(face)],
                  material_3f[Int_val(pname)],
                  val);
  ret = caml_alloc(3 * Double_wosize, Double_array_tag);
  Store_double_field(ret, 0, val[0]);
  Store_double_field(ret, 1, val[1]);
  Store_double_field(ret, 2, val[2]);
  CAMLreturn(ret);
}

t_prim gl_api_glGetMaterialf4(value face,value pname) {
  CAMLparam2(face, pname);
  CAMLlocal1(ret);
#include "enums/face_mode.inc"
#include "enums/material_4f.inc"

  float val[4];
  glGetMaterialfv(face_mode[Int_val(face)],
                  material_4f[Int_val(pname)],
                  val);
  ret = caml_alloc(4 * Double_wosize, Double_array_tag);
  Store_double_field(ret, 0, val[0]);
  Store_double_field(ret, 1, val[1]);
  Store_double_field(ret, 2, val[2]);
  Store_double_field(ret, 3, val[3]);
  CAMLreturn(ret);
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

t_prim gl_api_glDrawPixels(value width, value height, value format, value type, value data) {
  CAMLparam5(width, height, format, type, data);
#include "enums/read_pixel_format.inc"
#include "enums/read_pixel_type.inc"

  glDrawPixels(Int_val(width), Int_val(height),
               read_pixel_format[Int_val(format)],
               read_pixel_type[Int_val(type)],
               Caml_ba_data_val(data));

  CAMLreturn(Val_unit);
}

t_prim gl_api_glGetTexGen1(value v_coord) {
  CAMLparam1(v_coord);
#include "enums/coord.inc"
#include "enums/texgen_func.inc"

  GLint val;
  glGetTexGeniv(coord[Int_val(v_coord)],
                GL_TEXTURE_GEN_MODE, &val);
  for (int i = 0; i < sizeof(texgen_func); ++i) {
    if (texgen_func[i] == val) {
      CAMLreturn(Val_int(i));
    }
  }
  CAMLreturn(Val_int(-1));
}

t_prim gl_api_glGetTexGen4(value v_coord, value pname) {
  CAMLparam2(v_coord, pname);
  CAMLlocal1(ret);
#include "enums/coord.inc"
#include "enums/texgen_plane.inc"

  float val[4];
  glGetTexGenfv(coord[Int_val(v_coord)],
                texgen_plane[Int_val(pname)],
                val);
  ret = caml_alloc(4 * Double_wosize, Double_array_tag);
  Store_double_field(ret, 0, val[0]);
  Store_double_field(ret, 1, val[1]);
  Store_double_field(ret, 2, val[2]);
  Store_double_field(ret, 3, val[3]);
  CAMLreturn(ret);
}

t_prim gl_api_glGetTexEnv1(value unit) {
  CAMLparam0();
#include "enums/texgen_env_func.inc"

  GLint val;
  glGetTexEnviv(GL_TEXTURE_ENV,
                GL_TEXTURE_GEN_MODE, &val);
  for (int i = 0; i < sizeof(texgen_env_func); ++i) {
    if (texgen_env_func[i] == val) {
      CAMLreturn(Val_int(i));
    }
  }
  CAMLreturn(Val_int(-1));
}

t_prim gl_api_glGetTexEnv4(value unit) {
  CAMLparam0();
  CAMLlocal1(ret);

  float val[4];
  glGetTexEnvfv(GL_TEXTURE_ENV,
                GL_TEXTURE_ENV_COLOR,
                val);
  ret = caml_alloc(4 * Double_wosize, Double_array_tag);
  Store_double_field(ret, 0, val[0]);
  Store_double_field(ret, 1, val[1]);
  Store_double_field(ret, 2, val[2]);
  Store_double_field(ret, 3, val[3]);
  CAMLreturn(ret);
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

t_prim gl_api_glGetTexImage(value target, value level, value format, value type, value data) {
  CAMLparam5(target, level, format, type, data);
#include "enums/texture_image_type.inc"
#include "enums/texture_format.inc"
#include "enums/texture_type.inc"

  glGetTexImage(texture_image_type[Int_val(type)],
                Int_val(level),
                texture_format[Int_val(format)],
                texture_type[Int_val(type)],
                Caml_ba_data_val(data));
  CAMLreturn(Val_unit);
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

t_prim gl_api_glGetMap(value target, value query, value points) {
  CAMLparam3(target, query, points);
#include "enums/map_target.inc"
#include "enums/map_query.inc"
  glGetMapdv(map_target[Int_val(target)],
             map_query[Int_val(query)],
             Caml_ba_data_val(points));
  CAMLreturn(Val_unit);
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
