type buffer

module Buffer = struct
  include Enums.Buffer
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindBuffer.xml}
    manual pages on opengl.org}
*)
external glBindBuffer: target:Buffer.buffer_type -> buffer:buffer -> unit =
  "gl_api_glBindBuffer"

module BufferData = struct
  include Enums.BufferData
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBufferData.xml}
    manual pages on opengl.org}
*)
external glBufferData: target:BufferData.target_type -> size:int ->
  data:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t ->
  usage:BufferData.usage_type -> unit =
  "gl_api_glBufferData"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBufferSubData.xml}
    manual pages on opengl.org}
*)
external glBufferSubData: target:BufferData.target_type -> offset:int ->
  size:int -> data:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit =
  "gl_api_glBufferSubData"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGenBuffers.xml}
    manual pages on opengl.org}
*)
external glGenBuffer: unit -> buffer = "gl_api_glGenBuffer"
external glGenBuffers: int -> buffer list = "gl_api_glGenBuffers"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteBuffers.xml}
    manual pages on opengl.org}
*)
external glDeleteBuffers: size:int -> buffers:buffer list -> unit =
  "gl_api_glDeleteBuffers"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetBufferParameter.xml}
    manual pages on opengl.org}
*)
external glGetBufferParameter_access: Buffer.buffer_type -> Buffer.access_type =
  "gl_api_glGetBufferParameter_access"
external glGetBufferParameter_mapped: Buffer.buffer_type -> bool =
  "gl_api_glGetBufferParameter_mapped"
external glGetBufferParameter_size: Buffer.buffer_type -> int =
  "gl_api_glGetBufferParameter_size"
external glGetBufferParameter_usage: Buffer.buffer_type -> Buffer.buffer_usage_type =
  "gl_api_glGetBufferParameter_usage"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetBufferSubData.xml}
    manual pages on opengl.org}
*)
external glGetBufferSubData: target:Buffer.buffer_type ->
  offset:int -> size:int -> (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t =
  "gl_api_glGetBufferSubData"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsBuffer.xml}
    manual pages on opengl.org}
*)
external glIsBuffer: buffer -> bool = "gl_api_glIsBuffer"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCopyBufferSubData.xml}
    manual pages on opengl.org}
*)
external glCopyBufferSubData: read:BufferData.target_type -> write:BufferData.target_type ->
  readoffset:int -> writeoffset:int -> size:int -> unit = "gl_api_glCopyBufferSubData"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFlushMappedBufferRange.xml}
    manual pages on opengl.org}
*)
external glFlushMappedBufferRange: target:BufferData.target_type ->
  offset:int -> length:int -> unit = "gl_api_glFlushMappedBufferRange"

module TexBuffer = struct
  include Enums.TexBuffer
end

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexBuffer.xml}
    manual pages on opengl.org}
*)
external glTexBuffer: internalformat:TexBuffer.internal_format ->
  buffer:buffer -> unit = "gl_api_glTexBuffer"
