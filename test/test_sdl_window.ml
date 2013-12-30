open Core.Std
open Sdlcaml.Std

let with_init f =
  Init.init Flags.Sdl_init_flags.([SDL_INIT_VIDEO]);
  protect ~f ~finally:Init.quit

let with_win w f =
  protect ~f:(fun () -> f w) ~finally:(fun () -> Window.destroy w) |> ignore

let%spec "The SDL Window module should be able to get flags when initialize it" =
  let module W = Window in
  with_init (fun () ->
    let window = W.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[`RESIZABLE;] in
    with_win window (fun window -> 
      let f = List.exists ~f:(fun x -> x = `RESIZABLE) in
      f (W.get_window_flags window) [@true "exists"];
    )
  )

let%spec "The SDL Window module can create a window with options, then can destroy it" =
  let module W = Window in

  with_init (fun () ->
    let window = W.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[] in
    with_win window (fun window -> 

      (W.get_title window) [@eq "test"];
      let size = W.get_size window in
      (size.Structures.Size.width) [@eq 100];
      (size.Structures.Size.height) [@eq 200];
    )
  )

let%spec "The SDL Window module can set and get the size of the window" =
  let module W = Window in

  with_init (fun () ->
    let window = W.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[] in
    with_win window (fun window ->

      let size = W.get_size window in
      (size.Structures.Size.width) [@eq 100];
      (size.Structures.Size.height) [@eq 200];

      W.set_size window {Structures.Size.width = 200; height = 400};
      let size = W.get_size window in
      (size.Structures.Size.width) [@eq 200];
      (size.Structures.Size.height) [@eq 400]
    )
  )

let%spec "The SDL Window module can set and get maximize size of the window" =
  let module W = Window in
  with_init (fun () ->
    let window = W.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[] in
    with_win window (fun window ->
      W.set_maximum_size window {Structures.Size.width = 300; height = 400};
      W.maximize window;
      let size = W.get_maximum_size window in
      (size.Structures.Size.width) [@eq 300];
      (size.Structures.Size.height) [@eq 400]
    )
  )

let%spec "The SDL Window module can set and get minimize size of the window" =
  let module W = Window in
  with_init (fun () ->
    let window = W.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:200 ~flags:[] in
    with_win window (fun window ->

      W.set_minimum_size window {Structures.Size.width = 30; height = 40};
      W.minimize window;
      let size = W.get_minimum_size window in
      (size.Structures.Size.width) [@eq 30];
      (size.Structures.Size.height) [@eq 40]
    )
  )

let%spec "The SDL Window module should get ID of the window and get window from it" =
  let module W = Window in
  with_init (fun () ->
    let window = W.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:100 ~flags:[] in
    with_win window (fun window ->
      let id = W.get_id window in
      (W.get_from_id id |> W.get_id) [@eq id]
    )
  )

let%spec "The SDL Window module should hide and show window" =
  let module W = Window in
  with_init (fun () ->
    let window = W.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:100 ~flags:[] in
    with_win window (fun window ->
      W.show window;
      W.hide window
    )
  )

let%spec "The SDL Window module should set and get brightness of the window" =
  let module W = Window in
  with_init (fun () ->
    let window = W.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:100 ~flags:[] in
    with_win window (fun window ->
      W.set_brightness window 1.0;
      (W.get_brightness window) [@eq 1.0]
    )
  )

let%spec "The SDL Window module can set and get bordered property" =
  let module W = Window in
  (* borderless flags must be set on initialize *)
  with_init (fun () ->
    let window = W.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:100 ~flags:[`BORDERLESS] in
    with_win window (fun window ->

      let bordered_not_found = List.exists ~f:(fun x -> x = `BORDERLESS) in
      bordered_not_found (W.get_window_flags window) [@eq true];

      W.set_bordered window true;
      let bordered_found = Fn.compose not bordered_not_found in
      bordered_found (W.get_window_flags window) [@eq true]
    )
  )

let%spec "The SDL Window module can update surface of it owning" =
  let module W = Window in
  
  with_init (fun () ->
    let window = W.create ~title:"test" ~x:0 ~y:0 ~w:100 ~h:100 ~flags:[] in
    with_win window (fun window ->
    (* First, get_surface execute before do update_surface. *)
      W.get_surface window |> ignore;

      W.update_surface window
    )
  )

let%spec "The SDL Window module can set and get position of the window" =
  let module W = Window in
  with_init (fun () ->

    let window = W.create ~title:"test" ~x:100 ~y:110 ~w:100 ~h:100 ~flags:[] in
    with_win window (fun window ->

      let pos = W.get_position window in
      (pos.Structures.Point.x) [@eq 100];
      (pos.Structures.Point.y) [@eq 110];
      
      W.set_position window {Structures.Point.x = 200; y = 300};

      let pos = W.get_position window in
      (pos.Structures.Point.x) [@eq 200];
      (pos.Structures.Point.y) [@eq 300]
    )
  )
