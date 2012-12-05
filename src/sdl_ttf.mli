(** This module provide binding for SDL_ttf is extention library for SDL.
    If SDL_ttf not found when build this library, provided bindings were
    all replaced to stubs.

    Note: Functions to render text or calculate the size defines
          only for UTF8.

    @author derui
    @since 0.1
*)

(** wrapping type for the TTF_Font *)
type font

(** the metrics for a charactor in the font  *)
type metrics = {
  minx:int;
  maxx:int;
  miny:int;
  maxy:int;
  advance:int
}

(** the style to a font *)
type font_style =
  | STYLE_NORMAL
  | STYLE_BOLD
  | STYLE_ITALIC
  | STYLE_UNDERLINE
  | STYLE_STRIKETHROUGH

(** the hinting of a font  *)
type hinting =
  | HINTING_NORMAL
  | HINTING_LIGHT
  | HINTING_MONO
  | HINTING_NONE

(** Get current version of SDL_ttf, when it compiled and linked

    @reutrn tuple as (major, minor, patch)
*)
external linked_version: unit -> int * int * int = "sdlcaml_ttf_linked_version"
external compiled_version: unit -> int * int * int = "sdlcaml_ttf_compiled_version"

(** Initialize the SDL_ttf library.

    @return unit if initialize successful,
    string as error string if fail initialization
*)
external init: unit -> (unit, string) Extlib.Std.Either.t = "sdlcaml_ttf_init"

(** Query the initialization status of the SDL_ttf library.

    @return Left with true if initialized, and with false if initialized yet.
            Right with error string if some error occured
*)
external was_init: unit -> (bool, string) Extlib.Std.Either.t = "sdlcaml_ttf_was_init"

(** Shutdown and cleanup the SDL_ttf library.
*)
external quit: unit -> unit = "sdlcaml_ttf_quit"

(** Load file for use as a font, at ptsize size.

    @param file file name to load font from
    @param ptsize point size to load font as
    @return loaded font or error string
*)
external open_font: file:string -> ptsize:int -> (font, string) Extlib.Std.Either.t
  = "sdlcaml_ttf_open_font"

(** Load file, face index, for use as a font, at ptsize size.

    @param file file name to load font from
    @param ptsize point size to load font as
    @return loaded font or error string
*)
external open_font_index: file:string -> ptsize:int -> index:int
  -> (font, string) Extlib.Std.Either.t = "sdlcaml_ttf_open_font_index"

(** Free the memory used by font, and free font itself as well.
    Do not use font after this.

    @param font font to free
*)
external close_font: font -> unit = "sdlcaml_ttf_close_font"

(** This function tells SDL_ttf whether UNICODE text is generally byteswapped.

    @param swapped true if want to byteswap. if false, then do not byte swap.
*)
external byte_swapped: bool -> unit = "sdlcaml_ttf_byte_swapped"

(** Get the styles of the given font.

    @param font font to get styles
    @return the styles of font
*)
external get_style: font -> font_style list = "sdlcaml_ttf_get_style"

(** Set the rendering style of the loaded font.

    @param font loaded font to set the style of
    @param styles the font styles to set to the font
*)
external set_style: font -> font_style list -> unit = "sdlcaml_ttf_set_style"

(** Get the current outline size of the loaded font

    @param font font to get the outline size of
    @return current outline size of the loaded font
*)
external get_outline: font -> int = "sdlcaml_ttf_get_outline"

(** Set the new outline size of the loaded font

    @param font font to set the outline size of
    @param size new outline size of the loaded font
*)
external set_outline: font -> int -> unit = "sdlcaml_ttf_set_outline"

(** Get the current hinting settting of the loaded font

    @param font loaded font
    @return the hinting type of the loaded font
*)
external get_hinting: font -> hinting = "sdlcaml_ttf_get_hinting"

(** Set the new hinting settting of the loaded font

    @param font loaded font
    @param hinting the new hinting style
*)
external set_hinting: font -> hinting -> unit = "sdlcaml_ttf_set_hinting"

(** Get the kerning setting whether enable or not of the loaded font.

    @param font the loaded font
    @return true if kerning is enable, false is disable.
*)
external is_kerning: font -> bool = "sdlcaml_ttf_is_kerning"

(** Enable the kerning setting of the loaded font

    @param font the loaded font
*)
val enable_kerning: font -> unit

(** Disable the kerning setting of the loaded font

    @param font the loaded font
*)
val disable_kerning: font -> unit

(** Get the maximum pixel height of all glyphs of the loaded font.

    @param font the loaded font to get the maximum height of
    @return the max height of the loaded font
*)
external height: font -> int = "sdlcaml_ttf_height"

(** Get the maximum pixel ascent of all glyphs of the loaded font.

    @param font the loaded font to get the maximum ascent of
    @return the max ascent of the loaded font
*)
external ascent: font -> int = "sdlcaml_ttf_ascent"

(** Get the maximum pixel descent of all glyphs of the loaded font.

    @param font the loaded font to get the maximum descent of
    @return the max descent of the loaded font
*)
external descent: font -> int = "sdlcaml_ttf_descent"

(** Get the recommended pixel height of a rendered line of text of
    the loaded font

    @param font the loaded font to get the line skip height of
    @return the line skip height of the loaded font
*)
external line_skip: font -> int = "sdlcaml_ttf_line_skip"

(** Get the number of faces available in the loaded font.

    @param font the loaded font to get the number of available faces from
    @return the number of available faces
*)
external faces: font -> int = "sdlcaml_ttf_faces"

(** Test if the current font face of the loaded font is a fixed width.

    @param font the loaded font to get the fixed width status of
    @return true if the loaded font is fixed width,
            false is not.
*)
external is_fixed_width: font -> bool = "sdlcaml_ttf_is_fixed_width"

(** Get the current font face family name from the loaded font.

    @param font the loaded font to get the current font face family name of
    @return Some with the current font family name, but None if it do not have.
*)
external family_name: font -> string option = "sdlcaml_ttf_family_name"

(** Get the current font face style name from the loaded font.

    @param font the loaded font to get the current font face style name of
    @return Some with the current font style name, but None if it do not have.
*)
external style_name: font -> string option = "sdlcaml_ttf_style_name"

(** Get the status of the availability of the glyph for ch from the loaded font

    @param font the loaded font
    @param ch the unicode charactor point code to test glyph availability
    @return return the glyph for ch in font or not
*)
external glyph_is_provided: font -> int -> bool = "sdlcaml_ttf_glyph_is_provided"

(** Get desired glyph metrics of the UNICODE char given in ch from the loaded font.

    @param font the loaded font to get the desired glyph metrics of ch
    @param ch the UNICODE charactor code to get the glyph metrics for
    @return the glyph metrics for the UNICODE char point
*)
external glyph_metrics: font -> int -> metrics option = "sdlcaml_ttf_glyph_metrics"

(** Calculate the resulting surface size of the UTF8 encoded text rendered using font.

    @param font the loaded font to use to calculate the size of the string with
    @param text the UTF8 string to size up
    @return the calculated size as width * height of the string
*)
external size_utf8: font:font -> text:string -> int * int option = "sdlcaml_ttf_size_utf8"

(** Render the UTF8 encoed text using font with color onto a new surface.

    Note: any returned surface is freed by the caller!

    @param font the loaded font to use to render the UTF8 encoded text
    @param text the UTF8 encoded text to render
    @param color the color to use to render the UTF8 encoded text
    @return new surface rendered text if successful, or error string
*)
external render_utf8_solid: font:font -> text:string -> color:Sdl_video.color
  -> (Sdl_video.surface, string) Extlib.Std.Either.t = "sdlcaml_ttf_render_utf8_solid"

(** Render the UTF8 encoed text using font with color onto a new surface
    filled with the bg color.

    Note: any returned surface is freed by the caller!

    @param font the loaded font to use to render the UTF8 encoded text
    @param text the UTF8 encoded text to render
    @param fg the color to render text in
    @param bg the color to render the background box in
    @return new surface rendered text if successful, or error string
*)
external render_utf8_shaded: font:font -> text:string -> fg:Sdl_video.color
  -> bg:Sdl_video.color
  -> (Sdl_video.surface, string) Extlib.Std.Either.t = "sdlcaml_ttf_render_utf8_shaded"

(** Render the UTF8 encoed text using font with color onto a new surface,
    using the blended mode.

    Note: any returned surface is freed by the caller!

    @param font the loaded font to use to render the UTF8 encoded text
    @param text the UTF8 encoded text to render
    @param color the color to use to render the UTF8 encoded text
    @return new surface rendered text if successful, or error string
*)
external render_utf8_blended: font:font -> text:string -> color:Sdl_video.color
  -> (Sdl_video.surface, string) Extlib.Std.Either.t = "sdlcaml_ttf_render_utf8_blended"
