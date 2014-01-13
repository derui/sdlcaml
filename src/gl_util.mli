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
    -> Candyvec.Matrix.t

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
  val make_perspective_matrix : fov:float ->
  ratio:float ->
  near:float ->
  far:float -> Candyvec.Matrix.t

end

(**
   Providing to is wrapped operations for shader to create and delete.
*)
module Shader : sig

  (**
     Suffix for judgement shader type of the file is "Vertex Shader"
  *)
  val vertex_suffix : string
  (**
     Suffix for judgement shader type of the file is "Fragment Shader"
  *)
  val fragment_suffix : string

  (**
     Load shader source what is in the outer file and compile it, then return shader id.
     Return error message if raise some errors.

     If you did not give shader_type argument, load function judge shader_type solery on
     extension of the given filename.
     Example, compile as Vertex Shader if extension is "vert", as Fragment Shader if extension
     is "frag".

     @param shader_type specified shader type to compile shader source.
     @param filename specified shader source location and file name
     @return shader id if load source and compile is successful
  *)
  val load : ?shader_type:Gl_api.Shader.shader_type -> string ->
    (Gl_api.shader, string) Sugarpot.Std.Either.t

  (**
     Getting information log from given shader.

     @param shader shader to get information log
     @return information log
  *)
  val info_log : Gl_api.shader -> string

  (**
     Get source from the shader given

     @param shader shader to get source
     @return source of the shader given
  *)
  val source : Gl_api.shader -> string

  (**
     delete shader that is already created

     @param shader shader to delete
  *)
  val delete : Gl_api.shader -> unit
end

(**
   Providing whole operations for the program in OpenGL.
*)
module Program : sig

  (** Attach shader program to the program *)
  val attach : Gl_api.program -> Gl_api.shader -> unit

  (** create program  *)
  val create : unit -> Gl_api.program

  (** link program. This function need to call after attachment
      shaders to use in the program.
  *)
  val link : Gl_api.program -> unit

  (** Get attribute location  *)
  val attrib_location : Gl_api.program -> string -> int

  (** Get uniform location  *)
  val uniform_location : Gl_api.program -> string -> int

  (** Get uniform or attribute location. *)
  val location : Gl_api.program -> [< `Attrib | `Uniform] -> string -> int

end

(**
   construct a projection matrix for `ortho projection'.
   given parameters of near and far are mostly equivalant of
   perspective_projection arguments.
   Left and right specifies the coordinates for the left and right vertical clipping planes.
   Bottom and top specifies the coodinates for the left and right horizontal clipping planes.
*)
val ortho_projection : left:float -> right:float ->
  top:float -> bottom:float -> near:float -> far:float -> Candyvec.Matrix.t

(**
   construct a projection matrix.
   left and right is each side of the screen.
   top and bottom is each maximum and minimum height of the screen.
   near and far is clip that visible range along the Z axis.

   @param left minimum x of the screen
   @param right maximum x of the screen
   @param top maximum y of the screen
   @param bottom minimum y of the screen
   @param near near clip
   @param far far clip
*)
val perspective_projection :
  left:float -> right:float -> top:float -> bottom:float ->
  near:float ->
  far:float -> Candyvec.Matrix.t
