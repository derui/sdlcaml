open Ctypes
open Foreign

module Inner =
struct
  let gl3w_init = foreign "gl3wInit" (void @-> returning int)
end

let init () =
  let ret = Inner.gl3w_init () in
  ret = 0

type image_type = (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Genarray.t

module InternalFormat = Enums.InternalFormat

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClearIndex.xml}
    manual pages on opengl.org}
*)
external glClearIndex : float -> unit = "gl_api_glClearIndex"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClearColor.xml}
    manual pages on opengl.org}
*)
external glClearColor : red:float -> green:float -> blue:float -> alpha:float -> unit
  = "gl_api_glClearColor"

module Clear = Enums.Clear

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClear.xml}
    manual pages on opengl.org}
*)
external glClear : Clear.clear_mask list -> unit = "gl_api_glClear"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIndexMask.xml}
    manual pages on opengl.org}
*)
external glIndexMask : int -> unit = "gl_api_glIndexMask"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColorMask.xml}
    manual pages on opengl.org}
*)
external glColorMask : red:bool -> green:bool -> blue:bool -> alpha:bool -> unit
  = "gl_api_glColorMask"

module Func = Enums.Func

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glNormalPointer.xml}
    manual pages on opengl.org}
*)
external glAlphaFunc : func:Func.compare_func -> clamp:float -> unit = "gl_api_glAlphaFunc"

module SrcFunc = Enums.SrcFunc
module DestFunc = Enums.DestFunc
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBlendFunc.xml}
    manual pages on opengl.org}
*)
external glBlendFunc : src:SrcFunc.blend_src_func -> dest:DestFunc.blend_dst_func -> unit = "gl_api_glBlendFunc"

module Op = Enums.Op
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLogicOp.xml}
    manual pages on opengl.org}
*)
external glLogicOp : Op.logic_opcode -> unit = "gl_api_glLogicOp"

module CullFace = Enums.CullFace
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCullFace.xml}
    manual pages on opengl.org}
*)
external glCullFace : CullFace.cull_face_mode -> unit = "gl_api_glCullFace"

module FrontFace = Enums.FrontFace
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFrontFace.xml}
    manual pages on opengl.org}
*)
external glFrontFace : FrontFace.ccw -> unit = "gl_api_glFrontFace"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPointSize.xml}
    manual pages on opengl.org}
*)
external glPointSize : float -> unit = "gl_api_glPointSize"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLineWidth.xml}
    manual pages on opengl.org}
*)
external glLineWidth : float -> unit = "gl_api_glLineWidth"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLineStipple.xml}
    manual pages on opengl.org}
*)
external glLineStipple : factor:int -> pattern:int -> unit = "gl_api_glLineStipple"

module Poly = Enums.Poly
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPolygonMode.xml}
    manual pages on opengl.org}
*)
external glPolygonMode : face:Poly.cull_face_mode -> mode:Poly.poly_face_mode -> unit
  = "gl_api_glPolygonMode"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPolygonOffset.xml}
    manual pages on opengl.org}
*)
external glPolygonOffset : factor:float -> units:float -> unit
  = "gl_api_glPolygonOffset"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPolygonStipple.xml}
    manual pages on opengl.org}
*)
external glPolygonStipple : (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit
  = "gl_api_glPolygonStipple"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetPolygonStipple.xml}
    manual pages on opengl.org}
*)
external glGetPolygonStipple : unit -> (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
  = "gl_api_glGetPolygonStipple"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEdgeFlag.xml}
    manual pages on opengl.org}
*)
external glEdgeFlag : bool -> unit = "gl_api_glEdgeFlag"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glScissor.xml}
    manual pages on opengl.org}
*)
external glScissor : x:int -> y:int -> width:int -> height:int -> unit
  = "gl_api_glScissor"

module ClipPlane = Enums.ClipPlane

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClipPlane.xml}
    manual pages on opengl.org}
*)
external glClipPlane : plane:ClipPlane.clip_plane ->
  equaltion:(float, Bigarray.float64_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit
    = "gl_api_glClipPlane"

type clip_plane_i = GL_CLIP_PLANE of int

external _glClipPlanei : plane:int ->
  equaltion:(float, Bigarray.float64_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit
    = "gl_api_glClipPlanei"

let glClipPlanei ~plane ~equaltion =
  match plane with
  | GL_CLIP_PLANE i -> _glClipPlanei ~plane:i ~equaltion

external glGetClipPlane : ClipPlane.clip_plane ->
  (float, Bigarray.float64_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit
  = "gl_api_glGetClipPlane"

type aux_buffer = GL_AUX of int
module Buffer = Enums.Buffer
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDrawBuffer.xml}
    manual pages on opengl.org}
*)
external glDrawBuffer : Buffer.draw_buffer_mode -> unit = "gl_api_glDrawBuffer"
external glDrawBuffer_aux : aux_buffer -> unit = "gl_api_glDrawBuffer_aux"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glReadBuffer.xml}
    manual pages on opengl.org}
*)
external glReadBuffer : Buffer.read_buffer_mode -> unit = "gl_api_glReadBuffer"
external glReadBuffer_aux : aux_buffer -> unit = "gl_api_glReadBuffer_aux"

module Enable = Enums.Enable
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEnable.xml}
    manual pages on opengl.org}
*)
external glEnable : Enable.enable_mode -> unit = "gl_api_glEnable"
external glDisable : Enable.enable_mode -> unit = "gl_api_glDisable"
external glIsEnabled : Enable.enable_mode -> bool = "gl_api_glIsEnabled"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEnableClientState.xml}
    manual pages on opengl.org}
*)
external glEnableClientState : Enable.client_state_mode -> unit
  = "gl_api_glEnableClientState"
external glDisableClientState : Enable.client_state_mode -> unit
  = "gl_api_glDisableClientState"

module Get = Enums.Get
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGet.xml}
    manual pages on opengl.org}
*)
external glGetBoolean1 : Get.get_boolean_1 -> bool = "gl_api_glGetBoolean1"
external glGetBoolean4 : Get.get_boolean_4 -> bool * bool * bool * bool = "gl_api_glGetBoolean4"

external glGetFloat1: Get.get_value_1 -> float = "gl_api_glGetFloat1"
external glGetFloat2: Get.get_value_2 -> float * float = "gl_api_glGetFloat2"
(* For GL_CURRENT_NORMAL *)
external glGetFloat3: unit -> float * float * float = "gl_api_glGetFloat3"
external glGetFloat4: Get.get_value_4 -> float * float * float * float = "gl_api_glGetFloat4"

external glGetInteger1: Get.get_value_1 -> int = "gl_api_glGetInteger1"
external glGetInteger2: Get.get_value_2 -> int * int = "gl_api_glGetInteger2"
(* For GL_CURRENT_NORMAL *)
external glGetInteger3: unit -> int * int * int = "gl_api_glGetInteger3"
external glGetInteger4: Get.get_value_4 -> int * int * int * int = "gl_api_glGetInteger4"

external glGetMatrix : Get.get_matrix -> float array = "gl_api_glGetMatrix"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPushAttrib.xml}
    manual pages on opengl.org}
*)
module Attrib = Enums.Attrib
external glPushAttrib : Attrib.attrib_mask -> unit = "gl_api_glPushAttrib"
external glPopAttrib : unit -> unit = "gl_api_glPopAttrib"


(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPushClientAttrib.xml}
    manual pages on opengl.org}
*)
external glPushClientAttrib : Attrib.client_attrib_mask -> unit
  = "gl_api_glPushClientAttrib"
external glPopClientAttrib : unit -> unit = "gl_api_glPopClientAttrib"

module Render = Enums.Render
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glRenderMode.xml}
    manual pages on opengl.org}
*)
external glRenderMode : Render.render_mode -> int = "gl_api_glRenderMode"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetError.xml}
    manual pages on opengl.org}
*)
external glGetError : unit -> Get.get_error = "gl_api_glGetError"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetString.xml}
    manual pages on opengl.org}
*)
external glGetString : Get.get_string -> string = "gl_api_glGetString"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFinish.xml}
    manual pages on opengl.org}
*)
external glFinish : unit -> unit = "gl_api_glFinish"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFlush.xml}
    manual pages on opengl.org}
*)
external glFlush : unit -> unit = "gl_api_glFlush"

module Hint = Enums.Hint
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glHint.xml}
    manual pages on opengl.org}
*)
external glHint : target:Hint.hint_target -> mode:Hint.hint_mode -> unit
  = "gl_api_glHint"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glHint.xml}
    manual pages on opengl.org}
*)
external glClearDepth : float -> unit = "gl_api_glClearDepth"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDepthFunc.xml}
    manual pages on opengl.org}
*)
external glDepthFunc : Func.compare_func -> unit = "gl_api_glDepthFunc"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDepthMask.xml}
    manual pages on opengl.org}
*)
external glDepthMask : bool -> unit = "gl_api_glDepthMask"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDepthRange.xml}
    manual pages on opengl.org}
*)
external glDepthRange : near:float -> far:float -> unit = "gl_api_glDepthRange"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClearAccum.xml}
    manual pages on opengl.org}
*)
external glClearAccum : red:float -> green:float -> blue:float -> alpha:float -> unit
  = "gl_api_glClearAccum"

module Accum = Enums.Accum
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glAccum.xml}
    manual pages on opengl.org}
*)
external glAccum : op:Accum.accum_op -> value:float -> unit = "gl_api_glAccum"

module Matrix = Enums.Matrix
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMatrixMode.xml}
    manual pages on opengl.org}
*)
external glMatrixMode : Matrix.matrix_mode -> unit = "gl_api_glMatrixMode"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glOrtho.xml}
    manual pages on opengl.org}
*)
external glOrtho : left:float -> right:float -> bottom:float ->
  top:float -> near:float -> far:float -> unit
    = "gl_api_glOrtho_bytecode" "gl_api_glOrtho"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFrustum.xml}
    manual pages on opengl.org}
*)
external glFrustum : left:float -> right:float -> bottom:float ->
  top:float -> near:float -> far:float -> unit
    = "gl_api_glFrustum_bytecode" "gl_api_glFrustum"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glViewport.xml}
    manual pages on opengl.org}
*)
external glViewport : x:int -> y:int -> width:int -> height:int -> unit
  = "gl_api_glViewport"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPushMatrix.xml}
    manual pages on opengl.org}
*)
external glPushMatrix : unit -> unit = "gl_api_glPushMatrix"
external glPopMatrix : unit -> unit = "gl_api_glPopMatrix"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLoadIdentity.xml}
    manual pages on opengl.org}
*)
external glLoadIdentity : unit -> unit = "gl_api_glLoadIdentity"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLoadMatrix.xml}
    manual pages on opengl.org}
*)
external glLoadMatrix : float array -> unit = "gl_api_glLoadMatrix"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMultMatrix.xml}
    manual pages on opengl.org}
*)
external glMultMatrix : float array -> unit = "gl_api_glMultMatrix"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glRotate.xml}
    manual pages on opengl.org}
*)
external glRotate : angle:float -> x:float -> y:float -> z:float -> unit
  = "gl_api_glRotate"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glScale.xml}
    manual pages on opengl.org}
*)
external glScale : x:float -> y:float -> z:float -> unit = "gl_api_glScale"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTranslate.xml}
    manual pages on opengl.org}
*)
external glTranslate : x:float -> y:float -> z:float -> unit = "gl_api_glTranslate"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsList.xml}
    manual pages on opengl.org}
*)
external glIsList : int -> bool = "gl_api_glIsList"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteLists.xml}
    manual pages on opengl.org}
*)
external glDeleteLists : list:int -> range:int -> unit = "gl_api_glDeleteLists"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGenLists.xml}
    manual pages on opengl.org}
*)
external glGenLists : int -> int = "gl_api_glGenLists"

module NewList = Enums.NewList
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glNewList.xml}
    manual pages on opengl.org}
*)
external glNewList : list:int -> mode:NewList.newlist_mode -> unit
  = "gl_api_glNewList"
external glEndList : unit -> unit = "gl_api_glEndList"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCallList.xml}
    manual pages on opengl.org}
*)
external glCallList : int -> unit = "gl_api_glCallList"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glListBase.xml}
    manual pages on opengl.org}
*)
external glListBase : int -> unit = "gl_api_glListBase"

module Begin = Enums.Begin
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBegin.xml}
    manual pages on opengl.org}
*)
external glBegin : Begin.draw_mode -> unit = "gl_api_glBegin"
external glEnd : unit -> unit = "gl_api_glEnd"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertex.xml}
    manual pages on opengl.org}
*)
external glVertex2 : x:float -> y:float -> unit = "gl_api_glVertex2"
external glVertex3 : x:float -> y:float -> z:float -> unit = "gl_api_glVertex3"
external glVertex4 : x:float -> y:float -> z:float -> w:float -> unit = "gl_api_glVertex4"
external glVertex2v : float * float -> unit = "gl_api_glVertex2v"
external glVertex3v : float * float * float -> unit = "gl_api_glVertex3v"
external glVertex4v : float * float * float * float-> unit = "gl_api_glVertex4v"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glNormal.xml}
    manual pages on opengl.org}
*)
external glNormal : x:float -> y:float -> z:float -> unit = "gl_api_glNormal"
external glNormalv : float * float * float -> unit = "gl_api_glNormalv"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIndex.xml}
    manual pages on opengl.org}
*)
external glIndex : float -> unit = "gl_api_glIndex"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColor.xml}
    manual pages on opengl.org}
*)
external glColor3 : red:float -> green:float -> blue:float -> unit = "gl_api_glColor3"
external glColor4 : red:float -> green:float -> blue:float -> alpha:float -> unit
  = "gl_api_glColor4"
external glColor3v : float * float * float -> unit = "gl_api_glColor3v"
external glColor4v : float * float * float * float -> unit = "gl_api_glColor4v"


(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexCoord.xml}
    manual pages on opengl.org}
*)
external glTexCoord1 : float -> unit = "gl_api_glTexCoord1"
external glTexCoord2 : s:float -> t:float -> unit = "gl_api_glTexCoord2"
external glTexCoord3 : s:float -> t:float -> r:float -> unit
  = "gl_api_glTexCoord3"
external glTexCoord4 : s:float -> t:float -> r:float -> q:float -> unit
  = "gl_api_glTexCoord4"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glRasterPos.xml}
    manual pages on opengl.org}
*)
external glRasterPos2 : x:float -> y:float -> unit = "gl_api_glRasterPos2"
external glRasterPos3 : x:float -> y:float -> z:float -> unit = "gl_api_glRasterPos3"
external glRasterPos4 : x:float -> y:float -> z:float -> w:float -> unit
  = "gl_api_glRasterPos4"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glRect.xml}
    manual pages on opengl.org}
*)
external glRect : x1:float -> y1:float -> x2:float -> y2:float -> unit = "gl_api_glRect"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glArrayElement.xml}
    manual pages on opengl.org}
*)
external glArrayElement : int -> unit = "gl_api_glArrayElement"

module DrawArrays = Enums.DrawArrays
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDrawArrays.xml}
    manual pages on opengl.org}
*)
external glDrawArrays : mode:DrawArrays.draw_mode -> first:int -> count:int -> unit
  = "gl_api_glDrawArrays"

module Shade = Enums.Shade
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glShadeModel.xml}
    manual pages on opengl.org}
*)
external glShadeModel : Shade.shade_mode -> unit = "gl_api_glShadeModel"

(** type of number of light  *)
type gl_light = GL_LIGHT of int

module Light = Enums.Light
module SetLight = Enums.SetLight

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLight.xml}
    manual pages on opengl.org}
*)
external glLight1 : light_i:int -> pname:SetLight.set_light_1 ->
  value:float -> unit = "gl_api_glLight1"
external glLight3 : light_i:int ->
  value:float * float * float -> unit = "gl_api_glLight3"
external glLight4 : light_i:int -> pname:SetLight.set_light_4 ->
  value:float * float * float * float -> unit = "gl_api_glLight4"

type float_array = (float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLightModel.xml}
    manual pages on opengl.org}
*)
external glLightModel1 : pname:Light.light_model -> value:float -> unit = "gl_api_glLightModel1"
external glLightModel4 : float * float * float * float -> unit = "gl_api_glLightModel4"
external glLightModelControl :Light.light_model_control -> unit = "gl_api_glLightModelControl"

module Material = Enums.Material
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMaterial.xml}
    manual pages on opengl.org}
*)
external glMaterial1 : face:Material.cull_face_mode -> value:float -> unit
  = "gl_api_glMaterial1"
external glMaterial3 : face:Material.cull_face_mode ->
  value:float * float * float -> unit = "gl_api_glMaterial3"
external glMaterial4 : face:Material.cull_face_mode -> pname:Material.material_4f ->
  value:float * float * float * float -> unit
  = "gl_api_glMaterial4"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColorMaterial.xml}
    manual pages on opengl.org}
*)
external glColorMaterial : face:Material.cull_face_mode -> mode:Material.material_4f -> unit
  = "gl_api_glColorMaterial"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPixelZoom.xml}
    manual pages on opengl.org}
*)
external glPixelZoom : xfactor:float -> yfactor:float -> unit = "gl_api_glPixelZoom"

(* Alignment for requirements for the start of each pixel row in memroy  *)
type pixel_alignment =
| GL_ALIGN_1
| GL_ALIGN_2
| GL_ALIGN_4
| GL_ALIGN_8

module Pixels = Enums.Pixels
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPixelStore.xml}
    manual pages on opengl.org}
*)
external glPixelStoreb : pname:Pixels.pixel_store_boolean -> param:bool -> unit
  = "gl_api_glPixelStoreb"
external glPixelStorei : pname:Pixels.pixel_store_integer -> param:int -> unit
  = "gl_api_glPixelStorei"
external glPixelStore_align : pname:Pixels.pixel_store_align -> param:pixel_alignment -> unit
  = "gl_api_glPixelStore_align"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPixelTransfer.xml}
    manual pages on opengl.org}
*)
external glPixelTransferb : pname:Pixels.pixel_transfer_boolean -> param:bool -> unit
  = "gl_api_glPixelTransferb"
external glPixelTransferf : pname:Pixels.pixel_transfer_float -> param:float -> unit
  = "gl_api_glPixelTransferf"
external glPixelTransferi : pname:Pixels.pixel_transfer_integer -> param:float -> unit
  = "gl_api_glPixelTransferi"

type pixel_map = (float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPixelMap.xml}
    manual pages on opengl.org}
*)
external glPixelMap : map:Pixels.pixel_map -> values:pixel_map -> unit
  = "gl_api_glPixelMap"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetPixelMap.xml}
    manual pages on opengl.org}
*)
external glGetPixelMap : map:Pixels.pixel_map -> values:pixel_map -> unit = "gl_api_glGetPixelMap"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBigmap.xml}
    manual pages on opengl.org}
*)
external glBitmap : width:int -> height:int -> xorig:float -> yorig:float ->
  xmove:float -> ymove:float ->
    bitmap:image_type -> unit
      = "gl_api_glBitmap_bytecode" "gl_api_glBitmap"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCopyPixels.xml}
    manual pages on opengl.org}
*)
external glCopyPixels : x:int -> y:int -> width:int -> height:int ->
  copy_type:Pixels.pixel_copy_type -> unit
    = "gl_api_glCopyPixels"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glStencilFunc.xml}
    manual pages on opengl.org}
*)
external glStencilFunc : func:Func.compare_func -> func_ref:int -> mask:int -> unit
  = "gl_api_glStencilFunc"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glStencilMask.xml}
    manual pages on opengl.org}
*)
external glStencilMask : int -> unit = "gl_api_glStencilMask"

module Stencil = Enums.Stencil
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glStencilOp.xml}
    manual pages on opengl.org}
*)
external glStencilOp : fail:Stencil.stencil_op -> zfail:Stencil.stencil_op
  -> zpass:Stencil.stencil_op -> unit = "gl_api_glStencilOp"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClearStencil.xml}
    manual pages on opengl.org}
*)
external glClearStencil : int -> unit = "gl_api_glClearStencil"

module Tex = Enums.Tex
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexGen.xml}
    manual pages on opengl.org}
*)
external glTexGen1 : coord:Tex.coord -> pname:Tex.texgen_func -> unit
  = "gl_api_glTexGen1"
external glTexGen4 : coord:Tex.coord -> pname:Tex.texgen_plane ->
  param:float * float * float * float -> unit = "gl_api_glTexGen4"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexEnv.xml}
    manual pages on opengl.org}
*)
external glTexEnv1 : Tex.texgen_env_func ->  unit = "gl_api_glTexEnv1"
external glTexEnv4 : float * float * float * float -> unit = "gl_api_glTexEnv4"
(* TODO: append function for glTexEnv with other pnames *)

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexParameter.xml}
    manual pages on opengl.org}
*)
external glTexParameter1 : target:Tex.texture_image_type ->
  pname:Tex.tex_parameter_1 -> value:float -> unit
    = "gl_api_glTexParameter1"
(* for GL_TEXTURE_BORDER_COLOR *)
external glTexParameter4 : target:Tex.texture_image_type ->
  value:float * float * float * float -> unit = "gl_api_glTexParameter4"

(* for filter *)
external glTexParameter_filter : target:Tex.texture_image_type ->
  pname:Tex.tex_parameter_filter ->
    filter:Tex.tex_parameter_filter_type ->
      unit = "gl_api_glTexParameter_filter"

(* for type of wrap *)
external glTexParameter_wrap : target:Tex.texture_image_type ->
  pname:Tex.tex_parameter_wrap ->
    filter:Tex.tex_parameter_wrap_type ->
      unit = "gl_api_glTexParameter_filter"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetTexParameter.xml}
    manual pages on opengl.org}
*)
external glGetTexParameter1 : target:Tex.texture_image_type -> pname:Tex.tex_parameter_1 -> float
  = "gl_api_glGetTexParameter1"
external glGetTexParameter4 : Tex.texture_image_type -> float * float * float * float
  = "gl_api_glGetTexParameter4"

external glGetTexParameter_filter : target:Tex.texture_image_type ->
  pname:Tex.tex_parameter_filter -> Tex.tex_parameter_filter_type
    = "gl_api_glGetTexParameter_filter"

(* for type of wrap *)
external glGetTexParameter_wrap : target:Tex.texture_image_type ->
  pname:Tex.tex_parameter_wrap -> Tex.tex_parameter_wrap_type
    = "gl_api_glGetTexParameter_filter"

type texture
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGenTextures.xml}
    manual pages on opengl.org}
*)
external glGenTextures : int -> texture array = "gl_api_glGenTextures"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteTextures.xml}
    manual pages on opengl.org}
*)
external glDeleteTextures : size:int -> textures:texture array -> unit = "gl_api_glDeleteTextures"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindTexture.xml}
    manual pages on opengl.org}
*)
external glBindTexture : target:Tex.texture_image_type -> texture:texture -> unit
  = "gl_api_glBindTexture"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPrioritizeTextures.xml}
    manual pages on opengl.org}
*)
external glPrioritizeTextures : textures:texture array
  -> priorities:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit
    = "gl_api_glPrioritizeTextures"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glAreTexturesResident.xml}
    manual pages on opengl.org}
*)
external glAreTexturesResident : textures:texture array -> residences:bool array -> bool
  = "gl_api_glAreTexturesResident"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsTexture.xml}
    manual pages on opengl.org}
*)
external glIsTexture : texture -> bool = "gl_api_glIsTexture"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCopyTexImage1D.xml}
    manual pages on opengl.org}
*)
external glCopyTexImage1D : level:int -> format:InternalFormat.internal_format ->
  x:int -> y:int -> width:int -> border:int -> unit
    = "gl_api_glCopyTexImage1D_bytecode" "gl_api_glCopyTexImage1D"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCopyTexImage2D.xml}
    manual pages on opengl.org}
*)
external glCopyTexImage2D : level:int -> format:InternalFormat.internal_format ->
  x:int -> y:int -> width:int -> height:int -> border:int -> unit
    = "gl_api_glCopyTexImage2D_bytecode" "gl_api_glCopyTexImage2D"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCopyTexSubImage1D.xml}
    manual pages on opengl.org}
*)
external glCopyTexSubImage1D : level:int -> xoffset:int -> x:int -> y:int -> width:int -> unit
  = "gl_api_glCopyTexSubImage1D_bytecode" "gl_api_glCopyTexSubImage1D"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCopyTexSubImage2D.xml}
    manual pages on opengl.org}
*)
external glCopyTexSubImage2D : level:int -> xoffset:int -> yoffset:int -> x:int -> y:int ->
  width:int -> height:int -> unit
    = "gl_api_glCopyTexSubImage2D_bytecode" "gl_api_glCopyTexSubImage2D"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCopyTexSubImage3D.xml}
    manual pages on opengl.org}
*)
external glCopyTexSubImage3D : level:int -> xoffset:int -> yoffset:int -> zoffset:int ->
  x:int -> y:int -> width:int -> height:int -> unit
    = "gl_api_glCopyTexSubImage3D_bytecode" "gl_api_glCopyTexSubImage3D"

module Eval = Enums.Eval
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMap.xml}
    manual pages on opengl.org}
*)
external glMap1_1 : target:Eval.map_target_1_1 -> u1:float -> u2:float -> stride:int ->
  order:int -> value:float -> unit = "gl_api_glMap1_1_bytecode" "gl_api_glMap1_1"
external glMap1_2 : u1:float -> u2:float -> stride:int ->
  order:int -> value:float * float -> unit
    = "gl_api_glMap1_2"
external glMap1_3 : target:Eval.map_target_1_3 -> u1:float -> u2:float -> stride:int ->
  order:int -> value:float * float * float -> unit
    = "gl_api_glMap1_3_bytecode" "gl_api_glMap1_3"
external glMap1_4 : target:Eval.map_target_1_4 -> u1:float -> u2:float -> stride:int ->
  order:int -> value:float * float * float * float -> unit
    = "gl_api_glMap1_4_bytecode" "gl_api_glMap1_4"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMap2.xml}
    manual pages on opengl.org}
*)
external glMap2_1 : target:Eval.map_target_2_1 -> u1:float -> u2:float -> ustride:int ->
  uorder:int -> v1:float -> v2:float -> vstride:int -> vorder:int ->
    value:float -> unit = "gl_api_glMap2_1_bytecode" "gl_api_glMap2_1"
external glMap2_2 : u1:float -> u2:float -> ustride:int ->
  uorder:int -> v1:float -> v2:float -> vstride:int -> vorder:int ->
    value:float * float -> unit = "gl_api_glMap2_2_bytecode" "gl_api_glMap2_2"
external glMap2_3 : target:Eval.map_target_2_3 -> u1:float -> u2:float -> ustride:int ->
  uorder:int -> v1:float -> v2:float -> vstride:int -> vorder:int ->
    value:float * float * float -> unit = "gl_api_glMap2_3_bytecode" "gl_api_glMap2_3"
external glMap2_4 : target:Eval.map_target_2_4 -> u1:float -> u2:float -> ustride:int ->
  uorder:int -> v1:float -> v2:float -> vstride:int -> vorder:int ->
    value:float * float * float * float -> unit
      = "gl_api_glMap2_4_bytecode" "gl_api_glMap2_4"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEvalCoord.xml}
    manual pages on opengl.org}
*)
external glEvalCoord1: float -> unit = "gl_api_glEvalCoord1"
external glEvalCoord2 : u:float -> v:float -> unit = "gl_api_glEvalCoord2"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMapGrid.xml}
    manual pages on opengl.org}
*)
external glMapGrid1 : un:int -> u1:float -> u2:float -> unit
  = "gl_api_glMapGrid1"
external glMapGrid2 : un:int -> u1:float -> u2:float -> vn:int -> v1:float -> v2:float -> unit
  = "gl_api_glMapGrid2_bytecode" "gl_api_glMapGrid2"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEvalPoint.xml}
    manual pages on opengl.org}
*)
external glEvalPoint1 : int -> unit = "gl_api_glEvalPoint1"
external glEvalPoint2 : i:int -> j:int -> unit = "gl_api_glEvalPoint2"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEvalMesh.xml}
    manual pages on opengl.org}
*)
external glEvalMesh1 : mode:Eval.mesh_mode_1 -> i1:int -> i2:int -> unit
  = "gl_api_glEvalMesh1"
external glEvalMesh2 : mode:Eval.mesh_mode_2 -> i1:int -> i2:int -> j1:int -> j2:int -> unit
  = "gl_api_glEvalMesh2"

module Fog = Enums.Fog
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFog.xml}
    manual pages on opengl.org}
*)
external glFog_mode : mode:Fog.fog_mode -> param:Fog.fog_mode_param -> unit
  = "gl_api_glFog_mode"
external glFog1 : pname:Fog.fog_value_type -> param:float -> unit
  = "gl_api_glFog1"
external glFog4 : float * float * float * float -> unit
  = "gl_api_glFog4"

(*TODO
  glFeedbackBuffer
  glPassThrough
*)

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glSelectBuffer.xml}
    manual pages on opengl.org}
*)
external glSelectBuffer : int -> (int, Bigarray.int32_elt, Bigarray.c_layout) Bigarray.Array1.t
  = "gl_api_glSelectBuffer"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glInitNames.xml}
    manual pages on opengl.org}
*)
external glInitNames : unit -> unit = "gl_api_glInitNames"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLoadName.xml}
    manual pages on opengl.org}
*)
external glLoadName : int -> unit = "gl_api_glLoadName"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPushName.xml}
    manual pages on opengl.org}
*)
external glPushName : int -> unit = "gl_api_glPushName"
external glPopName : unit -> unit = "gl_api_glPopName"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBlendEquation.xml}
    manual pages on opengl.org}
*)
external glBlendEquation : Func.blend_func -> unit = "gl_api_glBlendEquation"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBlendColor.xml}
    manual pages on opengl.org}
*)
external glBlendColor : red:float -> green:float -> blue:float -> alpha:float -> unit
  = "gl_api_glBlendColor"

module Histogram = Enums.Histogram
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glHistogram.xml}
    manual pages on opengl.org}
*)
external glHistogram : target:Histogram.histogram -> width:int ->
  internalformat:InternalFormat.internal_format -> sink:bool -> unit
    = "gl_api_glHistogram"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glResetHistogram.xml}
    manual pages on opengl.org}
*)
external glResetHistogram : unit -> unit = "gl_api_glResetHistogram"

module Convolution = Enums.Convolution
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glConvolutionParameter.xml}
    manual pages on opengl.org}
*)
external glConvolutionParameter_border : target:Convolution.convolution_target ->
  mode:Convolution.convolution_border_mode -> unit
  = "gl_api_glConvolutionParameter_border"
external glConvolutionParameter : target:Convolution.convolution_target ->
  pname:Convolution.convolution_pname -> param:float * float * float * float -> unit
    = "gl_api_glConvolutionParameter"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCopyConvolutionFilter1D.xml}
    manual pages on opengl.org}
*)
external glCopyConvolutionFilter1D : internalformat:InternalFormat.internal_format ->
  x:int -> y:int -> width:int -> unit
    = "gl_api_glCopyConvolutionFilter1D"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCopyConvolutionFilter2D.xml}
    manual pages on opengl.org}
*)
external glCopyConvolutionFilter2D : internalformat:InternalFormat.internal_format ->
  x:int -> y:int -> width:int -> height:int -> unit
    = "gl_api_glCopyConvolutionFilter2D"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glActiveTexture.xml}
    manual pages on opengl.org}
*)
external glActiveTexture : texture -> unit = "gl_api_glActiveTexture"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMultiTexCoord.xml}
    manual pages on opengl.org}
*)
external glMultiTexCoord1 : texture:texture -> s:float -> unit = "gl_api_glMultiTexCoord1"
external glMultiTexCoord2 : texture:texture -> s:float -> t:float -> unit
  = "gl_api_glMultiTexCoord2"
external glMultiTexCoord3 : texture:texture -> s:float -> t:float -> r:float -> unit
  = "gl_api_glMultiTexCoord3"
external glMultiTexCoord4 : texture:texture -> s:float -> t:float -> r:float -> q:float -> unit
  = "gl_api_glMultiTexCoord4"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLoadTransposeMatrix.xml}
    manual pages on opengl.org}
*)
external glLoadTransposeMatrix : (float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit
  = "gl_api_glLoadTransposeMatrix"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMultTransposeMatrix.xml}
    manual pages on opengl.org}
*)
external glMultTransposeMatrix : (float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit
  = "gl_api_glMultTransposeMatrix"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glSampleCoverage.xml}
    manual pages on opengl.org}
*)
external glSampleCoverage : value:float -> invert:bool -> unit
  = "gl_api_glSampleCoverage"

module CallList = Enums.CallList
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCallLists.xml}
    manual pages on opengl.org}
*)
external glCallLists : size:int ->
  list_type:CallList.call_list_type
  -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
    -> unit = "gl_api_glCallLists"

module Vertex = Enums.Vertex

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertexPointer.xml}
    manual pages on opengl.org}
*)
external glVertexPointer2 : pointer_type:Vertex.vertex_pointer_type ->
  stride:int -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit = "gl_api_glVertexPointer2"
external glVertexPointer3 : pointer_type:Vertex.vertex_pointer_type ->
  stride:int -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit = "gl_api_glVertexPointer3"
external glVertexPointer4 : pointer_type:Vertex.vertex_pointer_type ->
  stride:int -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit = "gl_api_glVertexPointer4"

module Normal = Enums.Normal

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glNormalPointer.xml}
    manual pages on opengl.org}
*)
external glNormalPointer : pointer_type:Normal.normal_pointer_type ->
  stride:int -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit
    = "gl_api_glNormalPointer"

module Color = Enums.Color

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColorPointer.xml}
    manual pages on opengl.org}
*)
external glColorPointer : pointer_type:Color.color_pointer_type ->
  stride:int -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit
    = "gl_api_glColorPointer"

module Index = Enums.Index

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIndexPointer.xml}
    manual pages on opengl.org}
*)
external glIndexPointer : pointer_type:Index.index_pointer_type ->
  stride:int ->
    list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit = "gl_api_glIndexPointer"

module TexCoord = Enums.TexCoord

external glTexCoordPointer1 : pointer_type:TexCoord.texcoord_pointer_type
  -> stride:int
    -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit
      = "gl_api_glTexCoordPointer1"
external glTexCoordPointer2 : pointer_type:TexCoord.texcoord_pointer_type
  -> stride:int
    -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit
      = "gl_api_glTexCoordPointer2"
external glTexCoordPointer3 : pointer_type:TexCoord.texcoord_pointer_type
  -> stride:int
    -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit
      = "gl_api_glTexCoordPointer3"
external glTexCoordPointer4 : pointer_type:TexCoord.texcoord_pointer_type
  -> stride:int
    -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit
      = "gl_api_glTexCoordPointer4"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEdgeFlagPointer.xml}
    manual pages on opengl.org}
*)
external glEdgeFlagPointer : stride:int -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
  -> unit = "gl_api_glEdgeFlagPointer"

module DrawElements = Enums.DrawElements

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDrawElements.xml}
    manual pages on opengl.org}
*)
external glDrawElements_with_array : mode:DrawElements.draw_mode ->
  elements_type:DrawElements.draw_elements_type -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit
    = "gl_api_glDrawElements_with_array"
external glDrawElements : mode:DrawElements.draw_mode ->
  elements_type:DrawElements.draw_elements_type -> size:int -> unit
    = "gl_api_glDrawElements"

type tuple_type =
| Tuple1 of float
| Tuple3 of (float * float * float)
| Tuple4 of (float * float * float * float)

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetLight.xml}
    manual pages on opengl.org}
*)
external _glGetLightf1 : light_i:int -> int -> float = "gl_api_glGetLight1"
external _glGetLightf3 : light_i:int -> float * float * float = "gl_api_glGetLight3"
external _glGetLightf4 : light_i:int -> int -> float * float * float * float = "gl_api_glGetLight4"

let glGetLight ~light ~(pname:Light.get_light) =
  let light_i = match light with GL_LIGHT i -> i in
  match pname with
  (* four value of tuple *)
  | Light.GL_AMBIENT -> Tuple4 (_glGetLightf4 ~light_i 0)
  | Light.GL_DIFFUSE -> Tuple4 (_glGetLightf4 ~light_i 1)
  | Light.GL_SPECULAR -> Tuple4 (_glGetLightf4 ~light_i 2)
  | Light.GL_POSITION -> Tuple4 (_glGetLightf4 ~light_i 3)
  (* three value of tuple *)
  | Light.GL_SPOT_DIRECTION -> Tuple3 (_glGetLightf3 ~light_i)
  (* a value  *)
  | Light.GL_SPOT_EXPONENT -> Tuple1 (_glGetLightf1 ~light_i 5)
  | Light.GL_SPOT_CUTOFF -> Tuple1 (_glGetLightf1 ~light_i 6)
  | Light.GL_CONSTANT_ATTENUATION -> Tuple1 (_glGetLightf1 ~light_i 7)
  | Light.GL_LINEAR_ATTENUATION -> Tuple1 (_glGetLightf1 ~light_i 8)
  | Light.GL_QUADRATIC_ATTENUATION -> Tuple1 (_glGetLightf1 ~light_i 9)

module GetMaterial = struct
  include Enums.GetMaterial
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetMaterial.xml}
    manual pages on opengl.org}
*)
external glGetMaterialf1 : GetMaterial.face_mode ->
  GetMaterial.material_1f -> float = "gl_api_glGetMaterialf1"
external glGetMaterialf3 : GetMaterial.face_mode ->
  GetMaterial.material_3f -> float * float * float = "gl_api_glGetMaterialf3"
external glGetMaterialf4 : GetMaterial.face_mode ->
  GetMaterial.material_4f -> float * float * float * float  = "gl_api_glGetMaterialf4"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glReadPixels.xml}
    manual pages on opengl.org}
*)
external glReadPixels : x:int -> y:int -> width:int -> height:int ->
  format:Pixels.read_pixel_format -> pixel_type:Pixels.read_pixel_type -> image:image_type ->
    unit = "gl_api_glReadPixels_bytecode"
  "gl_api_glReadPixels_native"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDrawPixels.xml}
    manual pages on opengl.org}
*)
external glDrawPixels : width:int -> height:int ->
  format:Pixels.read_pixel_format -> pixel_type:Pixels.read_pixel_type ->
    image_type -> unit = "gl_api_glDrawPixels"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetTexGen.xml}
    manual pages on opengl.org}
*)
external glGetTexGen1 : coord:Tex.coord -> Tex.texgen_func = "gl_api_glGetTexGen1"
external glGetTexGen4 : coord:Tex.coord -> pname:Tex.texgen_plane ->
  float * float * float * float = "gl_api_glGetTexGen4"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetTexEnv.xml}
    manual pages on opengl.org}
*)
external glGetTexEnv1 : unit -> Tex.texgen_env_func = "gl_api_glGetTexEnv1"
external glGetTexEnv4 : unit -> float * float * float * float = "gl_api_glGetTexEnv4"

module TexLevel = Enums.TexLevel
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetTexLevelParameter.xml}
    manual pages on opengl.org}
*)
external glGetTexLevelParameter_format: target:TexLevel.texlevel_target ->
  level:int -> InternalFormat.internal_format = "gl_api_glGetTexLevelParameter_format"
external glGetTexLevelParameter: target:TexLevel.texlevel_target ->
  level:int -> pname:TexLevel.texlevel_pname -> int = "gl_api_glGetTexLevelParameter"

module Tex1D = Enums.Tex1D
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexImage1D.xml}
    manual pages on opengl.org}
*)
external glTexImage1D: image_type:Tex1D.image_1d_type -> level:int ->
  internal_format:InternalFormat.internal_format -> width:int -> border:bool ->
    format:Tex.texture_format -> texture_type:Tex.texture_type -> image_type -> unit
      = "gl_api_glTexImage1D_bytecode"
  "gl_api_glTexImage1D_native"

module Tex2D = Enums.Tex2D
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexImage2D.xml}
    manual pages on opengl.org}
*)
external glTexImage2D: image_type:Tex2D.image_2d_type -> level:int ->
  internal_format:InternalFormat.internal_format -> height:int -> width:int -> border:bool ->
    format:Tex.texture_format -> texture_type:Tex.texture_type -> image_type -> unit
      = "gl_api_glTexImage2D_bytecode"
  "gl_api_glTexImage2D_native"

module Tex3D = Enums.Tex3D
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexImage3D.xml}
    manual pages on opengl.org}
*)
external glTexImage3D: image_type:Tex3D.image_3d_type -> level:int ->
  internal_format:InternalFormat.internal_format -> height:int -> width:int -> depth:int -> border:bool ->
    format:Tex.texture_format -> texture_type:Tex.texture_type -> image_type -> unit
      = "gl_api_glTexImage3D_bytecode"
  "gl_api_glTexImage3D_native"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetTexImage.xml}
    manual pages on opengl.org}
*)
external glGetTexImage: target:Tex.texture_image_type -> level:int -> format:Tex.texture_format ->
  texture_type:Tex.texture_type -> image_type -> unit = "gl_api_glGetTexImage"

module TexSub = Enums.TexSub

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexSubImage1D.xml}
    manual pages on opengl.org}
*)
external glTexSubImage1D: level:int ->
  xoffset:int -> width:int ->  format:TexSub.texture_format ->
    texture_type:TexSub.texture_type -> image_type -> unit =
  "gl_api_glTexSubImage1D_bytecode"
    "gl_api_glTexSubImage1D_native"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexSubImage2D.xml}
    manual pages on opengl.org}
*)
external glTexSubImage2D: level:int -> xoffset:int -> yoffset:int -> width:int ->
  height:int ->  format:TexSub.texture_format ->
    type_format:TexSub.texture_type -> image_type -> unit =
  "gl_api_glTexSubImage2D_bytecode"
    "gl_api_glTexSubImage2D_native"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexSubImage3D.xml}
    manual pages on opengl.org}
*)
external glTexSubImage3D: level:int -> xoffset:int -> yoffset:int -> zoffset:int ->
  width:int -> height:int -> depth:int ->
    format:TexSub.texture_format ->
      texture_type:TexSub.texture_type -> image_type -> unit =
  "gl_api_glTexSubImage3D_bytecode"
    "gl_api_glTexSubImage3D_native"

type control_points = (float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t
module GetMap = Enums.GetMap

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetMap.xml}
    manual pages on opengl.org}
*)
external glGetMap: target:GetMap.map_target -> query:GetMap.map_query ->
  points:control_points -> unit = "gl_api_glGetMap"

type index_data = (int, Bigarray.int32_elt, Bigarray.c_layout) Bigarray.Array1.t
module DrawRange = Enums.DrawRange

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDrawRangeElements.xml}
    manual pages on opengl.org}
*)
external glDrawRangeElements: mode:DrawRange.draw_mode ->
  range_start:int -> range_end:int -> index_type:DrawRange.index_type ->
    indices:index_data -> unit = "gl_api_glDrawRangeElements"

(* NOTE: no implementation
   glGetPointer

   glColorTable
   glColorSubTable
   glGetColorTable
   glGetColorTableParameter
   glColorTableParameter
   glGetHistogram
   glGetHistogramParameter
   glGetMinmax
   glGetMinmaxParameter
   glConvolutionFilter1D
   glConvolutionFilter2D
   glGetConvolutionFilter
   glGetConvolutionParameter
   glCompressedTexImage1D
   glCompressedTexImage2D
   glCompressedTexImage3D
   glCompressedTexSubImage1D
   glCompressedTexSubImage2D
   glCompressedTexSubImage3D
   glGetCompressedTexImage
   glCopyColorSubTable
   glCopyColorTable
   glMinmax
   glResetMinmax
   glClientActiveTexture
*)

(* APIs being OpenGL 3.0 above version are implemented as follows.  *)
type shader
type program

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glAttachShader.xml}
    manual pages on opengl.org}
*)
external glAttachShader: shader:shader -> program:program -> unit = "gl_api_glAttachShader"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindAttribLocation.xml}
    manual pages on opengl.org}
*)
external glBindAttribLocation: program:program -> index:int -> name:string -> unit =
  "gl_api_glBindAttribLocation"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindFragDataLocation.xml}
    manual pages on opengl.org}
*)
external glBindFragDataLocation: program:program -> color:int -> name:string -> unit =
  "gl_api_glBindFragDataLocation"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindFragDataLocationIndexed.xml}
    manual pages on opengl.org}
*)
external glBindFragDataLocationIndexed: program:program -> color:int -> index:int -> name:string -> unit
  = "gl_api_glBindFragDataLocationIndexed"

type framebuffer
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindFramebuffer.xml}
    manual pages on opengl.org}
*)
external glBindFramebuffer: target:Buffer.frame_buffer_type ->
  buffer:framebuffer -> unit = "gl_api_glBindFramebuffer"

type renderbuffer

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindRenderbuffer.xml}
    manual pages on opengl.org}
*)
external glBindRenderbuffer: renderbuffer -> unit  = "gl_api_glBindRenderbuffer"

type sampler

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindSampler.xml}
    manual pages on opengl.org}
*)
external glBindSampler: target:int -> sampler:sampler -> unit
  = "gl_api_glBindSampler"

type vbo

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindVertexArray.xml}
    manual pages on opengl.org}
*)
external glBindVertexArray: vbo -> unit = "gl_api_glBindVertexArray"

module Blend = struct
  include Enums.Blend
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBlendEquationSeparate.xml}
    manual pages on opengl.org}
*)
external glBlendEquationSeparate: rgb:Blend.equation_mode -> alpha:Blend.equation_mode -> unit =
  "gl_api_glBlendEquationSeparate"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBlendFuncSeparate.xml}
    manual pages on opengl.org}
*)
external glBlendFuncSeparate: src_rgb:Blend.func_equation_mode ->
  dst_rgb:Blend.func_equation_mode -> src_alpha:Blend.func_equation_mode ->
    dst_alpha:Blend.func_equation_mode -> unit =
  "gl_api_glBlendFuncSeparate"

module Framebuffer = struct
  include Enums.Framebuffer
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBlitFramebuffer.xml}
    manual pages on opengl.org}
*)
external glBlitFramebuffer: src_x0:int -> src_y0:int -> src_x1:int -> src_y1:int ->
  dst_x0:int -> dst_y0:int -> dst_x1:int -> dst_y1:int ->
    mask:Framebuffer.blit_mask -> filter:Framebuffer.filter_type -> unit =
  "gl_api_glBlitFramebuffer_bytecode"
  "gl_api_glBlitFramebuffer_native"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCheckFramebufferStatus.xml}
    manual pages on opengl.org}
*)
external glCheckFramebufferStatus: Framebuffer.frame_buffer_type -> Framebuffer.status_type =
  "gl_api_glCheckFramebufferStatus"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClampColor.xml}
    manual pages on opengl.org}
*)
external glClampColor: bool -> unit = "gl_api_glClampColor"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClearBuffer_depth.xml}
    manual pages on opengl.org}
*)
external glClearBuffer_color: drawbuffer:int -> r:float -> g:float -> b:float -> alpha:float -> unit =
  "gl_api_glClearBuffer_color"
external glClearBuffer_depth: float -> unit = "gl_api_glClearBuffer_depth"
external glClearBuffer_stencil: int -> unit = "gl_api_glClearBuffer_stencil"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCompileShader.xml}
    manual pages on opengl.org}
*)
external glCompileShader: shader -> unit = "gl_api_glCompileShader"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCreateProgram.xml}
    manual pages on opengl.org}
*)
external glCreateProgram: unit -> program = "gl_api_glCreateProgram"

module Shader = Enums.Shader

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCreateShader.xml}
    manual pages on opengl.org}
*)
external glCreateShader: Shader.shader_type -> shader = "gl_api_glCreateShader"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteFramebuffers.xml}
    manual pages on opengl.org}
*)
external glDeleteFramebuffers: size:int -> buffers:framebuffer list -> unit =
  "gl_api_glDeleteFramebuffers"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteProgram.xml}
    manual pages on opengl.org}
*)
external glDeleteProgram : program -> unit = "gl_api_glDeleteProgram"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteRenderbuffers.xml}
    manual pages on opengl.org}
*)
external glDeleteRenderbuffers: size:int -> buffers:renderbuffer list -> unit =
  "gl_api_glDeleteRenderbuffers"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteSamplers.xml}
    manual pages on opengl.org}
*)
external glDeleteSamplers: size:int -> samplers:sampler list -> unit =
  "gl_api_glDeleteSamplers"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteShader.xml}
    manual pages on opengl.org}
*)
external glDeleteShader: shader -> unit = "gl_api_glDeleteShader"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteVertexArrays.xml}
    manual pages on opengl.org}
*)
external glDeleteVertexArrays: size:int -> arrays:vbo list -> unit =
  "gl_api_glDeleteVertexArrays"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDetachShader.xml}
    manual pages on opengl.org}
*)
external glDetachShader: program:program -> shader:shader -> unit =
  "gl_api_glDetachShader"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDrawBuffers.xml}
    manual pages on opengl.org}
*)
external glDrawBuffers : Buffer.draw_buffer_mode list -> unit =
  "gl_api_glDrawBuffers"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEnableVertexAttribArray.xml}
    manual pages on opengl.org}
*)
external glEnableVertexAttribArray: int -> unit = "gl_api_glEnableVertexAttribArray"
external glDisableVertexAttribArray: int -> unit = "gl_api_glDisableVertexAttribArray"

type gl_attachment = GL_ATTACHMENT of int |
    GL_DEPTH_ATTACHMENT | GL_STENCIL_ATTACHMENT | GL_DEPTH_STENCIL_ATTACHMENT

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFramebufferRenderbuffer.xml}
    manual pages on opengl.org}
*)
external glFramebufferRenderbuffer_attachment : Framebuffer.frame_buffer_type ->
  int -> renderbuffer -> unit = "gl_api_glFramebufferRenderbuffer_attachment"
external glFramebufferRenderbuffer_depth : Framebuffer.frame_buffer_type ->
  renderbuffer -> unit = "gl_api_glFramebufferRenderbuffer_depth"
external glFramebufferRenderbuffer_stencil : Framebuffer.frame_buffer_type ->
  renderbuffer -> unit = "gl_api_glFramebufferRenderbuffer_stencil"
external glFramebufferRenderbuffer_depth_stencil : Framebuffer.frame_buffer_type ->
  renderbuffer -> unit = "gl_api_glFramebufferRenderbuffer_depth_stencil"

let glFramebufferRenderbuffer ~target ~attachment ~render =
  match attachment with
  | GL_ATTACHMENT num -> glFramebufferRenderbuffer_attachment target num render
  | GL_DEPTH_ATTACHMENT -> glFramebufferRenderbuffer_depth target render
  | GL_STENCIL_ATTACHMENT -> glFramebufferRenderbuffer_stencil target render
  | GL_DEPTH_STENCIL_ATTACHMENT -> glFramebufferRenderbuffer_depth_stencil target render

external glFramebufferTextureLayer_attachment : Framebuffer.frame_buffer_type ->
  int -> texture -> int -> int -> unit = "gl_api_glFramebufferTextureLayer_attachment"
external glFramebufferTextureLayer_depth : Framebuffer.frame_buffer_type ->
  texture -> int -> int -> unit = "gl_api_glFramebufferTextureLayer_depth"
external glFramebufferTextureLayer_stencil : Framebuffer.frame_buffer_type ->
  texture -> int -> int -> unit = "gl_api_glFramebufferTextureLayer_stencil"
external glFramebufferTextureLayer_depth_stencil : Framebuffer.frame_buffer_type ->
  texture -> int -> int -> unit = "gl_api_glFramebufferTextureLayer_depth_stencil"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFramebufferTextureLayer.xml}
    manual pages on opengl.org}
*)
let glFramebufferTextureLayer ~target ~attachment ~texture ~level ~layer =
  match attachment with
  | GL_ATTACHMENT num -> glFramebufferTextureLayer_attachment target num texture level layer
  | GL_DEPTH_ATTACHMENT -> glFramebufferTextureLayer_depth target texture level layer
  | GL_STENCIL_ATTACHMENT -> glFramebufferTextureLayer_stencil target texture level layer
  | GL_DEPTH_STENCIL_ATTACHMENT -> glFramebufferTextureLayer_depth_stencil target texture level layer


(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGenFramebuffers.xml}
    manual pages on opengl.org}
*)
external glGenFramebuffer: unit -> framebuffer = "gl_api_glGenFramebuffer"
external glGenFramebuffers: int -> framebuffer list = "gl_api_glGenFramebuffers"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGenRenderbuffers.xml}
    manual pages on opengl.org}
*)
external glGenRenderbuffer: unit -> renderbuffer = "gl_api_glGenRenderbuffer"
external glGenRenderbuffers: int -> renderbuffer list = "gl_api_glGenRenderbuffers"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGenSamplers.xml}
    manual pages on opengl.org}
*)
external glGenSampler: unit -> sampler = "gl_api_glGenSampler"
external glGenSamplers: int -> sampler list = "gl_api_glGenSamplers"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGenVertexArrayss.xml}
    manual pages on opengl.org}
*)
external glGenVertexArray: unit -> vbo = "gl_api_glGenVertexArray"
external glGenVertexArrays: int -> vbo list = "gl_api_glGenVertexArrays"

module Mipmap = struct
  include Enums.Mipmap
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGenerateMipmap.xml}
    manual pages on opengl.org}
*)
external glGenerateMipmap: Mipmap.mipmap_type -> unit = "gl_api_glGenerateMipmap"

module GetAttrib = struct
  include Enums.GetAttrib
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetActiveAttrib.xml}
    manual pages on opengl.org}
*)
external glGetActiveAttrib_length: program:program -> index:int -> int =
  "gl_api_glGetActiveAttrib_length"
external glGetActiveAttrib_size: program:program -> index:int -> int =
  "gl_api_glGetActiveAttrib_size"
external glGetActiveAttrib_type: program:program -> index:int -> GetAttrib.attrib_type =
  "gl_api_glGetActiveAttrib_type"
external glGetActiveAttrib_name: program:program -> index:int -> string =
  "gl_api_glGetActiveAttrib_name"

module GetUniform = struct
  include Enums.GetUniform
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetActiveAttrib.xml}
    manual pages on opengl.org}
*)
external glGetActiveUniform_length: program:program -> index:int -> int =
  "gl_api_glGetActiveUniform_length"
external glGetActiveUniform_type: program:program -> index:int -> GetUniform.uniform_type =
  "gl_api_glGetActiveUniform_type"
external glGetActiveUniform_name: program:program -> index:int -> string =
  "gl_api_glGetActiveUniform_name"

module GetUniformBlock = struct
  include Enums.GetUniformBlock
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetActiveUniformBlock.xml}
    manual pages on opengl.org}
*)
external glGetActiveUniformBlock: program:program -> index:int ->
  pname:GetUniformBlock.uniform_block_type -> int = "gl_api_glGetActiveUniformBlock"
external glGetActiveUniformBlock_indices: program:program -> index:int ->
  (int, Bigarray.int_elt, Bigarray.c_layout) Bigarray.Array1.t = "gl_api_glGetActiveUniformBlock_indices"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetActiveUniformBlockName.xml}
    manual pages on opengl.org}
*)
external glGetActiveUniformBlockName: program:program -> index:int -> string =
  "gl_api_glGetActiveUniformBlockName"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetActiveUniformName.xml}
    manual pages on opengl.org}
*)
external glGetActiveUniformName: program:program -> index:int -> string =
  "gl_api_glGetActiveUniformName"

module GetActiveUniform = struct
  include Enums.GetActiveUniform
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetActiveUniformName.xml}
    manual pages on opengl.org}
*)
external glGetActiveUniforms_type: program:program -> index:int ->
  GetActiveUniform.uniform_type = "gl_api_glGetActiveUniforms_type"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetAttachedShaders.xml}
    manual pages on opengl.org}
*)
external glGetAttachedShaders: program -> shader list =
  "gl_api_glGetAttachedShaders"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetAttribLocation.xml}
    manual pages on opengl.org}
*)
external glGetAttribLocation: program:program -> name:string -> int =
  "gl_api_glGetAttribLocation"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetFragDataIndex.xml}
    manual pages on opengl.org}
*)
external glGetFragDataIndex: program:program -> name:string -> int =
  "gl_api_glGetFragDataIndex"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetFragDataLocation.xml}
    manual pages on opengl.org}
*)
external glGetFragDataLocation: program:program -> name:string -> int =
  "gl_api_glGetFragDataLocation"

module FramebufferAttachment = struct
  include Enums.FramebufferAttachment
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetFramebufferAttachmentParameter.xml}
    manual pages on opengl.org}
*)
external glGetFramebufferAttachmentParameter_type_color: FramebufferAttachment.frame_buffer_type ->
  int -> FramebufferAttachment.attachment_object_type =
  "gl_api_glGetFramebufferAttachmentParameter_type_color"
external glGetFramebufferAttachmentParameter_type_other: FramebufferAttachment.frame_buffer_type ->
  FramebufferAttachment.attachment_type ->
  FramebufferAttachment.attachment_object_type =
  "gl_api_glGetFramebufferAttachmentParameter_type_other"
external glGetFramebufferAttachmentParameter_int_color: FramebufferAttachment.frame_buffer_type ->
  int -> FramebufferAttachment.get_attachment_int -> int =
  "gl_api_glGetFramebufferAttachmentParameter_int_color"
external glGetFramebufferAttachmentParameter_int_other: FramebufferAttachment.frame_buffer_type ->
  FramebufferAttachment.attachment_type ->
    FramebufferAttachment.get_attachment_int -> int =
  "gl_api_glGetFramebufferAttachmentParameter_int_other"
external glGetFramebufferAttachmentParameter_component_color: FramebufferAttachment.frame_buffer_type ->
  int -> FramebufferAttachment.attachment_component_type =
  "gl_api_glGetFramebufferAttachmentParameter_component_color"
external glGetFramebufferAttachmentParameter_component_other: FramebufferAttachment.frame_buffer_type ->
  FramebufferAttachment.attachment_type -> FramebufferAttachment.attachment_component_type =
  "gl_api_glGetFramebufferAttachmentParameter_component_other"
external glGetFramebufferAttachmentParameter_encoding_color: FramebufferAttachment.frame_buffer_type ->
  int -> FramebufferAttachment.attachment_encoding_type =
  "gl_api_glGetFramebufferAttachmentParameter_encoding_color"
external glGetFramebufferAttachmentParameter_encoding_other: FramebufferAttachment.frame_buffer_type ->
  FramebufferAttachment.attachment_type -> FramebufferAttachment.attachment_encoding_type =
  "gl_api_glGetFramebufferAttachmentParameter_encoding_other"

let glGetFramebufferAttachmentParameter_type ~target ~attachment =
  match attachment with
  | GL_ATTACHMENT num -> glGetFramebufferAttachmentParameter_type_color target num
  | GL_DEPTH_ATTACHMENT -> glGetFramebufferAttachmentParameter_type_other target
    FramebufferAttachment.GL_DEPTH_ATTACHMENT
  | GL_STENCIL_ATTACHMENT -> glGetFramebufferAttachmentParameter_type_other target
    FramebufferAttachment.GL_STENCIL_ATTACHMENT
  | GL_DEPTH_STENCIL_ATTACHMENT -> glGetFramebufferAttachmentParameter_type_other target
    FramebufferAttachment.GL_DEPTH_STENCIL_ATTACHMENT

let glGetFramebufferAttachmentParameter_int ~target ~attachment ~pname =
  match attachment with
  | GL_ATTACHMENT num -> glGetFramebufferAttachmentParameter_int_color target num pname
  | GL_DEPTH_ATTACHMENT -> glGetFramebufferAttachmentParameter_int_other target
    FramebufferAttachment.GL_DEPTH_ATTACHMENT pname
  | GL_STENCIL_ATTACHMENT -> glGetFramebufferAttachmentParameter_int_other target
    FramebufferAttachment.GL_STENCIL_ATTACHMENT pname
  | GL_DEPTH_STENCIL_ATTACHMENT -> glGetFramebufferAttachmentParameter_int_other target
    FramebufferAttachment.GL_DEPTH_STENCIL_ATTACHMENT pname

let glGetFramebufferAttachmentParameter_component ~target ~attachment =
  match attachment with
  | GL_ATTACHMENT num -> glGetFramebufferAttachmentParameter_component_color target num
  | GL_DEPTH_ATTACHMENT -> glGetFramebufferAttachmentParameter_component_other target
    FramebufferAttachment.GL_DEPTH_ATTACHMENT
  | GL_STENCIL_ATTACHMENT -> glGetFramebufferAttachmentParameter_component_other target
    FramebufferAttachment.GL_STENCIL_ATTACHMENT
  | GL_DEPTH_STENCIL_ATTACHMENT -> glGetFramebufferAttachmentParameter_component_other target
    FramebufferAttachment.GL_DEPTH_STENCIL_ATTACHMENT

let glGetFramebufferAttachmentParameter_encoding ~target ~attachment =
  match attachment with
  | GL_ATTACHMENT num -> glGetFramebufferAttachmentParameter_encoding_color target num
  | GL_DEPTH_ATTACHMENT -> glGetFramebufferAttachmentParameter_encoding_other target
    FramebufferAttachment.GL_DEPTH_ATTACHMENT
  | GL_STENCIL_ATTACHMENT -> glGetFramebufferAttachmentParameter_encoding_other target
    FramebufferAttachment.GL_STENCIL_ATTACHMENT
  | GL_DEPTH_STENCIL_ATTACHMENT -> glGetFramebufferAttachmentParameter_encoding_other target
    FramebufferAttachment.GL_DEPTH_STENCIL_ATTACHMENT

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetMultisample.xml}
    manual pages on opengl.org}
*)
external glGetMultisample: int -> float * float = "gl_api_glGetMultisample"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetProgramInfoLog.xml}
    manual pages on opengl.org}
*)
external glGetProgramInfoLog: program -> string = "gl_api_glGetProgramInfoLog"

module RenderbufferParameter = struct
  include Enums.RenderbufferParameter
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetRenderbufferParameter.xml}
    manual pages on opengl.org}
*)
external glGetRenderbufferParameter: RenderbufferParameter.renderbuffer_parameter_type ->
  int = "gl_api_glGetRenderbufferParameter"

module SamplerParameter = struct
  include Enums.SamplerParameter
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetSamplerParameter.xml}
    manual pages on opengl.org}
*)
external glGetSamplerParameter_min_filter: sampler ->
  SamplerParameter.sampler_min_filter_type = "gl_api_glGetSamplerParameter_min_filter"
external glGetSamplerParameter_mag_filter: sampler ->
  SamplerParameter.sampler_mag_filter_type = "gl_api_glGetSamplerParameter_mag_filter"
external glGetSamplerParameter_lod: sampler:sampler ->
  pname:SamplerParameter.sampler_lod_type -> int = "gl_api_glGetSamplerParameter_lod"
external glGetSamplerParameter_wrap: sampler:sampler ->
  pname:SamplerParameter.sampler_wrap_type -> SamplerParameter.sampler_wrap_func
    = "gl_api_glGetSamplerParameter_wrap"
external glGetSamplerParameter_compare_mode: sampler ->
  SamplerParameter.sampler_compare_mode = "gl_api_glGetSamplerParameter_compare_mode"
external glGetSamplerParameter_compare_func: sampler ->
  SamplerParameter.sampler_compare_func = "gl_api_glGetSamplerParameter_compare_func"
external glGetSamplerParameter_color: sampler ->
  float * float * float * float = "gl_api_glGetSamplerParameter_color"

module GetShader = struct
  include Enums.GetShader
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetShader.xml}
    manual pages on opengl.org}
*)
external glGetShader_type: shader -> GetShader.shader_type = "gl_api_glGetShader_type"
external glGetShader_bool: shader:shader -> pname:GetShader.get_shader_bool
  -> bool = "gl_api_glGetShader_bool"
external glGetShader_int: shader:shader -> pname:GetShader.get_shader_int
  -> int = "gl_api_glGetShader_int"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetShaderInfoLog.xml}
    manual pages on opengl.org}
*)
external glGetShaderInfoLog: shader -> string = "gl_api_glGetShaderInfoLog"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetShaderSource.xml}
    manual pages on opengl.org}
*)
external glGetShaderSource: shader -> string = "gl_api_glGetShaderSource"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetUniform.xml}
    manual pages on opengl.org}
*)
external glGetUniformf1: program:program -> location:int ->
  float = "gl_api_glGetUniformf1"
external glGetUniformf2: program:program -> location:int ->
  float * float = "gl_api_glGetUniformf2"
external glGetUniformf3: program:program -> location:int ->
  float * float * float = "gl_api_glGetUniformf3"
external glGetUniformf4: program:program -> location:int ->
  float * float * float * float = "gl_api_glGetUniformf4"

external glGetUniformi1: program:program -> location:int -> int = "gl_api_glGetUniformi1"
external glGetUniformi2: program:program -> location:int -> int * int = "gl_api_glGetUniformi2"
external glGetUniformi3: program:program -> location:int -> int * int * int = "gl_api_glGetUniformi3"
external glGetUniformi4: program:program -> location:int -> int * int * int * int = "gl_api_glGetUniformi4"

external glGetUniformui1: program:program -> location:int -> int = "gl_api_glGetUniformui1"
external glGetUniformui2: program:program -> location:int -> int * int = "gl_api_glGetUniformui2"
external glGetUniformui3: program:program -> location:int -> int * int * int = "gl_api_glGetUniformui3"
external glGetUniformui4: program:program -> location:int -> int * int * int * int = "gl_api_glGetUniformui4"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetUniformBlockIndex.xml}
    manual pages on opengl.org}
*)
external glGetUniformBlockIndex: program:program -> name:string -> int =
  "gl_api_glGetUniformBlockIndex"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetUniformIndices.xml}
    manual pages on opengl.org}
*)
external glGetUniformIndices: program:program -> names:string list -> count:int -> int list =
  "gl_api_glGetUniformIndices"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetUniformLocation.xml}
    manual pages on opengl.org}
*)
external glGetUniformLocation: program:program -> name:string -> int =
  "gl_api_glGetUniformLocation"

module VertexAttrib = struct
  include Enums.VertexAttrib
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetVertexAttrib.xml}
    manual pages on opengl.org}
*)
external glGetVertexAttrib_bool: index:int -> pname:VertexAttrib.get_vertex_attrib_bool ->
  bool = "gl_api_glGetVertexAttrib_bool"
external glGetVertexAttrib_int: index:int -> pname:VertexAttrib.get_vertex_attrib_int ->
  int = "gl_api_glGetVertexAttrib_int"
external glGetVertexAttrib_vertex: int -> float * float * float * float
   = "gl_api_glGetVertexAttrib_vertex"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsFramebuffer.xml}
    manual pages on opengl.org}
*)
external glIsFramebuffer: framebuffer -> bool = "gl_api_glIsFramebuffer"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsProgram.xml}
    manual pages on opengl.org}
*)
external glIsProgram: program -> bool = "gl_api_glIsProgram"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsRenderbuffer.xml}
    manual pages on opengl.org}
*)
external glIsRenderbuffer: renderbuffer -> bool = "gl_api_glIsRenderbuffer"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsSampler.xml}
    manual pages on opengl.org}
*)
external glIsSampler: sampler -> bool = "gl_api_glIsSampler"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsShader.xml}
    manual pages on opengl.org}
*)
external glIsShader: shader -> bool = "gl_api_glIsShader"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsVertexArray.xml}
    manual pages on opengl.org}
*)
external glIsVertexArray: vbo -> bool = "gl_api_glIsVertexArray"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLinkProgram.xml}
    manual pages on opengl.org}
*)
external glLinkProgram: program -> unit = "gl_api_glLinkProgram"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMultiDrawElements.xml}
    manual pages on opengl.org}
*)
external glMultiDrawElements : mode:DrawElements.draw_mode ->
  elements_type:DrawElements.draw_elements_type -> list:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t list ->
    primcount:int -> unit
    = "gl_api_glMultiDrawElements"

module PointParameter = struct
  include Enums.PointParameter
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPointParameter.xml}
    manual pages on opengl.org}
*)
external glPointParameter: float -> unit = "gl_api_glPointParameter"
external glPointParameter_coord: PointParameter.coord_origin -> unit = "gl_api_glPointParameter_coord"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPrimitiveRestartIndex.xml}
    manual pages on opengl.org}
*)
external glPrimitiveRestartIndex : int -> unit = "gl_api_glPrimitiveRestartIndex"

module Provoking = struct
  include Enums.Provoking
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glProvokingVertex.xml}
    manual pages on opengl.org}
*)
external glProvokingVertex: Provoking.provoking_type -> unit = "gl_api_glProvokingVertex"

module Renderbuffer = struct
  include Enums.Renderbuffer
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glRenderbufferMultisample.xml}
    manual pages on opengl.org}
*)
external glRenderbufferStorageMultisample: samples:int -> internalformat:Renderbuffer.internal_format
  -> width:int -> height:int -> unit = "gl_api_glRenderbufferStorageMultisample"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glSampleMaski.xml}
    manual pages on opengl.org}
*)
external glSampleMask: masknumber:int -> mask:int -> unit = "gl_api_glSampleMask"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glSamplerParameter.xml}
    manual pages on opengl.org}
    TODO:need to implement for other parameter.
*)
external glSamplerParameter: sampler:sampler -> pname:SamplerParameter.sampler_lod_type ->
  value:int -> unit = "gl_api_glSamplerParameter"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glShaderSource.xml}
    manual pages on opengl.org}
*)
external glShaderSource: shader:shader -> source:string -> unit =
  "gl_api_glShaderSource"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glStencilFuncSeparate.xml}
    manual pages on opengl.org}
*)
external glStencilFuncSeparate : face:CullFace.cull_face_mode ->
  func:Func.compare_func -> func_ref:int -> mask:int -> unit = "gl_api_glStencilFuncSeparate"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glStencilMaskSeparate.xml}
    manual pages on opengl.org}
*)
external glStencilMaskSeparate : face:CullFace.cull_face_mode ->
  mask:int -> unit = "gl_api_glStencilMaskSeparate"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glStencilOpSeparate.xml}
    manual pages on opengl.org}
*)
external glStencilOpSeparate : face:Stencil.face_mode ->
  fail:Stencil.stencil_op -> zfail:Stencil.stencil_op
  -> zpass:Stencil.stencil_op -> unit = "gl_api_glStencilOpSeparate"

module TransformFeedback = struct
  include Enums.TransformFeedback
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTransformFeedbackVaryings.xml}
    manual pages on opengl.org}
*)
external glTransformFeedbackVaryings: program:program -> varyings:string array ->
  buffer_mode:TransformFeedback.transform_buffer_mode -> unit =
  "gl_api_glTransformFeedbackVaryings"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glUniform.xml}
    manual pages on opengl.org}
*)
external glUniform1f: location:int -> value:float -> unit = "gl_api_glUniform1f"
external glUniform2f: location:int -> value:float * float -> unit = "gl_api_glUniform2f"
external glUniform3f: location:int -> value:float * float * float -> unit = "gl_api_glUniform3f"
external glUniform4f: location:int -> value:float * float * float * float -> unit = "gl_api_glUniform4f"

external glUniform1ui: location:int -> value:int -> unit = "gl_api_glUniform1ui"
external glUniform2ui: location:int -> value:int * int -> unit = "gl_api_glUniform2ui"
external glUniform3ui: location:int -> value:int * int * int -> unit = "gl_api_glUniform3ui"
external glUniform4ui: location:int -> value:int * int * int * int -> unit = "gl_api_glUniform4ui"

external glUniformMatrix: location:int -> ?transpose:bool ->
  value:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit =
  "gl_api_glUniformMatrix"
external glUniformMatrix2x3: location:int -> ?transpose:bool ->
  value:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit =
  "gl_api_glUniformMatrix2x3"
external glUniformMatrix3x2: location:int -> ?transpose:bool ->
  value:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit =
  "gl_api_glUniformMatrix3x2"
external glUniformMatrix2x4: location:int -> ?transpose:bool ->
  value:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit =
  "gl_api_glUniformMatrix2x4"
external glUniformMatrix4x2: location:int -> ?transpose:bool ->
  value:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit =
  "gl_api_glUniformMatrix4x2"
external glUniformMatrix3x4: location:int -> ?transpose:bool ->
  value:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit =
  "gl_api_glUniformMatrix3x4"
external glUniformMatrix4x3: location:int -> ?transpose:bool ->
  value:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t -> unit =
  "gl_api_glUniformMatrix4x3"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glUniformBlockBinding.xml}
    manual pages on opengl.org}
*)
external glUniformBlockBinding: program:program -> index:int -> binding:int -> unit =
  "gl_api_glUniformBlockBinding"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glUseProgram.xml}
    manual pages on opengl.org}
*)
external glUseProgram: program -> unit = "gl_api_glUseProgram"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glValidateProgram.xml}
    manual pages on opengl.org}
*)
external glValidateProgram: program -> unit = "gl_api_glValidateProgram"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertexAttribDivisor.xml}
    manual pages on opengl.org}
*)
external glVertexAttribDivisor: index:int -> divisor:int -> unit =
  "gl_api_glVertexAttribDivisor"

module VertexArray = Enums.VertexArray

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertexAttribPointer.xml}
    manual pages on opengl.org}
*)
external glVertexAttribPointer: index:int -> size:int ->
  vert_type:VertexArray.vertattr_type -> normalize:bool ->
    stride:int -> unit = "gl_api_glVertexAttribPointer"

(* not implement yet

   glBeginConditionalRender
   glEndConditionalRender
   glBeginQuery
   glEndQuery
   glBeginTransformFeedback
   glEndTransformFeedback
   glBindBufferBase
   glBindBufferRange
   glClientWaitSync
   glDeleteQueries
   glDeleteSync
   glDrawArraysInstanced
   glDrawElementsBaseVertex
   glDrawElementsInstanced
   glDrawElementsInstancedBaseVertex
   glDrawRangeElementBaseVertex
   glFenceSync
   glFramebufferTexture
   glFramebufferTexture1D
   glFramebufferTexture2D
   glFramebufferTexture3D
   glGenQueries
   glGetBufferPointerv
   glGetProgram
   glGetQueryObject
   glGetQueryiv
   glGetSync
   glGetTransformFeedbackVarying
   glGetVertexAttribPointerv
   glIsQuery
   glIsSync
   glMultiDrawElementsBaseVertex
   glQueryCounter
   glWaitSync
   glVertexAttrib
   glMapBuffer
   glUnmapBuffer
*)
