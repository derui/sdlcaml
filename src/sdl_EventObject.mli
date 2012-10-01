(**
   Define useful module to provide with binding of SDL Event
   Structure.
   This module is used to create event, receive event, and
   pick up data from event structure.

   Usually, event structure and functions are used with {!Sdl_event}.
   you may see detail of {!Sdl_event} if you want to know Event
   Management with SDL.

   @since 0.1
   @author derui
*)

(**
   the type of event structure binding.
   This is only accessed by function from this module provided.
*)
type t

(**
 * Inplementation for C structure of {b SDL_Event}.
 * Including some Event Structure that implemented for each other, too.
 *)
type event =
| Active of t
| KeyDown of t
| KeyUp of t
| Motion of t
| ButtonDown of t
| ButtonUp of t
| Jaxis of t
| Jball of t
| Jhat of t
| JbuttonDown of t
| JbuttonUp of t
| Resize of t
| Expose
| Quit
| User of t
| Syswm of t

(** state of the application  *)
type app_state =
| APPMOUSEFOCUS                         (** has mouse focus *)
| APPINPUTFORCUS                        (** has keyboard focus *)
| APPACTIVE                            (** application is visible *)

(**
   Readable value types. These only make use of
   extract function that getting from an event structure.
*)
type read_value_type =
| X
| Y
| Xrel
| Yrel
| Gain
| AppState
| Keysym
| ButtonState
| Joystick
| Axis
| Value
| Ball
| Hat
| HatState
| Button
| Mouse
| Width
| Height

(**
   Receivable value type variants.
   These variants needs to get value, modify value from Event
   Strucutre.
   Each {!event_type} are related to these variant that are
   able to be received by some function.
*)
type value_type = [
| `X of int                             (* X coordinate *)
| `Y of int                             (* Y coordinate *)
| `Xrel of int                          (* Relative X direction *)
| `Yrel of int                          (* Relative Y direction *)
| `Gain of bool                         (* gain or ingain window *)
| `AppState of app_state list           (* see {!app_state} *)
| `Keysym of Sdl_key.key_info           (* key infomation *)
| `ButtonState of Sdl_input.mouse_button_state list (* current button state of
                                                       mouse *)
| `Joystick of int                  (* index joystick *)
| `Axis of int                   (* index of joystick's 'axis *)
| `Value of int                  (* value of axis, ball *)
| `Ball of int                   (* index of ball *)
| `Hat of int                    (* index of hat *)
| `HatState of Sdl_input.hat_state list (* hat switch state list *)
| `Button of int                 (* index of button of joystick *)
| `Mouse of int                 (* index of button of mouse *)
| `Width of int                  (* new width on the window *)
| `Height of int                 (* new height on the window *)
]

(**
 * type of events. these types are related to each Event Structures.
 * But, user can't access each event strucutre directly.
 * Only to be able to access from provided module functions.
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
   Create empty Event Structure to be related {!event_type}.
   'Empty' Event Structure is empty what all inner data is default.
   You should modify it to use some function to modify event structure.

   @param event_type What event_type  want to create
   @return created event structure
*)
val empty: event_type -> event

(**
   return new event structure with modified by given value list.
   Each {!value_type} are to be detected from deciding {!event_type}
   when event created.
   If giving unacceptable value type, but this function ignore it.

   @param event_type desire to create event type {!event_type}
   @param values values that set to new event structure
   @return new event structure
*)
val create: event_type -> value_type list -> event

(**
   return new event structure modfiying make use of list of
   {!value_type}.
   Each {!value_type} are to be detected from deciding {!event_type}
   when event created.
   If giving unreceivable value type, but this function ignore it.
   Noted: this function return {b new} event structure, it's not
          received one.

   @param event want to modify event structure
   @param values new values that is used by new event structure
   @return new event structure
*)
val modify: event -> value_type list -> event

(**
   Extract event data structure from event structure.
   But any event type don't have event data structure, such as
   {!Expose} or {!Quit}, so this return empty list if they given.

   @param event extracting target
   @return event data list
*)
val extract: event -> value_type list
