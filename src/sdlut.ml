module Input = Sdl_input
module Joystick = Sdl_joystick
module Event = Sdl_event
module Key = Sdl_key
module Mouse = Sdl_mouse
module Timer = Sdl_timer

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

type axis_mapping = {
  axis:Joystick.axis;
  capacity:int;
  key:Sdl_key.key_synonym
}

type button = int

type key_mapping = Sdl_key.key_synonym * button

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

type input_state = [
| `Key of Sdl_key.key_synonym
| `Button of int
| `Axis of Joystick.axis
]

type input_callback_func_type = (info:input_info -> unit)

type active_func_type   = state:Event.app_state list -> gain:bool -> unit
type keyboard_func_type = key:Key.key_info -> state:bool -> unit
type mouse_func_type    = button:Mouse.button -> x:int -> y:int -> state:bool -> unit
type motion_func_type   = x:int -> y:int -> xrel:int -> yrel:int -> unit
type joystick_func_type = num:int -> x:int -> y:int -> z:int -> masks:Joystick.button list -> unit
type resize_func_type   = width:int -> height:int -> unit
type expose_func_type   = unit -> unit
type display_func_type  = unit -> unit
type move_func_type     = unit -> unit

(* default callback functions *)
let default_active_func:active_func_type   = (fun ~state ~gain -> ())
let default_keyboard_func:keyboard_func_type = (fun ~key ~state -> ())
let default_mouse_func:mouse_func_type    = (fun ~button ~x ~y ~state -> ())
let default_motion_func:motion_func_type   = (fun ~x ~y ~xrel ~yrel -> ())
let default_joystick_func:joystick_func_type = (fun ~num ~x ~y ~z ~masks -> ())
let default_resize_func:resize_func_type   = (fun ~width ~height -> ())
let default_expose_func:expose_func_type   = (fun _ -> ())
let default_display_func:display_func_type  = (fun _ -> ())
let default_move_func:move_func_type     = (fun _ -> ())

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

let input_callback_funcs:(int, input_callback_func_type * input_info) IntMap.t ref
    = ref IntMap.empty

(* callback functions register and unregister *)

let unregister_callback ~callback =
  let remove_function = function
    | Active -> active_callback_func := default_active_func
    | Keyboard -> keyboard_callback_func := default_keyboard_func
    | Mouse -> mouse_callback_func := default_mouse_func
    | Motion -> motion_callback_func := default_motion_func
    | Joystick -> joystick_callback_func := default_joystick_func
    | Resize -> resize_callback_func := default_resize_func
    | Expose -> expose_callback_func := default_expose_func
    | Display -> display_callback_func := default_display_func
    | Move -> move_callback_func := default_move_func
  in
  List.iter remove_function callback

let active_callback ~func = active_callback_func := func
let keyboard_callback ~func = keyboard_callback_func := func
let mouse_callback ~func = mouse_callback_func := func
let motion_callback ~func = motion_callback_func := func
let joystick_callback ~func = joystick_callback_func := func
let resize_callback ~func = resize_callback_func := func
let expose_callback ~func = expose_callback_func := func
let display_callback ~func = display_callback_func := func
let move_callback ~func = move_callback_func := func

(* update input informations for all current input_info *)
let update_input_infos () =
  let key_states = Input.get_key_state () in
  let update_hashtbl_with_list tbl list =
    List.iter (fun (key, state) ->
      if not (Hashtbl.mem tbl key) then
        Hashtbl.replace tbl key state) list
  in
  let update_info (func, info) =
    begin
      (* update keys *)
      Sdl_key.StateMap.iter (fun key state ->
        if not (Hashtbl.mem !info.key_state key) then
          Hashtbl.replace !info.key_state key state) key_states;
      (* update binding buttons to keys *)
      Sdl_key.StateMap.iter (fun key state ->
        try
          let lst = Hashtbl.find !info.key_maps key in
          List.iter (fun key ->
            Hashtbl.replace !info.button_state key state) lst
        with Not_found -> ()
      ) key_states;

      (* update buttons *)
      let open Extlib.Std.Option.Open in
      (* runs monad with option *)
      ignore (!info.joy_struct >>= (fun joy ->
        let buttons = Joystick.get_button_all joy in
        (update_hashtbl_with_list !info.button_state buttons);
        Extlib.Std.Option.return buttons)

        >>= (fun buttons ->       (* update binding keys to buttons *)
          List.iter (fun (button, state) ->
            try
              let lst = Hashtbl.find !info.button_maps button in
              List.iter (fun key ->
                Hashtbl.replace !info.key_state key state) lst
            with Not_found -> ()
          ) buttons;
          Extlib.Std.Option.return ()));

      (* update axes *)
      let open Extlib.Std.Option.Open in
      ignore (!info.joy_struct >>= (fun joy ->
        Extlib.Std.Option.return (Joystick.get_axis_all joy))
        >>= (fun axes ->
          update_hashtbl_with_list !info.axis_state axes;
          (* update bindings *)
          Extlib.Std.Option.return (List.iter (fun (key, state) ->
            try
              let lst = Hashtbl.find !info.axis_maps key in
              List.iter (fun {key;capacity;_} ->
                let is_over = state >= capacity in
                Hashtbl.replace !info.key_state key is_over
              ) lst
            with Not_found -> ()
          ) axes)));
      (func, info)
    end in
  input_callback_funcs := IntMap.map !input_callback_funcs update_info

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
          ~xrel:ev.motion_xrel ~yrel:ev.motion_yrel
        | ButtonDown ev -> !mouse_callback_func ~x:ev.mouse_x ~y:ev.mouse_y
                             ~button:ev.mouse_button ~state:ev.mouse_state
        | ButtonUp ev -> !mouse_callback_func ~x:ev.mouse_x ~y:ev.mouse_y
                           ~button:ev.mouse_button ~state:ev.mouse_state
        | Resize {width;height} ->
          !resize_callback_func width height
        | Expose -> !expose_callback_func ()
        | Quit -> raise Game_loop_exit
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
    List.fold_left (fun tbl key ->
        begin
          Hashtbl.add tbl key init;
          tbl;
        end)
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

let is_pressed ~info ~state =
  match state with
  | `Button (btn:int) ->
    begin
      try Hashtbl.find !info.button_state btn with Not_found -> false
    end
  | `Key key ->
    begin
      try Hashtbl.find !info.key_state key with Not_found -> false
    end

let is_released ~info ~state = not (is_pressed ~info ~state)

let axis_state ~info ~state =
  match state with
  | `Axis axis ->
    try Hashtbl.find !info.axis_state axis with Not_found -> 0

let force_update = update_input_infos

(* main loop implementation *)

let game_loop ?fps:(fps=60) ?skip:(skip=true) () =
  let ms_per_sec = 1000 * 100 / (fps)
  and reminder_of_loop = ref 0 in

  let rec mainloop skip_this_loop =
    let start = Timer.get_ticks () in
    begin
      event_dispatch ();

      !move_callback_func ();

      if not skip_this_loop then
        !display_callback_func ();

      (* wait fps *)
      let diff = (Timer.get_ticks ()) - start in
      if diff * 100 > ms_per_sec then
        mainloop true
      else begin
        reminder_of_loop := !reminder_of_loop + ms_per_sec;
        let this_time_delay = !reminder_of_loop / 100 in
        reminder_of_loop := (!reminder_of_loop mod 100);
        Timer.delay this_time_delay;
        mainloop false;
      end
    end in
  try
    mainloop false
   with Game_loop_exit -> ()

let force_exit_game_loop () = raise Game_loop_exit
