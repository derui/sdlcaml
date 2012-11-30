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

(** To return from function that are {!get_pressed} and {!get_released}
    are types as mapped key and button.
    Null* is no key or button mapping it.
*)
type integrated = Button of button | Key of Sdl_key.key_synonym

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

(** Get current all input statements whether state is pressed or released.
    These functions return mapped key and button. If pressed key or button
    do not be contained via {!integrate_input}, returning list contain
    them as (some key, null_button) or (null_key, some button).

    For instance, to be used to input handling, you can use pattern match
    returned them.

    Note: this function always return {b all key and button states}, so
          returning list is often as big as 200 elements...
          To need only few key and key states, you should use {!get_pressed} and
          {!get_pressed}.

    @param info target integrated input infomation structure
    @return all current button and key state
*)
val get_all_pressed: input_info -> integrated list
val get_all_released: input_info -> integrated list

(** Get current input statements whether pressed or released any keys or buttons.
    If given key alreadly binding some buttons, result in equivalent when this function call with
    binding button to given key.
    you have to call {!axis_state} with same {!input_info}.

    If you was only registered some keys and call this function with not registered key or button,
    returning list contain them as whether (key, null_button) or (null_key, button).

    Note: To get newest state should call {!force_update} before,
          but these are usually used in callback-function registered by {!add_input_callback}.

    @param info target input info
    @param states Keys or buttons are to get current state
    @return current button or key state.
*)
val get_pressed: info:input_info ->
  states:[< `Key of Sdl_key.key_synonym | `Button of button] list ->
  integrated list
val get_released: info:input_info ->
  states:[< `Key of Sdl_key.key_synonym | `Button of button] list ->
  integrated list

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

(** Get current frame per second  when you call this function.
    Frame per second managed Sdlut update each second.

    @return fps when call this function
*)
val current_fps: unit -> int
