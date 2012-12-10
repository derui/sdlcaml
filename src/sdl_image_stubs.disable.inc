#define t_prim CAMLprim value

t_prim sdlcaml_image_is_linked(value unit) {
  CAMLparam1(unit);
  CAMLreturn(Val_false);
}

t_prim sdlcaml_image_linked_version(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_image_linked_version: SDL_image is not available");
  CAMLnoreturn;
}

t_prim sdlcaml_image_version(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_image_version: SDL_image is not available");
  CAMLnoreturn;
}

t_prim sdlcaml_image_init(value flags) {
  CAMLparam1(flags);
  caml_failwith("sdlcaml_image_init: SDL_image is not available");
  CAMLnoreturn;
}

t_prim sdlcaml_image_quit(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_image_quit: SDL_image is not available");
  CAMLnoreturn;
}

t_prim sdlcaml_image_load(value filename) {
  CAMLparam1(filename);
  caml_failwith("sdlcaml_image_load: SDL_image is not available");
  CAMLnoreturn;
}

t_prim sdlcaml_image_load_typed(value filename, value image_type) {
  CAMLparam2(filename, image_type);
  caml_failwith("sdlcaml_image_load_typed: SDL_image is not available");
  CAMLnoreturn;
}

t_prim sdlcaml_image_is_type(value filename, value image_type) {
  CAMLparam2(filename, image_type);
  caml_failwith("sdlcaml_image_is_type: SDL_image is not available");
  CAMLnoreturn;
}
