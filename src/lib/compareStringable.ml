
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

module Make (T:Type) : S with type t := T.t =
struct
  include Compareable.Make(T)
  include Stringable.Make(T)
end
