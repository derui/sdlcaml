(**
   this module provide lowlevel SDL bindings for SDL Renderer.

   @author derui
   @since 0.2
*)

(** A type of Renderer *)
type t

(**
   Create the renderer for the window given.

   @param window the window to attach renderer was created.
   @param index the index of renderer to create
   @param flags the list of flags for renderer.
   @return the renderer created with parameters.
*)
external create : Sdl_window.t -> int -> Sdl_renderer_flags.t list -> t =
  "sdl_wm_create_renderer"

(**
   Destroy the renderer.
*)
external destroy : t -> unit = "sdl_wm_destroy_renderer"
