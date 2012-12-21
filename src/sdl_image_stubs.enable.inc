static char* ml_image_type_table[] =
{ "BMP",
  "CUR",
  "GIF",
  "ICO",
  "JPG",
  "LBM",
  "PCX",
  "PNG",
  "PNM",
  "TGA",
  "TIF",
  "XCF",
  "XPM",
  "XV"};

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

#define t_prim CAMLprim value

t_prim sdlcaml_image_is_linked(value unit) {
  CAMLparam1(unit);
  CAMLreturn(Val_true);
}

t_prim sdlcaml_image_linked_version(value unit) {
  CAMLparam1(unit);
  CAMLlocal1(version);

  const SDL_version* v = IMG_Linked_Version();
  version = caml_alloc(3, 0);
  Store_field(version, 0, v->major);
  Store_field(version, 1, v->minor);
  Store_field(version, 2, v->patch);

  CAMLreturn(version);
}

t_prim sdlcaml_image_version(value unit) {
  CAMLparam1(unit);
  CAMLlocal1(version);

  SDL_version v;
  SDL_IMAGE_VERSION(&v);
  version = caml_alloc(3, 0);
  Store_field(version, 0, v.major);
  Store_field(version, 1, v.minor);
  Store_field(version, 2, v.patch);

  CAMLreturn(version);
}

t_prim sdlcaml_image_init(value flags) {
  CAMLparam1(flags);
  CAMLlocal3(list, f, res);
  list = flags;

  int real_flag = 0;
  while (is_not_nil(list)) {
    f = head(list);
    real_flag |= ml_lookup_to_c(ml_image_flag_table, f);
    list = tail(list);
  }

  int initted = IMG_Init(real_flag);
  if ((initted & real_flag) != real_flag) {
    res = caml_alloc(1, 0);
    Store_field(res, 0, caml_copy_string(IMG_GetError()));
  } else {
    res = caml_alloc(1, 1);
    Store_field(res, 0, Val_unit);
  }

  CAMLreturn(res);
}

t_prim sdlcaml_image_quit(value unit) {
  CAMLparam1(unit);

  IMG_Quit();
  CAMLreturn(Val_unit);
}

t_prim sdlcaml_image_load(value filename) {
  CAMLparam1(filename);

  SDL_Surface* raw_surface = IMG_Load(String_val(filename));
  if (raw_surface == NULL) {
    CAMLreturn(Val_none);
  }
  CAMLreturn(Val_some(alloc_surface(raw_surface)));
}

t_prim sdlcaml_image_load_typed(value filename, value image_type) {
  CAMLparam2(filename, image_type);

  SDL_Surface *raw_surface = IMG_LoadTyped_RW(
      SDL_RWFromFile(String_val(filename), "rb"), 1,
      ml_image_type_table[Int_val(image_type)]);
  if (raw_surface) {
    CAMLreturn(Val_none);
  }
  CAMLreturn(Val_some(alloc_surface(raw_surface)));
}

t_prim sdlcaml_image_is_type(value filename, value image_type) {
  CAMLparam2(filename, image_type);
  int ret = 0;

  SDL_RWops* ops = SDL_RWFromFile(String_val(filename), "rb");

  switch (Int_val(image_type)) {
    case 0 : ret = IMG_isBMP(ops); break;
    case 1 : ret = IMG_isCUR(ops); break;
    case 2 : ret = IMG_isGIF(ops); break;
    case 3 : ret = IMG_isICO(ops); break;
    case 4 : ret = IMG_isJPG(ops); break;
    case 5 : ret = IMG_isLBM(ops); break;
    case 6 : ret = IMG_isPCX(ops); break;
    case 7 : ret = IMG_isPNG(ops); break;
    case 8 : ret = IMG_isPNM(ops); break;
    case 9 : break;
    case 10: ret = IMG_isTIF(ops); break;
    case 11: ret = IMG_isXCF(ops); break;
    case 12: ret = IMG_isXPM(ops); break;
    case 13: ret = IMG_isXV (ops); break;
    default: break;
  }
  SDL_FreeRW(ops);

  if (ret) {
    CAMLreturn(Val_true);
  } else {
    CAMLreturn(Val_false);
  }
}
