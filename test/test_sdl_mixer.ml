open Sdlcaml
open OUnit

let test_set_up _ =
  Sdl.init [`AUDIO]

let test_tear_down _ =
  Sdl.quit ()

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
    let opened = open_audio ~freq:44100 ~format:AUDIO_U16LSB
      ~channels:2 ~chunk:1024 in
    begin
      match opened with
          Mylib.Prelude.Left s -> assert_failure s
        | Mylib.Prelude.Right _ -> ()
    end;

    match query_spec () with
      | None -> assert_failure "can't get any spec";
      | Some (freq, format, channels) ->
          begin
            assert_equal 44100 freq;
            assert_equal AUDIO_U16LSB format;
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
    assert_bool "decoder should have more than 1" (decoders >= 1);
    assert_bool "some decoder name gotten" ((get_chunk_decoder 0) <>
    "");

    close ();
    quit ();
  end

let test_mixer_load_wav _ =
  let open Sdl_mixer in
  begin
    ignore (init [`OGG]);
    ignore (open_audio ~freq:44100 ~format:AUDIO_U16LSB
      ~channels:2 ~chunk:1024);

    let m = load_wav "Once.wav" in
    match m with
        Mylib.Prelude.Left s -> assert_failure (Printf.sprintf "load_wav failed : %s" s);
      | Mylib.Prelude.Right ch -> begin
        assert_bool "volume changeable" ((volume_chunk ~chunk:ch
                                            ~volume:10) > 0);
        free_chunk ch;
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

    (* assert_equal 2 (allocate_channels 2); *)
    let vol = volume ~channel:(`Channel 1) ~volume:100 in
    assert_bool "a channel change volume" (vol = 128);
    assert_bool "all channels changes volume"
      ((volume ~channel:(`All) ~volume:100) > 0);

    let ch = load_wav "Once.ogg" in
    match ch with
        Mylib.Prelude.Left s -> assert_failure (Printf.sprintf "load_wav failed : %s" s);
      | Mylib.Prelude.Right ch -> begin
        let p =  play_channel ~channel:(`Unreserved) ~chunk:ch
          ~loops:(-1) () in
        match p with
            Mylib.Prelude.Left s -> assert_failure (Printf.sprintf "play_channel
    failed : %s" s)
          | Mylib.Prelude.Right _ -> Thread.delay 10.0;
        free_chunk ch;
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
    "playing channel" >:: (tmp_bracket test_mixer_channels)
  ]

let _ =
  run_test_tt_main suite
