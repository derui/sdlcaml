type t =
  [`INPUT
  | `ASSERT
  |`RENDER
  |`VIDEO
  |`AUDIO
  |`SYSTEM
  |`ERROR
  |`APPLICATION
  ]

let to_int = function
  | `INPUT -> 7
  | `RENDER -> 6
  | `VIDEO -> 5
  | `AUDIO -> 4
  | `SYSTEM -> 3
  | `ASSERT -> 2
  | `ERROR -> 1
  | `APPLICATION -> 0

let of_int = function
  | 7 -> `INPUT
  | 6 -> `RENDER
  | 5 -> `VIDEO
  | 4 -> `AUDIO
  | 3 -> `SYSTEM
  | 2 -> `ASSERT
  | 1 -> `ERROR
  | 0 -> `APPLICATION
  | _ -> failwith "No variant to match given value"
