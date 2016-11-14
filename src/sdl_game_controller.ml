open Core.Std
open Ctypes
open Foreign
open Sdlcaml_structures
open Sdlcaml_flags

type t = Sdl_types.GameController.t
let t = Sdl_types.GameController.t

type mapping = [`Button of int | `Hat of (int * Sdl_hat.t)| `Axis of int]

module Inner = struct
  let free = foreign "SDL_free" (ptr void @-> returning void)

  let game_controller_add_mapping = foreign "SDL_GameControllerAddMapping" (
    string @-> returning int)
  let game_controller_close = foreign "SDL_GameControllerClose" (
    t @-> returning void)
  let game_controller_event_state = foreign "SDL_GameControllerEventState" (
    int @-> returning int)
  let game_controller_from_instance_id = foreign "SDL_GameControllerFromInstanceID" (
    uint32_t @-> returning t)
  let game_controller_get_attached = foreign "SDL_GameControllerGetAttached" (
    t @-> returning int)
  let game_controller_get_axis = foreign "SDL_GameControllerGetAxis" (
    t @-> int @-> returning int16_t)
  let game_controller_get_bind_for_axis = foreign "SDL_GameControllerGetBindForAxis" (
    t @-> int @-> returning Controller_button_bind.t)
  let game_controller_get_bind_for_button = foreign "SDL_GameControllerGetBindForButton" (
    t @-> int @-> returning Controller_button_bind.t)
  let game_controller_get_button = foreign "SDL_GameControllerGetButton" (
    t @-> int @-> returning uint8_t)
  let game_controller_mapping = foreign "SDL_GameControllerMapping" (
    t @-> returning (ptr char))
  let game_controller_name = foreign "SDL_GameControllerName" (
    t @-> returning string_opt)
  let game_controller_name_for_index = foreign "SDL_GameControllerNameForIndex" (
    int @-> returning string_opt)
  let game_controller_open = foreign "SDL_GameControllerOpen" (
    int @-> returning t)
  let game_controller_update = foreign "SDL_GameControllerUpdate" (void @-> returning void)
  let is_game_controller = foreign "SDL_IsGameController" (int @-> returning int)
end

let string_of_mapping = function
  | `Button b -> Printf.sprintf "b%d" b
  | `Axis ind -> Printf.sprintf "a%d" ind
  | `Hat (ind, v) -> Printf.sprintf "h%d.%d" ind (Sdl_hat.to_int v)

let add_mapping ~guid ~name ~mappings =
  let mappings = List.map mappings ~f:string_of_mapping |> String.concat ~sep:"," in
  let guid = Sdl_joystick.get_guid_string guid in
  let mapping = Printf.sprintf "%s,%s,%s" guid name mappings in
  let ret = Inner.game_controller_add_mapping mapping in

  Sdl_util.catch (fun () -> ret <> -1) (fun () ->
    match ret with
    | 0 -> `Added
    | 1 -> `Updated
    | _ -> failwith "Unknown operation"
  )

let close_controller = Inner.game_controller_close

let open_controller ind =
  let module R = Sdl_types.Resource in 
  let ret = Inner.game_controller_open ind in
  R.make (fun c -> protectx ~finally:close_controller ~f:c ret)

let from_instance_id id =
  let module R = Sdl_types.Resource in 
  let ret = Inner.game_controller_from_instance_id Unsigned.UInt32.(of_int32 id) in
  R.make (fun c -> protectx ~finally:close_controller ~f:c ret)

let of_name controller =
  let ret = Inner.game_controller_name controller in
  Sdl_util.catch (fun () -> Option.is_some ret) (fun () -> Option.value ret ~default:"")

let of_name_for_index ind =
  let ret = Inner.game_controller_name_for_index ind in
  Sdl_util.catch (fun () -> Option.is_some ret) (fun () -> Option.value ret ~default:"")

let is_attached con =
  let ret = Inner.game_controller_get_attached con in
  Sdl_helper.int_to_bool ret

let get_axis con ~axis =
  let axis = Sdl_controller_axis.to_int axis in
  Inner.game_controller_get_axis con axis

let get_bind_for_axis con ~axis =
  let axis = Sdl_controller_axis.to_int axis in
  let bind = Inner.game_controller_get_bind_for_axis con axis in
  Controller_button_bind.to_ocaml bind

let get_bind_for_button con ~button =
  let button = Sdl_game_controller_button.to_int button in
  let bind = Inner.game_controller_get_bind_for_button con button in
  Controller_button_bind.to_ocaml bind

let is_pressed con ~button =
  let button = Sdl_game_controller_button.to_int button in
  let ret = Inner.game_controller_get_button con button in
  Unsigned.UInt8.(to_int ret) |> Sdl_helper.int_to_bool

let with_mapping con ~f =
  let str = Inner.game_controller_mapping con in
  let str' = coerce (ptr char) string str in
  protect ~f:(fun () -> f str' ) ~finally:(fun () -> Inner.free (to_voidp str))

let update = Inner.game_controller_update

let ignore_events () = Inner.game_controller_event_state 0 |> ignore
let enable_events () = Inner.game_controller_event_state 1 |> ignore
let event_state () = Inner.game_controller_event_state (-1) |> Sdl_helper.int_to_bool

let is_game_controller ind =
  Inner.is_game_controller ind |> Sdl_helper.int_to_bool
