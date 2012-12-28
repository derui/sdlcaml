(**
 * Providing SDL Video bindings. But this module providings are low level and
 * used by other high-level API.
 * these functions not always use from user.
 * {b sdlcaml}'s function interfaces are based on {i labeld interface}.
 *
 * If you want to use OpenGL/SDL, use along {!Sdl_gl} module, however
 * that module need to be generated by ocamlidl...
 *
 * @author derui
 * @since 0.1
 *)

(** array of image pixels on the surface  *)
type image_type = (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Genarray.t

(**
 * Binding of {b SDL_Surface}'s flags.
 *)
type videomodes =
  SDL_SWSURFACE    (** Surface is stored in system memory *)
| SDL_HWSURFACE    (** Surface is stored in video memory *)
| SDL_ASYNCBLIT    (** Surface uses asynchronous blits if possible *)
| SDL_ANYFORMAT    (** Allows any pixel-format (Display surface) *)
| SDL_HWPALETTE    (** Surface has exclusive palette *)
| SDL_DOUBLEBUF    (** Surface is double buffered (Display surface) *)
| SDL_FULLSCREEN   (** Surface is full screen (Display Surface) *)
| SDL_OPENGL       (** Surface has an OpenGL context (Display Surface) *)
| SDL_OPENGLBLIT   (** Surface supports OpenGL blitting (Display Surface) *)
| SDL_RESIZABLE    (** Surface is resizable (Display Surface) *)
| SDL_HWACCEL      (** Surface blit uses hardware acceleration *)
| SDL_SRCCOLORKEY  (** Surface use colorkey blitting *)
| SDL_RLEACCEL     (** Colorkey blitting is accelerated with RLE *)
| SDL_SRCALPHA     (** Surface blit uses alpha blending *)
| SDL_PREALLOC     (** Surface uses preallocated memory *)

(** binding of {b SDL_GLattr}  *)
type gl_attr =
| GL_RED_SIZE         (** Size of the framebuffer red component, in bits *)
| GL_GREEN_SIZE       (** Size of the framebuffer green component, in bits *)
| GL_BLUE_SIZE        (** Size of the framebuffer blue component, in bits *)
| GL_ALPHA_SIZE       (** Size of the framebuffer alpha component, in bits *)
| GL_DOUBLEBUFFER     (** 0 or 1, enable or disable double buffering *)
| GL_BUFFER_SIZE      (** Size of the framebuffer, in bits *)
| GL_DEPTH_SIZE       (** Size of the depth buffer, in bits *)
| GL_STENCIL_SIZE     (** Size of the stencil buffer, in bits *)
| GL_ACCUM_RED_SIZE   (** Size of the accumulation buffer red component, in bits *)
| GL_ACCUM_GREEN_SIZE (** Size of the accumulation buffer green component, in bits *)
| GL_ACCUM_BLUE_SIZE  (** Size of the accumulation buffer blue component, in bits *)
| GL_ACCUM_ALPHA_SIZE (** Size of the accumulation buffer alpha component, in bits *)

exception Sdl_video_exception of string

(**
 * Binding of {i SDL_Surface} but always hiding inner structure of
 * SDL_Surface.
 * this struct is used by some methods such as image, window screen, etc.
 * if some useful infomations of SDL_Surface, you can use following functions.
 * i.e. {!sdl_get_color_masks}, {!sdl_get_alpha}, and more!
 *)
type surface

(**
 * Mapping from SDL_PixelFormat, but doesn't include palette infomation
 * from original.
 * this has only readable properties such as color depth, color mask, and so on.
 *)
type pixelformat = {
  bits_per_pixel:int;
  bytes_per_pixel:int;
  rloss:int; gloss:int; bloss:int; aloss:int;
  rshift:int; gshift:int; bshift:int; ashift:int;
  rmask:int; gmask:int; bmask:int; amask:int;
  color_key : int;
  alpha:int
}

(**
 * type of color which is included each color elements and
 * combined with of those.
 * this type has appliable functions such a conversion
 * colors, or split color to elements.
 *)
type color = {
  red:int;                              (* red attribute *)
  green:int;                            (* green attribute *)
  blue:int;                             (* blue attribute *)
  alpha:int;                            (* transparency *)
}

(**
 * type of binding to {b SDL_Rect}. Each fields of this type has
 * equivalent name of SDL_Rect's member.

 *)
type rect = {
  x:int;                                (* left of left top corner *)
  y:int;                                (* top of left top corner *)
  w:int;                                (* rectangle width *)
  h:int;                                (* rectangle height *)
}

(**
 * Binding of {i SDL_SetVideoMode}. if this function failed, raise
 * {!Sdl_exception} with error message.
 * Returning value that is surface has to apply {!sdl_free_surface} when
 * it end using.(In any case, surface is only one created, so often call
 * {!sdl_free_surface} only once.
 *
 * @param width width of window that is opened by SDL
 * @param height height of window that is opened by SDL
 * @param depth color depth such as 8, 16, 24 and 32 that are {b bpp}
 * @param flags list of {!videomodes}
 * @return created surface by SDL with parameters
 * @raise Sdl_exception if SDL_SetVideoMode failed
 *)
external set_video_mode:
  width:int -> height:int -> depth:int ->
    flags:videomodes list -> surface = "sdlcaml_set_video_mode"

(**
 * Binding of {i SDL_FreeSurface}.
 *
 * @param surface target to apply SDL_FreeSurface
 *)
external free_surface: surface -> unit = "sdlcaml_free_surface"

(**
 * Returning PixelFormat struct in given surface.
 * surface that to be able to give this function is always valid.
 * (Therefore, when sdl_set_video_mode failed, exception is raised by it)
 *
 * @param surface surface returning from {!sdl_set_video_mode} or other
 * functions
 * @return valid pixelformat in a given surface
 *)
external get_pixelformat: surface -> pixelformat =
 "sdlcaml_get_pixelformat"

(** result of {!sdl_blit_surface} function. *)
type blit_result =
  BLIT_SUCCESS
| BLIT_FAILURE
| BLIT_LOST

(**
 * bliting clipped src surface with src rect to clippied dist surface
 * by dist rect.
 * When this function return BLIT_LOST, these should be reloaded with
 * artwork or be redrew by some operation, and re-blitted.
 *
 * {!srect} and {!drect} are optional arguments. if these are not
 * received some rectangle, there are used to {b NULL}.
 *
 * @param src source surface
 * @param dist distination surface
 * @param srect size of the copied rectangle
 * @param drect position of the copied rectangle's upper left corner
 * @return result of SDL_BlitSurface operation.
 *)
external blit_surface: src:surface -> dist:surface
  -> ?srect:rect -> ?drect:rect -> unit -> blit_result = "sdlcaml_blit_surface"

(**
 * Fill of the given rectangle with some color.
 * this function will fill the whole surface if you doesn't give {b
 * drect}.
 *
 * @param dist distination surface
 * @param fill filling color that should be a pixel of the format used
 *             by the distination surface
 * @param drect filling space of rectanble
 *)
external fill_rect: dist:surface -> fill:color -> ?drect:rect ->
  unit -> unit = "sdlcaml_fill_rect"

(**
 * Return new surface created that of size is given width and height
 * and with initialization flags.
 * Depth of returning surface from this function is always 32-bits,
 * I mean, always create surface that have ARGB format.
 * If you create surface by this function, you have to apply
 * {!sdl_free_surface} to it.
 *
 * @param width number of width pixels in surface
 * @param height number of height pixels in surface
 * @param flags initialization flag list
 * @return created new surface
 *)
external create_surface: width:int -> height:int ->
  flags:videomodes list -> surface = "sdlcaml_create_surface"

(**
 * update rectangle area on surface. It is nessesity from arguments that
 * is only {b screen}.
 * If all arguments omitted, update all area of given surface.
 * Any optional arguments given, use it but other arguments used by
 * default.
 *
 * @param x rectangle's left upper corner of left. default is 0.
 * @param y rectangle's left upper corner of upper. defautl is 0.
 * @param w width of rectangle. default is width of screen.
 * @param h height of rectangle. default is height of screen.
 * @param screen surface to update
 *)
external update_rect: ?x:int -> ?y:int ->
  ?width:int -> ?height:int -> surface -> unit = "sdlcaml_update_rect"

(**
 * Swap screen buffers. The {!SDL_DOUBLEBUF} flags must have been
 * passed to {!sdl_set_video_mode}.
 * This function perform hardware flipping if hardware support
 * double-buffering.
 * On hardware that doesn't support double-buffering, this is
 * equivalent to calling {!sdl_update_rect} with default.
 *
 * @param surface surface that is screen
 * @raise Sdl_video_function When function fail
 *)
external flip: surface -> unit = "sdlcaml_flip"

(**
   Clear given surface. Argument of {!fill} is color that fill out the
   surface.
   If doesn't given {!fill}, clearing surface color is {b black}.

   @param fill color for filling up, default is black
   @param surface target surface
*)
external clear: ?fill:color -> surface -> unit = "sdlcaml_clear"

(**
   Set a special SDL/OpenGL attributes

   See details {b SDL_GL_SetAttribute}

   @param attr target variant in {!gl_attr}
   @param value A special value
   @return true if successful
*)
external set_attribute : attr:gl_attr -> value:int -> bool = "sdlcaml_video_gl_set_attribute"

(**
   Get the value of special SDL/OpenGL attribute

   See details {b SDL_GL_GetAttribute}

   @param attr target variant in {!gl_attr}
   @return value of given attribute
*)
external get_attribute : gl_attr -> int = "sdlcaml_video_gl_get_attribute"

(**
   Swap OpenGL framebuffer/update Display, if double-buffering is supported.
*)
external gl_swap : unit -> unit = "sdlcaml_video_gl_swap_buffer"

(** Get the array of image pixels on the surface.
    If you apply {!free_surface} to this surface, must not
    use returned array!

    @param surface the surface to get image pixels
    @return the array of image pixels
*)
external get_pixels: surface -> image_type = "sdlcaml_video_get_pixels"

(** Get the width and height of the loaded surface.

    @param surface the loaded surface to get width and height
    @return width * height of the loaded surface
*)
external get_size: surface -> int * int = "sdlcaml_video_get_size"

(** Initialize OpenGL attributes to use with SDL.
    You must call this function before call {!set_video_mode} if want to use OpenGL with SDL.

    @param red size of red value as byte
    @param blue size of blue value as byte
    @param green size of green value as byte
    @param depth size of depth buffer
    @param doublebuffer give true if want to enable GL_DOUBLEBUFFER. Default is true.
    @param unit dummy argument
*)
let gl_init ~red ~blue ~green ~depth ?(doublebuffer=true) () =
  ignore (set_attribute ~attr:GL_RED_SIZE ~value:red);
  ignore (set_attribute ~attr:GL_BLUE_SIZE ~value:blue);
  ignore (set_attribute ~attr:GL_GREEN_SIZE ~value:green);
  ignore (set_attribute ~attr:GL_DEPTH_SIZE ~value:depth);

  if doublebuffer then
    ignore (set_attribute ~attr:GL_DOUBLEBUFFER ~value:1)
  else
    ignore (set_attribute ~attr:GL_DOUBLEBUFFER ~value:0)
