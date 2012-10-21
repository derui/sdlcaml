open Sdlcaml
open OUnit

let test_set_up _ =
  Sdl_init.init [`JOYSTICK]

let test_tear_down _ =
  Sdl_init.quit ()

let test_joystick_prev_get _ =
  begin
    assert_equal 0 (Sdl_joystick.get_num ()) ~msg:"get num";
    assert_equal "" (Sdl_joystick.get_name 0) ~msg:"get name";
    match (Sdl_joystick.joystick_open 0) with
    | Some _ -> assert_failure "unrecognized result";
    | None -> ();
      assert_equal false (Sdl_joystick.opened 0) ~msg:"opened";
  end

let tmp_bracket f = bracket test_set_up f test_tear_down

let suite = "SDL Joystick system specs" >:::
  [
    "get joystick info" >:: (tmp_bracket test_joystick_prev_get)
  ]

let _ =
  run_test_tt_main suite
