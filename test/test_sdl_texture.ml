[%%suite
 open Sdlcaml.Std

 let with_win_rend f =
   let open Flags in
   Init.init [Sdl_init_flags.SDL_INIT_VIDEO];
   let open Types.Resource.Monad_infix in
   let cc =
     Window.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[`HIDDEN]
     >>= fun window ->
     Renderer.create ~window ~index:(-1) ~flags:[Sdl_renderer_flags.SDL_RENDERER_ACCELERATED] ()
     >>= fun r -> f window r
   in
   Types.Resource.run cc ignore |> ignore;
   Init.quit ()

 let%spec "The SDL Texture module" = 
   let open Flags in
   with_win_rend (fun window renderer ->
     let open Flags in
     let open Texture in
     let open Types.Result.Monad_infix in
     Texture.create ~renderer ~format:Sdl_pixel_format_enum.SDL_PIXELFORMAT_RGB888
       ~access:Sdl_texture_access.SDL_TEXTUREACCESS_TARGET ~width:100 ~height:120
     >>= (fun t -> 
       (set_alpha_mod t 220
        >>= fun _ -> get_alpha_mod t
                     >>= fun t -> t [@eq 220]; Types.Result.return ()
       ) |> ignore;
       Types.Result.return (destroy t)
     ) |> Types.Resource.return
   )

 let%spec "can set and get blend mode of the texture" =
   let open Flags in
   with_win_rend (fun window renderer ->
     let open Flags in
     let open Texture in
     let texture = Texture.create ~renderer ~format:Sdl_pixel_format_enum.SDL_PIXELFORMAT_RGB888
       ~access:Sdl_texture_access.SDL_TEXTUREACCESS_TARGET ~width:100 ~height:120 in

     let open Types.Result.Monad_infix in
     texture >>= (fun texture -> 

       set_blend_mode texture Sdl_blendmode.SDL_BLENDMODE_BLEND
       >>= (fun _ -> get_blend_mode texture)
       >>= (fun t -> t [@eq Sdl_blendmode.SDL_BLENDMODE_BLEND];
         Types.Result.return ()
       ) |> ignore;
       destroy texture |> Types.Result.return
     ) |> Types.Resource.return
   )

 let%spec "can set and get color modulation of the texture" =
   with_win_rend (fun window renderer ->
     let open Flags in
     let open Texture in
     let texture = create ~renderer ~format:Sdl_pixel_format_enum.SDL_PIXELFORMAT_RGB888
       ~access:Sdl_texture_access.SDL_TEXTUREACCESS_TARGET ~width:100 ~height:120 in

     let open Types.Result.Monad_infix in
     texture >>= (fun texture ->
       set_color_mod texture {Structures.Color.r = 100;g = 120;b = 130;a = 0}
       >>= (fun () -> get_color_mod texture)
       >>= (fun color -> 
         color [@eq {Structures.Color.r = 100;g = 120; b = 130; a = 255}];
         Types.Result.return ()
       ) |> ignore;
       Types.Result.return (destroy texture)
     ) |> Types.Resource.return
   )


 let%spec "can query some information of the specified texture" =
   with_win_rend (fun window renderer ->
     let open Flags in
     let open Texture in
     let texture = create ~renderer ~format:Sdl_pixel_format_enum.SDL_PIXELFORMAT_RGB888
       ~access:Sdl_texture_access.SDL_TEXTUREACCESS_TARGET ~width:100 ~height: 120 in

     let open Types.Result.Monad_infix in
     texture >>= (fun texture ->
       (query_format texture) [@eq Ok(Sdl_pixel_format_enum.SDL_PIXELFORMAT_RGB888)];
       (query_access texture) [@eq Ok(Sdl_texture_access.SDL_TEXTUREACCESS_TARGET)];
       (query_size texture) [@eq Ok({Structures.Size.width = 100; height = 120})];
       destroy texture |> Types.Result.return
     ) |> Types.Resource.return
   )
]
