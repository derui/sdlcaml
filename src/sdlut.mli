(** SDL Utility Kit with Sdlcaml.
    These modules are providing functional and labeled interface for
    using Sdlcaml, for instance, event loop management,
    drawing management, fps management and integrated input management and so on.
    But this do not provide some interface for SDL Subsystems because
    they already has directly binding to SDL, I think SDL interfaces
    are sufficient to use basically and generally.

    Note: functions provided by this module only are used to operate
    for SDL, not OpenGL.

    @author derui
    @since 0.1
*)

(** event callback managements.

    Event callback managements provided this module is not
    event-driven loop.
    Occurred events by SDL subsystem dispatch each functions in game loop at one time,
    and event loop is not loop in other thread.

    This module can't register function to Quit event, so
    if occur Quit event, end game loop and exit {!game_loop} function.
    To need finalization, you add some code to after {!game_loop}.

    Event callback and game loop are integrated into single thread.

    Example)

    Sdl.Init.init [`VIDEO];
    Sdl.Video.set_video_mode ~width:640 ~height:800 ~depth:32 ~flags:[Sdl.Video.SDL_SWSURFACE];

    (* add display callback *)
    Sdlut.display_callback (fun () -> something);

    (* enter game loop with default fps and frame skipping setting. *)
    Sdlut.game_loop ();
*)

(** type of usable callback functions *)
type callback_type =
  | Active
  | Keyboard
  | Mouse
  | Motion
  | Joystick
  | Resize
  | Expose
  | Display
  | Move

(** Use mapping axis of joystick and some key of keyboard.
    Integrated axis and key perform as follows.
    - key pressed when current axis state is greater equal than {!capacity}
    - key released when current axis state is lesser than {!capacity}
    - axis state is full when key pressed
    - axis state is zero when key released

    When joystick axis and keyboard key operate simultaneously,
    choice more big value between them.
*)
type axis_mapping = {
  axis:Sdl_joystick.axis;
  (** target axis of joystick *)

  capacity:int;
  (** key pressed when axis state is greater than this value. *)

  key:Sdl_key.key_synonym
  (** mapping key as axis input of keyboard *)
}

(** type synonym for joystick button  *)
type button = int

(** Information to mapping keyboard key to joystick button.
    Mapped key and button propagates when pressed either.
*)
type key_mapping = Sdl_key.key_synonym * button

(** Container for input mapping infomations.
    User don't need nessesary to know details of this struct,
    this is only used to system.
*)
type input_info

(** To use current key or button status.
*)
type input_state = [
| `Key of Sdl_key.key_synonym
| `Button of button
| `Axis of Sdl_joystick.axis
]

(** Unregister callback function from given event and
    get back default function for given event.
    If any funciton haven't registered for given event,
    do nothing.

    @param callback To unregister callback function list
*)
val unregister_callback: callback:callback_type list -> unit

(** Register function for Active event.
    Nearly to register by {!register_callback_general} equal
    to register by this function.

    Note: callback functions each {!Sdl_event.event} are set
    default function to do nothing.

    @param func callback function for {!Sdl_event.Active}
*)
val active_callback: func:(state:Sdl_event.app_state list -> gain:bool -> unit) -> unit

(** Register function for KeyDown and KeyUp event.
    Details equal {!active_callback}.

    @param func callback function for {!Sdl_event.KeyDown} and {!Sdl_event.KeyUp}
*)
val keyboard_callback: func:(key:Sdl_key.key_info -> state:bool -> unit) -> unit

(** Register function for Mouse button event.
    Details equal {!active_callback}.

    @param func callback function for {!Sdl_event.ButtonDown} and {!Sdl_event.ButtonUp}
*)
val mouse_callback:
  func:(button:Sdl_mouse.button -> x:int -> y:int -> state:bool -> unit) -> unit

(** Register function for Mouse motion event.
    Details equal {!active_callback}.

    @param func callback function for {!Sdl_event.Motion}
*)
val motion_callback:
  func:(x:int -> y:int -> xrel:int -> yrel:int -> unit) -> unit

(** Register function for Joystick polling event.
    Details equal {!active_callback}.

    Joystick polling occur each when time given {!interval} comes, but
    minimum interval time is greater than time of each game loop.
    If fps set 60, joystick callback function calling interval is at least
    16.67 milliseconds.

    @param func callback function for joystick polling.
*)
val joystick_callback:
  func:(num:int -> x:int -> y:int -> z:int -> masks:Sdl_joystick.button list -> unit) -> unit

(** Register function for Resize event.
    Details equal {!active_callback}.

    @param func callback function for {!Sdl_event.Resize}
*)
val resize_callback: func:(width:int -> height:int -> unit) -> unit

(** Register function for Expose event.
    Details equal {!active_callback}.

    @param func callback function for {!Sdl_event.Expose}
*)
val expose_callback: func:(unit -> unit) -> unit

(** Start game loop contain event handling and drawing handling,
    and per-frame operation handling.
    {!display_callback} and {!move_callback} affects this function's performance.

    Given fps by argument effect loop count per second, default is 60fps.
    Argument of {!skip} affect skipping frame when game loop delayed any reason and overtime some
    operations, frame skip enable if true, disable if false.

    @param fps frame per second do game loop. default is 60FPS
    @param skip frame skip enable or disable. default is true.
*)
val game_loop: ?fps:int -> ?skip:bool -> unit -> unit

(** Register the display callback function execute inner game loop.
    Before calling this function, set default function do nothing.

    Note: Registered function by this is skipped when spent time is greater than
    limitation per frame time depend on FPS.

    @param func display callback function
*)
val display_callback:func:(unit -> unit) -> unit

(** Register the display callback function execute inner game loop.
    Before calling this function, set default function do nothing.

    Note: Registered function by this is not skipped by game loop, so
          registered function have to be called by game loop each frame.

    @param func display callback function
*)
val move_callback:func:(unit -> unit) -> unit

(** Integrate Keyboard and Joystick input infomations.
    Integrated input provide to be mapping keyboard keystroke to joystick axis and joystick button.

    But, now this don't be able to integrate mouse into keyboard and joystick,
    so mouse input handling is independent from them.

    Returning {!input_info} as result from this function is used to with {!input_callback},
    and don't forget to call {!input_close} with it when game loop ended.

    @param id unique number to each integrated input_info.
    @param num the number of joystick.
    @param axis_map the list of mapping joystick axis to some keyboard key. see {!axis_mapping}
    @param key_map the list of mapping keyboard keys to joystick button. see {!key_mapping}
    @return integrated input information that contains mapping joystick to keyboard.
*)
val integrate_inputs: id:int -> num:int -> axis_map:axis_mapping list ->
  key_map:key_mapping list -> input_info

(** Delete input information and release handle for joystick.
    This function must apply all {!input_info} made by {!integrate_inputs}.

    @param info input_info to close
*)
val input_close: input_info -> unit

(** Register callback function at end of event handling in game loop.
    Call this function then keyboard and joystick callback function are force changed
    to own callback functions of this.

    If another input_info and callback function registered,
    call them same timing then end of event handling with given {!input_info}

    @param info A input_info to give callback-function
    @param func callback function when end of event handling
*)
val add_input_callback: info:input_info -> func:(info:input_info -> unit) -> unit

(** Remove input_info and related callback-function from registered {!add_input_callback}.

    @param info target of input_info
*)
val remove_input_callback: input_info -> unit

(** Get current input statements whether pressed or released any keys or buttons.
    If given key alreadly binding some buttons, result in equivalent when this function call with
    binding button to given key.
    you have to call {!axis_state} with same {!input_info}.

    Note: To get newest state should call {!force_update} before,
          but these are usually used in callback-function registered by {!add_input_callback}.

    @param info target input info
    @param state Key or button is to get current state
    @return current button or key state.
*)
val is_pressed: info:input_info ->
  state:[< `Key of Sdl_key.key_synonym | `Button of button] -> bool
val is_released: info:input_info ->
  state:[< `Key of Sdl_key.key_synonym | `Button of button] -> bool

(** Get current state of given axis that is a signed integer representing
    the current position of the axis.

    @param info target input info
    @param state Key or button is to get current state
    @return current state of given axis
*)
val axis_state: info:input_info -> state:[< `Axis of Sdl_joystick.axis] -> int

(** Force update all {!input_info} already integrated.
*)
val force_update: unit -> unit

(** Exit game loop is arised by {!game_loop}.
    Noted, this function exit game loop forcely, raise exception no wait.
*)
val force_exit_game_loop: unit -> unit
