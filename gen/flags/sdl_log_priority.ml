type t = [`CRITICAL
         |`ERROR
         |`WARN
         |`INFO
         |`DEBUG
         |`VERBOSE
         ]

let to_int = function
  | `CRITICAL -> 6
  | `ERROR -> 5
  | `WARN -> 4
  | `INFO -> 3
  | `DEBUG -> 2
  | `VERBOSE -> 1

let of_int = function
  | 6 -> `CRITICAL
  | 5 -> `ERROR
  | 4 -> `WARN
  | 3 -> `INFO
  | 2 -> `DEBUG
  | 1 -> `VERBOSE
  | _ -> failwith "No variant to match given value"
