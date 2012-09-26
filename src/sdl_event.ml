(**
 * this module provide lowlevel SDL bindings for SDL Event. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * @author derui
 * @since 0.1
 *)

(**
 * state of processing event.
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

(** The application active event structure  *)
type active_event = {
  gain:bool;                       (** true if gain, false if loss  *)
  state:app_state;                 (** see {!app_state} *)
}

(** This Event Structure use both events whether SDL_KEYDOWN and SDL_KEYUP. *)
type keyboard_event = {
  keysym: Sdl_key.key_info           (** key that is occured event  *)
}

(** Mouse motion event structure  *)
type mouse_motion_event = {
  x:int; y:int;                         (** The x/y coordinates of the mouse *)
  relx:int; rely:int;                   (** Relative motions in  the
                                            X/Y direction *)
  state: Sdl_input.mouse_button_state list;
}

(** This Event Structure use both events whether SDL_MOUSEBUTTONDOWN and SDL_MOUSEBUTTONUP. *)
type mouse_button_event = {
  x:int; y:int; (** The X/Y coordinates of the mouse press/release time *)
  index:int;    (** the mouse button index *)
}

(**
 * Joystick axis motion event strucutre.
 *
 * Usually, On most modern joysticks the X axis
 * is represented by axis 0, and the Y axis by axis 1.
 * If your joysticks has difference axis index, you have to
 * detect to need axis index before.
 *)
type joy_axis_event = {
  index:int;                             (** joystick device index  *)
  axis:int;                              (** joystick axis index *)
  value:int;                             (** axis value  *)
}

(** Joystick trackball motion event structure  *)
type joy_ball_event = {
  index:int;            (** joystick device index  *)
  ball:int;             (** trackball index  *)
  relx:int; rely:int    (** relative motion in the X/Y coordinates  *)
}

(** Joystick hats motion event structure  *)
type joy_hat_event = {
  index:int;            (** joystick device index  *)
  hat:int;              (** hat index  *)
  value:Sdl_input.hat_state list; (** list of hat position *)
}

(** This Event Structure use both events whether SDL_JBUTTONDOWN and SDL_JBUTTONUP. *)
type joy_button_event = {
  index:int;                            (** joystick device index  *)
  button:int;                           (** joystick button index  *)
}

(** Window resize event structure *)
type resize_event = {
  width:int; height:int;   (** New width and height of the window   *)
}

(**
 * user defined event structure
 * TODO: How it implement?
*)
type user_event

(**
 * The system-dependent event structure
 * Note: this event is yet implement.
 *)
type sys_wm_event

(**
 * type of events. these types are related to each Event Structures.
 * Note: related structure on C is written in comment of each type.
 *)
type event_type =
| SDL_ACTIVEEVENT                       (** related SDL_ActiveEvent *)
| SDL_KEYDOWN                           (** related SDL_KeyboardEvent *)
| SDL_KEYUP                             (** related SDL_KeyboardEvent *)
| SDL_MOUSEMOTION                       (** related SDL_MouseMotionEvent *)
| SDL_MOUSEBUTTONDOWN                   (** related SDL_MouseButtonEvent *)
| SDL_MOUSEBUTTONUP                     (** related SDL_MouseButtonEvent *)
| SDL_JOYAXISMOTION                     (** related SDL_JoyAxisEvent *)
| SDL_JOYBALLMOTION                     (** related SDL_JoyBallEvent *)
| SDL_JOYHATMOTION                      (** related SDL_JoyHatEvent *)
| SDL_JOYBUTTONDOWN                     (** related SDL_JoyButtonEvent *)
| SDL_JOYBUTTONUP                       (** related SDL_JoyButtonEvent *)
| SDL_VIDEORESIZE                       (** related SDL_ResizeEvent *)
| SDL_VIDEOEXPOSE                       (** related SDL_ExposeEvent *)
| SDL_QUIT                              (** related SDL_QuitEvent *)
| SDL_USEREVENT                         (** related SDL_UserEvent *)
| SDL_SYSWMEVENT                        (** related SDL_SysWMEvent *)

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
| Jaxis of joy_axis_event
| Jball of joy_ball_event
| Jhat of joy_hat_event
| JbuttonDown of joy_button_event
| JbuttonUp of joy_button_event
| Resize of resize_event
| Expose
| Quit
| User of user_event
| Syswm of sys_wm_event

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
