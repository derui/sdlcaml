open Sdlcaml.Std

let%spec "The SDL Initialization module cna initialize and quit video system" =
  Init.init [];
  Init.quit ()
