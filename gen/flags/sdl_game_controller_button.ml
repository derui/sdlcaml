type t = [`DPAD_RIGHT
         |`DPAD_LEFT
         |`DPAD_DOWN
         |`DPAD_UP
         |`RIGHTSHOULDER
         |`LEFTSHOULDER
         |`RIGHTSTICK
         |`LEFTSTICK
         |`START
         |`GUIDE
         |`BACK
         |`Y
         |`X
         |`B
         |`A
         ]

let to_int = function
  | `A -> 0
  | `B -> 1
  | `X -> 2
  | `Y -> 3
  | `BACK -> 4
  | `GUIDE -> 5
  | `START -> 6
  | `LEFTSTICK -> 7
  | `RIGHTSTICK -> 8
  | `LEFTSHOULDER -> 9
  | `RIGHTSHOULDER -> 10
  | `DPAD_UP -> 11
  | `DPAD_DOWN -> 12
  | `DPAD_LEFT -> 13
  | `DPAD_RIGHT -> 14

let of_int = function
  | 0 -> `A
  | 1 -> `B
  | 2 -> `X
  | 3 -> `Y
  | 4 -> `BACK
  | 5 -> `GUIDE
  | 6 -> `START
  | 7 -> `LEFTSTICK
  | 8 -> `RIGHTSTICK
  | 9 -> `LEFTSHOULDER
  | 10 -> `RIGHTSHOULDER
  | 11 -> `DPAD_UP
  | 12 -> `DPAD_DOWN
  | 13 -> `DPAD_LEFT
  | 14 -> `DPAD_RIGHT
  | _ -> failwith "No variant to match given value"
