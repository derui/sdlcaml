open Ctypes

module F = Sdlcaml_flags
(** The key synonym information representing the key. *)
type t = {
  scancode : F.Sdl_scancode.t;
  sym : F.Sdl_keycode.t;
  keymod : F.Sdl_keymod.t list;
}

let t : t structure typ = structure "SDL_Keysym"

let scancode = field t "scancode" int
let sym = field t "sym" int
let keymod = field t "mod" uint16_t

let to_ocaml e = {
  scancode = getf e scancode |> F.Sdl_scancode.of_int;
  sym = getf e sym |> F.Sdl_keycode.of_int;
  keymod = let keymods = getf e keymod |> Unsigned.UInt16.to_int in
           F.Sdl_keymod.to_list keymods
}

let of_ocaml e =
  let s = make t in
  F.Sdl_scancode.to_int e.scancode |> setf s scancode;
  F.Sdl_keycode.to_int e.sym |> setf s sym;
  let mods = List.map F.Sdl_keymod.to_int e.keymod in
  let mods = List.fold_left (fun s m -> s lor m) 0 mods in
  Unsigned.UInt16.of_int mods |> setf s keymod;
  s

let () = seal t
