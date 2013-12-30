type t = [ `ALLOW_HIGHDPI
         | `FOREIGN
         | `MOUSE_FOCUS
         | `INPUT_FOCUS
         | `INPUT_GRABBED
         | `MAXIMIZED
         | `MINIMIZED
         | `RESIZABLE
         | `BORDERLESS
         | `SHOWN
         | `HIDDEN
         | `OPENGL
         | `FULLSCREEN_DESKTOP
         | `FULLSCREEN
         ]

let flags = [ `ALLOW_HIGHDPI
            ; `FOREIGN
            ; `MOUSE_FOCUS
            ; `INPUT_FOCUS
            ; `INPUT_GRABBED
            ; `MAXIMIZED
            ; `MINIMIZED
            ; `RESIZABLE
            ; `BORDERLESS
            ; `SHOWN
            ; `HIDDEN
            ; `OPENGL
            ; `FULLSCREEN_DESKTOP
            ; `FULLSCREEN
            ]

let to_int = function
  | `ALLOW_HIGHDPI -> 0x2000
  | `FULLSCREEN -> 0x1
  | `FULLSCREEN_DESKTOP -> 0x1001
  | `FOREIGN -> 0x800
  | `MOUSE_FOCUS -> 0x400
  | `INPUT_FOCUS -> 0x200
  | `INPUT_GRABBED -> 0x100
  | `MAXIMIZED -> 0x80
  | `MINIMIZED -> 0x40
  | `RESIZABLE -> 0x20
  | `BORDERLESS -> 0x10
  | `SHOWN -> 0x4
  | `HIDDEN -> 0x8
  | `OPENGL -> 0x2
  | _ -> invalid_arg "Sdlcaml_flags.Sdl_window_flags"

let of_int = function
  | 0x2000 -> `ALLOW_HIGHDPI
  | 0x1 -> `FULLSCREEN
  | 0x1001 -> `FULLSCREEN_DESKTOP
  | 0x800 -> `FOREIGN
  | 0x400 -> `MOUSE_FOCUS
  | 0x200 -> `INPUT_FOCUS
  | 0x100 -> `INPUT_GRABBED
  | 0x80 -> `MAXIMIZED
  | 0x40 -> `MINIMIZED
  | 0x20 -> `RESIZABLE
  | 0x10 -> `BORDERLESS
  | 0x4 -> `SHOWN
  | 0x8 -> `HIDDEN
  | 0x2 -> `OPENGL
  | _ -> invalid_arg "Sdlcaml_flags.Sdl_window_flags"
