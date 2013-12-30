type t =
    SDL_GL_RED_SIZE
  | SDL_GL_GREEN_SIZE
  | SDL_GL_BLUE_SIZE
  | SDL_GL_ALPHA_SIZE
  | SDL_GL_BUFFER_SIZE
  | SDL_GL_DOUBLEBUFFER
  | SDL_GL_DEPTH_SIZE
  | SDL_GL_STENCIL_SIZE
  | SDL_GL_ACCUM_RED_SIZE
  | SDL_GL_ACCUM_GREEN_SIZE
  | SDL_GL_ACCUM_BLUE_SIZE
  | SDL_GL_ACCUM_ALPHA_SIZE
  | SDL_GL_STEREO
  | SDL_GL_MULTISAMPLEBUFFERS
  | SDL_GL_MULTISAMPLESAMPLES
  | SDL_GL_ACCELERATED_VISUAL
  | SDL_GL_RETAINED_BACKING
  | SDL_GL_CONTEXT_MAJOR_VERSION
  | SDL_GL_CONTEXT_MINOR_VERSION
  | SDL_GL_CONTEXT_EGL
  | SDL_GL_CONTEXT_FLAGS
  | SDL_GL_CONTEXT_PROFILE_MASK
  | SDL_GL_SHARE_WITH_CURRENT_CONTEXT
  | SDL_GL_FRAMEBUFFER_SRGB_CAPABLE

let to_int = function
  | SDL_GL_RED_SIZE                    -> 0
  | SDL_GL_GREEN_SIZE                  -> 1
  | SDL_GL_BLUE_SIZE                   -> 2
  | SDL_GL_ALPHA_SIZE                  -> 3
  | SDL_GL_BUFFER_SIZE                 -> 4
  | SDL_GL_DOUBLEBUFFER                -> 5
  | SDL_GL_DEPTH_SIZE                  -> 6
  | SDL_GL_STENCIL_SIZE                -> 7
  | SDL_GL_ACCUM_RED_SIZE              -> 8
  | SDL_GL_ACCUM_GREEN_SIZE            -> 9
  | SDL_GL_ACCUM_BLUE_SIZE             -> 10
  | SDL_GL_ACCUM_ALPHA_SIZE            -> 11
  | SDL_GL_STEREO                      -> 12
  | SDL_GL_MULTISAMPLEBUFFERS          -> 13
  | SDL_GL_MULTISAMPLESAMPLES          -> 14
  | SDL_GL_ACCELERATED_VISUAL          -> 15
  | SDL_GL_RETAINED_BACKING            -> 16
  | SDL_GL_CONTEXT_MAJOR_VERSION       -> 17
  | SDL_GL_CONTEXT_MINOR_VERSION       -> 18
  | SDL_GL_CONTEXT_EGL                 -> 19
  | SDL_GL_CONTEXT_FLAGS               -> 20
  | SDL_GL_CONTEXT_PROFILE_MASK        -> 21
  | SDL_GL_SHARE_WITH_CURRENT_CONTEXT  -> 22
  | SDL_GL_FRAMEBUFFER_SRGB_CAPABLE    -> 23

let of_int = function
  | 0   -> SDL_GL_RED_SIZE
  | 1   -> SDL_GL_GREEN_SIZE
  | 2   -> SDL_GL_BLUE_SIZE
  | 3   -> SDL_GL_ALPHA_SIZE
  | 4   -> SDL_GL_BUFFER_SIZE
  | 5   -> SDL_GL_DOUBLEBUFFER
  | 6   -> SDL_GL_DEPTH_SIZE
  | 7   -> SDL_GL_STENCIL_SIZE
  | 8   -> SDL_GL_ACCUM_RED_SIZE
  | 9   -> SDL_GL_ACCUM_GREEN_SIZE
  | 10  -> SDL_GL_ACCUM_BLUE_SIZE
  | 11  -> SDL_GL_ACCUM_ALPHA_SIZE
  | 12  -> SDL_GL_STEREO
  | 13  -> SDL_GL_MULTISAMPLEBUFFERS
  | 14  -> SDL_GL_MULTISAMPLESAMPLES
  | 15  -> SDL_GL_ACCELERATED_VISUAL
  | 16  -> SDL_GL_RETAINED_BACKING
  | 17  -> SDL_GL_CONTEXT_MAJOR_VERSION
  | 18  -> SDL_GL_CONTEXT_MINOR_VERSION
  | 19  -> SDL_GL_CONTEXT_EGL
  | 20  -> SDL_GL_CONTEXT_FLAGS
  | 21  -> SDL_GL_CONTEXT_PROFILE_MASK
  | 22  -> SDL_GL_SHARE_WITH_CURRENT_CONTEXT
  | 23  -> SDL_GL_FRAMEBUFFER_SRGB_CAPABLE
  | _ -> failwith "No variant to match given value"
