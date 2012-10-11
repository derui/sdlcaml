module type Type =
sig
  type 'a t
  val identity : 'a t
  val singleton : 'a -> 'a t
  val bind : 'a t -> ('a -> 'b t) -> 'b t
end

module type S =
sig
  type 'a t
  val (>>=) : 'a t -> ('a  -> 'b t) -> 'b t
  val (<<=) : ('a -> 'b t) -> 'a t -> 'b t
  val fail : 'a t
  val return :  'a -> 'a t
  val guard : ('a -> bool) -> 'a -> 'a t
  val sequence : 'a t -> ('a -> 'a t) list -> 'a t
  val sequence_ : 'a t -> ('a -> 'a t) list -> unit
end

module Make (T:Type) : S with type 'a t := 'a T.t =
struct
  open T
  open Prelude
  let (>>=) = bind
  let (<<=) f m = m >>= f
  let fail = identity
  let return = singleton
  let guard f x = if f x then singleton x else identity
  let rec sequence x = function
    | [] -> x
    | f::t -> sequence (x >>= f) t
  let sequence_ x f = sequence x f |> ignore
end
