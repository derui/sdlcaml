open Sdlcaml
open OUnit

let test_set_up _ =
  Sdl_init.init [`CDROM]

let test_tear_down _ =
  Sdl_init.quit ()

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
          let info = get_info cd in
          ignore (status cd);
          if info.numtracks > 0 then begin
            assert_bool "play cd failed" (play ~cd ~start:0
                                            ~length:0);
            assert_bool "play cd track failed"
              (play_tracks ~cd ~track:1 ~frame:0 ~ntracks:1
                 ~nframes:1);
          end;
          assert_bool "can't pause" (pause cd);
          assert_bool "can't resume" (resume cd);
          assert_bool "can't stop" (stop cd);
          close cd;
        end
    end
  else
    Printf.printf "don't have any CDROM Drives"

let test_cdrom_infomations _ =
  let open Sdl_cdrom in
  if has_drive () then
    match cd_open 0 with
    | None -> assert_failure "can't open drive"
    | Some cd ->
      if in_drive cd then
        begin
          let info = get_info cd in
          begin
            assert_bool "tracks must be more than 1" (info.numtracks
                                                      > 0);
            assert_equal 0 info.current_track;
            assert_equal 0 info.current_frame;
          end;
          let tracks = track_status cd in
          begin
            assert_bool "tracks must have more than 1"
              ((List.length tracks) > 0);
            assert_equal AUDIO_TRACK ((List.hd tracks).track_type);
          end;
          close cd;
        end;

  else
    Printf.printf "have no drives on system..."


let tmp_bracket f = bracket test_set_up f test_tear_down

let suite = "SDL CDROM functions specs" >::: [
  "basic functions" >:: (tmp_bracket test_cdrom_basic_operations);
  "get infomatinos" >:: (tmp_bracket test_cdrom_infomations);
]

let _ =
  run_test_tt_main suite
