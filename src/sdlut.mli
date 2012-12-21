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

    First of all, all events without Quit ignored. If youenable some event with
    calling {!Sdl_event.event_state} or register callback function,
    targeted event enable and is able to dispatch to callback functions.
    If you unregister callback function, correspondent event disable same time.
    But, whenever Quit event enable because it need to quit SDL system.

    To need finalization, you add some code to after {!game_loop}.

    Event callback and game loop are integrated into single thread.

    Example)

    Sdlut.init [`VIDEO];
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
  | Quit

(** Manage axis infomation for virtualization of input to integrate.
    Axis and capacity in this record are used to virtualize input, such as
    some button is pushed.
*)
type axis_info = {
  axis:Sdl_joystick.axis;
  (** target axis of joystick *)

  capacity:int;
  (** key pressed when axis state is greater than this value. *)
}

(** type synonym for joystick button  *)
type button = int

(* virtualized some inputs are buttons and keys *)
type virtual_button =
  BUTTON_1
| BUTTON_2
| BUTTON_3
| BUTTON_4
| BUTTON_5
| BUTTON_6
| BUTTON_7
| BUTTON_8
| BUTTON_9
| BUTTON_10
| BUTTON_11
| BUTTON_12
| BUTTON_13
| BUTTON_14
| BUTTON_15
| BUTTON_16
| BUTTON_17
| BUTTON_18
| BUTTON_19
| BUTTON_20
| BUTTON_21
| BUTTON_22
| BUTTON_23
| BUTTON_24
| BUTTON_25
| BUTTON_26
| BUTTON_27
| BUTTON_28
| BUTTON_29
| BUTTON_30
| BUTTON_31
| BUTTON_32
| BUTTON_OTHER of button

(** Input methods from user. *)
type input_method =
  Key of Sdl_key.key_synonym
| Button of button
| Axis of axis_info

(** Mapping button to some input method from user.
    This type says that a virtual button is able to be mapped
    some input method, such as keys, joysticks and axes of joysticks.
*)
type input_mapping = virtual_button * input_method

(** Container for input mapping infomations.
    User don't need nessesary to know details of this struct,
    this is only used to system.
*)
type input_info

(** Initialize SDL and SDLUT system.
    This function work as wrapper for {!Sdl_init.init} and
    disable all events.

    @param auto_clean auto_clean setting up auto cleanup with sdl_quit if give
    this true. defaults, sdl_init doesn't set up it.
    @param flags Targets of initializing systems and mode flags.
    @raise SDL_init_exception raise it when initialization failed.
*)
val init : ?auto_clean:bool ->
  flags:[< Sdl_init.subsystem | `EVENTTHREAD | `NOPARACHUTE | `EVERYTHING] list -> unit

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
    Caution, callback function registered by this function is called by system
    each {!KeyDown} or {!KeyUp} event, but each event raised one by one.
    So input handling need to process realtime, use {!integrate_inputs} and
    {!add_input_callback}. see document them.
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
  func:(x:int -> y:int -> xrel:int -> yrel:int -> states:Sdl_mouse.mouse_button_state list -> unit) -> unit

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

(** Register function for event of Quit.
    Unless registered function return true, do not quit game loop.
    If you want to end game loop and system, return false when registered function is called.

    @param func callback function for Quit event
*)
val quit_callback: func:(unit -> bool) -> unit

(** Integrate Keyboard and Joystick input infomations.
    Integrated input provide to be mapping keyboard keystroke to joystick axis and joystick button.

    But, now this don't be able to integrate mouse into keyboard and joystick,
    so mouse input handling is independent from them.

    Returning {!input_info} as result from this function is used to with {!input_callback},
    and don't forget to call {!input_close} with it when game loop ended.

    @param id unique number to each integrated input_info.
    @param num the number of joystick.
    @param mapping the list to map virtual buttons to some input methods.
    @return integrated input information that contains mapping joystick to keyboard.
*)
val integrate_inputs: id:int -> num:int -> mapping:input_mapping list
  -> input_info

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

    This function do not enable any events unless already enabled, so
    function registered by this function is called every loop
    regardless of what event raise or not.

    @param info A input_info to give callback-function
    @param func callback function when end of event handling
*)
val add_input_callback: info:input_info -> func:(info:input_info -> unit) -> unit

(** Remove input_info and related callback-function from registered {!add_input_callback}.

    @param info target of input_info
*)
val remove_input_callback: input_info -> unit

(** Get current input statements whether pressed or released at a button.
    If given key alreadly binding some buttons, result in equivalent when this function call with
    binding button to given key.
    you have to call {!axis_state} with same {!input_info} if you need a current axis statement.

    If you give a virtual button which did not be mapped, always return false.

    Note: To get newest state should call {!force_update} before,
          but these are usually used in callback-function registered by {!add_input_callback}.

    @param info target input info
    @param button a virtual button variant to get current state.
    @return current state of a virtual button
*)
val get_pressed: input_info -> virtual_button -> bool
val get_released: input_info -> virtual_button -> bool

(** Get current state of given axis that is a signed integer representing
    the current position of the axis.

    @param info target input info
    @param axis Key or button is to get current state
    @return current state of given axis
*)
val axis_state: info:input_info -> axis: Sdl_joystick.axis -> int

(** Force update all {!input_info} already integrated.
*)
val force_update: unit -> unit

(** Exit game loop is arised by {!game_loop}.
    Noted, this function exit game loop forcely, raise exception no wait.
*)
val force_exit_game_loop: unit -> unit

(** Get current frame per second  when you call this function.
    Frame per second managed Sdlut update each second.

    @return fps when call this function
*)
val current_fps: unit -> int
