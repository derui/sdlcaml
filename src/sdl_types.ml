module Monad = Core.Std.Monad
module Fn = Core.Std.Fn
open Ctypes

module Result = struct
  module Core = struct
    type 'a t = ('a, string) result

    let return v = Ok v
    let fail msg = Error msg
    let map = `Define_using_bind

    let bind m f =
      match m with
      | Ok v -> f v
      | Error msg -> fail msg

  end

  include Core
  include Monad.Make(Core)
end

(* Implementation for Continuation Monad. *)
module Cont = struct
  type ('a, 'b) t = {
    continuation : ('a -> 'b) -> 'b
  }

  let make continuation = {continuation}
  let run_cont cont f = cont.continuation f
  let call_cc f = make @@ fun c -> run_cont (f (fun x -> make (fun _ -> c x))) c
end

(* The monad for Sdlcaml's resource management.

   Using this monad want to manage some resource, contains another Resource monad,
   or [Cont.call_cc] with not Resource monad.
*)
module Resource = struct
  module Core = struct
    type ('a, 'b) t = ('a, 'b) Cont.t

    let bind m f = Cont.(make (fun c -> run_cont m (fun x -> run_cont (f x) c)))

    let map = `Define_using_bind
    let return v = Cont.make (fun c -> c v)
    let fail v = failwith v

    let make = Cont.make
    let call_cc = Cont.call_cc
  end

  let run cc continuation =
    try
      Ok (Cont.run_cont cc continuation)
    with Failure v -> Error v
    | _ -> Error (Sdl_error.get ())

  include Core
  include Monad.Make2(Core)

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

module Thread = SDL_TYPE(struct
  let name = "SDL_Thread"
end)

module GLContext = SDL_TYPE(struct
  let name = "SDL_GLContext"
end)
