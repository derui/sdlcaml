open Sdlcaml
open Bigarray
open OUnit
module S = Baselib.Std

let error _ =
  match Gl.glGetError () with
  | Gl.Get.GL_NO_ERROR -> "NO_ERROR"
  | Gl.Get.GL_INVALID_ENUM -> "INVALID_ENUM"
  | Gl.Get.GL_INVALID_VALUE -> "INVALID_VALUE"
  | Gl.Get.GL_INVALID_OPERATION  -> "GL_INVALID_OPERATION"
  | Gl.Get.GL_STACK_OVERFLOW -> "STACK_OVERFLOW"
  | Gl.Get.GL_STACK_UNDERFLOW -> "STACK_UNDERFLOW"
  | Gl.Get.GL_OUT_OF_MEMORY -> "OUT_OF_MEMORY"
  | Gl.Get.GL_TABLE_TOO_LARGE -> "TABLE_TOO_LARGE"

let test_set_up _ =
  begin
    Sdl_init.init [`VIDEO] ();
    let open Sdlcaml.Sdl in
    assert_bool "set red size" (Video.set_attribute ~attr:Video.GL_RED_SIZE ~value:8);
    assert_bool "set blue size" (Video.set_attribute ~attr:Video.GL_BLUE_SIZE ~value:8);
    assert_bool "set green size" (Video.set_attribute ~attr:Video.GL_GREEN_SIZE ~value:8);
    assert_bool "set depth size" (Video.set_attribute ~attr:Video.GL_DEPTH_SIZE ~value:16);
    assert_bool "set double buffer" (Video.set_attribute ~attr:Video.GL_DOUBLEBUFFER ~value:1);

    let surf = Video.set_video_mode ~width:640 ~height:480 ~depth:32
      ~flags:[Video.SDL_OPENGL;] in
    begin
      ignore (Video.get_attribute Video.GL_DOUBLEBUFFER);
      surf
    end
  end

let test_tear_down surface =
  begin
    Sdl_video.free_surface surface;
    Sdl_init.quit ();
  end

let make_vbo () =
  let vertex_data = Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout
    [| -1.0; -1.0; 0.0;
       0.0;  1.0; 0.0;
       1.0; -1.0; 0.0;
    |] in
  let open Gl in
  let id = glGenBuffer () in
  glBindBuffer Buffer.GL_ARRAY_BUFFER id;
  glBufferData ~target:BufferData.GL_ARRAY_BUFFER ~size:(Bigarray.Array1.dim vertex_data)
    ~data:vertex_data ~usage:BufferData.GL_STATIC_DRAW;
  id
;;

let vertex_shader_src = "
#version 130
in vec3 VertexPosition;
invariant gl_Position;
void main () {
  gl_Position = vec4(VertexPosition, 1.0);
}"

let fragment_shader_src = "
#version 130
out vec4 Color;
void main() {
  Color = vec4(1.0, 0.0, 0.0, 1.0);
}"

let load_shaders () =
  let open Gl in
  let vertexShaderID = glCreateShader Shader.GL_VERTEX_SHADER in
  let fragmentShaderID = glCreateShader Shader.GL_FRAGMENT_SHADER in

  glShaderSource vertexShaderID vertex_shader_src;
  glShaderSource fragmentShaderID fragment_shader_src;

  glCompileShader vertexShaderID;
  glCompileShader fragmentShaderID;

  let shader_prog = glCreateProgram () in
  glAttachShader ~program:shader_prog ~shader:vertexShaderID;
  glAttachShader ~program:shader_prog ~shader:fragmentShaderID;

  glLinkProgram shader_prog;
  let vertexPosAttrib = glGetAttribLocation shader_prog "VertexPosition" in
  (shader_prog, vertexPosAttrib)

let test_sdl_gl_basic surface =
  let open Gl in
  begin
    let vao = glGenVertexArray () in
    glBindVertexArray vao;
    let vbobj = make_vbo () in
    let sprog, pos = load_shaders () in

    glViewport 0 0 640 480;
    glClear [Clear.GL_COLOR_BUFFER_BIT;];

    glUseProgram sprog;
    glBindBuffer Buffer.GL_ARRAY_BUFFER vbobj;
    glVertexAttribPointer ~index:pos ~size:3 ~vert_type:VertexArray.GL_FLOAT ~normalize:false
      ~stride:0;
    glEnableVertexAttribArray pos;
    glDrawArrays ~mode:DrawArrays.GL_TRIANGLES ~first:0 ~count:9;

    Sdl_video.gl_swap ();

    Thread.delay 3.0;
  end

let suite = "SDL video with GL tests" >:::
  [ "OpenGL bindings basic usage" >::
      (bracket test_set_up test_sdl_gl_basic test_tear_down)
  ]

let _ =
  run_test_tt_main suite
