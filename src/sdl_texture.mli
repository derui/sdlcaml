(**
  Define texture module to provide some operations for SDL_Texture

  @author derui
  @since 0.2
*)
open Ctypes

type t = Sdl_types.Texture.t

exception Sdl_texture_exception of string

val create: renderer:Sdl_types.Renderer.t ->
  format:Sdlcaml_flags.Sdl_pixel_format_enum.t -> access:Sdlcaml_flags.Sdl_texture_access.t ->
  width:int -> height:int -> Sdl_types.Texture.t Sdl_types.Result.t
(** Create texture with given parameters.

    Warning: The texture returned this function *must* destroy by user manually.
    If the texture is temporary, you should use [with_create] instead.
*)

val with_create: renderer:Sdl_types.Renderer.t ->
  format:Sdlcaml_flags.Sdl_pixel_format_enum.t -> access:Sdlcaml_flags.Sdl_texture_access.t ->
  width:int -> height:int -> (Sdl_types.Texture.t, 'b) Sdl_types.Resource.t
(** Create texture with given parameters, and return continuation.

    Warning: The texture passed to continuation from this function *must not* destroy by user manually.
*)

val create_from_surface: renderer:Sdl_types.Renderer.t -> surface:Sdl_types.Surface.t ->
  Sdl_types.Texture.t Sdl_types.Result.t
(** Create texture from specified surface and renderer.

    Warning: The texture returned this function *must* destroy by user manually.
    If the texture is temporary, you should use [with_create_from_surface] instead.
*)

val with_create_from_surface: renderer:Sdl_types.Renderer.t -> surface:Sdl_types.Surface.t ->
  (Sdl_types.Texture.t, 'b) Sdl_types.Resource.t
(** Create texture from specified surface and renderer.

    Warning: The texture passed to continuation from this function *must not* destroy by user manually.
*)

val destroy : t -> unit
(** Destroy a texture *)

val bind_gl: t -> (float * float) Sdl_types.Result.t
(** bind an OpenGL texture to the current context for use with when rendering OpenGL pritimives directly  *)

val unbind_gl: t -> unit Sdl_types.Result.t
(** unbind an OpenGL texture to the current context *)

val get_alpha_mod : t -> int Sdl_types.Result.t
(** Get the additional alpha value *)

val get_blend_mode : t -> Sdlcaml_flags.Sdl_blendmode.t Sdl_types.Result.t
(** Get the blend mode of a texture *)

val get_color_mod : t -> Sdlcaml_structures.Color.t Sdl_types.Result.t
(** Get the additional color value, but alpha value returned is always 255 *)

val set_alpha_mod : texture:t -> alpha:int -> unit Sdl_types.Result.t
(** Set the additional alpha value *)

val set_blend_mode : texture:t -> blendmode:Sdlcaml_flags.Sdl_blendmode.t -> unit Sdl_types.Result.t
(** Set the blend mode of a texture *)

val set_color_mod : texture:t -> color:Sdlcaml_structures.Color.t -> unit Sdl_types.Result.t
(** Set the additional color value, but alpha value is always ignored.
    If you want to set alpha value to use [set_alpha_mod].
*)

val query_format : t -> Sdlcaml_flags.Sdl_pixel_format_enum.t Sdl_types.Result.t
(** Query format of the texture *)

val query_access : t -> Sdlcaml_flags.Sdl_texture_access.t Sdl_types.Result.t
(** Query access for the texture *)

val query_size : t -> Sdlcaml_structures.Size.t Sdl_types.Result.t
(** Get the size of the texture *)

  (** Not implement yet functions below.

      SDL_LockTexture
      SDL_UnlockTexture
      SDL_UpdateTexture
      SDL_UpdateYUVTexture
  *)
