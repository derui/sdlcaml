open Sdlcaml.Std

let with_sdl f =
  let open Flags in
  Init.init [Sdl_init_flags.SDL_INIT_VIDEO];
  protect ~f ~finally:Init.quit

let%spec "The SDL Thread module can execute function on the other thread" = 
  with_sdl (fun () ->
    let open Types.Result.Monad_infix in
    let recorder = ref 0 in
    Thread.create ~name:"Sample" ~f:(fun _ -> 100)
    >>= (fun thread -> 
      Thread.get_name thread [@eq "Sample"];
      let status = Thread.wait thread in
      status [@eq 0];
      Types.Result.return ()
    ) |> ignore
  )
