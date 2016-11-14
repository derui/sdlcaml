(**
   Define module to provide joystick API wrapper and helpers.

   @author derui
   @since 0.2
*)

type t = Sdl_types.Joystick.t
(** The type of Joystick instance *)

type id = int32

type state = Ignore | Enable

type axis = Axis1 | Axis2 | Axis3 | Axis4 | AxisX of int
(** An axis of the joystick. If the joystick has axis greater than 4, use AxisX constructor. *)

type button = Button of int
(** The button of a Joystick *)

val open_device: int -> (t, 'a) Sdl_types.Resource.t
(** open a joystick for use *)

val is_ignored : unit -> bool Sdl_types.Result.t
(** Get current state whether is ignore or not *)

val is_enabled : unit -> bool Sdl_types.Result.t
(** Get current state whether is enable or not *)

val get_current_state: unit -> state Sdl_types.Result.t
(** Get current state for the specified joystick *)

val is_attached: t -> bool Sdl_types.Result.t
(** Get the status of a specified joystick *)

val get_axis : joystick:t -> axis:axis -> int Sdl_types.Result.t
(** Get the current state of an axis control on a joystick *)

val get_ball: joystick:t -> ball:int -> Sdlcaml_structures.Point.t Sdl_types.Result.t
  (** Get the ball axis change since the last poll *)

val get_button: joystick:t -> button:button -> Sdl_types.button_state
(** Get the current state of a button on a joystick *)

val get_guid: t -> Sdlcaml_structures.Joystick_guid.t Sdl_types.Result.t
(** Get the GUID for the joystick *)

val get_guid_string: Sdlcaml_structures.Joystick_guid.t -> string
(** Get the ASCII string of the specified GUID *)

val get_hat: joystick:t -> hat:int -> Sdlcaml_flags.Sdl_hat.t Sdl_types.Result.t
(** Get the ball axis change since the last poll *)

val get_instance_id: t -> id Sdl_types.Result.t
(** Get the device index of an opened joystick *)

val name: t -> string
(** Get the name of a joystick *)

val num_axes: t -> int Sdl_types.Result.t
(** Get the number of general axis onctrols on a joystick *)

val num_balls: t -> int Sdl_types.Result.t
(** Get the number of general trackball on a joystick *)

val num_buttons: t -> int Sdl_types.Result.t
(** Get the number of buttons on a joystick *)

val num_hats: t -> int Sdl_types.Result.t
(** Get the number of POV hats on a joystick *)

val update : unit -> unit
(** Update the current state of the open joysticks *)

val num_joysticks: unit -> int Sdl_types.Result.t
(** Count the number of joysticks attached to the system *)

  (** Not implement yet functions below.

      SDL_JoystickGetDeviceGUID
      SDL_JoystickNameForIndex
  *)
