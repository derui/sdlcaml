open Core.Std
open Sdlcaml.Std

let with_sdl f =
  let open Flags.Sdl_init_flags in
  Init.init [SDL_INIT_AUDIO];
  protect ~f ~finally:(fun () -> Init.quit ())

let%spec "SDL Audio can open device with desired status" =
  with_sdl (fun () ->
    let open Structures in
    let open Flags in 
    let spec = {
      Audio_spec.empty with
        Audio_spec.freq = 48000;
        format = Sdl_audio_format.AUDIO_U16LSB;
        channels = 2;
        silence = 1;
        samples = 4096;
    } in

    let open Types.Result.Monad_infix in
    let ret =
      Audio.open_device ~desired:spec ~allowed:[] ()
      >>= (fun (id, spec) ->
        Audio_spec.(spec.freq) [@eq 48000];
        Audio_spec.(spec.format) [@eq Sdl_audio_format.AUDIO_U16LSB];
        Audio_spec.(spec.channels) [@eq 2];
        Audio_spec.(spec.samples) [@eq 4096];
        Audio.close_device id |> Types.Result.return
      ) in
    let module R = Types.Result in
    (R.tap ~f:print_string ret |> R.is_success) [@eq true]
  )
