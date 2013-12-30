(**
   This module provide operation and types for SDL_Rect and relative operations.m

   Notice: The type of rect that is defined in this module equals to defined on
   Sdl_types.Rect.t .

   @author derui
   @since 0.2
*)

type t = Sdlcaml_structures.Rect.t

val enclose_points : points:Sdlcaml_structures.Point.t list -> ?clip:t -> unit -> t
(** [enclose_points ~points ~clip] calculate a minimal rectangle enclosing a set of points.
    If clip is not give to enclose all points, or it is given to be used for clipping points.
*)

val has_intersection : t -> t -> bool
(** [has_intersection a b] determine whether two rectangles intersect. *)

val intersect : t -> t -> t
(** [intersect a b] calculate the intersection of two rectangle as rect filled in with the
    intersection of rectangles.
*)

val is_empty : t -> bool
  (** [is_empty rect] to check whether a reactangle has no area. *)

val equals : t -> t -> bool
(** [equals a b] to check whether two rectangles are equal *)

val union : t -> t -> t
(** [union a b] to calculate the union of two rectangles *)
