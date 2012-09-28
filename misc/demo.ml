open Sdlcaml

let loop_count = ref 0
let prev_time = ref 0

let _ =
  Sdl.init [`VIDEO];
  prev_time := Sdl_timer.get_ticks ();

  let surface = Sdl_video.set_video_mode ~width:800 ~height:600
    ~depth:32 ~flags:[Sdl_video.SDL_HWSURFACE] in
  let blit = Sdl_video.create_surface ~width:800 ~height:600
    ~flags:[Sdl_video.SDL_HWSURFACE] in
  let rec loop _ =
    let current_time = Sdl_timer.get_ticks () in
    if current_time > 10000 then
      ()
    else
      begin
        if current_time - !prev_time > 1000 then
          begin
            prev_time := Sdl_timer.get_ticks ();
            Sdl_window.set_caption ~title:(Printf.sprintf "%d FPS"
                                             !loop_count) ();
            loop_count := 0;
          end;

        Sdl_window.set_caption ~title:(Printf.sprintf "%d FPS"
                                         !loop_count) ();

        loop_count := succ !loop_count;
        Sdl_video.fill_rect ~dist:blit
          ~fill:(let open Sdl_video in
                 {red = 255; green = 128;blue = 100; alpha = 255}) ();
        ignore (Sdl_video.blit_surface ~src:blit ~dist:surface ());
        Sdl_video.update_rect surface;
        loop ();
      end
  in loop ();


  Sdl_video.free_surface surface;
  Sdl_video.free_surface blit;
  Sdl.quit ()
