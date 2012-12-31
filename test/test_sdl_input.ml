open Sdlcaml
open OUnit

let test_set_up _ =
  Sdl_init.init [`VIDEO] ()

let test_tear_down _ =
  Sdl_init.quit ()

let test_get_key_state _ =
  let open Sdl_input in
  let statemap = get_key_state () in
  let key_check k =
    match k with
    | false -> ()
    | true -> assert_failure "hoge"
  in
  Sdl_key.StateMap.iter statemap key_check

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

let tmp_bracket f = bracket test_set_up f test_tear_down

let suite = "SDL input functions specs" >::: [
  "get key states" >:: (tmp_bracket test_get_key_state);
  "get mod key states" >:: (tmp_bracket test_get_mod_state);
  "modify mod key states" >:: (tmp_bracket test_modify_mod_state);
]


let _ =
  run_test_tt_main suite
