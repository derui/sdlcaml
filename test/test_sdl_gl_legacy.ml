open Sdlcaml
open Bigarray
open OUnit
module S = Extlib.Std

let test_set_up _ =
  begin
    Sdl_init.init [`VIDEO];
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
    let v0 = make_vertex_array Bigarray.float32 [| -1.0; -1.0;  1.0 |]
    and v1 = make_vertex_array Bigarray.float32 [|  1.0; -1.0;  1.0 |]
    and v2 = make_vertex_array Bigarray.float32 [|  1.0;  1.0;  1.0 |]
    and v3 = make_vertex_array Bigarray.float32 [| -1.0;  1.0;  1.0 |]
    and v4 = make_vertex_array Bigarray.float32 [| -1.0; -1.0; -1.0 |]
    and v5 = make_vertex_array Bigarray.float32 [|  1.0; -1.0; -1.0 |]
    and v6 = make_vertex_array Bigarray.float32 [|  1.0;  1.0; -1.0 |]
    and v7 = make_vertex_array Bigarray.float32 [| -1.0;  1.0; -1.0 |]
    and red    = make_vertex_array Bigarray.char
      [| char_of_int 255; char_of_int   0; char_of_int   0; char_of_int 255 |]
    and green  = make_vertex_array Bigarray.char
      [| char_of_int   0; char_of_int 255; char_of_int   0; char_of_int 255 |]
    and blue   = make_vertex_array Bigarray.char
      [| char_of_int   0; char_of_int   0; char_of_int 255; char_of_int 255 |]
    and white  = make_vertex_array Bigarray.char
      [| char_of_int 255; char_of_int 255; char_of_int 255; char_of_int 255 |]
    and yellow = make_vertex_array Bigarray.char
      [| char_of_int   0; char_of_int 255; char_of_int 255; char_of_int 255 |]
    and black  = make_vertex_array Bigarray.char
      [| char_of_int   0; char_of_int   0; char_of_int   0; char_of_int 255 |]
    and orange = make_vertex_array Bigarray.char
      [| char_of_int 255; char_of_int 255; char_of_int   0; char_of_int 255 |]
    and purple = make_vertex_array Bigarray.char
      [| char_of_int 255; char_of_int   0; char_of_int 255; char_of_int   0 |] in

    glShadeModel E.GSmooth;
    glCullFace E.GBack;
    glFrontFace E.GCcw;
    glEnable E.GCullFace;
    glClearColor 0.5 0.5 0.0 1.0;
    glViewport 0 0 640 480;
    glMatrixMode E.GProjection;
    glLoadIdentity ();
    glOrtho (-1.0) 1.0 (-1.0) 1.0 1.0 1024.0;

    glClear [E.GColorBufferBit;E.GDepthBufferBit];
    glMatrixMode E.GModelview;
    glLoadIdentity ();
    glTranslatef 0.0 0.0 (-5.0);
    glRotatef 10.0 0.0 1.0 0.0;

    glBegin E.GTriangles;

    glColor4ubv( red );
    glVertex3fv( v0 );
    glColor4ubv( green );
    glVertex3fv( v1 );
    glColor4ubv( blue );
    glVertex3fv( v2 );

    glColor4ubv( red );
    glVertex3fv( v0 );
    glColor4ubv( blue );
    glVertex3fv( v2 );
    glColor4ubv( white );
    glVertex3fv( v3 );

    glColor4ubv( green );
    glVertex3fv( v1 );
    glColor4ubv( black );
    glVertex3fv( v5 );
    glColor4ubv( orange );
    glVertex3fv( v6 );

    glColor4ubv( green );
    glVertex3fv( v1 );
    glColor4ubv( orange );
    glVertex3fv( v6 );
    glColor4ubv( blue );
    glVertex3fv( v2 );

    glColor4ubv( black );
    glVertex3fv( v5 );
    glColor4ubv( yellow );
    glVertex3fv( v4 );
    glColor4ubv( purple );
    glVertex3fv( v7 );

    glColor4ubv( black );
    glVertex3fv( v5 );
    glColor4ubv( purple );
    glVertex3fv( v7 );
    glColor4ubv( orange );
    glVertex3fv( v6 );

    glColor4ubv( yellow );
    glVertex3fv( v4 );
    glColor4ubv( red );
    glVertex3fv( v0 );
    glColor4ubv( white );
    glVertex3fv( v3 );

    glColor4ubv( yellow );
    glVertex3fv( v4 );
    glColor4ubv( white );
    glVertex3fv( v3 );
    glColor4ubv( purple );
    glVertex3fv( v7 );

    glColor4ubv( white );
    glVertex3fv( v3 );
    glColor4ubv( blue );
    glVertex3fv( v2 );
    glColor4ubv( orange );
    glVertex3fv( v6 );

    glColor4ubv( white );
    glVertex3fv( v3 );
    glColor4ubv( orange );
    glVertex3fv( v6 );
    glColor4ubv( purple );
    glVertex3fv( v7 );

    glColor4ubv( green );
    glVertex3fv( v1 );
    glColor4ubv( red );
    glVertex3fv( v0 );
    glColor4ubv( yellow );
    glVertex3fv( v4 );

    glColor4ubv( green );
    glVertex3fv( v1 );
    glColor4ubv( yellow );
    glVertex3fv( v4 );
    glColor4ubv( black );
    glVertex3fv( v5 );

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
