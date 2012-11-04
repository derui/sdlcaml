module Collection = Collection
module CompareStringable = CompareStringable
module Math = Math
module Monad = Monad
module Option = Option
module Prelude = Prelude
module Stringable = Stringable
module TypedCollection = TypedCollection
module TypedStringable = TypedStringable

module Either = Either

module Comparable = Comparable

(* extended List *)
module List = struct
  (* Inherits the original List module *)
  include List

  (* Inherits my extended List *)
  include Ext_list
end

(* Original Map module *)
module Map = Ext_map
