open Sdlcaml
open OUnit

let test_set_up _ =
  Sdl.init [`VIDEO]

let test_tear_down _ =
  Sdl.quit ()

let test_cdrom_basic_operations _ =
  let open Sdl_cdrom in
  let num = num_drives () in
  if num > 0 then
    begin
      assert_bool "name mustn't be empty" ((Sdl_cdrom.name 0) <> "");
      let cd = cd_open 0 in
      match cd with
        | None -> assert_failure "can't open CDROM Drive"
        | Some cd ->
          begin
            assert_equal TRAYEMPTY (status cd);
            assert_bool "play cd failed" (play ~cd ~start:0
                                            ~length:0);
            assert_bool "play cd track failed"
              (play_tracks ~cd ~track:1 ~frame:0 ~ntracks:1
                 ~nframes:1);
            assert_bool "can't pause" (pause cd);
            assert_bool "can't resume" (resume cd);
            assert_bool "can't stop" (stop cd);
            assert_bool "can't eject drive" (eject cd);
            close cd;
          end
    end
  else
    Printf.printf "don't have any CDROM Drives"

let tmp_bracket f = bracket test_set_up f test_tear_down

let suite = "SDL CDROM functions specs" >::: [
  "basic functions" >:: (tmp_bracket test_cdrom_basic_operations);
]

let _ =
  run_test_tt_main suite
