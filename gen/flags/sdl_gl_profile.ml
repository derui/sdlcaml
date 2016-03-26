type t =
  [ `ES
  | `COMPATIBILITY
  | `CORE
  ]

let to_int = function
  | `ES -> 0x4
  | `COMPATIBILITY -> 0x2
  | `CORE -> 0x1

let of_int = function
  | 0x4 -> `ES
  | 0x2 -> `COMPATIBILITY
  | 0x1 -> `CORE
  | _ -> failwith "No variant to match given value"
