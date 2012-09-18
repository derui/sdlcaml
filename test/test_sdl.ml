open Sdlcaml

let test_sdl_initialize _ =
  begin
    let open Sdl in
    Sdl.sdl_init [`EVERYTHING];
    Sdl.sdl_quit ();
  end

let _ =
  test_sdl_initialize ();
