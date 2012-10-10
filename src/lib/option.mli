(* Convert Option to string with translating function. *)
val to_string : ('a -> string) -> 'a option -> string

(* output string that converted option. *)
val print : Format.formatter -> ('a -> string) -> 'a option -> unit

(* core functions for option with typed variable. If you use
   specialized option, use Option.Make with functor. *)
module type CoreS =
sig
  type 'a t = 'a option
  val compare : 'a t -> 'a t -> int
  val empty : 'a option
  val identity : 'a option
  (* alias of `some` *)
  val singleton : 'a -> 'a t
  val some : 'a -> 'a t
  val add : 'a -> 'a t -> 'a t
  val bind : 'a t -> ('a -> 'b t) -> 'b t
  val fold : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b
  val safe_get : 'a -> 'a t -> 'a
end

module Core : CoreS

module type S =
sig
  type elt
  type t = elt option
  val safe_get : elt -> t -> elt
  include Monad.Type with type elt := elt
                     and type t := t
  include Collection.Type with type t := t and type elt := elt
  include Compareable.Type with type t := t
  include Monad.S with type elt := elt
                     and type t := t
  include Collection.S with type t := t and type elt := elt
  include Compareable.S with type t := t
end

module Make(T:CompareStringable.Type) : S with type elt = T.t
include CoreS
include TypedCompareable.S with type 'a t := 'a option
include TypedMonad.S with type 'a t := 'a option
include TypedCollection.S with type 'a t := 'a option
