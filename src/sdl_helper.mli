
val bool_to_int: bool -> int
(* [bool_to_int b] gets mapped integer value as true or false. This function return [1] when [b] is true,
   or [0] when [b] is false.
*)

val int_to_bool: int -> bool
(* [int_to_bool n] gets boolean value mapped by [n]. If [n] is 1, this function return [true],
   and return [false] when [n] is not 1.
*)

(** Return either Success or Failure whether return code as ret is success or failure *)
val ret_to_result: int -> (unit -> 'a) -> 'a Sdl_types.Result.t
