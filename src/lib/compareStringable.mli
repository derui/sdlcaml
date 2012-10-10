(* add ability that can compare and convert string to module *)
module type Type =
  sig
    include Compareable.Type
    include Stringable.Type with type t := t
  end

module type S =
  sig
    include Compareable.S
    include Stringable.S with type t := t
  end

module Make (T:Type) : S with type t := T.t
