open Ctypes

type value =
    Button of int
  | Axis of int
  | Hat of Sdlcaml_flags.Sdl_hat.t * int

type t = {
  bind_type: Sdlcaml_flags.Sdl_controller_bind_type.t;
  value: value option;
}

let t : t structure typ = structure "SDL_GameWControllerButtonBind"

let bind_type = field t "bindType" int
let button = field t "button" int
let axis = field t "axis" int

let to_ocaml s =
  let open Sdlcaml_flags in
  let module B = Sdl_controller_bind_type in 
  let bind_type = getf s bind_type |> B.of_int in
  match bind_type with
  | B.SDL_CONTROLLER_BINDTYPE_NONE -> {bind_type; value = None}
  | B.SDL_CONTROLLER_BINDTYPE_BUTTON -> {bind_type; value = Some(Button (getf s button))}
  | B.SDL_CONTROLLER_BINDTYPE_AXIS -> {bind_type; value = Some(Button (getf s axis))}
  | B.SDL_CONTROLLER_BINDTYPE_HAT ->
     let hat = getf s button
     and hat_mask = getf s axis in
     {bind_type; value = Some(Hat (Sdl_hat.of_int hat, hat_mask))}
