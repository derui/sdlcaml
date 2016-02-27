open Ctypes

module Sync = struct
  type _t
  let _t: _t structure typ = structure "__GLsync"
  type t = _t structure ptr
  let t = ptr _t
end
