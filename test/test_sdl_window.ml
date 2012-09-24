open Sdlcaml
open OUnit

let test_set_up _ =
  begin
    Sdl.init [`VIDEO];
    Sdl_video.set_video_mode ~width:640 ~height:480 ~depth:32
      ~flags:[Sdl_video.SDL_SWSURFACE];
  end

let test_tear_down surface =
  begin
    Sdl_video.free_surface surface;
    Sdl.quit ();
  end

let test_change_window_caption _ =
  let open Sdl_window in
  let (prev_title, prev_icon) = get_caption () in
  begin
    set_caption ~title:"hoge" ~icon:"huga" ();
    let (after_title, after_icon) = get_caption () in
    assert_equal "hoge" after_title;
    assert_equal "huga" after_icon;
    "prev_title differ from after one" @? (prev_title <> after_title);
    "prev_icon differ from after one" @? (prev_icon <> after_icon);
  end

let test_change_window_title _ =
  let open Sdl_window in
  let prev_title = get_title () in
  begin
    set_caption ~title:"hoge" ();
    let after_title = get_title () in
    assert_equal "hoge" after_title;
    "prev_title differ from after one" @? (prev_title <> after_title);
  end

let test_change_window_icon _ =
  let open Sdl_window in
  let prev_icon = get_icon_name () in
  begin
    set_caption ~icon:"huga" ();
    let after_icon = get_icon_name () in
    assert_equal "huga" after_icon;
    "prev_icon differ from after one" @? (prev_icon <> after_icon);
  end


let test_toggle_fullscreen _ =
  let open Sdl_window in
  begin
    ignore (toggle_fullscreen ());
    ignore (toggle_fullscreen ());
  end

let test_grab_input _ =
  let open Sdl_window in
  begin
    assert_equal SDL_GRAB_ON (grab_input SDL_GRAB_ON);
    assert_equal SDL_GRAB_ON (grab_input SDL_GRAB_QUERY);
  end

let suite = "SDL WM binding tests" >:::
  [
    "change window caption" >:: (bracket test_set_up test_change_window_caption test_tear_down);
    (* "change only window title" >:: (bracket test_set_up test_change_window_title test_tear_down); *)
    (* "change only window icon" >:: (bracket test_set_up test_change_window_icon test_tear_down); *)
    "toggle fullscreen" >:: (bracket test_set_up test_toggle_fullscreen test_tear_down);
    "change grab mode" >:: (bracket test_set_up test_grab_input test_tear_down);
  ]


let _ =
  run_test_tt_main suite
