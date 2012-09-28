open Sdlcaml
open OUnit

let test_set_up _ =
  Sdl.init [`VIDEO];
  Sdl_video.set_video_mode ~width:100 ~height:100 ~depth:32
    ~flags:[Sdl_video.SDL_SWSURFACE]

let test_tear_down s =
  Sdl_video.free_surface s;
  Sdl.quit ()

let test_push_event _ =
  let open Sdl_event in
  begin
    let active = Event.create Event.SDL_ACTIVEEVENT
      [`Gain (true);`AppState Event.APPACTIVE] in
    Sdl_event.push_event active;
    let keydown = Event.create Event.SDL_KEYDOWN
      [`Keysym (let open Sdl_key in {synonym = SDLK_A;
                                     modify_state = []})
      ]
    in Sdl_event.push_event keydown;
    let keyup = Event.create Event.SDL_KEYUP
      [`Keysym (let open Sdl_key in {synonym = SDLK_A;
                                     modify_state = []}
       )
      ] in
    Sdl_event.push_event keyup;
    let motion = Event.create Event.SDL_MOUSEMOTION
      [`X 100; `Y 100; `Xrel 1; `Yrel 1;] in
    Sdl_event.push_event motion;
    let button = Event.create Event.SDL_MOUSEBUTTONDOWN
      [`X 100; `Y 100; `Mouse 1] in
    Sdl_event.push_event button;
    let button = Event.create Event.SDL_MOUSEBUTTONUP
      [`X 100; `Y 100; `Mouse 1] in
    Sdl_event.push_event button;
    let resize = Event.create Event.SDL_VIDEORESIZE
      [`Width 100; `Height 100] in
    Sdl_event.push_event resize;
    Sdl_event.push_event (Event.create Event.SDL_VIDEOEXPOSE []);
    Sdl_event.push_event (Event.create Event.SDL_QUIT []);
  end

let test_pump_event _ =
  let open Sdl_event in
  begin
    let keydown = Event.create Event.SDL_KEYDOWN
      [`Keysym (let open Sdl_key in {synonym = SDLK_A;
                                     modify_state = []})
      ]
    in Sdl_event.push_event keydown;
    Sdl_event.pump_events ()
  end

let test_poll_event _ =
  let open Sdl_event in
  let assert_event event f =
    match event with
        None -> assert_failure "can't receive any event"
      | Some e -> f (Event.extract e)
  in
  begin
    let active = Event.create Event.SDL_ACTIVEEVENT
      [`Gain true;`AppState Event.APPACTIVE] in
    Sdl_event.push_event active;
    assert_event (Sdl_event.poll_event ()) (fun e ->
      let m = function
          `Gain v -> assert_bool "getting gain" v
        | `AppState v -> assert_equal Event.APPACTIVE v;
        | _ -> assert_failure "unrecognized data for ActiveEvent"
      in List.iter m e;
    );
    let keydown = Event.create Event.SDL_KEYDOWN
      [`Keysym (let open Sdl_key in {synonym = SDLK_A;modify_state = []})]
    in Sdl_event.push_event keydown;
    assert_event (poll_event ()) (fun e ->
      let m = function
          `Keysym ks -> assert_equal Sdl_key.SDLK_A ks.Sdl_key.synonym
        | _ -> assert_failure "unrecognized keysym"
      in List.iter m e
    );
    let keyup = Event.create Event.SDL_KEYUP
      [`Keysym (let open Sdl_key in {synonym = SDLK_A;modify_state = []})]
    in Sdl_event.push_event keyup;
    assert_event (poll_event ()) (fun e ->
      let m = function
          `Keysym ks -> assert_equal Sdl_key.SDLK_A ks.Sdl_key.synonym
        | _ -> assert_failure "unrecognized keysym"
      in List.iter m e
    );
    let motion = Event.create Event.SDL_MOUSEMOTION
      [`X 100; `Y 100; `Xrel 1; `Yrel 1;] in
    Sdl_event.push_event motion;
    assert_event (poll_event ()) (fun e ->
      let m = function
          `X v -> assert_equal 100 v;
        | `Y v -> assert_equal 100 v;
        | `Xrel v -> assert_equal 1 v;
        | `Yrel v -> assert_equal 1 v;
        | `ButtonState v -> assert_equal [] v
        | _ -> assert_failure "unrecognized data for MotionEvent"
      in List.iter m e
    );
    let button = Event.create Event.SDL_MOUSEBUTTONDOWN
      [`X 100; `Y 100; `Mouse 1] in
    Sdl_event.push_event button;
    assert_event (poll_event ()) (fun e ->
      let m = function
          `X v -> assert_equal 100 v;
        | `Y v -> assert_equal 100 v;
        | `Mouse v -> assert_equal 1 v
        | _ -> assert_failure "unrecognized data for MouseButton"
      in List.iter m e
    );

    let button = Event.create Event.SDL_MOUSEBUTTONUP
      [`X 100; `Y 100; `Mouse 1] in
    Sdl_event.push_event button;
    assert_event (poll_event ()) (fun e ->
      let m = function
          `X v -> assert_equal 100 v;
        | `Y v -> assert_equal 100 v;
        | `Mouse v -> assert_equal 1 v
        | _ -> assert_failure "unrecognized data for MouseButton"
      in List.iter m e
    );

    let resize = Event.create Event.SDL_VIDEORESIZE
      [`Width 100; `Height 200] in
    Sdl_event.push_event resize;
    assert_event (poll_event ()) (fun e ->
      let m = function
          `Width v -> assert_equal 100 v;
        | `Height v -> assert_equal 200 v;
        | _ -> assert_failure "not recognized data for Resize"
      in List.iter m e
    );

    Sdl_event.push_event (Event.create Event.SDL_VIDEOEXPOSE []);
    Sdl_event.push_event (Event.create Event.SDL_QUIT []);
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
