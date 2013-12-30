open Core.Std
open Ctypes
open Foreign
open Sdlcaml_flags
open Sdlcaml_structures

module A = CArray

type t = Sdl_types.Joystick.t
let t = Sdl_types.Joystick.t

(** The type of Joystick instance *)
type id = int32

type state = Ignore | Enable

type axis = Axis1 | Axis2 | Axis3 | Axis4 | AxisX of int
(** An axis of the joystick. If the joystick has axis greater than 4, use AxisX constructor. *)

type button = Button of int
(** The button of a Joystick *)

module Inner = struct
  let joystick_close = foreign "SDL_JoystickClose" (t @-> returning void)
  let joystick_event_state = foreign "SDL_JoystickEventState" (int @-> returning int)
  let joystick_get_attached = foreign "SDL_JoystickGetAttached" (t @-> returning int)
  let joystick_get_axis = foreign "SDL_JoystickGetAxis" (t @-> int @-> returning int16_t)
  let joystick_get_ball = foreign "SDL_JoystickGetBall" (t @-> int @-> ptr int @-> ptr int @-> returning int)
  let joystick_get_button = foreign "SDL_JoystickGetButton" (t @-> int @-> returning uint8_t)
  let joystick_get_guid = foreign "SDL_JoystickGetGUID" (t @-> returning Joystick_guid.t)
  let joystick_get_guid_string = foreign "SDL_JoystickGetGUIDString"
      (Joystick_guid.t @-> ptr char @-> int @-> returning void)
  let joystick_get_hat = foreign "SDL_JoystickGetHat" (t @-> int @-> returning uint8_t)
  let joystick_instance_id = foreign "SDL_JoystickInstanceID" (t @-> returning uint32_t)
  let joystick_name = foreign "SDL_JoystickName" (t @-> returning string)
  let joystick_num_axes = foreign "SDL_JoystickNumAxes" (t @-> returning int)
  let joystick_num_balls = foreign "SDL_JoystickNumBalls" (t @-> returning int)
  let joystick_num_buttons = foreign "SDL_JoystickNumButtons" (t @-> returning int)
  let joystick_num_hats = foreign "SDL_JoystickNumHats" (t @-> returning int)
  let joystick_open = foreign "SDL_JoystickOpen" (void @-> returning t)
  let joystick_update = foreign "SDL_JoystickUpdate" (void @-> returning void)
  let num_joysticks = foreign "SDL_NumJoysticks" (void @-> returning int)
end

let close js = Inner.joystick_close js

let is_ignored () =
  let ret = Inner.joystick_event_state 0 in
  Sdl_util.catch (fun () -> ret = 0) (fun () -> Sdl_helper.int_to_bool ret)

let is_enabled () = 
  let ret = Inner.joystick_event_state 1 in
  Sdl_util.catch (fun () -> ret = 0) (fun () -> Sdl_helper.int_to_bool ret)

let get_current_state () =
  let ret = Inner.joystick_event_state 1 in
  Sdl_util.catch (fun () -> ret = 0) (fun () -> match ret with
      | 0 -> Ignore
      | 1 -> Enable
      | _ -> failwith "Unknown joystick status"
    )

let is_attached js =
  let ret = Inner.joystick_get_attached js in
  Sdl_util.catch (Fn.const true) (fun () -> Sdl_helper.int_to_bool ret)

let axis_to_num = function
  | Axis1 -> 0
  | Axis2 -> 1
  | Axis3 -> 2
  | Axis4 -> 3
  | AxisX(num) -> num

let get_axis ~joystick ~axis =
  let axis = axis_to_num axis in
  let ret = Inner.joystick_get_axis joystick axis in
  Sdl_util.catch (fun () -> ret <> 0) (fun () -> ret)

let get_ball ~joystick ~ball =
  let dx = A.make int 1
  and dy = A.make int 1 in
  let ret = Inner.joystick_get_ball joystick ball (A.start dx) (A.start dy) in
  Sdl_helper.ret_to_result ret (fun () ->
      {Point.x = A.get dx 0;y = A.get dy 0}
    )

let button_to_int = function
  | Button (index) -> index

let get_button ~joystick ~button =
  let ret = Inner.joystick_get_button joystick (button_to_int button) in
  match Unsigned.UInt8.to_int ret with
  | 1 -> Sdl_types.Pressed
  | _ -> Sdl_types.Released

let get_guid js =
  let guid = Inner.joystick_get_guid js in
  let guid = Joystick_guid.to_ocaml guid in
  let data = guid.Joystick_guid.data in
  let exist_not_zero = Array.exists data ~f:(fun e -> e <> 0) in
  Sdl_util.catch (fun () -> exist_not_zero) (fun () -> guid)

let get_guid_string guid =
  let guid = Joystick_guid.of_ocaml guid in
  let str = A.make char 256 in
  Inner.joystick_get_guid_string guid (A.start str) (A.length str);
  string_from_ptr (A.start str) (A.length str)

let get_hat ~joystick ~hat =
  let hat = Inner.joystick_get_hat joystick hat in
  Sdl_types.Result.return (Unsigned.UInt8.to_int hat |> Sdl_hat.of_int)

let get_instance_id joystick =
  let id = Inner.joystick_instance_id joystick in
  let id = Unsigned.UInt32.to_int32 id in
  Sdl_util.catch (fun () -> id >= 0l) (fun () -> id)

let name joystick =
  let name = Inner.joystick_name joystick in
  name

let get_num_with_fun f joystick =
  let num = f joystick in
  Sdl_util.catch (fun () -> num >= 0) (fun () -> num)

let num_axes = get_num_with_fun Inner.joystick_num_axes
let num_balls = get_num_with_fun Inner.joystick_num_balls
let num_buttons = get_num_with_fun Inner.joystick_num_buttons
let num_hats = get_num_with_fun Inner.joystick_num_hats

let open_device index =
  let joystick = Inner.joystick_open () in
  Sdl_util.catch (fun () -> to_voidp joystick <> null) (fun () -> joystick)

let update = Inner.joystick_update

let num_joysticks () =
  let num = Inner.num_joysticks () in
  Sdl_util.catch (fun () -> num >= 0) (fun () -> num)
