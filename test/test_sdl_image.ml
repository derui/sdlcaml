open Sdlcaml
open OUnit
open Sugarpot

let test_set_up _ =
  Sdl_init.init [`VIDEO] ()

let test_tear_down _ =
  Sdl_init.quit ()

let test_image_basic _ =
  let open Sdl.Image in
  begin
    let (major, minor, patch) = compile_version ()
    in assert_bool "valid version" (major >= 0 && minor >= 0 && patch
                                    >= 0);
    let (major, minor, patch) = linked_version ()
    in assert_bool "valid linked version" (major >= 0 && minor >= 0 && patch
                                           >= 0);
    begin match init [INIT_JPG;INIT_PNG;INIT_TIF] with
    | Sugarpot.Std.Either.Left s -> assert_failure s
    | Sugarpot.Std.Either.Right _ -> ()
    end;

    begin match load "nothing.png" with
    | Some loaded -> assert_failure "nothing.png is found...";
    | None -> ()
    end;

    let fname = "sample.png" in
    begin
      if Sys.file_exists fname then
        match load "sample.png" with
        | Some loaded -> ()
        | None -> assert_failure (Printf.sprintf "%s is not found" fname);
    end;

    assert_bool "valid type as png" (is_type fname PNG);
    quit ();
  end

let tmp_bracket f = bracket test_set_up f test_tear_down

let suite = "SDL Image binding specs" >:::
  [
    "image basic usega" >:: (tmp_bracket test_image_basic);
  ]

let _ =
  run_test_tt_main suite
