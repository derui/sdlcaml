[%%suite
 open Core.Std
 open Sdlcaml.Std

 let%spec "The SDL Rwops module can open the file" =
   let file = "./temp.txt" in
   let module R = Types.Resource in
   let open Types.Resource.Monad_infix in
   let cc = RWops.read_from_file ~file ~mode:`Write () >>= (fun f ->
     protect ~f:(fun () ->
       (Sys.file_exists file) [@eq `Yes]
     ) ~finally:(fun () ->
       Sys.remove file
     ) |> Types.Resource.return
   ) in
   R.run cc ignore |> ignore

 let%spec "The SDL Rwops module can write and read from the file" =
   let file = "./temp2.txt" in
   protect ~f:(fun () ->
     let module R = Types.Resource in 
     let open Types.Resource.Monad_infix in
     let cc = RWops.read_from_file ~file ~mode:`Write () >>= (fun f ->
       let m = RWops.write f ~endian:`Little ~value:(`Word 1000) in
       m [@eq Pervasives.Ok ()];
       Types.Resource.return ()
     ) in
     R.run cc ignore |> ignore;

     let cc = RWops.read_from_file ~file ~mode:`Read () >>= (fun f ->
       let v = RWops.read f ~endian:`Little ~size:`Word in
       v [@eq `Word 1000];
       Types.Resource.return ()
     ) in
     R.run cc ignore |> ignore;
   ) ~finally:(fun () -> Sys.remove file)

 let%spec "The SDL Rwops module can seek and tell pointer that positions" =
   let file = "./temp3.txt" in
   protect ~f:(fun () ->
     let module R = Types.Resource in 
     let open Types.Resource.Monad_infix in
     let cc = RWops.read_from_file ~file ~mode:`Write () >>= (fun f ->
       let range = List.range 1 1000 in
       List.iter range ~f:(fun index -> RWops.write f ~endian:`Little ~value:(`Byte index) |> ignore);
       Types.Resource.return ()
     ) in
     R.run cc ignore |> ignore;

     let return = Types.Result.return in
     let assert_pos expect pos = pos [@eq expect]; return () in
     R.run (RWops.read_from_file ~file ~mode:`Read () >>= (fun f ->
       Types.Result.Monad_infix.(
         RWops.current_position f >>= (fun pos -> pos [@eq 0L]; return ()) >>=
           (fun () -> RWops.seek f ~pos:10L ~relative:`CUR >>= assert_pos 10L) >>=
           (fun () -> RWops.current_position f >>= assert_pos 10L) >>=
           (fun () -> RWops.seek f ~pos:(-10L) ~relative:`END >>= assert_pos 989L) >>=
           (fun () -> RWops.current_position f >>= assert_pos 989L)
       ) |> Types.Resource.return)) ignore |> ignore
   ) ~finally:(fun () -> Sys.remove file)
]
