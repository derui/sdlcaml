open Sdlcaml

let test_sdl_initialize _ =
  begin
    let open Sdl in
    Sdl.init [`EVERYTHING];
    Sdl.quit ();
  end

let _ =
  test_sdl_initialize ();
