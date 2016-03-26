type t = [`TRIGGERRIGHT
         |`TRIGGERLEFT
         |`RIGHTY
         |`RIGHTX
         |`LEFTY
         |`LEFTX
         |`INVALID
         ]

let to_int = function
  | `INVALID -> -1
  | `LEFTX -> 0
  | `LEFTY -> 1
  | `RIGHTX -> 2
  | `RIGHTY -> 3
  | `TRIGGERLEFT -> 4
  | `TRIGGERRIGHT -> 5

let of_int = function
  | -1 -> `INVALID
  | 0 -> `LEFTX
  | 1 -> `LEFTY
  | 2 -> `RIGHTX
  | 3 -> `RIGHTY
  | 4 -> `TRIGGERLEFT
  | 5 -> `TRIGGERRIGHT
  | _ -> failwith "No variant match given value"
