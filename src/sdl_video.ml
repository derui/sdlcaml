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
 * type of color that is synonym of {!int}.
 * this type is included some color for instance, Red, Green,
 * Blue, Alpha  or pixel color such as RGBA.
 *)
type color = int

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
external sdl_set_video_mode:
  width:int -> height:int -> depth:int ->
    flags:videomodes list -> surface = "sdlcaml_set_video_mode"

(**
 * Binding of {i SDL_FreeSurface}.
 *
 * @param surface target to apply SDL_FreeSurface
 *)
external sdl_free_surface: surface -> unit = "sdlcaml_free_surface"

(**
 * Returning PixelFormat struct in given surface.
 * surface that to be able to give this function is always valid.
 * (Therefore, when sdl_set_video_mode failed, exception is raised by it)
 *
 * @param surface surface returning from {!sdl_set_video_mode} or other
 * functions
 * @return valid pixelformat in a given surface
 *)
external sdl_get_pixelformat: surface -> pixelformat = "sdlcaml_get_pixelformat"
