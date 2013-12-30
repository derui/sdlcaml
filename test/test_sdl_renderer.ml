open Sdlcaml.Std
module S = Structures

let with_sdl f = 
  let open Flags in
  Init.init [Sdl_init_flags.SDL_INIT_VIDEO];
  f ();
  Init.quit ()

let%spec "The SDL Renderer module can create renderer of the window" =
  let open Renderer in
  let open Flags in
  with_sdl (fun () -> 
    let window = Window.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[`HIDDEN] in
    let open Types.Result.Monad_infix in
    (create ~window ~flags:[Sdl_renderer_flags.SDL_RENDERER_ACCELERATED] ()
     >>= destroy) |> ignore;
    Window.destroy window;
  )

let%spec "The SDL Renderer module can get the size of the renderer created for the window" =
  let open Renderer in
  let open Flags in
  with_sdl (fun () ->
    let window = Window.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[`HIDDEN] in
    let open Types.Result.Monad_infix in
    create ~window ~flags:[Sdl_renderer_flags.SDL_RENDERER_ACCELERATED] ()
    >>= (fun renderer -> 
      get_output_size renderer
      >>= (fun size ->
        let open Structures.Size in
        (size.width) [@eq 100];
        (size.height) [@eq 200];
        Types.Result.return ()
      )
      >>= (fun () -> destroy renderer)
    ) |> ignore;
    Window.destroy window;
  )

let%spec "The SDL Renderer module must get positive number of render drivers" =
  let open Renderer in
  with_sdl (fun () ->
    (get_num_render_drivers () >= 1) [@eq true]
  )
    
let%spec "The SDL Renderer module can set and get renderer's blend mode" =
  let open Renderer in
  let open Flags in
  with_sdl (fun () ->
    let window = Window.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[`HIDDEN] in
    let open Types.Result.Monad_infix in
    create ~window ~flags:[Sdl_renderer_flags.SDL_RENDERER_ACCELERATED] ()
    >>= (fun renderer ->
      set_draw_blend_mode renderer Sdl_blendmode.SDL_BLENDMODE_ADD
      >>= (fun () -> get_draw_blend_mode renderer)
      >>= (fun t -> t [@eq Sdl_blendmode.SDL_BLENDMODE_ADD];
        Types.Result.return ()
      ) |> ignore;
      destroy renderer
    ) |> ignore;
    Window.destroy window
  )

let%spec "The SDL Renderer module can get the rendering context of the window" =
  let open Renderer in
  let open Flags in
  with_sdl (fun () ->
    let window = Window.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[`HIDDEN] in
    (* First, create renderer for the window *)
    let open Types.Result.Monad_infix in
    create ~window ~flags:[Sdl_renderer_flags.SDL_RENDERER_ACCELERATED] ()
    >>= (fun _ -> get window)
    >>= (fun renderer ->
      get_output_size renderer
      >>= (fun size ->
        let open Structures.Size in
        (size.width) [@eq 100];
        (size.height) [@eq 200];
        Types.Result.return ()
      ) |> ignore;
      destroy renderer
    ) |> ignore;
    Window.destroy window
  )

let%spec "The SDL Renderer module can set and get the color to draw rect, line and more" =
  let open Renderer in
  let open Flags in
  with_sdl (fun () -> 
    let window = Window.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[`HIDDEN] in
    let open Types.Result.Monad_infix in
    create ~window ~flags:[Sdl_renderer_flags.SDL_RENDERER_ACCELERATED] ()
    >>= (fun renderer -> 
      set_draw_color renderer {S.Color.r = 100;g = 110;b = 120;a = 255}
      >>= (fun () -> get_draw_color renderer)
      >>= (fun color -> 
        let open S.Color in
        color [@eq {r = 100;g = 110;a = 255; b = 120}];
        Types.Result.return ()
      ) |> ignore;

      destroy renderer
    ) |> ignore;
    Window.destroy window
  )

let%spec "The SDL Renderer module can create and set, and get the texture to draw" =
  let open Renderer in
  let open Flags in
  with_sdl (fun () ->
    let window = Window.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[`HIDDEN] in
    let open Types.Result.Monad_infix in
    create ~window ~flags:[Sdl_renderer_flags.SDL_RENDERER_ACCELERATED] ()
    >>= (fun renderer -> 
      Texture.create ~renderer ~format:Sdl_pixel_format_enum.SDL_PIXELFORMAT_RGB888
        ~access:Sdl_texture_access.SDL_TEXTUREACCESS_TARGET ~width:100 ~height: 120 ()
      >>= (fun texture ->
        (set_target ~renderer ~texture
         >>= (fun _ -> get_target renderer) >>= (fun texture -> set_target ~renderer ~texture)
        ) |> ignore;
        Texture.destroy texture
      ) |> ignore;
      destroy renderer
    ) |> ignore;
    Window.destroy window
  )
