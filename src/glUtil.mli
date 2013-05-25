(**
   This module providing some utility function and modules for programming with Sdlcaml.

   @author derui
   @version 0.1
*)

(**
   Providing to make `Camera matrix' to use setting camera position and angle.

   Usega:

   let mat = Camera.make_matrix ~pos:V.to_vec_tuple (1.0, 1.0, 1.0)
   ~at:V.to_vec_tuple (0.0, 0.0, 0.0)
   ~up:V.to_vec_tuple (0.0, 1.0, 0.0) in
*)
module Camera : sig

  (** Make camera matrix and return it.
      Camera matrix is made by three elements, position of camera, position of looking at,
      and direction of above of camera.

      @param pos position of camera
      @param at position looked by camera
      @param up up-direction of camera
      @return Camera transformation matrix made by arguments.
  *)
  val make_matrix: pos:Candyvec.Vector.t -> at:Candyvec.Vector.t -> up:Candyvec.Vector.t
    -> Candyvec.Matrix4.t

end

(**
   construct a projection matrix for `ortho projection'.
   given parameters of near and far are mostly equivalant of
   perspective_projection arguments.
   Left and right specifies the coordinates for the left and right vertical clipping planes.
   Bottom and top specifies the coodinates for the left and right horizontal clipping planes.
*)
val ortho_projection : left:float -> right:float ->
  top:float -> bottom:float -> near:float -> far:float -> Candyvec.Matrix4.t

(**
   construct a projection matrix.
   `fov' is that the field of view angle in the y direction.
   `ratio` is screen ratio that determines the field of view in the x direction.
   near and far is clip that visible range along the Z axis.

   @param fov Field Of View
   @param the ratio of x to y
   @param near near clip
   @param far far clip
*)
val perspective_projection :
  fov:float ->
  ratio:float ->
  near:float ->
  far:float -> Candyvec.Matrix4.t

