(** This module provide image loader with Sdl_image module.
    Loaded image by this module is added some format infomations,
    texture format, internal format, texture type, and so on.

    @author derui
    @version 0.1
*)

type info = {
  image:Sdl_video.surface;
  width:int;
  height:int;
  internal_format:Gl_api.InternalFormat.internal_format;
  format:Gl_api.Tex.texture_format;
  texture_type:Gl_api.Tex.texture_type;
}

(** Load image file what given as argument, and collect
    some infomations for loaded image.

    internal_format, format, texture_type in returned info are
    probably as equal as loaded image of.
    But if you want to use other type and format for loaded image,
    yes, you can.

    @param fname file name to load image
    @return infomation structure of loaded image.
*)
val load: string -> info option
