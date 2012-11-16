module V = Gl_vector

(* precise 4x4 matrix definition. *)
type t = {
  mutable m11 : float; mutable m12 : float; mutable m13 : float; mutable m14 : float;
  mutable m21 : float; mutable m22 : float; mutable m23 : float; mutable m24 : float;
  mutable m31 : float; mutable m32 : float; mutable m33 : float; mutable m34 : float;
  mutable m41 : float; mutable m42 : float; mutable m43 : float; mutable m44 : float;
}

let to_array mat =
  [|
    mat.m11; mat.m12; mat.m13; mat.m14;
    mat.m21; mat.m22; mat.m23; mat.m24;
    mat.m31; mat.m32; mat.m33; mat.m34;
    mat.m41; mat.m42; mat.m43; mat.m44;
  |]

let identity _ =
  {
    m11 = 1.0; m12 = 0.0; m13 = 0.0; m14 = 0.0;
    m21 = 0.0; m22 = 1.0; m23 = 0.0; m24 = 0.0;
    m31 = 0.0; m32 = 0.0; m33 = 1.0; m34 = 0.0;
    m41 = 0.0; m42 = 0.0; m43 = 0.0; m44 = 1.0;
  }

let ortho_projection ~width ~height ~near ~far =
  let ratio = float width /. float height in
  let height_ratio = ratio *. 1.0 /. float height
  and width_ratio = 1.0/. (ratio *. float width) in

  { m11 = width_ratio ; m12 = 0.0;          m13 = 0.0; m14 = 0.0;
    m21 = 0.0         ; m22 = height_ratio; m23 = 0.0; m24 = 0.0;
    m31 = 0.0         ; m32 = 0.0;          m33 = 0.0; m34 = 0.0;
    m41 = 0.0         ; m42 = 0.0;          m43 = 0.0; m44 = 1.0;
  }

let perspective_projection ~fov ~ratio ~near ~far =

  let pi = 3.14159265358979323846 in
  let maxY = near *. tan (fov *. pi /. 360.0) in
  let minY = -. maxY in
  let minX = minY *. ratio
  and maxX = maxY *. ratio in

  let x_diff = maxX -. minX in
  let y_diff = maxY -. minY in
  let z_diff = far -. near in
  let near_twice = 2.0 *. near in

  let a = near_twice /. x_diff
  and b = near_twice /. y_diff
  and c = (maxX +. minX) /. x_diff
  and d = (maxY +. minY) /. y_diff
  and e = -. (far +. near) /. z_diff
  and f = -. (near_twice *. far) /. z_diff
  in
  { m11 = a;   m12 = 0.0; m13 = 0.0; m14 =  0.0;
    m21 = 0.0; m22 = b;   m23 = 0.0; m24 =  0.0;
    m31 = c;   m32 = d;   m33 = e;   m34 = -1.0;
    m41 = 0.0; m42 = 0.0; m43 = f;   m44 =  0.0;
  }

let multiply ~m1 ~m2 =
  {
    m11 = m1.m11 *. m2.m11 +. m1.m12 *. m2.m21 +. m1.m13 *. m2.m31 +. m1.m14 *. m2.m41;
    m12 = m1.m11 *. m2.m12 +. m1.m12 *. m2.m22 +. m1.m13 *. m2.m32 +. m1.m14 *. m2.m42;
    m13 = m1.m11 *. m2.m13 +. m1.m12 *. m2.m23 +. m1.m13 *. m2.m33 +. m1.m14 *. m2.m43;
    m14 = m1.m11 *. m2.m14 +. m1.m12 *. m2.m24 +. m1.m13 *. m2.m34 +. m1.m14 *. m2.m44;
    m21 = m1.m21 *. m2.m11 +. m1.m22 *. m2.m21 +. m1.m23 *. m2.m31 +. m1.m24 *. m2.m41;
    m22 = m1.m21 *. m2.m12 +. m1.m22 *. m2.m22 +. m1.m23 *. m2.m32 +. m1.m24 *. m2.m42;
    m23 = m1.m21 *. m2.m13 +. m1.m22 *. m2.m23 +. m1.m23 *. m2.m33 +. m1.m24 *. m2.m43;
    m24 = m1.m21 *. m2.m14 +. m1.m22 *. m2.m24 +. m1.m23 *. m2.m34 +. m1.m24 *. m2.m44;
    m31 = m1.m31 *. m2.m11 +. m1.m32 *. m2.m21 +. m1.m33 *. m2.m31 +. m1.m34 *. m2.m41;
    m32 = m1.m31 *. m2.m12 +. m1.m32 *. m2.m22 +. m1.m33 *. m2.m32 +. m1.m34 *. m2.m42;
    m33 = m1.m31 *. m2.m13 +. m1.m32 *. m2.m23 +. m1.m33 *. m2.m33 +. m1.m34 *. m2.m43;
    m34 = m1.m31 *. m2.m14 +. m1.m32 *. m2.m24 +. m1.m33 *. m2.m34 +. m1.m34 *. m2.m44;
    m41 = m1.m41 *. m2.m11 +. m1.m42 *. m2.m21 +. m1.m43 *. m2.m31 +. m1.m44 *. m2.m41;
    m42 = m1.m41 *. m2.m12 +. m1.m42 *. m2.m22 +. m1.m43 *. m2.m32 +. m1.m44 *. m2.m42;
    m43 = m1.m41 *. m2.m13 +. m1.m42 *. m2.m23 +. m1.m43 *. m2.m33 +. m1.m44 *. m2.m43;
    m44 = m1.m41 *. m2.m14 +. m1.m42 *. m2.m24 +. m1.m43 *. m2.m34 +. m1.m44 *. m2.m44;
  }

let rotation_matrix_of_axis ~dir ~angle =
  let angle = angle *. 0.5 in
  let vn_x, vn_y, vn_z = V.of_vec (V.normalize dir) in
  let sinAngle = sin angle in
  let qx = vn_x *. sinAngle
  and qy = vn_y *. sinAngle
  and qz = vn_z *. sinAngle
  and qw = cos angle
  in
  let x2 = qx *. qx
  and y2 = qy *. qy
  and z2 = qz *. qz
  and xy = qx *. qy
  and xz = qx *. qz
  and yz = qy *. qz
  and wx = qw *. qx
  and wy = qw *. qy
  and wz = qw *. qz in
  { m11 = 1.0 -. 2.0 *. (y2 +. z2) ; m12 = 2.0 *. (xy -. wz)        ;  m13 = 2.0 *. (xz +. wy)        ; m14 = 0.0;
    m21 = 2.0 *. (xy +. wz)        ; m22 = 1.0 -. 2.0 *. (x2 +. z2) ;  m23 = 2.0 *. (yz -. wx)        ; m24 = 0.0;
    m31 = 2.0 *. (xz -. wy)        ; m32 = 2.0 *. (yz +. wx)        ;  m33 = 1.0 -. 2.0 *. (x2 +. y2) ; m34 = 0.0;
    m41 = 0.0                      ; m42 = 0.0                      ;  m43 = 0.0                      ; m44 = 1.0;
  }


let translation v =
  let x, y, z = V.of_vec v in
  { m11 = 1.0; m12 = 0.0; m13 = 0.0; m14 = 0.0;
    m21 = 0.0; m22 = 1.0; m23 = 0.0; m24 = 0.0;
    m31 = 0.0; m32 = 0.0; m33 = 1.0; m34 = 0.0;
    m41 =   x; m42 =   y; m43 =   z; m44 = 1.0;
  }

let scaling v =
  let x, y, z = V.of_vec v in
  { m11 =   x; m12 = 0.0; m13 = 0.0; m14 = 0.0;
    m21 = 0.0; m22 =   y; m23 = 0.0; m24 = 0.0;
    m31 = 0.0; m32 = 0.0; m33 =   z; m34 = 0.0;
    m41 = 0.0; m42 = 0.0; m43 = 0.0; m44 = 1.0;
  }

let inverse _ = None

(* providing matrix from this module is always cator-cornred. *)
let transpose mat =
  {
    m11 = mat.m11; m12 = mat.m21; m13 = mat.m31; m14 = mat.m41;
    m21 = mat.m12; m22 = mat.m22; m23 = mat.m32; m24 = mat.m42;
    m31 = mat.m13; m32 = mat.m23; m33 = mat.m33; m34 = mat.m43;
    m41 = mat.m14; m42 = mat.m24; m43 = mat.m34; m44 = mat.m44;
  }
