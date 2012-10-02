(**
 * this module provide lowlevel SDL bindings for SDL Event. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * @author derui
 * @since 0.1
 *)

exception Sdl_event_exception of string

(**
 * state of event that event is enable ,ignore, or get current state
 * of it.
 *)
type event_state =
| IGNORE                                (** ignore event *)
| ENABLE                                (** enable processing event *)
| QUERY                                 (** inquery current processing state *)

(** state of the application  *)
type app_state =
| APPMOUSEFOCUS                         (** has mouse focus *)
| APPINPUTFORCUS                        (** has keyboard focus *)
| APPACTIVE                            (** application is visible *)

(** Variant for hat values *)
type hat_type =
| HAT_CENTERED
| HAT_UP
| HAT_RIGHT
| HAT_DOWN
| HAT_LEFT
| HAT_RIGHTUP
| HAT_RIGHTDOWN
| HAT_LEFTUP
| HAT_LEFTDOWN

(**
   Event structure for SDL_ACTIVEEVENT.
*)
type active_event = {
  gain:bool;
  active_state:app_state list;
}

(** Event structure for SDL_KEYDOWN or SDL_KEYUP  *)
type keyboard_event = {
  keysym:Sdl_key.key_info;              (** key states when event occured *)
  key_state: Sdl_generic.button_state;  (** pressed or released. *)
}

(**
   Implementation from C to OCaml of mouse event structure.
*)
type mouse_motion_event = {
  motion_x:int;                          (** current X/Y coordinates *)
  motion_y:int;
  motion_xrel:int;                       (** related X/Y coordinates
                                            from previous  *)
  motion_yrel:int;
  motion_states:Sdl_mouse.mouse_button_state list;
}

type mouse_button_event = {
  mouse_x:int;                          (** current X/Y coordinates *)
  mouse_y:int;
  mouse_button:Sdl_mouse.button;
  mouse_state:Sdl_generic.button_state;
}

(** event structure for SDL_JOYAXISMOTION  *)
type joyaxis_event = {
  joy_index:int;
  axis:int;
  axis_value:int;
}

(** event structure for SDL_JOYBALLMOTION  *)
type joyball_event = {
  joy_index:int;                (** index of joystick event occured *)
  ball:int;                     (** index of ball event occured  *)
  ball_xrel:int;                (** The X/Y coodinates related
                                    previous them  *)
  ball_yrel:int;
}

(** event structure for SDL_JOYHATMOTION  *)
type joyhat_event = {
  joy_index:int;
  hat:int;
  hat_state:hat_type list;
}

(** event structure for SDL_JOYBUTTONDOWN or SDL_JOYBUTTONUP  *)
type joybutton_event = {
  joy_index:int;               (** index of joystick event occured  *)
  button:int;                  (** index of button  *)
  button_state:Sdl_generic.button_state; (** pressed or released *)
}

(** Occured when resize window  *)
type resize_event = {
  width:int; height:int;
}

(**
 * Inplementation for C structure of {b SDL_Event}.
 * Including some Event Structure that implemented for each other, too.
 *)
type event =
| Active of active_event
| KeyDown of keyboard_event
| KeyUp of keyboard_event
| Motion of mouse_motion_event
| ButtonDown of mouse_button_event
| ButtonUp of mouse_button_event
| Jaxis of joyaxis_event
| Jball of joyball_event
| Jhat of joyhat_event
| JbuttonDown of joybutton_event
| JbuttonUp of joybutton_event
| Resize of resize_event
| Expose
| Quit
| User
| Syswm

(**
 * type of events. these types are related to each Event Structures.
 * But, user can't access each event strucutre directly.
 * Only to be able to access from provided module functions.
 * Note: related structure on C is written in comment of each type.
 *)
type event_type =
| ACTIVEEVENT                       (** related SDL_ActiveEvent *)
| KEYDOWN                           (** related SDL_KeyboardEvent *)
| KEYUP                             (** related SDL_KeyboardEvent *)
| MOUSEMOTION                       (** related SDL_MouseMotionEvent *)
| MOUSEBUTTONDOWN                   (** related SDL_MouseButtonEvent *)
| MOUSEBUTTONUP                     (** related SDL_MouseButtonEvent *)
| JOYAXISMOTION                     (** related SDL_JoyAxisEvent *)
| JOYBALLMOTION                     (** related SDL_JoyBallEvent *)
| JOYHATMOTION                      (** related SDL_JoyHatEvent *)
| JOYBUTTONDOWN                     (** related SDL_JoyButtonEvent *)
| JOYBUTTONUP                       (** related SDL_JoyButtonEvent *)
| VIDEORESIZE                       (** related SDL_ResizeEvent *)
| VIDEOEXPOSE                       (** related SDL_ExposeEvent *)
| QUIT                              (** related SDL_QuitEvent *)
| USEREVENT                         (** related SDL_UserEvent *)
| SYSWMEVENT                        (** related SDL_SysWMEvent *)

(**
   Push some Event Structure onto the event queue.

   If can't push onto 'the event queue any reason, raise {!Sdl_event_exception} with
   result of {b SDL_GetError()}.

   @param event wish event to push
   @raise Sdl_event_exception if event can't push onto the event queue
*)
external push_event: event -> unit = "sdlcaml_push_event"

(**
 * Pump the event loop, gathering events from the input devices.
 * Often call the need for this function is hidden from the user what
 * since {!poll_event} or {!wait_event} implicitly calls this function.
 *
 * Note: this function can only call in the thread set the video mode.
 *)
external pump_events: unit -> unit = "sdlcaml_pump_events"

(**
 * Polls for currently pending events, if there are any pending
 * events, return events and remove it from queue.
 * If there is no pending events, None is returned from this function.
 *
 * @return if there are any pending events, return Some.
 *)
external poll_event: unit -> event option = "sdlcaml_poll_event"

(**
 * Wait indefinitly for the next avaliable event.
 *
 * @return if there is avaliable event, return Some.
 *)
external wait_event: unit -> event option = "sdlcaml_wait_event"

(**
 * This function allows you to set the state of processing certain
 * events.
 *
 * If {i state} is set to IGNORE, that event {i etype} will be
 * automatically dropped from the event queue.
 * If {i state} is set to ENABLE, that event {i etype} will be
 * processed normaly.
 * If {i state} is set to QUERY, this function will return the current
 * processing state of the specific {i etype}
 *
 * @param etype event type
 * @param state state of the event {i etype}
 * @return If you set QUERY to {i state}, this function will return
 * Some with the current state of the specific {i etype}, but will
 * return None when you don't set QUERY.
 *)
external event_state: etype:event_type ->
  state:event_state -> event_state option = "sdlcaml_event_state"

(**
 * Get the current state of the application.
 *
 * This function returns the current state of application.
 * The value returned is a list of {!app_state}
 *
 * @return list of the current states of the application
 *)
external get_app_state: unit -> app_state list = "sdlcaml_get_app_state"

let _ =
  Callback.register_exception "Sdl_event_exception"
