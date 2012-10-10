module type Type =
sig
  type elt
  type t
  val identity : t
  val singleton : elt -> t
  val bind : t -> (elt -> t) -> t
end

module type S =
sig
  type elt
  type t
  val (>>=) : t -> (elt -> t) -> t
  val (<<=) : (elt -> t) -> t -> t
  val fail :t
  val return : elt -> t
  val guard : (elt -> bool) -> elt -> t
  val sequence : t -> (elt -> t) list -> t
  val sequence_ : t -> (elt -> t) list -> unit
end

module Make (T:Type) : S with type elt := T.elt and type t := T.t =
struct
  open T
  let (>>=) = bind
  let (<<=) f m = m >>= f
  let fail = identity
  let return = singleton
  let guard f x = if f x then singleton x else identity
  let rec sequence x = function
    | [] -> x
    | f::t -> sequence (x >>= f) t
  let rec sequence_ x = function
    | [] -> ()
    | f::t -> sequence_ (x >>= f) t
end
