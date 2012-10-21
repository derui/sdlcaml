open Sdlcaml
open OUnit

let test_set_up _ =
  Sdl_init.init [`VIDEO]

let test_tear_down _ =
  Sdl_init.quit ()

let test_mouse_state _ =
  let open Sdl_mouse in
  let mouse_state = get_mouse_state () in
  let pressed {state;index} = state in
  begin
    assert_bool "valid X coordinate of mouse" (mouse_state.x >= 0);
    assert_bool "valid Y coordinate of mouse" (mouse_state.y >= 0);
    assert_bool "there is no pressed mouse button"
      (List.for_all pressed (mouse_state.button_states));
  end

let tmp_bracket f = bracket test_set_up f test_tear_down

let suite = "SDL mouse functions specs" >::: [
  "getting mouse state " >:: (tmp_bracket test_mouse_state);
]


let _ =
  run_test_tt_main suite
