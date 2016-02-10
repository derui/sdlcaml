open Core.Std
open Ctypes
open Foreign

open Sdlcaml_flags
module T = Sdl_types

module Inner = struct
  let get_key_from_name = foreign "SDL_GetKeyFromName" (string @-> returning int32_t)
  let get_key_from_scancode = foreign "SDL_GetKeyFromScancode" (int @-> returning int32_t)
  let get_key_name = foreign "SDL_GetKeyName" (int32_t @-> returning string)
  let get_keyboard_focus = foreign "SDL_GetKeyboardFocus" (void @-> returning T.Window.t)
  let get_keyboard_state = foreign "SDL_GetKeyboardState" (ptr int @-> returning (ptr uint8_t))
  let get_mod_state = foreign "SDL_GetModState" (void @-> returning int)
  let has_screen_keyboard_support = foreign "SDL_HasScreenKeyboardSupport" (void @-> returning int)
  let is_screen_keyboard_shown = foreign "SDL_IsScreenKeyboardShown" (T.Window.t @-> returning int)
  let is_text_input_active = foreign "SDL_IsTextInputActive" (void @-> returning int)
  let start_text_input = foreign "SDL_StartTextInput" (void @-> returning void)
  let stop_text_input = foreign "SDL_StopTextInput" (void @-> returning void)
end

let get_key_from_name name =
  let ret = Inner.get_key_from_name name in
  let key = Signed.Int32.to_int ret |> Sdl_keycode.of_int in
  Sdl_util.catch (fun () -> key = Sdl_keycode.SDLK_UNKNOWN) (fun () -> key)

let get_key_from_scan_code scancode =
  let scancode = Sdl_scancode.to_int scancode in
  let key = Inner.get_key_from_scancode scancode in
  Sdl_keycode.of_int (Signed.Int32.to_int key)

let get_name keycode =
  let keycode = Sdl_keycode.to_int keycode in
  Inner.get_key_name (Signed.Int32.of_int keycode)

let get_keyboard_focus () = Inner.get_keyboard_focus ()

let is_pressed scancode =
  let count = CArray.make int 1 in
  let ret = Inner.get_keyboard_state (CArray.start count) in
  let point = ret +@ (Sdl_scancode.to_int scancode) in
  Sdl_helper.int_to_bool (!@point |> Unsigned.UInt8.to_int)

let is_released = Fn.compose not is_pressed

let get_mod_state () =
  let ret = Inner.get_mod_state () in
  Sdl_keymod.of_int ret

let has_screen_keyboard_support =
  Fn.compose Sdl_helper.int_to_bool Inner.has_screen_keyboard_support

let is_screen_keyboard_shown =
  Fn.compose Sdl_helper.int_to_bool Inner.is_screen_keyboard_shown

let is_text_input_active =
  Fn.compose Sdl_helper.int_to_bool Inner.is_text_input_active

let start_text_input = Inner.start_text_input
let stop_text_input = Inner.stop_text_input
