open Sdlcaml

let test_sdl_initialize _ =
  begin
    let open Sdl in
    Sdl_init.init [`EVERYTHING] ();
    Sdl_init.quit ();
  end

let _ =
  test_sdl_initialize ();
