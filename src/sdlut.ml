module Input = Sdl_input
module Joystick = Sdl_joystick
module Event = Sdl_event
module Key = Sdl_key
module Mouse = Sdl_mouse
module Timer = Sdl_timer
module Window = Sdl_window

exception Game_loop_exit

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

type axis_mapping = {
  axis:Joystick.axis;
  capacity:int;
  key:Sdl_key.key_synonym
}

type button = int

type key_mapping = Sdl_key.key_synonym * button

type input_state = Button of button | Key of Sdl_key.key_synonym

module AxisMap = Map.Make (
  struct
    type t = Joystick.axis
    let compare = compare
  end
)

module IntMap = Extlib.Std.Map.Poly

type input_info_real = {
  info_id:int;
  (* made joysticks by Sdl_joystick *)
  joy_struct:Joystick.joystick option;

  (* map that key is axis and value is list of axis_mapping  *)
  axis_maps:(Joystick.axis, axis_mapping list) Hashtbl.t;
  (* map that key is keyboard key and value is joystick buttons *)
  key_maps:(Sdl_key.key_synonym, button list) Hashtbl.t;
  (* map that key is keyboard key and value is joystick buttons *)
  button_maps:(button, Sdl_key.key_synonym list) Hashtbl.t;

  (* each states to save *)
  button_state: (button, bool) Hashtbl.t;
  axis_state: (Joystick.axis, int) Hashtbl.t;
  key_state: (Sdl_key.key_synonym, bool) Hashtbl.t;
}

type input_info = input_info_real ref

type input_callback_func_type = (info:input_info -> unit)

type active_func_type   = state:Event.app_state list -> gain:bool -> unit
type keyboard_func_type = key:Key.key_info -> state:bool -> unit
type mouse_func_type    = button:Mouse.button -> x:int -> y:int -> state:bool -> unit
type motion_func_type   = x:int -> y:int -> xrel:int -> yrel:int -> states:Mouse.mouse_button_state list -> unit
type joystick_func_type = num:int -> x:int -> y:int -> z:int -> masks:Joystick.button list -> unit
type resize_func_type   = width:int -> height:int -> unit
type expose_func_type   = unit -> unit
type display_func_type  = unit -> unit
type move_func_type     = unit -> unit
type quit_func_type     = unit -> bool

(* default callback functions *)
let default_active_func:active_func_type   = (fun ~state ~gain -> ())
let default_keyboard_func:keyboard_func_type = (fun ~key ~state -> ())
let default_mouse_func:mouse_func_type    = (fun ~button ~x ~y ~state -> ())
let default_motion_func:motion_func_type   = (fun ~x ~y ~xrel ~yrel ~states -> ())
let default_joystick_func:joystick_func_type = (fun ~num ~x ~y ~z ~masks -> ())
let default_resize_func:resize_func_type   = (fun ~width ~height -> ())
let default_expose_func:expose_func_type   = (fun _ -> ())
let default_display_func:display_func_type  = (fun _ -> ())
let default_move_func:move_func_type     = (fun _ -> ())
let default_quit_func:quit_func_type     = (fun _ -> false)

(* callback function warehouse *)
let active_callback_func   = ref default_active_func
let keyboard_callback_func = ref default_keyboard_func
let mouse_callback_func    = ref default_mouse_func
let motion_callback_func   = ref default_motion_func
let joystick_callback_func = ref default_joystick_func
let resize_callback_func   = ref default_resize_func
let expose_callback_func   = ref default_expose_func
let display_callback_func  = ref default_display_func
let move_callback_func     = ref default_move_func
let quit_callback_func     = ref default_quit_func

let input_callback_funcs:(int, input_callback_func_type * input_info) IntMap.t ref
    = ref IntMap.empty

(* Counting fps for to managed by Sdlut *)
let global_fps = ref 0

(* initialize Sdlut *)
let ignore_events etypes =
  let func etype = ignore (Event.event_state ~etype ~state:Event.IGNORE) in
  List.iter func etypes

let enable_events etypes =
  let func etype = ignore (Event.event_state ~etype ~state:Event.ENABLE) in
  List.iter func etypes

let init ?auto_clean:(auto_clean=true) ~flags =
  Sdl_init.init ~auto_clean ~flags;
  ignore_events [
    Event.ACTIVEEVENT;
    Event.KEYDOWN;
    Event.KEYUP;
    Event.MOUSEMOTION;
    Event.MOUSEBUTTONDOWN;
    Event.MOUSEBUTTONUP;
    Event.JOYAXISMOTION;
    Event.JOYBALLMOTION;
    Event.JOYHATMOTION;
    Event.JOYBUTTONDOWN;
    Event.JOYBUTTONUP;
    Event.VIDEORESIZE;
    Event.VIDEOEXPOSE;
  ]

(* callback functions register and unregister *)

let unregister_callback ~callback =
  let remove_function = function
    | Active -> active_callback_func := default_active_func;
      ignore_events [Event.ACTIVEEVENT]
    | Keyboard -> keyboard_callback_func := default_keyboard_func;
      ignore_events [Event.KEYDOWN;Event.KEYUP];
    | Mouse -> mouse_callback_func := default_mouse_func;
      ignore_events [Event.MOUSEBUTTONDOWN;Event.MOUSEBUTTONUP];
    | Motion -> motion_callback_func := default_motion_func;
      ignore_events [Event.MOUSEMOTION];
    | Joystick -> joystick_callback_func := default_joystick_func;
      ignore_events [Event.JOYAXISMOTION;Event.JOYBALLMOTION;
                     Event.JOYHATMOTION; Event.JOYBUTTONDOWN;
                     Event.JOYBUTTONDOWN];
    | Resize -> resize_callback_func := default_resize_func;
      ignore_events [Event.VIDEORESIZE];
    | Expose -> expose_callback_func := default_expose_func;
      ignore_events [Event.VIDEOEXPOSE];
    | Display -> display_callback_func := default_display_func
    | Move -> move_callback_func := default_move_func
    | Quit -> quit_callback_func := default_quit_func
  in
  List.iter remove_function callback

let active_callback ~func = active_callback_func := func;
  enable_events [Event.ACTIVEEVENT]
let keyboard_callback ~func = keyboard_callback_func := func;
  enable_events [Event.KEYDOWN; Event.KEYUP]
let mouse_callback ~func = mouse_callback_func := func;
  enable_events [Event.MOUSEBUTTONDOWN; Event.MOUSEBUTTONUP]
let motion_callback ~func = motion_callback_func := func;
  enable_events [Event.MOUSEMOTION]
let joystick_callback ~func = joystick_callback_func := func;
  enable_events [Event.JOYAXISMOTION;Event.JOYBALLMOTION;
                 Event.JOYHATMOTION; Event.JOYBUTTONDOWN;
                 Event.JOYBUTTONDOWN]
let resize_callback ~func = resize_callback_func := func;
  enable_events [Event.VIDEORESIZE]
let expose_callback ~func = expose_callback_func := func;
  enable_events [Event.VIDEOEXPOSE]
let display_callback ~func = display_callback_func := func
let move_callback ~func = move_callback_func := func
let quit_callback ~func = quit_callback_func := func

(* synchronize each states which are keys, buttons, and axes. *)
let sync_bindings info =
  let replace_if_exists tbl key v =
    if Hashtbl.mem tbl key then Hashtbl.replace tbl key v else () in
  let sync_each_tbl fromtbl totbl map =
    let open Extlib.Std.Option.Open in
    Hashtbl.iter (fun key buttons ->
      let state = try Some (Hashtbl.find fromtbl key) with Not_found -> None in
      ignore (
        state >>= (fun state ->
          return (List.iter (fun x ->
            let state = state || (try Hashtbl.find totbl x with _ -> false) in
            replace_if_exists totbl x state) buttons))
      )
    ) map in

  (* key states synchronize button states *)
  sync_each_tbl info.key_state info.button_state info.key_maps;

  (* button states synchronize key states *)
  sync_each_tbl info.button_state info.key_state info.button_maps;

  (* axis states synchronize key states *)
  let open Extlib.Std.Option.Open in
  Hashtbl.iter (fun key mapping ->
    let state = try Some (Hashtbl.find info.axis_state key) with Not_found -> None in
    ignore (
      state >>= (fun state ->
        return (List.iter (fun x ->
          if x.capacity < state then
            replace_if_exists info.key_state x.key true
          else ()) mapping))
    )
  ) info.axis_maps


(* update input informations for all current input_info *)
let update_input_infos () =
  let update_info (func, info) =
    let key_states = Input.get_key_state () in
    begin
      (* update keys that all state of keys by to get SDL *)
      Sdl_key.StateMap.iter (Hashtbl.replace !info.key_state) key_states;

      (* update buttons *)
      let open Extlib.Std.Option.Open in
      (* runs monad with option *)
      ignore (!info.joy_struct >>= (fun joy ->
        let buttons = Joystick.get_button_all joy in
        return (List.iter (fun (k,v) -> Hashtbl.replace !info.button_state k v) buttons)));

      (* update axes *)
      let open Extlib.Std.Option.Open in
      ignore (!info.joy_struct >>= (fun joy ->
        return (Joystick.get_axis_all joy)) >>= (fun axes ->
          return (List.iter (fun (k, v) -> Hashtbl.replace !info.axis_state k v) axes)));
      sync_bindings !info;
    end in
  IntMap.iter !input_callback_funcs update_info

let event_dispatch () =
  let rec polling = function
    | Some ev ->
      let open Event in
      begin
        match ev with
        | Active {gain;active_state} -> !active_callback_func ~state:active_state ~gain:gain
        | KeyDown {keysym;key_state} -> !keyboard_callback_func ~key:keysym ~state:key_state
        | KeyUp {keysym;key_state} -> !keyboard_callback_func ~key:keysym ~state:key_state
        | Motion ev -> !motion_callback_func ~x:ev.motion_x ~y:ev.motion_y
          ~xrel:ev.motion_xrel ~yrel:ev.motion_yrel ~states:ev.motion_states
        | ButtonDown ev -> !mouse_callback_func ~x:ev.mouse_x ~y:ev.mouse_y
          ~button:ev.mouse_button ~state:ev.mouse_state
        | ButtonUp ev -> !mouse_callback_func ~x:ev.mouse_x ~y:ev.mouse_y
          ~button:ev.mouse_button ~state:ev.mouse_state
        | Resize {width;height} -> !resize_callback_func width height
        | Expose -> !expose_callback_func ()
        | Quit -> if !quit_callback_func () then raise Game_loop_exit else ()
        | _ -> ();
        polling (Event.poll_event ());
      end
    | None -> () in
  begin
    polling (Event.poll_event ());
    (* check joystick event *)
    Joystick.update ();
    update_input_infos ();
    IntMap.iteri !input_callback_funcs (fun ~key ~data:(func,info) -> func ~info);
  end

(* input management *)

let integrate_inputs ~id ~num ~axis_map ~key_map =
  let make_axis_map axis_map =
    let axes = List.map (fun {axis;_} -> axis) axis_map in
    let add_axis target axis =
      let related = List.filter (fun s -> s.axis = axis) axis_map in
      Hashtbl.add target axis related;
      target in
    List.fold_left add_axis (Hashtbl.create 10) axes in

  let make_key_map key_map =
    let keys = List.map fst key_map in
    let add_key target key =
      let related = List.map snd (List.filter (fun (k,_) -> k = key) key_map) in
      Hashtbl.add target key related;
      target in
    List.fold_left add_key (Hashtbl.create 10) keys in

  let make_button_map key_map =
    let keys = List.map snd key_map in
    let add_key target key =
      let related = List.map fst (List.filter (fun (_,b) -> b = key) key_map) in
      Hashtbl.add target key related;
      target in
    List.fold_left add_key (Hashtbl.create 10) keys in

  let make_hashtbl list init =
    List.fold_left (fun tbl key -> Hashtbl.add tbl key init; tbl)
      (Hashtbl.create 10) list in

  let make_struct joy =
    { info_id = id;
      joy_struct = joy;
      axis_maps = make_axis_map axis_map;
      key_maps = make_key_map key_map;
      button_maps = make_button_map key_map;

      button_state = make_hashtbl (List.map snd key_map) false;
      axis_state = make_hashtbl (List.map (fun {axis;_} -> axis) axis_map) 0;
      key_state = make_hashtbl (List.map fst key_map) false;
    } in
  ref (make_struct (Joystick.joystick_open num))

let input_close info =
  match !info.joy_struct with
  | Some joy -> Joystick.joystick_close joy
  | None -> ()

let add_input_callback ~info ~func =
  input_callback_funcs := IntMap.add !input_callback_funcs !info.info_id (func, info);
  keyboard_callback_func := default_keyboard_func;
  joystick_callback_func := default_joystick_func

let remove_input_callback info =
  input_callback_funcs := IntMap.remove !input_callback_funcs !info.info_id

let correct_states ~info ~states ~pred =
  let input_pressed state =
    match state with
    | `Button (btn:int) ->
      begin
        try
          if pred (Hashtbl.find !info.button_state btn) then
            Some (Button btn)
          else None
        with Not_found -> None
      end
    | `Key key ->
      begin
        try
          if pred (Hashtbl.find !info.key_state key) then
            Some (Key key)
          else None
        with Not_found -> None
      end
  in
  let merge_state list = function
    | Some x -> x :: list
    | None -> list
  in
  List.fold_left merge_state [] (List.map input_pressed states)

let get_pressed ~info ~states =
  correct_states ~info ~states ~pred:Extlib.Prelude.id

let get_released ~info ~states =
  correct_states ~info ~states ~pred:not

(* all status extract as key and button state *)
let extract_all_states info pred =
  let button_states =
    let filter k e l = if pred e then (Button k) :: l else l in
    Hashtbl.fold filter !info.button_state []
  in
  let key_states =
    let filter k e l = if pred e then (Key k) :: l else l in
    Hashtbl.fold filter !info.key_state []
  in
  button_states @ key_states

let get_all_pressed info = extract_all_states info Extlib.Prelude.id
let get_all_released info = extract_all_states info not

let axis_state ~info ~state =
  try Hashtbl.find !info.axis_state state with Not_found -> 0

let force_update = update_input_infos

(* implementation of main loop *)
let game_loop ?fps:(fps=60) ?skip:(skip=true) () =
  let ms_per_sec = 1000 * 100 / (fps)
  and reminder_of_loop = ref 0
  and count_a_second = ref 0
  and count_frame = ref 0
  and seconds_as_ms = 1000 in
  let update_counts () =
    if !count_a_second > seconds_as_ms then begin
        global_fps := !count_frame;
        count_frame := 0;
        count_a_second := 0;
    end
  and waits_reminder diff =
    reminder_of_loop := !reminder_of_loop + ms_per_sec;
    let this_time_delay = !reminder_of_loop / 100 - diff in
    reminder_of_loop := (!reminder_of_loop mod 100);
    count_a_second := !count_a_second + diff + this_time_delay;
    Timer.delay this_time_delay in
  let delay_current_loop start =
    let diff = (Timer.get_ticks ()) - start in
    if diff * 100 > ms_per_sec then begin
      count_a_second := !count_a_second + diff;
      true
    end else begin
      waits_reminder diff;
      false
    end in

  let rec mainloop skip_this_loop =
    let start = Timer.get_ticks () in
    begin
      update_counts ();

      event_dispatch ();

      !move_callback_func ();

      (* skip current calling display function if previous loop is too delay *)
      if not skip_this_loop then begin
        count_frame := succ !count_frame;
        !display_callback_func ();
      end;

      let skip_next_loop = delay_current_loop start in
      mainloop skip_next_loop;
    end in
  try
    mainloop false
  with Game_loop_exit -> ()

let force_exit_game_loop () = raise Game_loop_exit

let current_fps () = !global_fps
