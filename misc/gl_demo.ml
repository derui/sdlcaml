open Sdlcaml
open Bigarray

let loop_count = ref 0
let prev_time = ref 0

let make_vertex_array arrayt vertex =
  let barray = Array1.create arrayt Bigarray.c_layout
    (Array.length vertex) in
  Array.iteri (fun i x -> barray.{i} <- x) vertex;
  barray

let render _ =
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

    glClear [Gl_enum.GColorBufferBit;Gl_enum.GDepthBufferBit];
    glMatrixMode Gl_enum.GModelview;
    glLoadIdentity ();
    glTranslatef 0.0 0.0 (-5.0);
    glRotatef 10.0 0.0 1.0 0.0;

    glBegin Gl_enum.GTriangles;

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
  end

let _ =
  Sdl_init.init [`VIDEO];
  prev_time := Sdl_timer.get_ticks ();

  ignore (Sdl_video.set_attribute ~attr:Sdl_video.GL_RED_SIZE ~value:5);
  ignore (Sdl_video.set_attribute ~attr:Sdl_video.GL_BLUE_SIZE ~value:5);
  ignore (Sdl_video.set_attribute ~attr:Sdl_video.GL_GREEN_SIZE ~value:5);
  ignore (Sdl_video.set_attribute ~attr:Sdl_video.GL_DEPTH_SIZE ~value:16);
  ignore (Sdl_video.set_attribute ~attr:Sdl_video.GL_DOUBLEBUFFER ~value:1);
  let surface = Sdl_video.set_video_mode ~width:800 ~height:600
    ~depth:32 ~flags:[Sdl_video.SDL_OPENGL] in
  let rec loop _ =
    let current_time = Sdl_timer.get_ticks () in
    if current_time > 10000 then
      ()
    else
      begin
        if current_time - !prev_time > 1000 then
          begin
            prev_time := Sdl_timer.get_ticks ();
            Sdl_window.set_caption ~title:(Printf.sprintf "%d FPS"
                                             !loop_count) ();
            loop_count := 0;
          end;

        loop_count := succ !loop_count;
        render ();
        loop ();
      end
  in
  begin

    Gl.glShadeModel Gl.E.GSmooth;
    Gl.glCullFace Gl.E.GBack;
    Gl.glFrontFace Gl.E.GCcw;
    Gl.glEnable Gl.E.GCullFace;
    Gl.glClearColor 0.5 0.5 0.0 0.0;
    Gl.glViewport 0 0 800 600;
    Gl.glMatrixMode Gl.E.GProjection;
    Gl.glLoadIdentity ();
    Gl.glOrtho (-1.0) 1.0 (-1.0) 1.0 1.0 1024.0;

    loop ();
  end;

  Sdl_video.free_surface surface;
  Sdl_init.quit ()
