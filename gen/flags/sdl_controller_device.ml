type t = [`REMAPPED
         | `REMOVED
         | `ADDED
         ]

let to_int = function
  | `REMAPPED -> 0x655
  | `REMOVED -> 0x654
  | `ADDED -> 0x653

let of_int = function
  | 0x655 -> `REMAPPED
  | 0x654 -> `REMOVED
  | 0x653 -> `ADDED
  | _ -> failwith "No variant match given value"
