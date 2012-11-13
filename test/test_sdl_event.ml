open Sdlcaml
open OUnit

let test_set_up _ =
  Sdl_init.init [`VIDEO];
  Sdl_video.set_video_mode ~width:100 ~height:100 ~depth:32
    ~flags:[Sdl_video.SDL_SWSURFACE]

let test_tear_down s =
  Sdl_video.free_surface s;
  Sdl_init.quit ()

let test_push_event _ =
  let open Sdl_event in
  begin
    let active = Active {
      gain = true; active_state = [APPACTIVE]
    } in
    Sdl_event.push_event active;
    let keydown = KeyDown {
      keysym = (let open Sdl_key in {synonym = SDLK_A;
                                     modify_state = []});
      key_state = false
    }
    in Sdl_event.push_event keydown;
    let keyup = KeyUp {
      keysym = (let open Sdl_key in {synonym = SDLK_A;
                                     modify_state = []});
      key_state = true
    }
    in
    Sdl_event.push_event keyup;
    let motion = Motion {
      motion_x = 100; motion_y = 100; motion_xrel = 1; motion_yrel = 1;
      motion_states = [];
    }
    in
    Sdl_event.push_event motion;
    let button = ButtonDown {
      mouse_x = 100; mouse_y = 100;
      mouse_button = Sdl_mouse.MOUSE_LEFT; mouse_state = true
    } in
    Sdl_event.push_event button;
    let button =  ButtonUp {
      mouse_x = 100; mouse_y = 100;
      mouse_button = Sdl_mouse.MOUSE_RIGHT; mouse_state = false
    } in
    Sdl_event.push_event button;
    let resize = Resize {width = 100; height = 100} in
    Sdl_event.push_event resize;
    Sdl_event.push_event Expose;
    Sdl_event.push_event Quit;
  end

let test_pump_event _ =
  let open Sdl_event in
  begin
    let keydown = KeyDown {
      keysym = (let open Sdl_key in {synonym = SDLK_A;
                                     modify_state = []});
      key_state = true
    }
    in Sdl_event.push_event keydown;
    Sdl_event.pump_events ()
  end

let test_poll_event _ =
  let open Sdl_event in
  let assert_event event f =
    match event with
    | None -> assert_failure "can't receive any event"
    | Some e -> f e
  in
  begin
    ignore (Sdl_event.poll_event ());
    let active = Active {
      gain = true; active_state = [APPACTIVE]
    } in
    Sdl_timer.delay 1;
    Sdl_event.push_event active;
    assert_event (Sdl_event.poll_event ()) (fun e ->
      match e with
      | Active e ->
          begin
            assert_bool "window do not gained" e.gain;
            assert_equal [APPACTIVE] e.active_state;
          end
      | _ -> assert_failure "unrecognized data for ActiveEvent"
    );

    let keydown = KeyDown {
      keysym = (let open Sdl_key in {synonym = SDLK_A;
                                     modify_state = []});
      key_state = true
    }
    in Sdl_event.push_event keydown;
    assert_event (poll_event ()) (fun e ->
      match e with
      | KeyDown e ->
          begin
            assert_equal Sdl_key.SDLK_A e.keysym.Sdl_key.synonym;
          end
      | _ -> assert_failure "unrecognized keydown keysym"
    );

    let keyup = KeyUp {
      keysym = (let open Sdl_key in {synonym = SDLK_A;
                                     modify_state = []});
      key_state = false
    }
    in Sdl_event.push_event keyup;
    assert_event (poll_event ()) (fun e ->
      match e with
      | KeyUp e ->
          begin
            assert_equal Sdl_key.SDLK_A e.keysym.Sdl_key.synonym;
          end
      | _ -> assert_failure "unrecognized keyup keysym"
    );

    let motion = Motion {
      motion_x = 100; motion_y = 100; motion_xrel = 0; motion_yrel = 0;
      motion_states = [];
    } in
    Sdl_event.push_event motion;
    assert_event (poll_event ()) (fun e ->
      match e with
      | Motion e ->
          begin
            assert_equal 100 e.motion_x;
            assert_equal 100 e.motion_y;
            assert_equal 0 e.motion_xrel;
            assert_equal 0 e.motion_yrel;
            assert_equal [] e.motion_states;
          end
      | _ -> assert_failure "unrecognized data for MotionEvent"
    );
    let button = ButtonDown {
      mouse_x = 100; mouse_y = 100;
      mouse_button = Sdl_mouse.MOUSE_LEFT;
      mouse_state = true
    } in
    Sdl_event.push_event button;
    assert_event (poll_event ()) (fun e ->
      match e with
      | ButtonDown e ->
          begin
            assert_equal 100 e.mouse_x;
            assert_equal 100 e.mouse_y;
            assert_equal Sdl_mouse.MOUSE_LEFT e.mouse_button
          end
      | _ -> assert_failure "unrecognized data for MouseButton"
    );

    let button = ButtonUp {
      mouse_x = 100; mouse_y = 100;
      mouse_button = Sdl_mouse.MOUSE_LEFT;
      mouse_state = false
    } in
    Sdl_event.push_event button;
    assert_event (poll_event ()) (fun e ->
      match e with
      | ButtonUp e ->
          begin
            assert_equal 100 e.mouse_x;
            assert_equal 100 e.mouse_y;
            assert_equal Sdl_mouse.MOUSE_LEFT e.mouse_button
          end
      | _ -> assert_failure "unrecognized data for MouseButton"
    );

    let resize = Resize {width = 100; height = 200;} in
    Sdl_event.push_event resize;
    assert_event (poll_event ()) (fun e ->
      match e with
      | Resize e ->
          begin
            assert_equal 100 e.width;
            assert_equal 200 e.height;
          end
      | _ -> assert_failure "not recognized data for Resize"
    );

  end


let tmp_bracket f = bracket test_set_up f test_tear_down

let suite = "SDL Event system specs" >:::
  [
    "SDL event pushing" >:: (tmp_bracket test_push_event);
    "SDL event pumping" >:: (tmp_bracket test_pump_event);
    "SDL event polling" >:: (tmp_bracket test_poll_event);
  ]

let _ =
  run_test_tt_main suite
