open Sdlcaml
open OUnit
open Baselib

let test_set_up _ =
  Sdl_init.init [`AUDIO]

let test_tear_down _ =
  Sdl_init.quit ()

let test_mixer_initialize _ =
  let open Sdl_mixer in
  begin
    let (major, minor, patch) = compile_version ()
    in assert_bool "valid version" (major >= 0 && minor >= 0 && patch
                                    >= 0);
    let (major, minor, patch) = linked_version ()
    in assert_bool "valid linked version" (major >= 0 && minor >= 0 && patch
                                           >= 0);
    let inited = init [`OGG] in
    assert_equal 1 (List.length inited);
    let opened = open_audio ~freq:44100 ~format:AUDIO_U8
      ~channels:2 ~chunk:1024 in
    begin
      match opened with
      | Either.Left s -> assert_failure s
      | Either.Right _ -> ()
    end;

    match query_spec () with
    | None -> assert_failure "can't get any spec";
    | Some (freq, format, channels) ->
      begin
        assert_equal 44100 freq;
        assert_equal AUDIO_U8 format;
        assert_equal 2 channels;
      end;

      close ();
      quit ();
  end

let test_mixer_chunk _ =
  let open Sdl_mixer in
  begin
    ignore (init [`OGG]);
    ignore (open_audio ~freq:44100 ~format:AUDIO_U16LSB
              ~channels:2 ~chunk:1024);

    let decoders = get_num_chunk_decoders () in
    assert_bool "decoder should have more than 0" (decoders >= 0);
    if decoders > 0 then
      assert_bool "some decoder name gotten" ((get_chunk_decoder 0) <> "");

    close ();
    quit ();
  end

let test_mixer_load_wav _ =
  let open Sdl_mixer in
  begin
    ignore (init [`OGG]);
    ignore (open_audio ~freq:44100 ~format:AUDIO_U16LSB
              ~channels:2 ~chunk:1024);
    let fname = "Once.wav" in
    if Sys.file_exists fname then begin
      let m = load_wav fname in
      match m with
        | Either.Left s -> assert_failure (Printf.sprintf "load_wav failed : %s" s);
        | Either.Right ch -> begin
          assert_bool "volume changeable" ((volume_chunk ~chunk:ch
                                              ~volume:10) > 0);
          free_chunk ch;
        end;

    end;
    close ();
    quit ();
  end

let test_mixer_channels _ =
  let open Sdl_mixer in
  begin
    assert_equal 1 (List.length (init [`OGG]));
    ignore (open_audio ~freq:44100 ~format:AUDIO_S16LSB
              ~channels:2 ~chunk:1024);

    assert_equal 2 (allocate_channels 2);
    let vol = volume ~channel:(`Channel 1) ~volume:100 in
    assert_bool "a channel change volume" (vol = 128);
    assert_bool "all channels changes volume"
      ((volume ~channel:(`All) ~volume:100) > 0);

    let fname = "battle001.wav" in
    if Sys.file_exists fname then begin
      let ch = load_wav fname in
      match ch with
        | Either.Left s -> assert_failure (Printf.sprintf "load_wav failed : %s" s);
        | Either.Right ch -> begin
          let p =  play_channel ~channel:(`Channel 1) ~chunk:ch
            ~loops:(-1) () in
          match p with
              Either.Left s -> assert_failure (Printf.sprintf "play_channel
    failed : %s" s)
            | Either.Right _ -> ();
              assert_bool "playing now" (playing (`Channel 1));
              pause (`Channel 1);
              assert_bool "pause now" (paused (`Channel 1));
              assert_bool "get chunk" (Option.is_some
                                         (get_chunk (`Channel 1)));
              resume (`Channel 1);
              halt_channel (`Channel 1);
              ignore (fadeout_channel (`Channel 1) 100);
              free_chunk ch;
        end;
    end;

    close ();
    quit ();
  end


let test_mixer_groups _ =
  let open Sdl_mixer in
  begin
    assert_equal 1 (List.length (init [`OGG]));
    ignore (open_audio ~freq:44100 ~format:AUDIO_S16LSB
              ~channels:2 ~chunk:1024);

    assert_bool "group channel setting" (group_channel
                                           ~which:(`Channel 1)
                                           ~tag:1);
    assert_equal 2
      (group_channels ~from_to:(`Channel 0, `Channel 1) ~tag:1)
      ~msg:"group channels failed";

    assert_equal 2 (group_count 1);
    match group_available 1 with
    | Some _ -> assert_failure "not found avaliable group";
    | None -> ();
      match group_oldest 1 with
      | Some _ -> assert_failure "not found oldest in group";
      | None -> ();

        match group_newer 1 with
        | Some _ -> assert_failure "not found newer in group";
        | None -> ();

          halt_group 1;
          close ();
          quit ();
  end

let test_mixer_music _ =
  let open Sdl_mixer in
  begin
    ignore (init [`OGG]);
    ignore (open_audio ~freq:44100 ~format:AUDIO_S16LSB
              ~channels:2 ~chunk:1024);

    assert_bool "music decoder must have more than 1"
      ((get_num_music_decoders ()) > 0);
    assert_bool "can get decoder name"
      ((get_music_decoder 0) <> "");

    let fname = "Once.ogg" in
    if Sys.file_exists fname then begin
      match load_mus fname with
          Std.Either.Left s -> assert_failure (Printf.sprintf "load_mus failed :
        %s" s);
        | Std.Either.Right m ->
          begin
            match play_music ~music:m ~loops:(-1) with
                Std.Either.Left s -> assert_failure (Printf.sprintf "load_mus failed : %s" s);
              | Std.Either.Right _ -> ();

                assert_bool "music volume change"
                  ((volume_music 120) = 128);
                assert_bool "not playing music" (playing_music ());
                pause_music ();
                assert_bool "not paused music" (paused_music ());
                resume_music ();
                rewind_music ();
                begin match set_music_position 10.0 with
                    Std.Either.Left s -> assert_failure
                      (Printf.sprintf "set_music_position failed : %s" s);
                  | Std.Either.Right _ -> ();
                end;
                halt_music ();
          end;
    end;
    close ();
    quit ();
  end

let test_mixer_effects _ =
  let open Sdl_mixer in
  begin
    assert_equal 1 (List.length (init [`OGG]));
    ignore (open_audio ~freq:44100 ~format:AUDIO_S16LSB
              ~channels:2 ~chunk:1024);

    assert_equal 2 (allocate_channels 2);
    let vol = volume ~channel:(`Channel 1) ~volume:100 in
    assert_bool "a channel change volume" (vol = 128);
    assert_bool "all channels changes volume"
      ((volume ~channel:(`All) ~volume:100) > 0);

    let fname = "battle001.wav" in
    if Sys.file_exists fname then begin
      let ch = load_wav fname in
      match ch with
        | Std.Either.Left s -> assert_failure (Printf.sprintf "load_wav failed : %s" s);
        | Std.Either.Right ch -> begin
          let p =  play_channel ~channel:(`Channel 1) ~chunk:ch
            ~loops:(-1) () in
          begin match p with
              Std.Either.Left s -> assert_failure (Printf.sprintf "play_channel
    failed : %s" s)
            | Std.Either.Right _ -> ();
          end;
          begin match set_position ~channel:(`Channel 1) ~angle:100 ~dist:100 with
            | Std.Either.Left s -> assert_failure (Printf.sprintf "set_position failed : %s" s)
            | Std.Either.Right _ -> ()
          end;
          halt_channel (`Channel 1);
          free_chunk ch;
        end;
    end;
    close ();
    quit ();
  end

let tmp_bracket f = bracket test_set_up f test_tear_down

let suite = "SDL Mixer binding specs" >:::
  [
    "initialize mixer" >:: (tmp_bracket test_mixer_initialize);
    "chunk specs" >:: (tmp_bracket test_mixer_chunk);
    "can be loading some wav" >:: (tmp_bracket test_mixer_load_wav);
    "playing channel" >:: (tmp_bracket test_mixer_channels);
    "setting groups" >:: (tmp_bracket test_mixer_groups);
    "playing musics" >:: (tmp_bracket test_mixer_music);
    "effects apply channel" >:: (tmp_bracket test_mixer_effects);
  ]

let _ =
  run_test_tt_main suite
