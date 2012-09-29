let to_string_sep rparen lparen f =
  function
      None -> rparen ^ lparen
    | Some x -> rparen ^ (f x) ^ lparen

let to_string f =
  to_string_sep "{" "}" f

let print fmt f x =
  Format.fprintf fmt "%s" (to_string f x)

module type CoreS =
sig
  type 'a t = 'a option
  val compare : 'a t -> 'a t -> int
  val empty : 'a option
  val identity : 'a option
  val singleton : 'a -> 'a t
  val some : 'a -> 'a t
  val add : 'a -> 'a t -> 'a t
  val bind : 'a t -> ('a -> 'b t) -> 'b option
  val fold : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b
  val safe_get : 'a -> 'a t -> 'a
end

module Core : CoreS =
struct
  type 'a t = 'a option

  let compare = compare
  let empty = None
  let identity = None
  let singleton x = Some x
  let some = singleton
  let add x _ = Some x

  let bind x f =
    match x with
        None -> None
      | Some x -> f x

  let fold f x e =
    match x with
        None -> e
      | Some x -> f x e

  let safe_get e = function
      None -> e
    | Some x -> x
end

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

module Make(T:CompareStringable.Type) : S with type elt = T.t =
struct
  module Core =
  struct
    type elt = T.t
    type t = elt option
    let lparen = "{"
    let rparen = "}"
    let separator = ""
    let compare x y =
      match (x, y) with
          (None, None) -> 0
        | (Some _, None) -> 1
        | (None, Some _) -> -1
        | (Some x, Some y) -> T.compare x y
    let identity = None
    let empty = identity
    let singleton x = Some x
    let add x _ = Some x
    let bind x f =
      match x with
          None -> None
        | Some x -> f x
    let fold f opt e =
      match opt with
          None -> e
        | Some x -> f x e
    let safe_get emp = function
        None -> emp
      | Some x -> x
    let to_string = T.to_string
  end

  include Core
  include Compareable.Make(Core)
  include Monad.Make(Core)
  include Collection.Make(Core)
end

include Core
include TypedCompareable.Make(Core)
include TypedMonad.Make(Core)
include TypedCollection.Make(Core)
