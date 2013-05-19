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

let keysym_printer = function
  | SDLK_BACKSPACE    -> "SDLK_BACKSPACE"
  | SDLK_TAB          -> "SDLK_TAB"
  | SDLK_CLEAR        -> "SDLK_CLEAR"
  | SDLK_RETURN       -> "SDLK_RETURN"
  | SDLK_PAUSE        -> "SDLK_PAUSE"
  | SDLK_ESCAPE       -> "SDLK_ESCAPE"
  | SDLK_SPACE        -> "SDLK_SPACE"
  | SDLK_EXCLAIM      -> "SDLK_EXCLAIM"
  | SDLK_QUOTEDBL     -> "SDLK_QUOTEDBL"
  | SDLK_HASH         -> "SDLK_HASH"
  | SDLK_DOLLAR       -> "SDLK_DOLLAR"
  | SDLK_AMPERSAND    -> "SDLK_AMPERSAND"
  | SDLK_QUOTE        -> "SDLK_QUOTE"
  | SDLK_LEFTPAREN    -> "SDLK_LEFTPAREN"
  | SDLK_RIGHTPAREN   -> "SDLK_RIGHTPAREN"
  | SDLK_ASTERISK     -> "SDLK_ASTERISK"
  | SDLK_PLUS         -> "SDLK_PLUS"
  | SDLK_COMMA        -> "SDLK_COMMA"
  | SDLK_MINUS        -> "SDLK_MINUS"
  | SDLK_PERIOD       -> "SDLK_PERIOD"
  | SDLK_SLASH        -> "SDLK_SLASH"
  | SDLK_0            -> "SDLK_0"
  | SDLK_1            -> "SDLK_1"
  | SDLK_2            -> "SDLK_2"
  | SDLK_3            -> "SDLK_3"
  | SDLK_4            -> "SDLK_4"
  | SDLK_5            -> "SDLK_5"
  | SDLK_6            -> "SDLK_6"
  | SDLK_7            -> "SDLK_7"
  | SDLK_8            -> "SDLK_8"
  | SDLK_9            -> "SDLK_9"
  | SDLK_COLON        -> "SDLK_COLON"
  | SDLK_SEMICOLON    -> "SDLK_SEMICOLON"
  | SDLK_LESS         -> "SDLK_LESS"
  | SDLK_EQUALS       -> "SDLK_EQUALS"
  | SDLK_GREATER      -> "SDLK_GREATER"
  | SDLK_QUESTION     -> "SDLK_QUESTION"
  | SDLK_AT           -> "SDLK_AT"
  | SDLK_LEFTBRACKET  -> "SDLK_LEFTBRACKET"
  | SDLK_BACKSLASH    -> "SDLK_BACKSLASH"
  | SDLK_RIGHTBRACKET -> "SDLK_RIGHTBRACKET"
  | SDLK_CARET        -> "SDLK_CARET"
  | SDLK_UNDERSCORE   -> "SDLK_UNDERSCORE"
  | SDLK_BACKQUOTE    -> "SDLK_BACKQUOTE"
  | SDLK_A            -> "SDLK_A"
  | SDLK_B            -> "SDLK_B"
  | SDLK_C            -> "SDLK_C"
  | SDLK_D            -> "SDLK_D"
  | SDLK_E            -> "SDLK_E"
  | SDLK_F            -> "SDLK_F"
  | SDLK_G            -> "SDLK_G"
  | SDLK_H            -> "SDLK_H"
  | SDLK_I            -> "SDLK_I"
  | SDLK_J            -> "SDLK_J"
  | SDLK_K            -> "SDLK_K"
  | SDLK_L            -> "SDLK_L"
  | SDLK_M            -> "SDLK_M"
  | SDLK_N            -> "SDLK_N"
  | SDLK_O            -> "SDLK_O"
  | SDLK_P            -> "SDLK_P"
  | SDLK_Q            -> "SDLK_Q"
  | SDLK_R            -> "SDLK_R"
  | SDLK_S            -> "SDLK_S"
  | SDLK_T            -> "SDLK_T"
  | SDLK_U            -> "SDLK_U"
  | SDLK_V            -> "SDLK_V"
  | SDLK_W            -> "SDLK_W"
  | SDLK_X            -> "SDLK_X"
  | SDLK_Y            -> "SDLK_Y"
  | SDLK_Z            -> "SDLK_Z"
  | SDLK_DELETE       -> "SDLK_DELETE"
  | SDLK_KP0          -> "SDLK_KP0"
  | SDLK_KP1          -> "SDLK_KP1"
  | SDLK_KP2          -> "SDLK_KP2"
  | SDLK_KP3          -> "SDLK_KP3"
  | SDLK_KP4          -> "SDLK_KP4"
  | SDLK_KP5          -> "SDLK_KP5"
  | SDLK_KP6          -> "SDLK_KP6"
  | SDLK_KP7          -> "SDLK_KP7"
  | SDLK_KP8          -> "SDLK_KP8"
  | SDLK_KP9          -> "SDLK_KP9"
  | SDLK_KP_PERIOD    -> "SDLK_KP_PERIOD"
  | SDLK_KP_DIVIDE    -> "SDLK_KP_DIVIDE"
  | SDLK_KP_MULTIPLY  -> "SDLK_KP_MULTIPLY"
  | SDLK_KP_MINUS     -> "SDLK_KP_MINUS"
  | SDLK_KP_PLUS      -> "SDLK_KP_PLUS"
  | SDLK_KP_ENTER     -> "SDLK_KP_ENTER"
  | SDLK_KP_EQUALS    -> "SDLK_KP_EQUALS"
  | SDLK_UP           -> "SDLK_UP"
  | SDLK_DOWN         -> "SDLK_DOWN"
  | SDLK_RIGHT        -> "SDLK_RIGHT"
  | SDLK_LEFT         -> "SDLK_LEFT"
  | SDLK_INSERT       -> "SDLK_INSERT"
  | SDLK_HOME         -> "SDLK_HOME"
  | SDLK_END          -> "SDLK_END"
  | SDLK_PAGEUP       -> "SDLK_PAGEUP"
  | SDLK_PAGEDOWN     -> "SDLK_PAGEDOWN"
  | SDLK_F1           -> "SDLK_F1"
  | SDLK_F2           -> "SDLK_F2"
  | SDLK_F3           -> "SDLK_F3"
  | SDLK_F4           -> "SDLK_F4"
  | SDLK_F5           -> "SDLK_F5"
  | SDLK_F6           -> "SDLK_F6"
  | SDLK_F7           -> "SDLK_F7"
  | SDLK_F8           -> "SDLK_F8"
  | SDLK_F9           -> "SDLK_F9"
  | SDLK_F10          -> "SDLK_F10"
  | SDLK_F11          -> "SDLK_F11"
  | SDLK_F12          -> "SDLK_F12"
  | SDLK_F13          -> "SDLK_F13"
  | SDLK_F14          -> "SDLK_F14"
  | SDLK_F15          -> "SDLK_F15"
  | SDLK_NUMLOCK      -> "SDLK_NUMLOCK"
  | SDLK_CAPSLOCK     -> "SDLK_CAPSLOCK"
  | SDLK_SCROLLOCK    -> "SDLK_SCROLLOCK"
  | SDLK_RSHIFT       -> "SDLK_RSHIFT"
  | SDLK_LSHIFT       -> "SDLK_LSHIFT"
  | SDLK_RCTRL        -> "SDLK_RCTRL"
  | SDLK_LCTRL        -> "SDLK_LCTRL"
  | SDLK_RALT         -> "SDLK_RALT"
  | SDLK_LALT         -> "SDLK_LALT"
  | SDLK_RMETA        -> "SDLK_RMETA"
  | SDLK_LMETA        -> "SDLK_LMETA"
  | SDLK_LSUPER       -> "SDLK_LSUPER"
  | SDLK_RSUPER       -> "SDLK_RSUPER"
  | SDLK_MODE         -> "SDLK_MODE"
  | SDLK_HELP         -> "SDLK_HELP"
  | SDLK_PRINT        -> "SDLK_PRINT"
  | SDLK_SYSREQ       -> "SDLK_SYSREQ"
  | SDLK_BREAK        -> "SDLK_BREAK"
  | SDLK_MENU         -> "SDLK_MENU"
  | SDLK_POWER        -> "SDLK_POWER"
  | SDLK_EURO         -> "SDLK_EURO"
  | SDLK_NONE         -> "SDLK_NONE"

type key_info = {
  synonym: key_synonym;
  modify_state: modify_key list;
}

let empty = {synonym = SDLK_NONE; modify_state = []}

module Compare =
  struct
    type t = key_synonym
    let compare x y =
      if x < y then -1
      else if x = y then 0
      else 1
  end

module Comparable = Sugarpot.Std.Comparable.Make(Compare)

module StateMap = Sugarpot.Std.Map.Make (Compare)

let to_state_map statelist =
  let make_map (key, state) map = StateMap.add map ~key ~data:state in
  List.fold_right make_map statelist StateMap.empty

let _ =
  Callback.register "sdlcaml_ml_convert_state_map" to_state_map
