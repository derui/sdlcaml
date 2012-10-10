(* Type of Monad with type variable. *)
module type Type =
sig
  (* type *)
  type 'a t
  (* return identity element of this type *)
  val identity : 'a t
  (* return wraped elt  *)
  val singleton : 'a -> 'a t
  (* combine type with action functon, return combined type *)
  val bind : 'a t -> ('a -> 'b t) -> 'b t
end

module type S =
sig
  type 'a t
  (* alias of `bind` *)
  val (>>=) : 'a t -> ('a  -> 'b t) -> 'b t
  (* fliped >>= *)
  val (<<=) : ('a -> 'b t) -> 'a t -> 'b t
  (* if it is failed, return identity *)
  val fail : 'a t
  (* alias `singleton` *)
  val return :  'a -> 'a t
  (* if given function is true, return wraped elt. but given function
     is false, return identity. *)
  val guard : ('a -> bool) -> 'a -> 'a t
  (* apply list of bind function to monadic type of `t`, return last t *)
  val sequence : 'a t -> ('a -> 'a t) list -> 'a t
  (* basic function equals `sequence`, but this function return unit.
     it is used by only desired side effects.
  *)
  val sequence_ : 'a t -> ('a -> 'a t) list -> unit
end

module Make (T:Type) : S with type 'a t := 'a T.t
