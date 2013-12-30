open Sdlcaml.Std

let with_sdl f =
  let open Flags in
  Init.init [Sdl_init_flags.SDL_INIT_VIDEO];
  f ();
  Init.quit ()

let%spec "The SDL Error module should return the previous occured error" =
  let open Error in

  try
    Window.create ~title:"test" ~x:0 ~y:0 ~w:(-1) ~h:(-1) ~flags:[`HIDDEN] |> ignore;
  with e -> ();
  (get ()) [@ne ""]

let%spec "The SDL Error module can clear error information" =
  let open Error in

  try
    Window.create ~title:"test" ~x:0 ~y:0 ~w:(-1) ~h:(-1) ~flags:[`HIDDEN] |> ignore;
  with e -> ();
  clear ();
  (get ()) [@eq ""]
