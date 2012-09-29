open Num
(* identity function *)
val id : 'a -> 'a
(* constant function. always return first argument. *)
val const : 'a -> 'b -> 'a
(* flip argument align. *)
val flip : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c

(* control direction of to apply function to argument.
   |> looks like monad bind (>>=) is reversed to apply argument of
   normal direction.
*)
val (|>) : 'a -> ('a -> 'b ) -> 'b

(* control direction of to apply function to argument.
   <| is alias of normal function application.
*)
val (<|) : ('a -> 'b) -> 'a -> 'b

(* initialization list. this return list that applied each [0..n) to
   f. it likes [f(0);f(1);..f(n-1)]
*)
val init : int -> (int -> 'a) -> 'a list

(* return list within the compass of given min to given max. *)
val range : num * num -> num list

(* return true if given option is None. *)
val is_none : 'a option -> bool

(* return true if given option is Some and some value. *)
val is_some : 'a option -> bool

(* comparing floats that if one float has difference lesser than
  `epsilon`, result of comparing is `0` as true.
*)
val cmp_float : epsilon:float -> float -> float -> int
