
(** this module is used to functor when needs some modules to compare
    t.

    usage: when you want to add compareable ability into module,
    include with applying Make that is in this module.

    include Compareable.Make({...})
*)
module type Type =
sig
  type t
  (** compare elements. if first @t@ is less than second, return -1.
      if first @t@ equal second, return 0.
      return 1 if first @t@ is greater than second.
  *)
  val compare : t -> t -> int
end

module type S =
sig
  (** element type of this signature. this is had to overwrite when
      using any module. *)
  type t

  (** equals between elements *)
  val eq : t -> t -> bool
  (** not equals between elements *)
  val ne : t -> t -> bool
  (** first element is greater than second *)
  val gt : t -> t -> bool
  (** first element is greater equal second *)
  val ge : t -> t -> bool
  (** first element is less than second *)
  val lt : t -> t -> bool
  (** first element is less equal second *)
  val le : t -> t -> bool
end

(** using this module when need order functions. *)
module Make (T : Type) : S with type t := T.t
