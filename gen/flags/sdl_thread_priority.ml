type t = [`High
         |`Normal
         |`Low
         ]

let to_int = function
  | `Low -> 0
  | `Normal -> 1
  | `High -> 2

let of_int = function
  | 0 -> `Low
  | 1 -> `Normal
  | 2 -> `High
  | _ -> failwith "No variant to match given value"
