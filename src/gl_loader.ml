module I = Sdl_image
module V = Sdl_video
module G = Gl_api

type info = {
  image:Sdl_video.surface;
  width:int;
  height:int;
  internal_format:G.InternalFormat.internal_format;
  format:G.Tex.texture_format;
  texture_type:G.Tex.texture_type;
}

let rgb8 = 8
let rgb16 = 16
let rgb = 24
let rgba = 32

let get_surface_format pformat =
  let rmask = pformat.V.rmask in
  let bmask = pformat.V.bmask in
  let has_alpha = pformat.V.amask <> 0x0 in
  if rmask < bmask then                (* when little-endian *)
    if has_alpha then `RGBA else `RGB
  else                                  (* when big-endian *)
    if has_alpha then `BGRA else `BGR

let correct_info img =
  let pformat = V.get_pixelformat img in
  let internal_format =
    (* only 8, 16, 24, and 32. *)
    match pformat.V.bits_per_pixel with
    | v when v = rgb8 -> G.InternalFormat.GL_RGB8
    | v when v = rgb16 -> G.InternalFormat.GL_RGB16
    | v when v = rgb -> G.InternalFormat.GL_RGB
    | v when v = rgba -> G.InternalFormat.GL_RGBA
    | _ -> G.InternalFormat.GL_RGB      (* for default *)
  and format =
    match get_surface_format pformat with
    | `RGB -> G.Tex.GL_RGB
    | `BGR -> G.Tex.GL_BGR
    | `RGBA -> G.Tex.GL_RGBA
    | `BGRA -> G.Tex.GL_BGRA
  and width, height = V.get_size img in
  {image = img; width; height;
   internal_format; format; texture_type = G.Tex.GL_UNSIGNED_BYTE
  }

let load fname =
  let open Sugarpot.Std.Option.Open in
  let open Sugarpot.Std.Prelude in
  if I.is_linked () then
    I.load fname >>= (return @< correct_info)
  else
    None
