type t = [`DISABLE
         |`ENABLE
         ]

let to_int = function
  | `DISBLE -> 0
  | `ENABLE -> 1

let of_int = function
  | 0 -> `DISBLE
  | 1 -> `ENABLE
  | _ -> failwith "No availability match with given value"
