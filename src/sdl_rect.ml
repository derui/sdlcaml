

type t = Sdlcaml_structures.Rect.t

module R = Sdlcaml_structures.Rect
module P = Sdlcaml_structures.Point

let is_enclose_point rect point =
  if rect.R.x > point.P.x || rect.R.y > point.P.y then false
  else
  if rect.R.x + rect.R.w < point.P.x || rect.R.y + rect.R.h < point.P.y then false
  else true

let either_side_at_point rect point =
  if rect.R.x > point.P.x then `Left
  else `Right

let either_updown_at_point rect point =
  if rect.R.y > point.P.y then `Top else `Bottom

let enclose_points ~points ?clip () =
  let rect = {R.x = 0; y = 0; w = 0; h = 0} in
  let calc_enclosing rect point =
    let rect = match either_side_at_point rect point with
      | `Left ->
        {rect with R.x = point.P.x; w = rect.R.w + (abs (point.P.x - rect.R.x))}
      | `Right ->
        {rect with R.w = abs (point.P.x - rect.R.x)}
    in
    match either_updown_at_point rect point with
    | `Top ->
      {rect with R.y = point.P.y; h = rect.R.h + (abs (point.P.y - rect.R.y))}
    | `Bottom -> {rect with R.h = abs (point.P.y - rect.R.y)}
  in

  match clip with
  | None ->
    List.fold_left calc_enclosing rect points
  | Some clip ->
    let calc_enclosing' rect point =
      if not (is_enclose_point clip point) then rect
      else calc_enclosing rect point
    in
    List.fold_left calc_enclosing' rect points
let is_intersected a b =
  let intersect_x = a.R.x + a.R.w > b.R.x && b.R.x > a.R.x
  and intersect_y = a.R.y + a.R.h > b.R.y && b.R.y > a.R.y in
  intersect_x && intersect_y

let has_intersection a b =
  is_intersected a b || is_intersected b a

let intersect a b =
  if not (has_intersection a b) then {R.x = 0; y = 0; w = 0; h = 0}
  else
    match (is_intersected a b, is_intersected b a) with
    | (true, _) -> {R.x = b.R.x; y = b.R.y; w = abs (b.R.x - a.R.x);
                    h = abs (b.R.y - a.R.y)}
    | (_, true) -> {R.x = a.R.x; y = a.R.y; w = abs (b.R.x - a.R.x); h = abs (b.R.y - a.R.y)}
    | (false, false) -> {R.x = 0; y = 0; w = 0; h = 0}

let is_empty rect = rect.R.w = 0 && rect.R.h == 0

let equals a b =
  let open R in
  a.x = b.x && a.y = b.y && a.h = b.h && a.w == b.w

let union a b =
  let x = min a.R.x b.R.x
  and y = min a.R.y b.R.y in
  let w = (max (a.R.x + a.R.w) (b.R.x + b.R.w)) - x
  and h = (max (a.R.y + a.R.h) (b.R.y + b.R.h)) - y in
  {R.x = x;y;w;h}
