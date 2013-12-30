open Ctypes
open Core.Std
open Sdlcaml.Std

let with_sdl f =
  Init.init Flags.Sdl_init_flags.([SDL_INIT_VIDEO]);
  protect ~f ~finally:Init.quit |> ignore

let%spec "SDL Mouse module can get mouse state" =
  with_sdl (fun () ->
    let mouse_state = Mouse.get_state () in
    let point = Mouse.State.point mouse_state in
    let open Structures in
    Point.(point.x >= 0) [@true "valid X coordinate of mouse"];
    Point.(point.y >= 0) [@true "valid Y coordinate of mouse"];
    [] [@eq []];
  )

let%spec "SDL Mouse module can create system cursor" =
  with_sdl (fun () ->
    let open Flags in
    let cursor = Mouse.create_system_cursor Sdl_system_cursor.SDL_SYSTEM_CURSOR_ARROW in
    let open Types.Result.Monad_infix in
    let s = cursor >>= (fun cursor ->
      Mouse.set cursor;
      Types.Result.return ()
    ) in
    match s with
    | Types.Result.Success _ -> ()
    | Types.Result.Failure s -> s [@fail]
  ) 

let%spec "SDL Mouse module can toggle what cursor is shown" =
  with_sdl (fun () ->
    let open Types.Result.Monad_infix in
    Mouse.show () >>= (fun s ->
      Mouse.hide () >>= (fun h ->
        Mouse.is_showing () >>= (fun q ->
          s [@eq `SHOWN];
          h [@eq `SHOWN];
          q [@eq `HIDDEN];
          Types.Result.return ()
        )
      )
    )
  )

let%spec "SDL Mouse module can warp to the point" =
  with_sdl (fun () ->
    let open Types.Result.Monad_infix in
    let open Structures in
    Mouse.warp_global Point.({x = 10;y = 100}) >>= (fun () ->
      let s = Mouse.get_global_state () in
      let module S = Mouse.State in
      let point = S.point s in
      point.Point.x [@eq 10];
      point.Point.y [@eq 100];
      Types.Result.return ()
    )
  )
