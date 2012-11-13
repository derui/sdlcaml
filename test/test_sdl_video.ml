open Sdlcaml
open OUnit

let test_set_up flag _ =
  begin
    Sdl_init.init [`VIDEO];
    Sdl_video.set_video_mode ~width:640 ~height:480 ~depth:32
      ~flags:flag
  end

let test_tear_down surface =
  begin
    Sdl_video.free_surface surface;
    Sdl_init.quit ();
  end

let test_sdl_video_init surface =
  begin
    Thread.delay 1.0;
  end

let test_sdl_get_pixel_format surface =
  begin
    let format = Sdl_video.get_pixelformat surface in
    let open Sdl_video in
    assert_equal 32 format.bits_per_pixel;
    assert_equal 4 format.bytes_per_pixel;
  end

let test_sdl_fill_color surface =
  begin
    let open Sdl_video in
    let col = {red = 255; green = 128; blue = 0; alpha = 255} in
    Sdl_video.fill_rect ~dist:surface ~fill:col ();
    Sdl_video.update_rect surface;
    Thread.delay 2.0;
  end

let test_sdl_blit_surface surface =
  begin
    let open Sdl_video in
    let newsurface = Sdl_video.create_surface
      ~flags:[SDL_SWSURFACE;SDL_SRCALPHA] ~width:300 ~height:200
    and col = {red = 255; green = 128; blue = 0; alpha = 255} in
    Sdl_video.fill_rect ~dist:newsurface ~fill:col ();
    assert_equal BLIT_SUCCESS (Sdl_video.blit_surface
                                 ~src:newsurface ~dist:surface ());
    Sdl_video.update_rect surface;
    Thread.delay 2.0;
    Sdl_video.free_surface newsurface;
  end

let test_use_alpha surface =
  begin
    let open Sdl_video in
    let newsurface = Sdl_video.create_surface
      ~flags:[SDL_SWSURFACE;SDL_SRCALPHA] ~width:300 ~height:200
    and col = {red = 255; green = 128; blue = 0; alpha = 128} in
    Sdl_video.fill_rect ~dist:newsurface ~fill:col ();
    assert_equal BLIT_SUCCESS (Sdl_video.blit_surface
                                 ~src:newsurface ~dist:surface ());
    Sdl_video.update_rect surface;
    Thread.delay 2.0;
    Sdl_video.free_surface newsurface;
  end

let test_use_flip surface =
  begin
    let open Sdl_video in
    let newsurface = Sdl_video.create_surface
      ~flags:[SDL_SWSURFACE;SDL_SRCALPHA] ~width:300 ~height:200
    and col = {red = 255; green = 128; blue = 0; alpha = 128} in
    Sdl_video.fill_rect ~dist:newsurface ~fill:col ();
    assert_equal BLIT_SUCCESS (Sdl_video.blit_surface
                                 ~src:newsurface ~dist:surface ());
    Sdl_video.flip surface;
    Thread.delay 2.0;
    Sdl_video.free_surface newsurface;
  end

let suite = "SDL video tests" >:::
  [ "video initialize" >::
      (bracket (test_set_up [Sdl_video.SDL_HWSURFACE]) test_sdl_video_init
         test_tear_down);
    "get current pixel format" >::
      (bracket (test_set_up [Sdl_video.SDL_SWSURFACE]) test_sdl_get_pixel_format test_tear_down);
    "fill color" >::
      (bracket (test_set_up [Sdl_video.SDL_SWSURFACE]) test_sdl_fill_color test_tear_down);
    "blit surface" >::
      (bracket (test_set_up [Sdl_video.SDL_SWSURFACE]) test_sdl_blit_surface test_tear_down);
    "use alpha" >::
      (bracket (test_set_up [Sdl_video.SDL_SWSURFACE]) test_use_alpha
         test_tear_down);
    "use double buffering" >::
      (bracket (test_set_up
                  [Sdl_video.SDL_SWSURFACE;Sdl_video.SDL_DOUBLEBUF])
         test_use_flip test_tear_down);
  ]

let _ =
  run_test_tt_main suite
