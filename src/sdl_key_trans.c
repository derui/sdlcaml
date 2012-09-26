#include "sdl_key_trans.h"

#include <SDL.h>
#include <SDL_keysym.h>

lookup_info ml_symkey_trans_table[] = {
{0, 133},
{Val_int(MLTAG_SDLK_BACKSPACE), SDLK_BACKSPACE},
{Val_int(MLTAG_SDLK_TAB), SDLK_TAB},
{Val_int(MLTAG_SDLK_CLEAR), SDLK_CLEAR},
{Val_int(MLTAG_SDLK_RETURN), SDLK_RETURN},
{Val_int(MLTAG_SDLK_PAUSE), SDLK_PAUSE},
{Val_int(MLTAG_SDLK_ESCAPE), SDLK_ESCAPE},
{Val_int(MLTAG_SDLK_SPACE), SDLK_SPACE},
{Val_int(MLTAG_SDLK_EXCLAIM), SDLK_EXCLAIM},
{Val_int(MLTAG_SDLK_QUOTEDBL), SDLK_QUOTEDBL},
{Val_int(MLTAG_SDLK_HASH), SDLK_HASH},
{Val_int(MLTAG_SDLK_DOLLAR), SDLK_DOLLAR},
{Val_int(MLTAG_SDLK_AMPERSAND), SDLK_AMPERSAND},
{Val_int(MLTAG_SDLK_QUOTE), SDLK_QUOTE},
{Val_int(MLTAG_SDLK_LEFTPAREN), SDLK_LEFTPAREN},
{Val_int(MLTAG_SDLK_RIGHTPAREN), SDLK_RIGHTPAREN},
{Val_int(MLTAG_SDLK_ASTERISK), SDLK_ASTERISK},
{Val_int(MLTAG_SDLK_PLUS), SDLK_PLUS},
{Val_int(MLTAG_SDLK_COMMA), SDLK_COMMA},
{Val_int(MLTAG_SDLK_MINUS), SDLK_MINUS},
{Val_int(MLTAG_SDLK_PERIOD), SDLK_PERIOD},
{Val_int(MLTAG_SDLK_SLASH), SDLK_SLASH},
{Val_int(MLTAG_SDLK_0), SDLK_0},
{Val_int(MLTAG_SDLK_1), SDLK_1},
{Val_int(MLTAG_SDLK_2), SDLK_2},
{Val_int(MLTAG_SDLK_3), SDLK_3},
{Val_int(MLTAG_SDLK_4), SDLK_4},
{Val_int(MLTAG_SDLK_5), SDLK_5},
{Val_int(MLTAG_SDLK_6), SDLK_6},
{Val_int(MLTAG_SDLK_7), SDLK_7},
{Val_int(MLTAG_SDLK_8), SDLK_8},
{Val_int(MLTAG_SDLK_9), SDLK_9},
{Val_int(MLTAG_SDLK_COLON), SDLK_COLON},
{Val_int(MLTAG_SDLK_SEMICOLON), SDLK_SEMICOLON},
{Val_int(MLTAG_SDLK_LESS), SDLK_LESS},
{Val_int(MLTAG_SDLK_EQUALS), SDLK_EQUALS},
{Val_int(MLTAG_SDLK_GREATER), SDLK_GREATER},
{Val_int(MLTAG_SDLK_QUESTION), SDLK_QUESTION},
{Val_int(MLTAG_SDLK_AT), SDLK_AT},
{Val_int(MLTAG_SDLK_LEFTBRACKET), SDLK_LEFTBRACKET},
{Val_int(MLTAG_SDLK_BACKSLASH), SDLK_BACKSLASH},
{Val_int(MLTAG_SDLK_RIGHTBRACKET), SDLK_RIGHTBRACKET},
{Val_int(MLTAG_SDLK_CARET), SDLK_CARET},
{Val_int(MLTAG_SDLK_UNDERSCORE), SDLK_UNDERSCORE},
{Val_int(MLTAG_SDLK_BACKQUOTE), SDLK_BACKQUOTE},
{Val_int(MLTAG_SDLK_A), SDLK_a},
{Val_int(MLTAG_SDLK_B), SDLK_b},
{Val_int(MLTAG_SDLK_C), SDLK_c},
{Val_int(MLTAG_SDLK_D), SDLK_d},
{Val_int(MLTAG_SDLK_E), SDLK_e},
{Val_int(MLTAG_SDLK_F), SDLK_f},
{Val_int(MLTAG_SDLK_G), SDLK_g},
{Val_int(MLTAG_SDLK_H), SDLK_h},
{Val_int(MLTAG_SDLK_I), SDLK_i},
{Val_int(MLTAG_SDLK_J), SDLK_j},
{Val_int(MLTAG_SDLK_K), SDLK_k},
{Val_int(MLTAG_SDLK_L), SDLK_l},
{Val_int(MLTAG_SDLK_M), SDLK_m},
{Val_int(MLTAG_SDLK_N), SDLK_n},
{Val_int(MLTAG_SDLK_O), SDLK_o},
{Val_int(MLTAG_SDLK_P), SDLK_p},
{Val_int(MLTAG_SDLK_Q), SDLK_q},
{Val_int(MLTAG_SDLK_R), SDLK_r},
{Val_int(MLTAG_SDLK_S), SDLK_s},
{Val_int(MLTAG_SDLK_T), SDLK_t},
{Val_int(MLTAG_SDLK_U), SDLK_u},
{Val_int(MLTAG_SDLK_V), SDLK_v},
{Val_int(MLTAG_SDLK_W), SDLK_w},
{Val_int(MLTAG_SDLK_X), SDLK_x},
{Val_int(MLTAG_SDLK_Y), SDLK_y},
{Val_int(MLTAG_SDLK_Z), SDLK_z},
{Val_int(MLTAG_SDLK_DELETE), SDLK_DELETE},
{Val_int(MLTAG_SDLK_KP0), SDLK_KP0},
{Val_int(MLTAG_SDLK_KP1), SDLK_KP1},
{Val_int(MLTAG_SDLK_KP2), SDLK_KP2},
{Val_int(MLTAG_SDLK_KP3), SDLK_KP3},
{Val_int(MLTAG_SDLK_KP4), SDLK_KP4},
{Val_int(MLTAG_SDLK_KP5), SDLK_KP5},
{Val_int(MLTAG_SDLK_KP6), SDLK_KP6},
{Val_int(MLTAG_SDLK_KP7), SDLK_KP7},
{Val_int(MLTAG_SDLK_KP8), SDLK_KP8},
{Val_int(MLTAG_SDLK_KP9), SDLK_KP9},
{Val_int(MLTAG_SDLK_KP_PERIOD), SDLK_KP_PERIOD},
{Val_int(MLTAG_SDLK_KP_DIVIDE), SDLK_KP_DIVIDE},
{Val_int(MLTAG_SDLK_KP_MULTIPLY), SDLK_KP_MULTIPLY},
{Val_int(MLTAG_SDLK_KP_MINUS), SDLK_KP_MINUS},
{Val_int(MLTAG_SDLK_KP_PLUS), SDLK_KP_PLUS},
{Val_int(MLTAG_SDLK_KP_ENTER), SDLK_KP_ENTER},
{Val_int(MLTAG_SDLK_KP_EQUALS), SDLK_KP_EQUALS},
{Val_int(MLTAG_SDLK_UP), SDLK_UP},
{Val_int(MLTAG_SDLK_DOWN), SDLK_DOWN},
{Val_int(MLTAG_SDLK_RIGHT), SDLK_RIGHT},
{Val_int(MLTAG_SDLK_LEFT), SDLK_LEFT},
{Val_int(MLTAG_SDLK_INSERT), SDLK_INSERT},
{Val_int(MLTAG_SDLK_HOME), SDLK_HOME},
{Val_int(MLTAG_SDLK_END), SDLK_END},
{Val_int(MLTAG_SDLK_PAGEUP), SDLK_PAGEUP},
{Val_int(MLTAG_SDLK_PAGEDOWN), SDLK_PAGEDOWN},
{Val_int(MLTAG_SDLK_F1), SDLK_F1},
{Val_int(MLTAG_SDLK_F2), SDLK_F2},
{Val_int(MLTAG_SDLK_F3), SDLK_F3},
{Val_int(MLTAG_SDLK_F4), SDLK_F4},
{Val_int(MLTAG_SDLK_F5), SDLK_F5},
{Val_int(MLTAG_SDLK_F6), SDLK_F6},
{Val_int(MLTAG_SDLK_F7), SDLK_F7},
{Val_int(MLTAG_SDLK_F8), SDLK_F8},
{Val_int(MLTAG_SDLK_F9), SDLK_F9},
{Val_int(MLTAG_SDLK_F10), SDLK_F10},
{Val_int(MLTAG_SDLK_F11), SDLK_F11},
{Val_int(MLTAG_SDLK_F12), SDLK_F12},
{Val_int(MLTAG_SDLK_F13), SDLK_F13},
{Val_int(MLTAG_SDLK_F14), SDLK_F14},
{Val_int(MLTAG_SDLK_F15), SDLK_F15},
{Val_int(MLTAG_SDLK_NUMLOCK), SDLK_NUMLOCK},
{Val_int(MLTAG_SDLK_CAPSLOCK), SDLK_CAPSLOCK},
{Val_int(MLTAG_SDLK_SCROLLOCK), SDLK_SCROLLOCK},
{Val_int(MLTAG_SDLK_RSHIFT), SDLK_RSHIFT},
{Val_int(MLTAG_SDLK_LSHIFT), SDLK_LSHIFT},
{Val_int(MLTAG_SDLK_RCTRL), SDLK_RCTRL},
{Val_int(MLTAG_SDLK_LCTRL), SDLK_LCTRL},
{Val_int(MLTAG_SDLK_RALT), SDLK_RALT},
{Val_int(MLTAG_SDLK_LALT), SDLK_LALT},
{Val_int(MLTAG_SDLK_RMETA), SDLK_RMETA},
{Val_int(MLTAG_SDLK_LMETA), SDLK_LMETA},
{Val_int(MLTAG_SDLK_LSUPER), SDLK_LSUPER},
{Val_int(MLTAG_SDLK_RSUPER), SDLK_RSUPER},
{Val_int(MLTAG_SDLK_MODE), SDLK_MODE},
{Val_int(MLTAG_SDLK_HELP), SDLK_HELP},
{Val_int(MLTAG_SDLK_PRINT), SDLK_PRINT},
{Val_int(MLTAG_SDLK_SYSREQ), SDLK_SYSREQ},
{Val_int(MLTAG_SDLK_BREAK), SDLK_BREAK},
{Val_int(MLTAG_SDLK_MENU), SDLK_MENU},
{Val_int(MLTAG_SDLK_POWER), SDLK_POWER},
{Val_int(MLTAG_SDLK_EURO), SDLK_EURO}
};

lookup_info ml_modkey_trans_table[] = {
  {0, 12},
  {Val_int(MLTAG_KMOD_NONE), KMOD_NONE},
  {Val_int(MLTAG_KMOD_NUM), KMOD_NUM},
  {Val_int(MLTAG_KMOD_CAPS), KMOD_CAPS},
  {Val_int(MLTAG_KMOD_LCTRL), KMOD_LCTRL},
  {Val_int(MLTAG_KMOD_RCTRL), KMOD_RCTRL},
  {Val_int(MLTAG_KMOD_RSHIFT), KMOD_RSHIFT},
  {Val_int(MLTAG_KMOD_LSHIFT), KMOD_LSHIFT},
  {Val_int(MLTAG_KMOD_RALT), KMOD_RALT},
  {Val_int(MLTAG_KMOD_LALT), KMOD_LALT},
  {Val_int(MLTAG_KMOD_CTRL), KMOD_CTRL},
  {Val_int(MLTAG_KMOD_SHIFT), KMOD_SHIFT},
  {Val_int(MLTAG_KMOD_ALT), KMOD_ALT}
};
