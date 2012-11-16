type t = float * float * float

let to_vec ~x ~y ~z = (x, y, z)
let to_vec_tuple tuple = tuple
let of_vec tuple = tuple

let normal_axis = function
    `X -> (1.0, 0.0, 0.0)
  | `Y -> (0.0, 1.0, 0.0)
  | `Z -> (0.0, 0.0, 1.0)

let normalize (x,y,z) =
  let len = sqrt(x *. x +. y *. y +. z *. z) in
  (x /. len, y /. len, z /. len)

let norm (x, y, z) = sqrt(x *. x +. y *. y +. z *. z)

let norm_square (x, y, z) = x *. x +. y *. y +. z *. z

let dot (x1, y1, z1) (x2, y2, z2) =
  x1 *. x2 +. y1 *. y2 +. z1 *. z2

let cross (x1, y1, z1) (x2, y2, z2) =
  (y1 *. z2 -. y2 *. z1, x1 *. z2 -. x2 *. z1, x1 *. y2 -. x2 *. y1)

let scaling ~vec:(x, y, z) ~scale =
  (x *. scale, y *. scale, z *. scale)

let add (x1, y1 ,z1) (x2, y2, z2) = (x1 +. x2, y1 +. y2, z1 +. z2)

let sub (x1, y1, z1) (x2, y2, z2) = (x1 -. x2, y1 -. y2, z1 -. z2)

let is_square v1 v2 =
  match classify_float (dot v1 v2) with
      FP_zero -> true
    | _ -> false

let compare (x1, y1, z1) (x2, y2, z2) =
  let open Extlib.Std.Prelude in
  let cmp = cmp_float ~epsilon:0.0000001 in
  let compare_x = cmp x1 x2
  and compare_y = cmp y1 y2
  and compare_z = cmp z1 z2
  in
  if compare_x = 0 then
    if compare_y = 0 then
      compare_z
    else compare_y
  else compare_x
