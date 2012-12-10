#include <SDL_ttf.h>
#include "sdl_ttf_flags.h"

/* Encapsulation of opaque SDL surface (of type SDL_Surface *)
   as Caml custom blocks
 */
static struct custom_operations sdl_surface_ops = {
  "sdlcaml.sdl_surface",
  custom_finalize_default,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

/* Accessing the SDL_Surface * part of a Caml custom block */
#define Surface_val(v) (*((SDL_Surface**)Data_custom_val(v)))

/* Allocating a Caml custom block to hold the given SDL_Surface *  */
static value alloc_surface(SDL_Surface* surface) {
  value v = alloc_custom(&sdl_surface_ops, sizeof(SDL_Surface*), 0, 1);
  Surface_val(v) = surface;
  return v;
}

/* Encapsulation of opaque SDL_ttf font (of type TTF_Font *)
   as Caml custom blocks
 */
static struct custom_operations sdl_font_ops = {
  "sdlcaml.sdl_ttf_font",
  custom_finalize_default,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

/* Accessing the SDL_Surface * part of a Caml custom block */
#define Font_val(v) (*((TTF_Font**)Data_custom_val(v)))

/* Allocating a Caml custom block to hold the given SDL_Surface *  */
static value alloc_font(TTF_Font* font) {
  value v = alloc_custom(&sdl_font_ops, sizeof(TTF_Font*), 0, 1);
  Font_val(v) = font;
  return v;
}

#define t_prim CAMLprim value

t_prim sdlcaml_ttf_is_linked(value unit) {
  CAMLparam1(unit);
  CAMLreturn(Val_true);
}

t_prim sdlcaml_ttf_linked_version(value unit) {
  CAMLparam1(unit);
  CAMLlocal1(version);

  const SDL_version* v = TTF_Linked_Version();
  version = caml_alloc(3, 0);
  Store_field(version, 0, v->major);
  Store_field(version, 1, v->minor);
  Store_field(version, 2, v->patch);

  CAMLreturn(version);
}

t_prim sdlcaml_ttf_compiled_version(value unit) {
  CAMLparam1(unit);
  CAMLlocal1(version);

  SDL_version v;
  SDL_TTF_VERSION(&v);
  version = caml_alloc(3, 0);
  Store_field(version, 0, v.major);
  Store_field(version, 1, v.minor);
  Store_field(version, 2, v.patch);

  CAMLreturn(version);
}

t_prim sdlcaml_ttf_init(value unit) {
  CAMLparam1(unit);
  CAMLlocal1(ret);

  if (TTF_Init() == -1) {
    ret = caml_alloc(1, 0);
    Store_field(ret, 0, caml_copy_string(TTF_GetError()));
  } else {
    ret = caml_alloc(1, 1);
    Store_field(ret, 0, Val_unit);
  }

  CAMLreturn(ret);
}

t_prim sdlcaml_ttf_was_init(value unit) {
  CAMLparam1(unit);

  if (TTF_WasInit()) {
    CAMLreturn(Val_true);
  } else {
    CAMLreturn(Val_false);
  }
}

t_prim sdlcaml_ttf_quit(value unit) {
  CAMLparam1(unit);

  TTF_Quit();

  CAMLnoreturn;
}

t_prim sdlcaml_ttf_open_font(value file, value ptsize) {
  CAMLparam2(file, ptsize);
  CAMLlocal1(ret);

  TTF_Font* font = NULL;
  font = TTF_OpenFont(String_val(file), Int_val(ptsize));
  if (!font) {
    ret = caml_alloc(1, 0);
    Store_field(ret, 0, caml_copy_string(TTF_GetError()));
  } else {
    ret = caml_alloc(1, 1);
    Store_field(ret, 0, alloc_font(font));
  }
  CAMLreturn(ret);
}

t_prim sdlcaml_ttf_open_font_index(value file, value ptsize, value index) {
  CAMLparam3(file, ptsize, index);
  CAMLlocal1(ret);

  TTF_Font* font = NULL;
  font = TTF_OpenFontIndex(String_val(file), Int_val(ptsize), Int_val(index));
  if (!font) {
    ret = caml_alloc(1, 0);
    Store_field(ret, 0, caml_copy_string(TTF_GetError()));
  } else {
    ret = caml_alloc(1, 1);
    Store_field(ret, 0, alloc_font(font));
  }
  CAMLreturn(ret);
}

t_prim sdlcaml_ttf_close_font(value font) {
  CAMLparam1(font);

  TTF_CloseFont(Font_val(font));

  CAMLnoreturn;
}

t_prim sdlcaml_ttf_byte_swapped(value swapped) {
  CAMLparam1(swapped);

  if (swapped == Val_true) {
    TTF_ByteSwappedUNICODE(1);
  } else {
    TTF_ByteSwappedUNICODE(0);
  }

  CAMLnoreturn;
}

t_prim sdlcaml_ttf_get_style(value font) {
  CAMLparam1(font);
  CAMLlocal1(ret);

  ret = Val_unit;

  int style = TTF_GetFontStyle(Font_val(font));

  if (style & TTF_STYLE_BOLD) {
    ret = add_head(ret, ml_lookup_from_c(ml_ttf_flag_table,
                                         TTF_STYLE_BOLD));
  }
  if (style & TTF_STYLE_ITALIC) {
    ret = add_head(ret, ml_lookup_from_c(ml_ttf_flag_table,
                                         TTF_STYLE_ITALIC));
  }
  if (style & TTF_STYLE_UNDERLINE) {
    ret = add_head(ret, ml_lookup_from_c(ml_ttf_flag_table,
                                         TTF_STYLE_UNDERLINE));
  }
  if (style & TTF_STYLE_STRIKETHROUGH) {
    ret = add_head(ret, ml_lookup_from_c(ml_ttf_flag_table,
                                         TTF_STYLE_STRIKETHROUGH));
  }

  if (style == TTF_STYLE_NORMAL) {
    ret = add_head(ret, ml_lookup_from_c(ml_ttf_flag_table,
                                         TTF_STYLE_NORMAL));
  }

  CAMLreturn(ret);
}

t_prim sdlcaml_ttf_set_style(value font, value styles) {
  CAMLparam2(font, styles);
  CAMLlocal1(hd);

  int style = TTF_STYLE_NORMAL;

  while (is_not_nil(styles)) {
    hd = head(styles);
    styles = tail(styles);
    style |= Int_val(hd);
  }
  TTF_SetFontStyle(Font_val(font), style);
  CAMLnoreturn;
}

t_prim sdlcaml_ttf_get_outline(value font) {
  CAMLparam1(font);

  int outline = TTF_GetFontOutline(Font_val(font));
  CAMLreturn(Val_int(outline));
}

t_prim sdlcaml_ttf_set_outline(value font, value width) {
  CAMLparam2(font, width);

  TTF_SetFontOutline(Font_val(font), Int_val(width));

  CAMLnoreturn;
}

t_prim sdlcaml_ttf_get_hinting(value font) {
  CAMLparam1(font);

  int hinting = TTF_GetFontHinting(Font_val(font));
  CAMLreturn(ml_lookup_from_c(ml_ttf_hinting_table, hinting));
}

t_prim sdlcaml_ttf_set_hinting(value font, value hinting) {
  CAMLparam2(font, hinting);

  TTF_SetFontHinting(Font_val(font),
                     ml_lookup_to_c(ml_ttf_hinting_table, hinting));
  CAMLnoreturn;
}

t_prim sdlcaml_ttf_is_kerning(value font) {
  CAMLparam1(font);

  int kerning = TTF_GetFontKerning(Font_val(font));

  CAMLreturn(kerning ? Val_true : Val_false);
}

t_prim sdlcaml_ttf_set_kerning(value font, value kerning) {
  CAMLparam2(font, kerning);

  int ker = kerning == Val_true ? 1 : 0;

  TTF_SetFontKerning(Font_val(font), ker);
  CAMLnoreturn;
}

t_prim sdlcaml_ttf_height(value font) {
  CAMLparam1(font);

  int height = TTF_FontHeight(Font_val(font));

  CAMLreturn(Val_int(height));
}

t_prim sdlcaml_ttf_ascent(value font) {
  CAMLparam1(font);

  int ascent = TTF_FontAscent(Font_val(font));

  CAMLreturn(Val_int(ascent));
}

t_prim sdlcaml_ttf_descent(value font) {
  CAMLparam1(font);

  int descent = TTF_FontDescent(Font_val(font));

  CAMLreturn(Val_int(descent));
}

t_prim sdlcaml_ttf_line_skip(value font) {
  CAMLparam1(font);

  int skip_line = TTF_FontLineSkip(Font_val(font));

  CAMLreturn(Val_int(skip_line));
}

t_prim sdlcaml_ttf_faces(value font) {
  CAMLparam1(font);

  int faces = TTF_FontFaces(Font_val(font));

  CAMLreturn(Val_int(faces));
}

t_prim sdlcaml_ttf_is_fixed_width(value font) {
  CAMLparam1(font);

  int ret = TTF_FontFaceIsFixedWidth(Font_val(font));

  CAMLreturn(ret ? Val_true : Val_false);
}

t_prim sdlcaml_ttf_family_name(value font) {
  CAMLparam1(font);

  const char* name = TTF_FontFaceFamilyName(Font_val(font));
  if (name) {
    CAMLreturn(Val_some(caml_copy_string(name)));
  } else {
    CAMLreturn(Val_none);
  }
}

t_prim sdlcaml_ttf_style_name(value font) {
  CAMLparam1(font);

  const char* name = TTF_FontFaceStyleName(Font_val(font));
  if (name) {
    CAMLreturn(Val_some(caml_copy_string(name)));
  } else {
    CAMLreturn(Val_none);
  }
}

t_prim sdlcaml_ttf_glyph_is_provided(value font, value ch) {
  CAMLparam2(font, ch);

  int index = TTF_GlyphIsProvided(Font_val(font), Int_val(ch));
  CAMLreturn(!index ? Val_false : Val_true);
}

t_prim sdlcaml_ttf_glyph_metrics(value font, value ch) {
  CAMLparam2(font, ch);
  CAMLlocal1(metrics);
  metrics = caml_alloc(4, 0);

  int minx, maxx, miny, maxy, advance;
  if (TTF_GlyphMetrics(Font_val(font), Int_val(ch),
                   &minx, &maxx, &miny, &maxy, &advance)) {
    CAMLreturn(Val_none);
  } else {
    Store_field(metrics, 0, Val_int(minx));
    Store_field(metrics, 1, Val_int(maxx));
    Store_field(metrics, 2, Val_int(miny));
    Store_field(metrics, 3, Val_int(maxy));
    Store_field(metrics, 4, Val_int(advance));
    CAMLreturn(Val_some(metrics));
  }
}

t_prim sdlcaml_ttf_size_utf8(value font, value text) {
  CAMLparam2(font, text);
  CAMLlocal1(ret);

  int w, h;
  if (TTF_SizeUTF8(Font_val(font), String_val(text), &w, &h)) {
    CAMLreturn(Val_none);
  } else {
    ret = caml_alloc(2, 0);
    Store_field(ret, 0, Val_int(w));
    Store_field(ret, 1, Val_int(h));
    CAMLreturn(ret);
  }
}

t_prim sdlcaml_ttf_render_utf8_solid(value font, value text, value color) {
  CAMLparam3(font, text, color);
  CAMLlocal1(ret);

  SDL_Color col = {Int_val(Field(color, 0)), Int_val(Field(color, 1)),
                   Int_val(Field(color, 2))};
  SDL_Surface* surface = NULL;
  if (!(surface = TTF_RenderUTF8_Solid(Font_val(font), String_val(text), col))) {
    ret = caml_alloc(1, 0);
    Store_field(ret, 0, caml_copy_string(TTF_GetError()));
  } else {
    ret = caml_alloc(1, 1);
    Store_field(ret, 0, alloc_surface(surface));
  }

  CAMLreturn(ret);
}

t_prim sdlcaml_ttf_render_utf8_shaded(value font, value text, value fg, value bg) {
  CAMLparam4(font, text, fg, bg);
  CAMLlocal1(ret);

  SDL_Color fgcol = {Int_val(Field(fg, 0)), Int_val(Field(fg, 1)),
                     Int_val(Field(fg, 2))};
  SDL_Color bgcol = {Int_val(Field(bg, 0)), Int_val(Field(bg, 1)),
                     Int_val(Field(bg, 2))};

  SDL_Surface* surface = NULL;
  if (!(surface = TTF_RenderUTF8_Shaded(Font_val(font), String_val(text),
                                        fgcol, bgcol))) {
    ret = caml_alloc(1, 0);
    Store_field(ret, 0, caml_copy_string(TTF_GetError()));
  } else {
    ret = caml_alloc(1, 1);
    Store_field(ret, 0, alloc_surface(surface));
  }

  CAMLreturn(ret);
}

t_prim sdlcaml_ttf_render_utf8_blended(value font, value text, value fg) {
  CAMLparam3(font, text, fg);
  CAMLlocal1(ret);

  SDL_Color fgcol = {Int_val(Field(fg, 0)), Int_val(Field(fg, 1)),
                     Int_val(Field(fg, 2))};

  SDL_Surface* surface = NULL;
  if (!(surface = TTF_RenderUTF8_Blended(Font_val(font), String_val(text),
                                        fgcol))) {
    ret = caml_alloc(1, 0);
    Store_field(ret, 0, caml_copy_string(TTF_GetError()));
  } else {
    ret = caml_alloc(1, 1);
    Store_field(ret, 0, alloc_surface(surface));
  }

  CAMLreturn(ret);
}
