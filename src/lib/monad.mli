(* Type of Monad. *)
module type Type =
sig
  (* element type *)
  type elt
  (* type *)
  type t
  (* return identity element of this type *)
  val identity : t
  (* return wraped elt  *)
  val singleton : elt -> t
  (* combine type with action functon, return combined type *)
  val bind : t -> (elt -> t) -> t
end

module type S =
sig
  type elt
  type t
  (* alias of `bind` *)
  val (>>=) : t -> (elt -> t) -> t
  (* fliped >>= *)
  val (<<=) : (elt -> t) -> t -> t
  (* if it is failed, return identity *)
  val fail : t
  (* alias `singleton` *)
  val return : elt -> t
  (* if given function is true, return wraped elt. but given function
     is false, return identity. *)
  val guard : (elt -> bool) -> elt -> t
  (* apply list of bind function to monadic type of `t`, return last t *)
  val sequence : t -> (elt -> t) list -> t
  (* basic function equals `sequence`, but this function return unit.
     it is used by only desired side effects.
  *)
  val sequence_ : t -> (elt -> t) list -> unit
end

module Make (T:Type) : S with type elt := T.elt and type t := T.t
