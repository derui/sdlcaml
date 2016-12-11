(**
   This module provide shortcuts for modules that are Sdl_* prefixed modules.

   @author derui
   @since 0.1
*)

module Init = Sdl_init
module Error = Sdl_error
module Surface = Sdl_surface
module Texture = Sdl_texture
module Renderer = Sdl_renderer
module Window = Sdl_window
module Joystick = Sdl_joystick
module Pixel = Sdl_pixels
module Event = Sdl_event
module Mouse = Sdl_mouse
module Timer = Sdl_timer
module Audio = Sdl_audio
module RWops = Sdl_rwops
module Keyboard = Sdl_keyboard
module Game_controller = Sdl_game_controller
module Gl = Sdl_gl

module Flags = struct
  include Sdlcaml_flags
end

module Structures = struct
  include Sdlcaml_structures
end

module Types = struct
  include Sdl_types
end

module Rect = Sdl_rect
