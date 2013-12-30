open Core.Std
open Sdlcaml.Std

let%spec "The SDL Rwops module can open the file" =
  let file = "./temp.txt" in
  let open Types.Result.Monad_infix in
  Rw_ops.read_from_file ~file ~mode:`Write () >>= (fun f ->
    protect ~f:(fun () ->
      (Sys.file_exists file) [@eq `Yes]
    ) ~finally:(fun () ->
      Rw_ops.close f >>= (fun () -> Sys.remove file |> Types.Result.return) |> ignore
    ) |> Types.Result.return
  ) |> ignore

let%spec "The SDL Rwops module can write and read from the file" =
  let file = "./temp2.txt" in
  protect ~f:(fun () ->
    let open Types.Result.Monad_infix in
    Rw_ops.read_from_file ~file ~mode:`Write () >>= (fun f ->
      let m = Rw_ops.write f ~endian:`Little ~value:(`Word 1000) in
      Types.Result.is_success m [@eq true];
      Rw_ops.close f
    ) |> ignore;

    Rw_ops.read_from_file ~file ~mode:`Read () >>= (fun f ->
      let v = Rw_ops.read f ~endian:`Little ~size:`Word in
      v [@eq `Word 1000];
      Types.Result.return ()
    ) |> ignore;
  ) ~finally:(fun () -> Sys.remove file)

let%spec "The SDL Rwops module can seek and tell pointer that positions" =
  let file = "./temp3.txt" in
  protect ~f:(fun () ->
    let open Types.Result.Monad_infix in
    Rw_ops.read_from_file ~file ~mode:`Write () >>= (fun f ->
      let range = List.range 1 1000 in
      List.iter range ~f:(fun index -> Rw_ops.write f ~endian:`Little ~value:(`Byte index) |> ignore);
      Rw_ops.close f
    ) |> ignore;

    let return = Types.Result.return in
    Rw_ops.read_from_file ~file ~mode:`Read () >>= (fun f ->
      Rw_ops.current_position f >>= (fun pos -> pos [@eq 0L]; return ())
      >>= (fun () -> Rw_ops.seek f ~pos:10L ~relative:`CUR >>= (fun pos -> pos [@eq 10L]; return ()))
      >>= (fun () -> Rw_ops.current_position f >>= (fun pos -> pos [@eq 10L]; return ()))
      >>= (fun () -> Rw_ops.seek f ~pos:(-10L) ~relative:`END >>= (fun pos -> pos [@eq 989L]; return ()))
      >>= (fun () -> Rw_ops.current_position f >>= (fun pos -> pos [@eq 989L]; return ()))
    ) |> ignore;
  ) ~finally:(fun () -> Sys.remove file)
