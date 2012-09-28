type app_state =
| APPMOUSEFOCUS
| APPINPUTFORCUS
| APPACTIVE
| APPNONE                               (* only used by OCaml *)

(* all probable values of event structure  *)
type t = {
  gain:bool;                       (** true if gain, false if loss  *)
  app_state:app_state;             (** see {!app_state} *)
  keysym: Sdl_key.key_info;         (** key that is occured event  *)
  x:int;
  y:int;                       (** The x/y coordinates of the mouse *)
  relx:int;
  rely:int;              (** Relative motions in the X/Y direction *)
  button_state: Sdl_input.mouse_button_state list;
  index:int;                            (** joystick device index  *)
  axis:int;                             (** joystick axis index *)
  value:int;                            (** joystick's variable value *)
  ball:int;                             (** trackball index  *)
  hat:int;                              (** hat index  *)
  hat_state:Sdl_input.hat_state list;
  button:int;                           (** joystick button index  *)
  width:int;               (** New width and height of the window   *)
  height:int;              (** New width and height of the window   *)
}

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

type value_type = [
| `X of int                             (* X coordinate *)
| `Y of int                             (* Y coordinate *)
| `Xrel of int                          (* Relative X direction *)
| `Yrel of int                          (* Relative Y direction *)
| `Gain of bool                         (* gain or ingain window *)
| `AppState of app_state                (* see {!app_state} *)
| `Keysym of Sdl_key.key_info           (* key infomation *)
| `ButtonState of Sdl_input.mouse_button_state list (* current button
                                                       state of mouse *)
| `Joystick of int                  (* index joystick *)
| `Axis of int                   (* index of joystick's 'axis *)
| `Value of int                  (* value of axis, ball *)
| `Ball of int                   (* index of ball *)
| `Hat of int                    (* index of hat *)
| `HatState of Sdl_input.hat_state list (* hat switch state list *)
| `Button of int             (* index of button of joystick or mouse*)
| `Mouse of int              (* index of button of mouse*)
| `Width of int                  (* new width on the window *)
| `Height of int                 (* new height on the window *)
]

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

(* default event structure *)
let empty_of_event = {
  gain = false;
  app_state = APPNONE;
  keysym = Sdl_key.empty;
  x = 0; y = 0; relx = 0; rely = 0;
  button_state = [];
  index = 0; axis = 0; value = 0;
  ball = 0; hat = 0; button = 0;
  hat_state = [];
  width = 0; height = 0;
}

(* extracting received {!event} to {!event_type} and {!t} *)
let extract_event = function
  | Active (ev)      -> (SDL_ACTIVEEVENT     , Some ev)
  | KeyDown (ev)     -> (SDL_KEYDOWN         , Some ev)
  | KeyUp (ev)       -> (SDL_KEYUP           , Some ev)
  | Motion (ev)      -> (SDL_MOUSEMOTION     , Some ev)
  | ButtonDown (ev)  -> (SDL_MOUSEBUTTONDOWN , Some ev)
  | ButtonUp (ev)    -> (SDL_MOUSEBUTTONUP   , Some ev)
  | Jaxis (ev)       -> (SDL_JOYAXISMOTION   , Some ev)
  | Jball (ev)       -> (SDL_JOYBALLMOTION   , Some ev)
  | Jhat (ev)        -> (SDL_JOYHATMOTION    , Some ev)
  | JbuttonDown (ev) -> (SDL_JOYBUTTONDOWN   , Some ev)
  | JbuttonUp (ev)   -> (SDL_JOYBUTTONUP     , Some ev)
  | Resize (ev)      -> (SDL_VIDEORESIZE     , Some ev)
  | Expose           -> (SDL_VIDEOEXPOSE     , None)
  | Quit             -> (SDL_QUIT            , None)
  | User (ev)        -> (SDL_USEREVENT       , Some ev)
  | Syswm (ev)       -> (SDL_SYSWMEVENT      , Some ev)

let inner_create_event ev = function
  | SDL_ACTIVEEVENT     -> Active (ev)
  | SDL_KEYDOWN         -> KeyDown (ev)
  | SDL_KEYUP           -> KeyUp (ev)
  | SDL_MOUSEMOTION     -> Motion (ev)
  | SDL_MOUSEBUTTONDOWN -> ButtonDown (ev)
  | SDL_MOUSEBUTTONUP   -> ButtonUp (ev)
  | SDL_JOYAXISMOTION   -> Jaxis (ev)
  | SDL_JOYBALLMOTION   -> Jball (ev)
  | SDL_JOYHATMOTION    -> Jhat (ev)
  | SDL_JOYBUTTONDOWN   -> JbuttonDown (ev)
  | SDL_JOYBUTTONUP     -> JbuttonUp (ev)
  | SDL_VIDEORESIZE     -> Resize (ev)
  | SDL_VIDEOEXPOSE     -> Expose
  | SDL_QUIT            -> Quit
  | SDL_USEREVENT       -> User (ev)
  | SDL_SYSWMEVENT      -> Syswm (ev)

let empty = inner_create_event empty_of_event

(* define acceptable {!value_type} each event_type *)
let active_acceptable = function
  | `Gain _ -> true
  | `AppState _ -> true
  | _ -> false

let keydown_acceptable = function
  | `Keysym _ -> true
  | _ -> false

let keyup_acceptable = keydown_acceptable

let motion_acceptable = function
  | `X _ -> true
  | `Y _ -> true
  | `Xrel _ -> true
  | `Yrel _ -> true
  | `ButtonState _ -> true
  | _ -> false

let button_down_acceptable = function
  | `X _ -> true
  | `Y _ -> true
  | `Mouse _ -> true
  | _ -> false

let button_up_acceptable = button_down_acceptable

let jaxis_acceptable = function
  | `Joystick _ -> true
  | `Axis _ -> true
  | `Value _ -> true
  | _ -> false

let jball_acceptable = function
  | `Joystick _ -> true
  | `Ball _ -> true
  | `Xrel _ -> true
  | `Yrel _ -> true
  | _ -> false

let jhat_acceptable = function
  | `Joystick _ -> true
  | `Hat _ -> true
  | `HatState _ -> true
  | _ -> false

let jbutton_down_acceptable = function
  | `Joystick _ -> true
  | `Button _ -> true
  | _ -> false

let jbutton_up_acceptable = jbutton_down_acceptable

let resize_acceptable = function
  | `Width _ -> true
  | `Height _ -> true
  | _ -> false

let no_acceptable _ = false

let event_acceptable = function
  | Active (structure)      -> active_acceptable
  | KeyDown (structure)     -> keydown_acceptable
  | KeyUp (structure)       -> keyup_acceptable
  | Motion (structure)      -> motion_acceptable
  | ButtonDown (structure)  -> button_down_acceptable
  | ButtonUp (structure)    -> button_up_acceptable
  | Jaxis (structure)       -> jaxis_acceptable
  | Jball (structure)       -> jball_acceptable
  | Jhat (structure)        -> jhat_acceptable
  | JbuttonDown (structure) -> jbutton_down_acceptable
  | JbuttonUp (structure)   -> jbutton_up_acceptable
  | Resize (structure)      -> resize_acceptable
  | Expose                  -> no_acceptable
  | Quit                    -> no_acceptable
  (* TODO: implement some day above *)
  | User (structure)        -> no_acceptable
  | Syswm (structure)       -> no_acceptable

(* function for event structure modification *)
let modify oldevent modify_list =
  let modify_by_value_list e = function
    | `X (x)                      -> {e with x}
    | `Y (y)                      -> {e with y}
    | `Xrel (xrel)                -> {e with relx = xrel}
    | `Yrel (yrel)                -> {e with rely = yrel}
    | `Gain (gain)                -> {e with gain}
    | `AppState (app_state)       -> {e with app_state}
    | `Keysym (keysym)            -> {e with keysym}
    | `ButtonState (button_state) -> {e with button_state}
    | `Joystick (index)           -> {e with index}
    | `Axis (axis)                -> {e with axis}
    | `Value (value)              -> {e with value}
    | `Ball (ball)                -> {e with ball}
    | `Hat (hat)                  -> {e with hat}
    | `HatState (hat_state)       -> {e with hat_state}
    | `Button (button)            -> {e with button}
    | `Mouse (index)              -> {e with index}
    | `Width (width)              -> {e with width}
    | `Height (height)            -> {e with height}
  and (old_type, old_struct) = extract_event oldevent in
  match old_struct with
    | Some old_struct -> inner_create_event (
      List.fold_left
        modify_by_value_list
        old_struct
        (List.filter (event_acceptable oldevent) modify_list))
      old_type
    | None -> oldevent

(* create is that mofify empty event with values *)
let create etype values = modify (empty etype) values

let extract = function
  | Active ev      ->
    [`Gain (ev.gain) ; `AppState (ev.app_state)]
  | (KeyDown ev | KeyUp ev) -> [`Keysym (ev.keysym)]
  | Motion (ev)      ->
    [`X ev.x ; `Y ev.y ; `Xrel ev.relx; `Yrel ev.rely; `ButtonState ev.button_state]

  | (ButtonDown ev | ButtonUp ev) ->
    [`X ev.x ; `Y ev.y ; `Xrel ev.relx; `Yrel ev.rely; `Mouse ev.index]

  | Jaxis ev       -> [`Joystick ev.index; `Axis ev.axis; `Value ev.value]
  | Jball ev       -> [`Joystick ev.index; `Ball ev.ball; `Xrel
    ev.relx; `Yrel ev.rely ]
  | Jhat ev       -> [`Joystick ev.index; `Hat ev.hat; `HatState ev.hat_state]
  | (JbuttonDown ev | JbuttonUp ev) -> [`Joystick ev.index; `Button ev.button]
  | Resize ev      -> [`Width ev.width; `Height ev.height]
  | Expose                  -> []
  | Quit                    -> []
  | User (ev)        -> []
  | Syswm (ev)       -> []

let _ =
  Callback.register "sdlcaml_empty_event_object" empty_of_event
