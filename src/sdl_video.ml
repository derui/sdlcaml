(**
 * Providing SDL Video bindings. But this module providings are low level and
 * used by other high-level API.
 * these functions not always use from user.
 * {b sdlcaml}'s function interfaces are based on {i labeld interface}.
 *
 * Bindfing at SDL API's rule, SDL_* bind to sdl_* and translate caml case to
 * underscore case.
 *
 * @author derui
 * @since 0.1
 *)

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
  blue:int;                             (* blue attribute *)
  green:int;                            (* green attribute *)
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
  unit ->
  unit = "sdlcaml_fill_rect"

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
