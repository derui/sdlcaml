open Sdlcaml
open Bigarray
open OUnit
module S = Baselib.Std

let test_set_up _ =
  begin
    Sdl_init.init [`VIDEO] ();
    let open Sdlcaml.Sdl in
    assert_bool "set red size" (Video.set_attribute ~attr:Video.GL_RED_SIZE ~value:5);
    assert_bool "set blue size" (Video.set_attribute ~attr:Video.GL_BLUE_SIZE ~value:5);
    assert_bool "set green size" (Video.set_attribute ~attr:Video.GL_GREEN_SIZE ~value:5);
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

let make_vertex_array arrayt vertex =
  let barray = Array1.create arrayt Bigarray.c_layout
    (Array.length vertex) in
  Array.iteri (fun i x -> barray.{i} <- x) vertex;
  barray

let test_sdl_gl_basic surface =
  let open Gl in
  begin
    let v0 = ( -1.0, -1.0,  1.0 )
    and v1 = (  1.0, -1.0,  1.0 )
    and v2 = (  1.0,  1.0,  1.0 )
    and v3 = ( -1.0,  1.0,  1.0 )
    and v4 = ( -1.0, -1.0, -1.0 )
    and v5 = (  1.0, -1.0, -1.0 )
    and v6 = (  1.0,  1.0, -1.0 )
    and v7 = ( -1.0,  1.0, -1.0 )
    and red    = ( 1.0, 0.0, 0.0, 1.0 )
    and green  = ( 0.0, 1.0, 0.0, 1.0 )
    and blue   = ( 0.0, 0.0, 1.0, 1.0 )
    and white  = ( 1.0, 1.0, 1.0, 1.0 )
    and yellow = ( 0.0, 1.0, 1.0, 1.0 )
    and black  = ( 0.0, 0.0, 0.0, 1.0 )
    and orange = ( 1.0, 1.0, 0.0, 1.0 )
    and purple = ( 1.0, 0.0, 1.0, 0.0 ) in

    glShadeModel Shade.GL_SMOOTH;
    glCullFace CullFace.GL_BACK;
    glFrontFace FrontFace.GL_CCW;
    glEnable Enable.GL_CULL_FACE;
    glClearColor 0.5 0.5 0.0 1.0;
    glViewport 0 0 640 480;
    glMatrixMode Matrix.GL_PROJECTION;
    glLoadIdentity ();
    glOrtho (-1.0) 1.0 (-1.0) 1.0 1.0 1024.0;

    glClear [Clear.GL_COLOR_BUFFER_BIT;Clear.GL_DEPTH_BUFFER_BIT];
    glMatrixMode Matrix.GL_MODELVIEW;
    glLoadIdentity ();
    glTranslate 0.0 0.0 (-5.0);
    glRotate 10.0 0.0 1.0 0.0;

    glBegin Begin.GL_TRIANGLES;

    glColor4v red;
    glVertex3v v0;
    glColor4v green;
    glVertex3v v1;
    glColor4v blue;
    glVertex3v( v2 );

    glColor4v( red );
    glVertex3v( v0 );
    glColor4v( blue );
    glVertex3v( v2 );
    glColor4v( white );
    glVertex3v( v3 );

    glColor4v( green );
    glVertex3v( v1 );
    glColor4v( black );
    glVertex3v( v5 );
    glColor4v( orange );
    glVertex3v( v6 );

    glColor4v( green );
    glVertex3v( v1 );
    glColor4v( orange );
    glVertex3v( v6 );
    glColor4v( blue );
    glVertex3v( v2 );

    glColor4v( black );
    glVertex3v( v5 );
    glColor4v( yellow );
    glVertex3v( v4 );
    glColor4v( purple );
    glVertex3v( v7 );

    glColor4v( black );
    glVertex3v( v5 );
    glColor4v( purple );
    glVertex3v( v7 );
    glColor4v( orange );
    glVertex3v( v6 );

    glColor4v( yellow );
    glVertex3v( v4 );
    glColor4v( red );
    glVertex3v( v0 );
    glColor4v( white );
    glVertex3v( v3 );

    glColor4v( yellow );
    glVertex3v( v4 );
    glColor4v( white );
    glVertex3v( v3 );
    glColor4v( purple );
    glVertex3v( v7 );

    glColor4v( white );
    glVertex3v( v3 );
    glColor4v( blue );
    glVertex3v( v2 );
    glColor4v( orange );
    glVertex3v( v6 );

    glColor4v( white );
    glVertex3v( v3 );
    glColor4v( orange );
    glVertex3v( v6 );
    glColor4v( purple );
    glVertex3v( v7 );

    glColor4v( green );
    glVertex3v( v1 );
    glColor4v( red );
    glVertex3v( v0 );
    glColor4v( yellow );
    glVertex3v( v4 );

    glColor4v( green );
    glVertex3v( v1 );
    glColor4v( yellow );
    glVertex3v( v4 );
    glColor4v( black );
    glVertex3v( v5 );

    glEnd ();

    Sdl_video.gl_swap ();

    Thread.delay 3.0;
  end

let suite = "SDL video with GL tests" >:::
  [ "OpenGL bindings basic usage" >::
      (bracket test_set_up test_sdl_gl_basic test_tear_down)
  ]

let _ =
  run_test_tt_main suite
