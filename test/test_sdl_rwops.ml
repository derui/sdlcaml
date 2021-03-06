[%%suite
 open Core.Std
 open Sdlcaml.Std

 let%spec "The SDL Rwops module can open the file" =
   let file = "./temp.txt" in
   let open Types.Resource.Monad_infix in
   RWops.read_from_file ~file ~mode:`Write () >>= (fun f ->
     protect ~f:(fun () ->
       (Sys.file_exists file) [@eq `Yes]
     ) ~finally:(fun () ->
       Sys.remove file
     ) |> Types.Resource.return
   ) |> ignore

 let%spec "The SDL Rwops module can write and read from the file" =
   let file = "./temp2.txt" in
   protect ~f:(fun () ->
     let open Types.Resource.Monad_infix in
     RWops.read_from_file ~file ~mode:`Write () >>= (fun f ->
       let m = RWops.write f ~endian:`Little ~value:(`Word 1000) in
       m [@eq Pervasives.Ok ()];
       Types.Resource.return ()
     ) |> ignore;

     RWops.read_from_file ~file ~mode:`Read () >>= (fun f ->
       let v = RWops.read f ~endian:`Little ~size:`Word in
       v [@eq `Word 1000];
       Types.Resource.return ()
     ) |> ignore;
   ) ~finally:(fun () -> Sys.remove file)

 let%spec "The SDL Rwops module can seek and tell pointer that positions" =
   let file = "./temp3.txt" in
   protect ~f:(fun () ->
     let open Types.Resource.Monad_infix in
     RWops.read_from_file ~file ~mode:`Write () >>= (fun f ->
       let range = List.range 1 1000 in
       List.iter range ~f:(fun index -> RWops.write f ~endian:`Little ~value:(`Byte index) |> ignore);
       Types.Resource.return ()
     ) |> ignore;

     let return = Types.Result.return in
     RWops.read_from_file ~file ~mode:`Read () >>= (fun f ->
       Types.Result.Monad_infix.(
       RWops.current_position f >>= (fun pos -> pos [@eq 0L]; return ())
       >>= (fun () -> RWops.seek f ~pos:10L ~relative:`CUR >>= (fun pos -> pos [@eq 10L]; return ()))
       >>= (fun () -> RWops.current_position f >>= (fun pos -> pos [@eq 10L]; return ()))
       >>= (fun () -> RWops.seek f ~pos:(-10L) ~relative:`END >>= (fun pos -> pos [@eq 989L]; return ()))
                                                >>= (fun () -> RWops.current_position f >>= (fun pos -> pos [@eq 989L]; return ()))
       ) |> Types.Resource.return
     ) |> ignore;
   ) ~finally:(fun () -> Sys.remove file)
]
