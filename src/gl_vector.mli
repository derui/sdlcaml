(** This module provide type of Vector and related vector operations.
    Providing type is anticipated to be used to !{Gl_matrix} module.

    @author derui
    @version 0.1
*)

(** type of vector  *)
type t

(** Construct Vector with each value of axis.

    @param x value of x axis
    @param y value of y axis
    @param z value of z axis
    @return constructed vector
*)
val to_vec: x:float -> y:float -> z:float -> t

(** Construct Vector with tuple contain each value of x, y, z axis.

    @param tuple (x, y, z)
    @return constructed vector
*)
val to_vec_tuple: float * float * float -> t

(** Extract each axis value from {!t}.   *)
val of_vec: t -> float * float * float

(** construct normal vector along axis of X or Y or Z. *)
val normal_axis : [< `X |`Y |`Z ] -> t

(** return normalised vector of given argument.
   normalising is defined given vector to unit vector that
   vector's norm is 1.
*)
val normalise : t -> t

(** return norm of given vector.
   returned norm from this function apply square root to norm of
   origin.
   Since performance is less than norm_square, because need more
   performance and don't need exact norm, recommend using norm_square.
*)
val norm : t -> float

(** return squared norm of given vector.
    if you need exact norm, you apply square root
    to returned norm from this function.
    Since performance is less than norm_square, because need more
    performance and don't need exact norm, recommend using norm_square.
*)
val norm_square : t -> float

(** return inner product of two vector. *)
val dot : t -> t -> float

(** return cross product of two vector. *)
val cross : t -> t -> t

(** scale vector with scaling scalar. *)
val scaling : vec:t -> scale:float -> t

(** return added vector between two vectors. *)
val add : t -> t -> t

(** return subtructed second vector from first vector. *)
val sub : t -> t -> t

(** is vectors between angle square.  *)
val is_square : t -> t -> bool
