open Core.Std
open Sdlcaml.Std
open Ctypes

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
        Audio.close_device id |> Types.Result.return
      ) in
    let module R = Types.Result in
    (R.tap ~f:print_string ret |> R.is_success) [@eq true]
  )

let%spec "SDL Audio can load .wav file" =
  with_sdl (fun () ->
    let open Structures in
    let open Flags in 

    let open Types.Result.Monad_infix in
    let ret =
      RWops.read_from_file ~binary:true ~file:"sample.wav" ~mode:`Read ()
      >>= (fun rwops -> Audio.load_wav rwops ())
      >>= (fun (buf, len, spec) ->
        (len > 0l) [@eq true];
        (CArray.length buf) [@eq (Int32.to_int len |> Option.value ~default:0)];
        Audio_spec.(spec.freq) [@eq 44100];
        Audio_spec.(spec.channels) [@eq 2];
        Audio_spec.(spec.format) [@eq Sdl_audio_format.AUDIO_S16LSB];
        Types.Result.return ()
      ) in
    let module R = Types.Result in
    (R.tap ~f:print_string ret |> R.is_success) [@eq true]
  )

let%spec "SDL Audio can play audio with loaded .wav file" =
  with_sdl (fun () ->
    let open Structures in
    let open Flags in 

    let open Types.Result.Monad_infix in
    let ret =
      RWops.read_from_file ~binary:true ~file:"sample.wav" ~mode:`Read ()
      >>= (fun rwops -> Audio.load_wav rwops ())
      >>= (fun (buf, len, spec) ->
        Audio.open_device ~desired:spec ~allowed:[] ()
        >>= (fun (id, _) ->
          Audio.queue ~id ~data:buf
          >>= (fun _ ->
            Audio.unpause id;
            (* wait 4 second *)
            Timer.delay 4000l;
            Audio.close_device id |> Types.Result.return
          )
        )
      ) in
    let module R = Types.Result in
    (R.tap ~f:print_string ret |> R.is_success) [@eq true]
  )
