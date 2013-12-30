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

let%spec "SDL Surface module can create new empty surface with some opitons" =
  let module S = Surface in
  let module C = Structures.Color in
  with_sdl (fun _ ->
    let open Types.Result.Monad_infix in
    S.create_argb_surface ~width:50 ~height:8
    >>= (fun s ->
      S.set_color_mod s {C.r = 0xff;g = 0xff;b = 0xff; a = 0}
      >>= (fun _ -> S.get_color_mod s)
      >>= (fun c ->
        c.C.r [@eq 0xff];
        c.C.b [@eq 0xff];
        c.C.g [@eq 0xff];
        Types.Result.return ()
      )
      >>= (fun _ -> S.free s)
    )
  )

let%spec "SDL Surface module can fill a rectangle with a specific color" =
  let open Flags in
  let module S = Surface in
  with_win (fun window ->
    let surface = Window.get_surface window in
    let rect = {Structures.Rect.w = 10;h = 10; x = 10; y = 10} in
    let color = 0xff00l in
    let open Types.Result.Monad_infix in
    S.fill_rect ~dst:surface ~rect ~color () >>= (fun () ->
      "success" [@eq "success"];
      Types.Result.return ()
    )
  )

let%spec "SDL Surface module can set and get clip rect for a surface" =
  let module S = Surface in
  with_win (fun window ->
    let surface = Window.get_surface window in
    let rect = {Structures.Rect.w = 10; h = 10; x = 10; y = 10} in
    let open Types.Result.Monad_infix in
    S.set_clip_rect ~surface ~rect >>= (fun () ->
      S.get_clip_rect surface >>= (fun current_rect ->
        current_rect [@eq rect];
        Types.Result.return ()
      )
    )
  )

let%spec "SDL Surface module can set and get color key for a surface" =
  let module S = Surface in
  with_win (fun window ->
    let open Structures in
    let surface = Window.get_surface window in
    let key = {Color.r = 0x11;g = 0x11;b = 0x11; a = 0} in
    let open Types.Result.Monad_infix in
    S.set_color_key ~surface ~key >>= (fun _ -> S.get_color_key surface) >>= (fun ret ->
      begin match ret with
      | None -> "should be get some key" [@fail]
      | Some ret ->
         Color.(
           ret.r [@eq key.r];
           ret.g [@eq key.g];
           ret.b [@eq key.b]
         )
      end;
      Types.Result.return ()
    )
  )

let%spec "SDL Surface module can set and get alpha mod used in blit surface" =
  let module S = Surface in
  with_win (fun window ->
    let surface = Window.get_surface window in
    let alpha = 0x15 in

    let open Types.Result.Monad_infix in
    S.set_alpha_mod ~surface ~alpha >>= (fun _ -> S.get_alpha_mod surface) >>= (fun ret ->
      ret [@eq alpha];
      Types.Result.return ()
    )
  )

let%spec "SDL Surface module can set and get blend mode used for blit operations" =
  let open Flags in
  let module S = Surface in
  with_win (fun window ->
    let surface = Window.get_surface window in
    let mode = Sdl_blendmode.SDL_BLENDMODE_NONE in
    let open Types.Result.Monad_infix in
    S.set_blend_mode ~surface ~mode >>= (fun _ -> S.get_blend_mode surface) >>=
      (fun ret ->
        ret [@eq mode] |> Types.Result.return
      )
  )

let%spec "SDL Surface module can set and get color mod used into blit operations" =
  let module S = Surface in
  with_win (fun window ->
    let surface = Window.get_surface window in
    let color = {Structures.Color.r = 100;g = 110; b = 120;a = 0} in
    let open Types.Result.Monad_infix in
    S.set_color_mod ~surface ~color >>= (fun _ -> S.get_color_mod surface) >>=
      (fun ret ->
        Structures.Color.(
          ret.r [@eq color.r];
          ret.b [@eq color.b];
          ret.g [@eq color.g]
        ) |> Types.Result.return)
  )

let%spec "SDL Surface module can lock and unlock a surface to direct access for pixels" =
  let module S = Surface in
  with_win (fun window ->
    let surface = Window.get_surface window in
    let open Types.Result.Monad_infix in
    S.lock surface >>= (fun _ -> S.unlock surface)
  )

let%spec "SDL Surface module can enable and disable rle switch" =
  let module S = Surface in
  with_win (fun window ->
    let surface = Window.get_surface window in
    let open Types.Result.Monad_infix in
    S.enable_rle surface >>= (fun () ->
      "success" [@eq "success"];
      S.disable_rle surface >>= (fun () ->
        "success" [@eq "success"] |> Types.Result.return
      )
    )
  )
