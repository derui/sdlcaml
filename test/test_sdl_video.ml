open Sdlcaml
open OUnit

let test_set_up _ =
  begin
    Sdl.sdl_init [`VIDEO];
    sdl_set_video_mode ~width:640 ~height:480 ~depth:24
      ~flags:[SDL_SWSURFACE];
  end

let test_tear_down surface =
  begin
    Sdl_video.sdl_free_surface surface;
    Sdl.sdl_quit ();
  end

let test_sdl_video_init surface =
  begin
    Thread.delay 3.0;
  end

let test_sdl_get_pixel_format surface =
  begin
    let format = sdl_get_pixelformat surface in
    assert_equal 24 format.bits_per_pixel;
    assert_equal 3 format.bytes_per_pixel;
    assert_equal 0xFF0000 format.rmask;
    assert_equal 0xFF00 format.gmask;
    assert_equal 0xFF format.bmask;
  end

let test_sdl_fill_color surface =
  begin
    let col = {red = 255; green = 128; blue = 0; alpha = 255} in
    Sdl_video.sdl_fill_color ~dist:surface ~fill:col;
    Thread.delay 5.0;
  end

let test_sdl_blit_surface surface =
  begin
    let newsurface = Sdl_video.sdl_create_surface
      ~flags:[SDL_SWSURFACE;SDL_SRCALPHA] ~width:300 ~height:200
    and col = {red = 255; green = 128; blue = 0; alpha = 255} in
    Sdl_video.sdl_fill_color ~dist:newsurface ~fill:col;
    Sdl_video.sdl_blit_surface ~src:newsurface ~dist:surface;
    Thread.delay 3.0;
    Sdl_video.sdl_free_surface newsurface;
  end

let test_sdl_get

let suite = "SDL video tests" >:::
  [ "video initialize" >:: (bracket test_set_up test_sdl_video_init
                               test_tear_down);
    "get current pixel format" >::
      (bracket test_set_up test_sdl_get_pixel_format test_tear_down);
    "fill color" >::
      (bracket test_set_up test_sdl_fill_color test_tear_down);
    "blit surface" >::
      (bracket test_set_up test_sdl_blit_surface test_tear_down);

  ]

let _ =
  run_test_tt_main suite
