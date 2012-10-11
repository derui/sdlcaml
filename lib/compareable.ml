module type Type =
sig
  type t
  val compare : t -> t -> int
end

module type S =
sig
  type t

  val eq : t -> t -> bool
  val ne : t -> t -> bool
  val gt : t -> t -> bool
  val ge : t -> t -> bool
  val lt : t -> t -> bool
  val le : t -> t -> bool
end

module Make (T : Type) : S with type t := T.t
  =
struct
  open T
  let eq t1 t2 = compare t1 t2 = 0
  let ne t1 t2 = compare t1 t2 <> 0
  let gt t1 t2 = compare t1 t2 > 0
  let ge t1 t2 = compare t1 t2 >= 0
  let lt t1 t2 = compare t1 t2 < 0
  let le t1 t2 = compare t1 t2 <= 0
end
