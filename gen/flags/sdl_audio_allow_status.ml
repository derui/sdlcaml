type t =
  [ `FREQUENCY_CHANGE
  | `FORMAT_CHANGE
  | `CHANNELS_CHANGE
  ]

let mapping = [
  (1, `FREQUENCY_CHANGE);
  (2, `FORMAT_CHANGE);
  (4, `CHANNELS_CHANGE);
]

let of_int = function
  | `FREQUENCY_CHANGE -> 1
  | `FORMAT_CHANGE -> 2
  | `CHANNELS_CHANGE -> 4

let to_list v =
  List.fold_left (fun memo (mask, variant) ->
    if v land mask > 0 then variant :: memo else memo
  ) [] mapping

let of_list list =
  List.fold_left (fun memo v ->
    memo lor (of_int v)
  ) 0 list
