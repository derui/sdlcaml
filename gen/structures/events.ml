open Ctypes
module F = Sdlcaml_flags

type finger_type = FDOWN | FUP | FMOTION

(* shortcut functions for timestamp field *)
let timestamp_field t = field t "timestamp" uint32_t
let timestamp_to_ocaml t ts = getf t ts |> Unsigned.UInt32.to_int32
let timestamp_of_ocaml = Unsigned.UInt32.of_int32

(* shortcut functions for type field *)
let type_field t = field t "type" uint32_t
let type_to_ocaml t ts = getf t ts |> Unsigned.UInt32.to_int32 |> F.Sdl_event_type.of_int32
let type_of_ocaml e = F.Sdl_event_type.to_int32 e |> Unsigned.UInt32.of_int32

module type TYPE = sig
  type structure
  val struct_name : string
end

(* Provide definitions of common field *)
module Common(TYPE:TYPE) = struct
  let t : TYPE.structure structure typ = structure TYPE.struct_name
  let event_type = type_field t
  let timestamp  = timestamp_field t
end

module ControllerAxisEvent = struct
  type t = {
    timestamp : int32;
    which : int;
    axis : F.Sdl_controller_axis.t;
    value : int;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_ControllerAxisEvent"
  end)

  let which = field t "which" int32_t
  let axis = field t "axis" uint8_t
  let _ = field t "padding1" uint8_t
  let _ = field t "padding2" uint8_t
  let _ = field t "padding3" uint8_t
  let value = field t "value" int16_t
  let _ = field t "padding4" uint16_t

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    which = getf e which |> Signed.Int32.to_int;
    axis = getf e axis |> Unsigned.UInt8.to_int |> F.Sdl_controller_axis.of_int;
    value = getf e value
  }

  let of_ocaml e =
    let s = make t in

    type_of_ocaml F.Sdl_event_type.SDL_CONTROLLERAXISMOTION |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Signed.Int32.of_int e.which |> setf s which;
    F.Sdl_controller_axis.to_int e.axis |> Unsigned.UInt8.of_int |> setf s axis;
    setf s value e.value;
    s

  let to_event_type _ = F.Sdl_event_type.SDL_CONTROLLERAXISMOTION
end

module ControllerButtonEvent = struct
  type t = {
    timestamp : int32;
    which : int;
    button : F.Sdl_game_controller_button.t;
    state : F.Sdl_button_state.t;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_ControllerButtonEvent"
  end)
  let which = field t "which" int32_t
  let button = field t "button" uint8_t
  let state = field t "state" uint8_t
  let _ = field t "padding1" uint8_t
  let _ = field t "padding2" uint8_t

  let to_event_type e =
    match e.state with
    | F.Sdl_button_state.SDL_PRESSED -> F.Sdl_event_type.SDL_CONTROLLERBUTTONDOWN
    | F.Sdl_button_state.SDL_RELEASED -> F.Sdl_event_type.SDL_CONTROLLERBUTTONUP

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    which = getf e which |> Signed.Int32.to_int;
    button = getf e button |> Unsigned.UInt8.to_int |> F.Sdl_game_controller_button.of_int;
    state = getf e state |> Unsigned.UInt8.to_int |> F.Sdl_button_state.of_int
  }

  let of_ocaml e =
    (* SDL_ControllerButtonEvent is used by two event which are down and up it. *)
    let s = make t in

    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Signed.Int32.of_int e.which |> setf s which;
    F.Sdl_game_controller_button.to_int e.button |> Unsigned.UInt8.of_int |> setf s button;
    F.Sdl_button_state.to_int e.state |> Unsigned.UInt8.of_int |> setf s state;
    s

end

module ControllerDeviceEvent = struct
  type t = {
    event_type : F.Sdl_controller_device.t;
    timestamp : int32;
    which : int;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_ControllerDeviceEvent"
  end)
  let which = field t "which" int32_t

  let to_event_type e =
    match e.event_type with
    | `REMAPPED -> F.Sdl_event_type.SDL_CONTROLLERDEVICEREMAPPED
    | `REMOVED -> F.Sdl_event_type.SDL_CONTROLLERDEVICEREMOVED
    | `ADDED -> F.Sdl_event_type.SDL_CONTROLLERDEVICEADDED

  let to_ocaml e =
    let module UInt32 = Unsigned.UInt32 in
    {
      event_type = getf e event_type |> UInt32.to_int32 |> Int32.to_int |> F.Sdl_controller_device.of_int;
      timestamp = timestamp_to_ocaml e timestamp;
      which = getf e which |> Signed.Int32.to_int
    }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Signed.Int32.of_int e.which |> setf s which;
    s
end

module DollarGestureEvent = struct
  type t = {
    action_type: F.Sdl_dollar.t;
    timestamp : int32;
    touch_id : int64;
    gesture_id : int64;
    num_fingers : int32;
    error : float;
    x : float;
    y : float;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_DollarGestureEvent"
  end)
  let touch_id = field t "touchId" int64_t
  let gesture_id = field t "gestureId" int64_t
  let num_fingers = field t "numFingers" uint32_t
  let error = field t "error" float
  let x = field t "x" float
  let y = field t "y" float

  let to_event_type e =
    match e.action_type with
    | `GESTURE -> F.Sdl_event_type.SDL_DOLLARGESTURE
    | `RECORD -> F.Sdl_event_type. SDL_DOLLARRECORD

  let to_ocaml e =
    let module U = Unsigned in
    let module S = Signed in
    {
      action_type = getf e event_type |> U.UInt32.to_int32 |> F.Sdl_dollar.of_int32;
      timestamp = timestamp_to_ocaml e timestamp;
      touch_id = getf e touch_id |> S.Int64.to_int64;
      gesture_id = getf e gesture_id |> S.Int64.to_int64;
      num_fingers = getf e num_fingers |> U.UInt32.to_int32;
      error = getf e error;
      x = getf e x; y = getf e y
    }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Signed.Int64.of_int64 e.touch_id |> setf s touch_id;
    Signed.Int64.of_int64 e.gesture_id |> setf s gesture_id;
    Unsigned.UInt32.of_int32 e.num_fingers |> setf s num_fingers;
    setf s error e.error;
    setf s x e.x;
    setf s y e.y;
    s

end

module DropEvent = struct
  type t = {
    timestamp : int32;
    file : string
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_DropEvent"
  end)
  let file = field t "file" string

  let to_event_type _ = F.Sdl_event_type.SDL_DROPFILE

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    file = getf e file
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    setf s file e.file;
    s
end

module JoyAxisEvent = struct
  type t = {
    timestamp : int32;
    which : int;
    axis : int;
    value : int
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_JoyAxisEvent"
  end)
  let which = field t "which" int32_t
  let axis = field t "axis" uint8_t
  let _ = field t "padding1" uint8_t
  let _ = field t "padding2" uint8_t
  let _ = field t "padding3" uint8_t
  let value = field t "value" int16_t
  let _ = field t "padding4" uint16_t

  let to_event_type _ = F.Sdl_event_type.SDL_JOYAXISMOTION

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    which = getf e which |> Signed.Int32.to_int;
    axis = getf e axis |> Unsigned.UInt8.to_int;
    value = getf e value;
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Signed.Int32.of_int e.which |> setf s which;
    Unsigned.UInt8.of_int e.axis |> setf s axis;
    setf s value e.value;
    s
end

module JoyBallEvent = struct
  type t = {
    timestamp : int32;
    which : int;
    ball : int;
    xrel : int;
    yrel : int;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_JoyBallEvent"
  end)

  let which = field t "which" int32_t
  let ball = field t "ball" uint8_t
  let _ = field t "padding1" uint8_t
  let _ = field t "padding2" uint8_t
  let _ = field t "padding3" uint8_t
  let xrel = field t "xrel" int16_t
  let yrel = field t "yrel" int16_t

  let to_event_type _ = F.Sdl_event_type.SDL_JOYBALLMOTION

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    which = getf e which |> Signed.Int32.to_int;
    ball = getf e ball |> Unsigned.UInt8.to_int;
    xrel = getf e xrel;
    yrel = getf e yrel;
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Signed.Int32.of_int e.which |> setf s which;
    Unsigned.UInt8.of_int e.ball |> setf s ball;
    setf s xrel e.xrel;
    setf s yrel e.yrel;
    s

end

module JoyButtonEvent = struct
  type t = {
    timestamp : int32;
    which : int;
    button : int;
    state : F.Sdl_button_state.t;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_JoyButtonEvent"
  end)

  let which = field t "which" int32_t
  let button = field t "button" uint8_t
  let state = field t "state" uint8_t
  let _= field t "padding1" uint8_t
  let _= field t "padding2" uint8_t

  let to_event_type e =
    match e.state with
    | F.Sdl_button_state.SDL_PRESSED -> F.Sdl_event_type.SDL_CONTROLLERBUTTONDOWN
    | F.Sdl_button_state.SDL_RELEASED -> F.Sdl_event_type.SDL_CONTROLLERBUTTONUP

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    which = getf e which |> Signed.Int32.to_int;
    button = getf e button |> Unsigned.UInt8.to_int;
    state = getf e state |> Unsigned.UInt8.to_int |> F.Sdl_button_state.of_int;
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Signed.Int32.of_int e.which |> setf s which;
    Unsigned.UInt8.of_int e.button |> setf s button;
    F.Sdl_button_state.to_int e.state |> Unsigned.UInt8.of_int |> setf s state;
    s
end

module JoyDeviceEvent = struct
  type t = {
    action_type: F.Sdl_joy_device.t;
    timestamp: int32;
    which: int;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_JoyButtonEvent"
  end)
  let which = field t "which" int32_t

  let to_event_type e =
    let act = F.Sdl_joy_device.to_int32 e.action_type in
    F.Sdl_event_type.of_int32 act

  let to_ocaml e =
    let module J = F.Sdl_joy_device in
    {
      action_type = getf e event_type |> Unsigned.UInt32.to_int32 |> J.of_int32;
      timestamp = timestamp_to_ocaml e timestamp;
      which = getf e which |> Signed.Int32.to_int;
    }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Signed.Int32.of_int e.which |> setf s which;
    s

end

module JoyHatEvent = struct
  type t = {
    timestamp : int32;
    which : int;
    hat : int;
    value : F.Sdl_hat.t;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_JoyHatEvent"
  end)

  let which = field t "which" int32_t
  let hat = field t "hat" uint8_t
  let value = field t "value" uint8_t
  let _ = field t "padding1" uint8_t
  let _ = field t "padding2" uint8_t

  let to_event_type _ = F.Sdl_event_type.SDL_JOYHATMOTION

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    which = getf e which |> Signed.Int32.to_int;
    hat = getf e hat |> Unsigned.UInt8.to_int;
    value = getf e value |> Unsigned.UInt8.to_int |> F.Sdl_hat.of_int
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Signed.Int32.of_int e.which |> setf s which;
    Unsigned.UInt8.of_int e.hat |> setf s hat;
    F.Sdl_hat.to_int e.value |> Unsigned.UInt8.of_int |> setf s value;
    s
end

module KeyboardEvent = struct
  type t = {
    event_type : F.Sdl_event_type.t;
    timestamp : int32;
    window_id : int32;
    state : F.Sdl_button_state.t;
    repeat : bool;
    keysym : Keysym.t;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_KeyboardEvent"
  end)
  let window_id = field t "windowID" uint32_t
  let state = field t "state" uint8_t
  let repeat = field t "repeat" uint8_t
  let _ = field t "padding2" uint8_t
  let _ = field t "padding3" uint8_t
  let keysym = field t "keysym" Keysym.t

  let to_event_type e =
    match e.state with
    | F.Sdl_button_state.SDL_RELEASED -> F.Sdl_event_type.SDL_KEYUP
    | F.Sdl_button_state.SDL_PRESSED -> F.Sdl_event_type.SDL_KEYDOWN

  let to_ocaml e = {
    event_type = type_to_ocaml e event_type;
    timestamp = timestamp_to_ocaml e timestamp;
    window_id = getf e window_id |> Unsigned.UInt32.to_int32;
    state = getf e state |> Unsigned.UInt8.to_int |> F.Sdl_button_state.of_int;
    repeat = getf e repeat |> Unsigned.UInt8.to_int <> 0;
    keysym = getf e keysym |> Keysym.to_ocaml
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Unsigned.UInt32.of_int32 e.window_id |> setf s window_id;
    F.Sdl_button_state.to_int e.state |> Unsigned.UInt8.of_int |> setf s state;
    Keysym.of_ocaml e.keysym |> setf s keysym;
    s
end

module MouseButtonEvent = struct
  type t = {
    timestamp : int32;
    window_id : int32;
    which : int32;
    button : F.Sdl_mousebutton.t;
    state: F.Sdl_button_state.t;
    clicks : int;
    x : int;
    y : int;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_MouseButtonEvent"
  end)
  let window_id = field t "windowID" uint32_t
  let which = field t "which" uint32_t
  let button = field t "button" uint8_t
  let state = field t "state" uint8_t
  let clicks = field t "clicks" uint8_t
  let _ = field t "padding1" uint8_t
  let x = field t "x" int32_t
  let y = field t "y" int32_t

  let to_event_type e =
    match e.state with
    | F.Sdl_button_state.SDL_PRESSED -> F.Sdl_event_type.SDL_MOUSEBUTTONDOWN
    | F.Sdl_button_state.SDL_RELEASED -> F.Sdl_event_type.SDL_MOUSEBUTTONUP

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    window_id = getf e window_id |> Unsigned.UInt32.to_int32;
    which = getf e which |> Unsigned.UInt32.to_int32;
    button = getf e button |> Unsigned.UInt8.to_int |> F.Sdl_mousebutton.of_int;
    state = getf e state |> Unsigned.UInt8.to_int |> F.Sdl_button_state.of_int;
    clicks = getf e clicks |> Unsigned.UInt8.to_int;
    x = getf e x |> Signed.Int32.to_int;
    y = getf e y |> Signed.Int32.to_int;
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Unsigned.UInt32.of_int32 e.window_id |> setf s window_id;
    Unsigned.UInt32.of_int32 e.which |> setf s which;
    F.Sdl_mousebutton.to_int e.button |> Unsigned.UInt8.of_int |> setf s button;
    F.Sdl_button_state.to_int e.state |> Unsigned.UInt8.of_int |> setf s state;
    Unsigned.UInt8.of_int e.clicks |> setf s clicks;
    Signed.Int32.of_int e.x |> setf s x;
    Signed.Int32.of_int e.y |> setf s y;
    s
end

module MouseMotionEvent = struct
  type t = {
    timestamp : int32;
    window_id : int32;
    which : int32;
    state : F.Sdl_mousebutton.t list;
    x : int;
    y : int;
    xrel : int;
    yrel : int;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_MouseMotionEvent"
  end)
  let window_id = field t "windowID" uint32_t
  let which = field t "which" uint32_t
  let state = field t "state" uint8_t
  let x = field t "x" int32_t
  let y = field t "y" int32_t
  let xrel = field t "xrel" int32_t
  let yrel = field t "yrel" int32_t

  let to_event_type _ = F.Sdl_event_type.SDL_MOUSEMOTION

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    window_id = getf e window_id |> Unsigned.UInt32.to_int32;
    which = getf e which |> Unsigned.UInt32.to_int32;
    state = getf e state |> Unsigned.UInt8.to_int |> F.Sdl_mousebutton.of_int_list;
    x = getf e x |> Signed.Int32.to_int;
    y = getf e y |> Signed.Int32.to_int;
    xrel = getf e xrel |> Signed.Int32.to_int;
    yrel = getf e yrel |> Signed.Int32.to_int;
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Unsigned.UInt32.of_int32 e.window_id |> setf s window_id;
    Unsigned.UInt32.of_int32 e.which |> setf s which;
    F.Sdl_mousebutton.to_combined_int e.state |> Unsigned.UInt8.of_int |> setf s state;
    Signed.Int32.of_int e.x |> setf s x;
    Signed.Int32.of_int e.y |> setf s y;
    Signed.Int32.of_int e.xrel |> setf s xrel;
    Signed.Int32.of_int e.yrel |> setf s yrel;
    s

end

module MouseWheelEvent = struct
  type t = {
    timestamp : int32;
    window_id : int32;
    which : int32;
    x : int;
    y : int;
    direction: F.Sdl_mousewheel.t;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_MouseWheelEvent"
  end)

  let window_id = field t "windowID" uint32_t
  let which = field t "which" uint32_t
  let x = field t "x" int32_t
  let y = field t "y" int32_t
  let direction = field t "direction" uint32_t

  let to_event_type _ = F.Sdl_event_type.SDL_MOUSEWHEEL

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    window_id = getf e window_id |> Unsigned.UInt32.to_int32;
    which = getf e which |> Unsigned.UInt32.to_int32;
    x = getf e x |> Signed.Int32.to_int;
    y = getf e y |> Signed.Int32.to_int;
    direction = getf e direction |> Unsigned.UInt32.to_int |> F.Sdl_mousewheel.of_int;
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Unsigned.UInt32.of_int32 e.window_id |> setf s window_id;
    Unsigned.UInt32.of_int32 e.which |> setf s which;
    Signed.Int32.of_int e.x |> setf s x;
    Signed.Int32.of_int e.y |> setf s y;
    F.Sdl_mousewheel.to_int e.direction |> Unsigned.UInt32.of_int |> setf s direction;
    s
end

module MultiGestureEvent = struct
  type t = {
    timestamp : int32;
    touch_id : int64;
    delta_theta : float;
    delta_dist : float;
    x : float;
    y : float;
    num_fingers:int;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_MultiGestureEvent"
  end)
  let touch_id = field t "touchId" int64_t
  let x = field t "x" float
  let y = field t "y" float
  let delta_dist = field t "dTheta" float
  let delta_theta = field t "dDist" float
  let num_fingers = field t "numFingers" uint16_t
  let _ = field t "padding" uint16_t

  let to_event_type _ = F.Sdl_event_type.SDL_MULTIGESTURE

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    touch_id = getf e touch_id |> Signed.Int64.to_int64;
    x = getf e x;
    y = getf e y;
    delta_theta = getf e delta_theta;
    delta_dist = getf e delta_dist;
    num_fingers = getf e num_fingers |> Unsigned.UInt16.to_int;
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Signed.Int64.of_int64 e.touch_id |> setf s touch_id;
    setf s x e.x;
    setf s y e.y;
    setf s delta_dist e.delta_dist;
    setf s delta_theta e.delta_theta;
    Unsigned.UInt16.of_int e.num_fingers |> setf s num_fingers;
    s
end

module QuitEvent = struct
  type t = {
    timestamp : int32;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_QuitEvent"
  end)

  let to_event_type _ = F.Sdl_event_type.SDL_QUIT

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    s
end

module SysWMEvent = struct
  type t = {
    timestamp : int32;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_SysWMEvent"
  end)
  let msg = field t "msg" (ptr Sys_wm_msg.t)

  let to_event_type _ = F.Sdl_event_type.SDL_SYSWMEVENT

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    let sys_wm_msg = make Sys_wm_msg.t in
    setf s msg (addr sys_wm_msg);
    s
end

module TextEditingEvent = struct
  type t = {
    timestamp : int32;
    window_id : int32;
    text : string;
    start : int;
    length : int;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_TextEditingEvent"
  end)

  let window_id = field t "windowID" uint32_t
  let text = field t "text" string
  let start = field t "start" int32_t
  let length = field t "length" int32_t

  let to_event_type _ = F.Sdl_event_type.SDL_TEXTEDITING

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    window_id = getf e window_id |> Unsigned.UInt32.to_int32;
    text = getf e text;
    start = getf e start |> Signed.Int32.to_int;
    length = getf e length |> Signed.Int32.to_int;
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Unsigned.UInt32.of_int32 e.window_id |> setf s window_id;
    let max_len = String.length e.text |> min 31 in
    String.sub e.text 0 max_len |> setf s text;
    Signed.Int32.of_int e.start |> setf s start;
    Signed.Int32.of_int e.length |> setf s length;
    s
end

module TextInputEvent = struct
  type t = {
    timestamp : int32;
    window_id : int32;
    text : string;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_TextInputEvent"
  end)

  let window_id = field t "windowID" uint32_t
  let text = field t "text" string

  let to_event_type _ = F.Sdl_event_type.SDL_TEXTINPUT

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    window_id = getf e window_id |> Unsigned.UInt32.to_int32;
    text = getf e text;
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Unsigned.UInt32.of_int32 e.window_id |> setf s window_id;
    let max_len = String.length e.text |> min 31 in
    String.sub e.text 0 max_len |> setf s text;
    s
end

module TouchFingerEvent = struct
  type t = {
    timestamp : int32;
    touch_id : int64;
    finger_id : int64;
    x : float;
    y : float;
    dx : float;
    dy : float;
    pressure : float;
    motion: F.Sdl_finger.t
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_TouchFingerEvent"
  end)

  let touch_id = field t "touchId" int64_t
  let finger_id = field t "fingerId" int64_t
  let x = field t "x" float
  let y = field t "y" float
  let dx = field t "dx" float
  let dy = field t "dy" float
  let pressure = field t "pressure" float

  (* Event type of TouchFingerEvent module is equal to Sdl_finger variant converted via
     provided function. *)
  let to_event_type e = F.Sdl_finger.to_int32 e.motion |> F.Sdl_event_type.of_int32

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    touch_id = getf e touch_id |> Signed.Int64.to_int64;
    finger_id = getf e finger_id |> Signed.Int64.to_int64;
    x = getf e x;
    y = getf e y;
    dx = getf e dx;
    dy = getf e dy;
    pressure = getf e pressure;
    motion = getf e event_type |> Unsigned.UInt32.to_int32 |> F.Sdl_finger.of_int32
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Signed.Int64.of_int64 e.touch_id |> setf s touch_id;
    setf s x e.x;
    setf s y e.y;
    setf s dx e.dx;
    setf s dy e.dy;
    setf s pressure e.pressure;
    s

end

module Window_event = struct
  type t =
      SHOWN
    | HIDDEN
    | EXPOSED
    | MOVED of int32 * int32
    | RESIZED of int32 * int32
    | CHANGED of int32 * int32
    | MINIMIZED
    | MAXIMIZED
    | RESTORED
    | ENTER
    | LEAVE
    | GAINED
    | LOST
    | CLOSE

  let to_ocaml data1 data2 = function
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_CLOSE -> CLOSE
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_SHOWN -> SHOWN
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_HIDDEN -> HIDDEN
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_EXPOSED -> EXPOSED
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_MOVED -> MOVED (data1, data2)
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_RESIZED -> RESIZED (data1, data2)
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_MINIMIZED -> MINIMIZED
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_MAXIMIZED -> MAXIMIZED
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_RESTORED -> RESTORED
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_ENTER -> ENTER
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_LEAVE -> LEAVE
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_FOCUS_GAINED -> GAINED
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_FOCUS_LOST -> LOST
    | F.Sdl_window_event_id.SDL_WINDOWEVENT_SIZE_CHANGED -> CHANGED (data1,data2)

  let of_ocaml = function
    | CLOSE -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_CLOSE, None, None)
    | SHOWN -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_SHOWN, None, None)
    | HIDDEN -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_HIDDEN, None, None)
    | EXPOSED -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_EXPOSED, None, None)
    | MOVED (data1, data2) -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_MOVED, Some data1, Some data2)
    | RESIZED (data1, data2) -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_RESIZED, Some data1, Some data2)
    | MINIMIZED -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_MINIMIZED, None, None)
    | MAXIMIZED -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_MAXIMIZED, None, None)
    | RESTORED -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_RESTORED, None, None)
    | ENTER -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_ENTER, None, None)
    | LEAVE -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_LEAVE, None, None)
    | GAINED -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_FOCUS_GAINED, None, None)
    | LOST -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_FOCUS_LOST, None, None)
    | CHANGED (data1,data2) -> (F.Sdl_window_event_id.SDL_WINDOWEVENT_SIZE_CHANGED, Some data1, Some data2)
end

module WindowEvent = struct
  type t = {
    timestamp : int32;
    window_id : int32;
    event : Window_event.t;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_TouchFingerEvent"
  end)
  let window_id = field t "windowID" uint32_t
  let event = field t "event" uint8_t
  let _ = field t "padding1" uint8_t
  let _ = field t "padding2" uint8_t
  let _ = field t "padding3" uint8_t
  let data1 = field t "data1" int32_t
  let data2 = field t "data2" int32_t

  let to_event_type _ = F.Sdl_event_type.SDL_WINDOWEVENT

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    window_id = getf e window_id |> Unsigned.UInt32.to_int32;
    event = let id = getf e event |> Unsigned.UInt8.to_int |> F.Sdl_window_event_id.of_int in
            let to_int32 f = getf e f |> Signed.Int32.to_int |> Int32.of_int in
            Window_event.to_ocaml (to_int32 data1) (to_int32 data2) id;
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Unsigned.UInt32.of_int32 e.window_id |> setf s window_id;
    let ev, d1, d2 = Window_event.of_ocaml e.event in
    let set_data f d = match d with
      | None -> ()
      | Some d -> Int32.to_int d |> Signed.Int32.of_int |> setf s f; in
    F.Sdl_window_event_id.to_int ev |> Unsigned.UInt8.of_int |> setf s event;
    set_data data1 d1;
    set_data data1 d2;
    s
end

module CommonEvent = struct
  type t = {
    event_type: F.Sdl_event_type.t;
    timestamp: int32
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_TouchFingerEvent"
  end)

  let to_ocaml e = {
    event_type = type_to_ocaml e event_type;
    timestamp = timestamp_to_ocaml e timestamp;
  }

  let of_ocaml e =
    let s = make t in
    type_of_ocaml e.event_type |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    s
end

module AudioDeviceEvent = struct
  type t = {
    action_type: F.Sdl_audio_device.t;
    timestamp : int32;
    which: int32;
    device_type: [`CAPTURE | `OUTPUT];
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_AudioDeviceEvent"
  end)
  let which = field t "which" uint32_t
  let iscapture = field t "iscapture" uint8_t
  let _ = field t "padding1" uint8_t
  let _ = field t "padding2" uint8_t
  let _ = field t "padding3" uint8_t

  let to_event_type e =
    F.Sdl_audio_device.to_int32 e.action_type |> F.Sdl_event_type.of_int32

  let to_ocaml e =
    let cap = getf e iscapture |> Unsigned.UInt8.to_int in
    {
    action_type = type_to_ocaml e event_type |> F.Sdl_event_type.to_int32 |> F.Sdl_audio_device.of_int32;
    timestamp = timestamp_to_ocaml e timestamp;
    which = getf e which |> Unsigned.UInt32.to_int32;
    device_type = if cap = 0 then `OUTPUT else `CAPTURE
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Unsigned.UInt32.of_int32 e.which |> setf s which;
    let cap = match e.device_type with
      | `OUTPUT -> 0
      | `CAPTURE -> 1
    in
    Unsigned.UInt8.(of_int cap |> setf s iscapture);
    s
end

module UserEvent = struct
  type t = {
    timestamp : int32;
    window_id: int32;
    code: int;
  }

  include Common(struct
    type structure = t
    let struct_name = "SDL_UserEvent"
  end)
  let window_id = field t "windowID" uint32_t
  let code = field t "code" int32_t
  let _ = field t "data1" (ptr void)
  let _ = field t "data2" (ptr void)

  let to_event_type e = F.Sdl_event_type.SDL_USEREVENT (Int32.of_int e.code)

  let to_ocaml e = {
    timestamp = timestamp_to_ocaml e timestamp;
    window_id = getf e window_id |> Unsigned.UInt32.to_int32;
    code = getf e code |> Signed.Int32.to_int
  }

  let of_ocaml e =
    let s = make t in
    to_event_type e |> type_of_ocaml |> setf s event_type;
    timestamp_of_ocaml e.timestamp |> setf s timestamp;
    Unsigned.UInt32.of_int32 e.window_id |> setf s window_id;
    Signed.Int32.of_int e.code |> setf s code;
    s
end

type t =
    ControllerAxis of ControllerAxisEvent.t
  | ControllerButton of ControllerButtonEvent.t
  | ControllerDevice of ControllerDeviceEvent.t
  | DollarGesture of DollarGestureEvent.t
  | Drop of DropEvent.t
  | JoyAxis of JoyAxisEvent.t
  | JoyBall of JoyBallEvent.t
  | JoyDevice of JoyDeviceEvent.t
  | JoyButton of JoyButtonEvent.t
  | JoyHat of JoyHatEvent.t
  | Keyboard of KeyboardEvent.t
  | MouseButton of MouseButtonEvent.t
  | MouseMotion of MouseMotionEvent.t
  | MouseWheel of MouseWheelEvent.t
  | MultiGesture of MultiGestureEvent.t
  | Quit of QuitEvent.t
  | SysWM of SysWMEvent.t
  | TextEditing of TextEditingEvent.t
  | TextInput of TextInputEvent.t
  | TouchFinger of TouchFingerEvent.t
  | Window of WindowEvent.t
  | Common of CommonEvent.t
  | AudioDevice of AudioDeviceEvent.t
  | User of UserEvent.t

let t : t union typ = union "SDL_Event"
let event_type = type_field t
let common = field t "common" CommonEvent.t
let window = field t "window" WindowEvent.t
let key = field t "key" KeyboardEvent.t

let edit = field t "edit" TextEditingEvent.t
let text = field t "text" TextInputEvent.t

let motion = field t "motion" MouseMotionEvent.t
let button = field t "button" MouseButtonEvent.t
let wheel = field t "wheel" MouseWheelEvent.t

let jaxis = field t "jaxis" JoyAxisEvent.t
let jball = field t "jball" JoyBallEvent.t
let jhat = field t "jhat" JoyHatEvent.t
let jbutton = field t "jbutton" JoyButtonEvent.t
let jdevice = field t "jdevice" JoyDeviceEvent.t

let caxis = field t "caxis" ControllerAxisEvent.t
let cbutton = field t "cbutton" ControllerButtonEvent.t
let cdevice = field t "cdevice" ControllerDeviceEvent.t

let adevice = field t "adevice" AudioDeviceEvent.t

let quit = field t "quit" QuitEvent.t
let user = field t "user" UserEvent.t
let syswm = field t "syswm" SysWMEvent.t
let tfinger = field t "tfinger" TouchFingerEvent.t
let mgesture = field t "mgesture" MultiGestureEvent.t
let dgesture = field t "dgesture" DollarGestureEvent.t
let drop = field t "drop" DropEvent.t
let _ = field t "padding" (array 56 uint8_t)

(* Convert each event modules to an event structure. *)
let of_ocaml e =
  let s = make t in
  begin
    match e with
    | ControllerAxis e -> ControllerAxisEvent.of_ocaml e |> setf s caxis
    | ControllerButton e -> ControllerButtonEvent.of_ocaml e |> setf s cbutton
    | ControllerDevice e -> ControllerDeviceEvent.of_ocaml e |> setf s cdevice
    | DollarGesture e -> DollarGestureEvent.of_ocaml e |> setf s dgesture
    | Drop e -> DropEvent.of_ocaml e |> setf s drop
    | JoyAxis e -> JoyAxisEvent.of_ocaml e |> setf s jaxis
    | JoyBall e -> JoyBallEvent.of_ocaml e |> setf s jball
    | JoyDevice e -> JoyDeviceEvent.of_ocaml e |> setf s jdevice
    | JoyHat e -> JoyHatEvent.of_ocaml e |> setf s jhat
    | Keyboard e -> KeyboardEvent.of_ocaml e |> setf s key
    | MouseButton e -> MouseButtonEvent.of_ocaml e |> setf s button
    | MouseMotion e -> MouseMotionEvent.of_ocaml e |> setf s motion
    | MouseWheel e -> MouseWheelEvent.of_ocaml e |> setf s wheel
    | MultiGesture e -> MultiGestureEvent.of_ocaml e |> setf s mgesture
    | Quit e -> QuitEvent.of_ocaml e |> setf s quit
    | SysWM e -> SysWMEvent.of_ocaml e |> setf s syswm
    | TextEditing e -> TextEditingEvent.of_ocaml e |> setf s edit
    | TextInput e -> TextInputEvent.of_ocaml e |> setf s text
    | TouchFinger e -> TouchFingerEvent.of_ocaml e |> setf s tfinger
    | Window e -> WindowEvent.of_ocaml e |> setf s window
    | JoyButton e -> JoyButtonEvent.of_ocaml e |> setf s jbutton
    | Common e -> CommonEvent.of_ocaml e |> setf s common
    | AudioDevice e -> AudioDeviceEvent.of_ocaml e |> setf s adevice
    | User e -> UserEvent.of_ocaml e |> setf s user
  end;
  s

let to_ocaml e =
  let open F.Sdl_event_type in
  match type_to_ocaml e event_type with
  | SDL_AUDIODEVICEADDED | SDL_AUDIODEVICEREMOVED ->
     AudioDevice (getf e adevice |> AudioDeviceEvent.to_ocaml)
  | SDL_DROPFILE -> Drop (getf e drop |> DropEvent.to_ocaml)
  | SDL_MULTIGESTURE -> MultiGesture (getf e mgesture |> MultiGestureEvent.to_ocaml)
  | SDL_DOLLARRECORD -> DollarGesture(getf e dgesture |> DollarGestureEvent.to_ocaml)
  | SDL_DOLLARGESTURE -> DollarGesture(getf e dgesture |> DollarGestureEvent.to_ocaml)
  | SDL_FINGERMOTION | SDL_FINGERUP | SDL_FINGERDOWN
    -> TouchFinger(getf e tfinger |> TouchFingerEvent.to_ocaml)
  | SDL_CONTROLLERDEVICEREMAPPED | SDL_CONTROLLERDEVICEREMOVED | SDL_CONTROLLERDEVICEADDED
    -> ControllerDevice (getf e cdevice |> ControllerDeviceEvent.to_ocaml)
  | SDL_CONTROLLERBUTTONUP | SDL_CONTROLLERBUTTONDOWN
    -> ControllerButton(getf e cbutton |> ControllerButtonEvent.to_ocaml)
  | SDL_CONTROLLERAXISMOTION -> ControllerAxis (getf e caxis |> ControllerAxisEvent.to_ocaml)
  | SDL_JOYDEVICEREMOVED | SDL_JOYDEVICEADDED
    -> JoyDevice(getf e jdevice |> JoyDeviceEvent.to_ocaml) 
  | SDL_JOYBUTTONUP | SDL_JOYBUTTONDOWN
      -> JoyButton (getf e jbutton |> JoyButtonEvent.to_ocaml)
  | SDL_JOYHATMOTION -> JoyHat (getf e jhat |> JoyHatEvent.to_ocaml)
  | SDL_JOYBALLMOTION -> JoyBall (getf e jball |> JoyBallEvent.to_ocaml)
  | SDL_JOYAXISMOTION -> JoyAxis (getf e jaxis |> JoyAxisEvent.to_ocaml)
  | SDL_MOUSEWHEEL -> MouseWheel (getf e wheel |> MouseWheelEvent.to_ocaml)
  | SDL_MOUSEBUTTONUP | SDL_MOUSEBUTTONDOWN
    -> MouseButton (getf e button |> MouseButtonEvent.to_ocaml)
  | SDL_MOUSEMOTION -> MouseMotion (getf e motion |> MouseMotionEvent.to_ocaml)
  | SDL_TEXTINPUT -> TextInput (getf e text |> TextInputEvent.to_ocaml)
  | SDL_TEXTEDITING -> TextEditing (getf e edit |> TextEditingEvent.to_ocaml)
  | SDL_KEYUP | SDL_KEYDOWN
    -> Keyboard (getf e key |> KeyboardEvent.to_ocaml)
  | SDL_SYSWMEVENT -> SysWM (getf e syswm |> SysWMEvent.to_ocaml)
  | SDL_WINDOWEVENT -> Window (getf e window |> WindowEvent.to_ocaml)
  | SDL_QUIT -> Quit (getf e quit |> QuitEvent.to_ocaml)
  | SDL_USEREVENT _ -> User (getf e user |> UserEvent.to_ocaml)
  | _ -> Common (getf e common |> CommonEvent.to_ocaml)

let () =
  seal ControllerAxisEvent.t;
  seal ControllerButtonEvent.t;
  seal ControllerDeviceEvent.t;
  seal DollarGestureEvent.t;
  seal DropEvent.t;
  seal JoyAxisEvent.t;
  seal JoyBallEvent.t;
  seal JoyButtonEvent.t;
  seal JoyDeviceEvent.t;
  seal JoyHatEvent.t;
  seal KeyboardEvent.t;
  seal MouseButtonEvent.t;
  seal MouseMotionEvent.t;
  seal MouseWheelEvent.t;
  seal MultiGestureEvent.t;
  seal QuitEvent.t;
  seal SysWMEvent.t;
  seal TextEditingEvent.t;
  seal TextInputEvent.t;
  seal TouchFingerEvent.t;
  seal WindowEvent.t;
  seal CommonEvent.t;
  seal AudioDeviceEvent.t;
  seal UserEvent.t;

  seal t
