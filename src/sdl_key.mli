(**
   this module contains key synonyms binding SDLK_* and Modify key
   binding MODK_*.
   In addition them, provide it that state map associate key with state what key is
   pressed or released.

*)

(**
 * Mapping {b SDLkey}. These often uses with {!Sdl_KeyStateMap.state_map}
 *)
type key_synonym =
| SDLK_BACKSPACE                        (** backspace *)
| SDLK_TAB                              (** tab *)
| SDLK_CLEAR                            (** clear *)
| SDLK_RETURN                           (** return *)
| SDLK_PAUSE                            (** pause *)
| SDLK_ESCAPE                           (** escape *)
| SDLK_SPACE                            (** space *)
| SDLK_EXCLAIM                          (** exclaim *)
| SDLK_QUOTEDBL                         (** quotedbl *)
| SDLK_HASH                             (** hash *)
| SDLK_DOLLAR                           (** dollar *)
| SDLK_AMPERSAND                        (** ampersand *)
| SDLK_QUOTE                            (** quote *)
| SDLK_LEFTPAREN                        (** left parenthesis *)
| SDLK_RIGHTPAREN                       (** right parenthesis *)
| SDLK_ASTERISK                         (** asterisk *)
| SDLK_PLUS                             (** plus sign *)
| SDLK_COMMA                            (** comma *)
| SDLK_MINUS                            (** minus sign *)
| SDLK_PERIOD                           (** period *)
| SDLK_SLASH                            (** forward slash *)
| SDLK_0                                (** 0 *)
| SDLK_1                                (** 1 *)
| SDLK_2                                (** 2 *)
| SDLK_3                                (** 3 *)
| SDLK_4                                (** 4 *)
| SDLK_5                                (** 5 *)
| SDLK_6                                (** 6 *)
| SDLK_7                                (** 7 *)
| SDLK_8                                (** 8 *)
| SDLK_9                                (** 9 *)
| SDLK_COLON                            (** colon *)
| SDLK_SEMICOLON                        (** semicolon *)
| SDLK_LESS                             (** less-than sign *)
| SDLK_EQUALS                           (** equals sign *)
| SDLK_GREATER                          (** greater-than sign *)
| SDLK_QUESTION                         (** question mark *)
| SDLK_AT                               (** at *)
| SDLK_LEFTBRACKET                      (** left bracket *)
| SDLK_BACKSLASH                        (** backslash *)
| SDLK_RIGHTBRACKET                     (** right bracket *)
| SDLK_CARET                            (** caret *)
| SDLK_UNDERSCORE                       (** underscore *)
| SDLK_BACKQUOTE                        (** grave *)
| SDLK_A                                (** a *)
| SDLK_B                                (** b *)
| SDLK_C                                (** c *)
| SDLK_D                                (** d *)
| SDLK_E                                (** e *)
| SDLK_F                                (** f *)
| SDLK_G                                (** g *)
| SDLK_H                                (** h *)
| SDLK_I                                (** i *)
| SDLK_J                                (** j *)
| SDLK_K                                (** k *)
| SDLK_L                                (** l *)
| SDLK_M                                (** m *)
| SDLK_N                                (** n *)
| SDLK_O                                (** o *)
| SDLK_P                                (** p *)
| SDLK_Q                                (** q *)
| SDLK_R                                (** r *)
| SDLK_S                                (** s *)
| SDLK_T                                (** t *)
| SDLK_U                                (** u *)
| SDLK_V                                (** v *)
| SDLK_W                                (** w *)
| SDLK_X                                (** x *)
| SDLK_Y                                (** y *)
| SDLK_Z                                (** z *)
| SDLK_DELETE                           (** delete *)
| SDLK_KP0                              (** keypad 0 *)
| SDLK_KP1                              (** keypad 1 *)
| SDLK_KP2                              (** keypad 2 *)
| SDLK_KP3                              (** keypad 3 *)
| SDLK_KP4                              (** keypad 4 *)
| SDLK_KP5                              (** keypad 5 *)
| SDLK_KP6                              (** keypad 6 *)
| SDLK_KP7                              (** keypad 7 *)
| SDLK_KP8                              (** keypad 8 *)
| SDLK_KP9                              (** keypad 9 *)
| SDLK_KP_PERIOD                        (** keypad period *)
| SDLK_KP_DIVIDE                        (** keypad divide *)
| SDLK_KP_MULTIPLY                      (** keypad multiply *)
| SDLK_KP_MINUS                         (** keypad minus *)
| SDLK_KP_PLUS                          (** keypad plus *)
| SDLK_KP_ENTER                         (** keypad enter *)
| SDLK_KP_EQUALS                        (** keypad equals *)
| SDLK_UP                               (** up arrow *)
| SDLK_DOWN                             (** down arrow *)
| SDLK_RIGHT                            (** right arrow *)
| SDLK_LEFT                             (** left arrow *)
| SDLK_INSERT                           (** insert *)
| SDLK_HOME                             (** home *)
| SDLK_END                              (** end *)
| SDLK_PAGEUP                           (** page up *)
| SDLK_PAGEDOWN                         (** page down *)
| SDLK_F1                               (** F1 *)
| SDLK_F2                               (** F2 *)
| SDLK_F3                               (** F3 *)
| SDLK_F4                               (** F4 *)
| SDLK_F5                               (** F5 *)
| SDLK_F6                               (** F6 *)
| SDLK_F7                               (** F7 *)
| SDLK_F8                               (** F8 *)
| SDLK_F9                               (** F9 *)
| SDLK_F10                              (** F10 *)
| SDLK_F11                              (** F11 *)
| SDLK_F12                              (** F12 *)
| SDLK_F13                              (** F13 *)
| SDLK_F14                              (** F14 *)
| SDLK_F15                              (** F15 *)
| SDLK_NUMLOCK                          (** numlock *)
| SDLK_CAPSLOCK                         (** capslock *)
| SDLK_SCROLLOCK                        (** scrollock *)
| SDLK_RSHIFT                           (** right shift *)
| SDLK_LSHIFT                           (** left shift *)
| SDLK_RCTRL                            (** right ctrl *)
| SDLK_LCTRL                            (** left ctrl *)
| SDLK_RALT                             (** right alt *)
| SDLK_LALT                             (** left alt *)
| SDLK_RMETA                            (** right meta *)
| SDLK_LMETA                            (** left meta *)
| SDLK_LSUPER                           (** left windows key *)
| SDLK_RSUPER                           (** right windows key *)
| SDLK_MODE                             (** mode shift *)
| SDLK_HELP                             (** help *)
| SDLK_PRINT                            (** print-screen *)
| SDLK_SYSREQ                           (** SysRq *)
| SDLK_BREAK                            (** break *)
| SDLK_MENU                             (** menu *)
| SDLK_POWER                            (** power *)
| SDLK_EURO                             (** euro *)
| SDLK_NONE                             (** only use in OCaml *)

(**
   convert keysym into string. string converted is simply
   without change constructor name.
*)
val keysym_printer: key_synonym -> string

(**
 * Mapping modify keys in {b SDL_keysym}.
 * These often uses with {!Sdl_event.get_mod_state}
 *)
type modify_key =
| KMOD_NONE                             (** No modifiers applicable *)
| KMOD_NUM                              (** Numlock is down *)
| KMOD_CAPS                             (** Capslock is down *)
| KMOD_LCTRL                            (** Left Control is down *)
| KMOD_RCTRL                            (** Right Control is down *)
| KMOD_RSHIFT                           (** Right Shift is down *)
| KMOD_LSHIFT                           (** Left Shift is down *)
| KMOD_RALT                             (** Right Alt is down *)
| KMOD_LALT                             (** Left Alt is down *)
| KMOD_CTRL                             (** A Control key is down *)
| KMOD_SHIFT                            (** A Shift key is down *)
| KMOD_ALT                              (** An Alt key is down *)

(**
   Mapping {b SDL_keysym}. however, {!keysym.mod_key} is the list of
   current modify key state. If some {!mod_key} variants are
   contained, it means that they are pressed now.
*)
type key_info = {
  synonym: key_synonym;
  modify_state: modify_key list;
}

(** default {!key_info} *)
val empty: key_info

module Compare : Sugarpot.Std.Comparable.Type with type t := key_synonym

module Comparable : Sugarpot.Std.Comparable.S with type t := key_synonym

(** Map for key and key state. *)
module StateMap : Sugarpot.Std.Map.S with type Key.t = key_synonym

(**
   This function is provided to be used from C.
   To reveive list is converted into {!state_map}.
*)
val to_state_map: (key_synonym * bool) list -> bool StateMap.t
