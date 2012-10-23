open Sdlcaml

let loop_count = ref 0
let prev_time = ref 0

let _ =
  Sdl_init.init [`VIDEO];
  prev_time := Sdl_timer.get_ticks ();

  let surface = Sdl_video.set_video_mode ~width:800 ~height:600
    ~depth:32 ~flags:[Sdl_video.SDL_SWSURFACE;Sdl_video.SDL_DOUBLEBUF] in
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

        loop_count := succ !loop_count;
        Sdl_video.clear surface;
        let rect = {Sdl_video.x = !loop_count / 100; y = 0;
                    w = 400; h = 300} in
        Sdl_video.fill_rect ~dist:surface
          ~drect:rect
          ~fill:(let open Sdl_video in
                 {red = 255; green = 128;blue = 100; alpha = 255}) ();
        Sdl_video.flip surface;
        loop ();
      end
  in loop ();


  Sdl_video.free_surface surface;
  Sdl_video.free_surface blit;
  Sdl_init.quit ()
