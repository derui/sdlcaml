open Sdlcaml
open OUnit

let test_set_up _ =
  Sdl.init [`VIDEO]

let test_tear_down _ =
  Sdl.quit ()

let test_get_key_state _ =
  let open Sdl_input in
  let statemap = get_key_state () in
  let key_check _ k =
    match k with
      | `RELEASED -> ()
      | `PRESSED -> assert_failure "hoge"
    in
  Sdl_key.StateMap.iter key_check statemap

let test_get_mod_state _ =
  let open Sdl_input in
  let mod_state_list = get_mod_state () in
  assert_equal [] mod_state_list

let test_modify_mod_state _ =
  let open Sdl_input in
  begin
    assert_equal [] (get_mod_state ());
    set_mod_state [Sdl_key.KMOD_NUM ; Sdl_key.KMOD_CAPS];
    let mod_state = get_mod_state ()
    and key_check l = l = Sdl_key.KMOD_NUM || l = Sdl_key.KMOD_CAPS in
    assert_bool "check setted modifier keys" (List.for_all key_check
  mod_state);
  end

let test_enable_key_state _ =
  assert_bool "enable repeat" (Sdl_input.enable_key_repeat ~delay:10
  ~interval:200)

let test_mouse_state _ =
  let open Sdl_input in
  let mouse_state = Sdl_input.get_mouse_state () in
  let pressed {state;index} =
    match state with
        `RELEASED -> true
      | `PRESSED -> false
  in
  begin
    assert_bool "valid X coordinate of mouse" (mouse_state.x >= 0);
    assert_bool "valid Y coordinate of mouse" (mouse_state.y >= 0);
    assert_bool "there is no pressed mouse button"
      (List.for_all pressed (mouse_state.button_states));
  end

let tmp_bracket f = bracket test_set_up f test_tear_down

let suite = "SDL input functions specs" >::: [
  "get key states" >:: (tmp_bracket test_get_key_state);
  "get mod key states" >:: (tmp_bracket test_get_mod_state);
  "modify mod key states" >:: (tmp_bracket test_modify_mod_state);
  "getting mouse state " >:: (tmp_bracket test_mouse_state);
]


let _ =
  run_test_tt_main suite
