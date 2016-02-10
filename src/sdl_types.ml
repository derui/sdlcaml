open Core.Std
open Ctypes 

module Result = struct
  module Core = struct
    type 'a t = Success of 'a | Failure of string

    let bind s f =
      match s with
      | Success v -> f v
      | Failure s -> Failure s

    let return v = Success v
    let map = `Define_using_bind

    let is_success = function
      | Success _ -> true
      | Failure _ -> false

    (* Trap failure and do anything, then continue monad. *)
    let tap ~f m =
      match m with
      | Success _ -> m
      | Failure s -> f s; m
  end

  include Core
  include Monad.Make(Core)
end

type button_state = Pressed | Released

module type TYPE = sig
  val name: string
end

module SDL_TYPE(T:TYPE) = struct
  type _t
  let _t: _t structure typ = structure T.name
  type t = _t structure ptr
  let t = ptr _t
end

(* A type of SDL_Window *)
module Window = SDL_TYPE(struct
  let name = "SDL_Window"
end)

(* A type for SDL_Surface. Only providing Surface module are accessors for ctype structure,
   not included conversion function and type of ocaml.
*)
module Surface = struct
  type surface
  let struct_surface : surface structure typ = structure "SDL_Surface"

  let _ = field struct_surface "flags" uint32_t
  let format = field struct_surface "format" (ptr Sdlcaml_structures.Pixel_format.t)
  let w = field struct_surface "w" int
  let h = field struct_surface "h" int
  let pitch = field struct_surface "pitch" int
  let pixels = field struct_surface "pixels" (ptr void)
  let userdata = field struct_surface "userdata" (ptr void)
  let _ = field struct_surface "locked" int
  let _ = field struct_surface "lock_data" (ptr void)
  let clip_rect = field struct_surface "clip_rect" Sdlcaml_structures.Rect.t
  let _ = field struct_surface "map" (ptr void)
  let refcount = field struct_surface "refcount" int
  let () = seal struct_surface
  let surface = view struct_surface ~read:Fn.id ~write:Fn.id
    ~format_typ:(fun k fmt -> Format.pp_print_string fmt "SDL_Surface"; k fmt)

  type t = surface structure ptr
  let t = ptr surface
end

(* A type for SDL_Renderer *)
module Renderer = SDL_TYPE(struct
  let name = "SDL_Renderer"
end)

(* A type for SDL_Texture *)
module Texture = SDL_TYPE(struct
  let name = "SDL_Texture"
end)

(* A type for SDL_Joystick *)
module Joystick = SDL_TYPE(struct
  let name = "SDL_Joystick"
end)

(* A type for SDL_Cursor *)
module Cursor = SDL_TYPE(struct
  let name = "SDL_Cursor"
end)

module GameController = SDL_TYPE(struct
  let name = "SDL_GameController"
end)
