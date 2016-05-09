[%%suite
 open Core.Std
 open Sdlcaml.Std

 let with_sdl f =
   Init.init Flags.Sdl_init_flags.([SDL_INIT_VIDEO]);
   protect ~f ~finally:Init.quit |> ignore

 let with_win f =
   let open Flags in
   with_sdl (fun () ->
     let window = Window.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[] in

     protect ~f:(fun () -> f window) ~finally:(fun () -> Window.destroy window) |> ignore
   )

 let%spec "SDL GL module can create and delete context" =
   let module C = Structures.Color in
   with_win (fun w ->
     let open Types.Result.Monad_infix in
     Gl.create_context w >>= fun c ->
     Gl.reset_attributes ();
     Gl.swap_window w;
     Types.Result.return c
     >>= Gl.delete_context
   )
]
