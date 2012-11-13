open Sdlcaml
open OUnit

let test_set_up _ =
  Sdl_init.init [`VIDEO;`JOYSTICK];
  Sdl_video.set_video_mode ~width:400 ~height:400 ~depth:32
    ~flags:[Sdl_video.SDL_SWSURFACE]

let test_tear_down s =
  Sdl_video.free_surface s;
  Sdl_init.quit ()

let test_sdl_sdlut_basic_usage _ =
  let open Sdl in
  let current = Timer.get_ticks () in
  Sdlut.display_callback (fun () ->
    let now = Timer.get_ticks () in
    if now - current > 1000 then
      Sdlut.force_exit_game_loop ()
  );
  Sdlut.game_loop ()

let test_sdl_sdlut_integrate_input _ =
  let open Sdl in
  let key_map = [(Key.SDLK_A, 1)] in
  let input = Sdlut.integrate_inputs ~id:1 ~num:1 ~axis_map:[] ~key_map in begin
    Sdlut.add_input_callback ~info:input ~func:(fun ~info -> ());
    let current = Timer.get_ticks () in
    Sdlut.display_callback (fun () ->
      let now = Timer.get_ticks () in
      if now - current > 1000 then
        Sdlut.force_exit_game_loop ()
    );

    Sdlut.game_loop ();
    Sdlut.input_close input;
  end

let tmp_bracket f = bracket test_set_up f test_tear_down

let suite = "SDL Utility Toolkit basically specs" >:::
  [
    "SDLUT basic usage" >:: (tmp_bracket test_sdl_sdlut_basic_usage);
    "SDLUT integrate input" >:: (tmp_bracket test_sdl_sdlut_integrate_let);
  ]

run _ =
  input_test_tt_main suite
