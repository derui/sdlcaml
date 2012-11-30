type t = {x:float; y:float; z:float}

let zero = {x = 0.0; y = 0.0; z = 0.0}

let of_vec {x;y;z} = (x, y, z)

let normal_axis = function
  | `X -> {x = 1.0; y = 0.0; z = 0.0}
  | `Y -> {x = 0.0; y = 1.0; z = 0.0}
  | `Z -> {x = 0.0; y = 0.0; z = 1.0}

let normalize {x;y;z} =
  let len = sqrt(x *. x +. y *. y +. z *. z) in
  {x = x /. len; y = y /. len;z = z /. len}

let norm {x;y;z} = sqrt(x *. x +. y *. y +. z *. z)

let norm_square {x;y;z} = x *. x +. y *. y +. z *. z

let dot v1 v2 =
  v1.x *. v2.x +. v1.y *. v2.y +. v1.z *. v2.z

let cross v1 v2 =
  {x = v1.y *. v2.z -. v2.y *. v1.z;
   y = v1.x *. v2.z -. v2.x *. v1.z;
   z = v1.x *. v2.y -. v2.x *. v1.z;
  }

let scale ~v ~scale =
  {x = v.x *. scale; y = v.y *. scale; z = v.z *. scale}

let add v1 v2 = {x = v1.x +. v2.x; y = v1.y +. v2.y; z = v1.z +. v2.z}

let sub v1 v2 = {x = v1.x -. v2.x;y = v1.y -. v2.y; z = v1.z -. v2.z}

let is_square v1 v2 =
  match classify_float (dot v1 v2) with
      FP_zero -> true
    | _ -> false

let compare v1 v2 =
  let open Extlib.Std.Prelude in
  let cmp = cmp_float ~epsilon:0.0000001 in
  let compare_x = cmp v1.x v2.x
  and compare_y = cmp v1.y v2.y
  and compare_z = cmp v1.z v2.z
  in
  if compare_x = 0 then
    if compare_y = 0 then
      compare_z
    else compare_y
  else compare_x
