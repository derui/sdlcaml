(**
   Define a module to provide operations for handling audio devices and audio input/output.
   This module define some of SDL_audio API for [new] API.

   Not providing audio subsystem initialization because it is always
   initialized by [Sdl_init.init] or [Sdl_init.init_subsystem]. 

   @author derui
   @since 0.2
*)


open Sdlcaml_structures
open Ctypes
open Foreign

type id

type buf = Unsigned.UInt8.t carray

val get_device_names: unit -> string list
(** [get_device_names ()] get names of all available audio devices. *)

val open_device: ?device:string ->
  desired:Sdlcaml_structures.Audio_spec.t ->
  allowed:Sdlcaml_flags.Sdl_audio_allow_status.t list -> unit ->
  (id * Sdlcaml_structures.Audio_spec.t) Sdl_types.Result.t
(** [open_device ?device ~desired ~allowed ()] open a specifie audio device. *)

val load_wav: ?auto_clean:bool -> Sdl_rwops.t ->
  unit -> (buf * int32 * Audio_spec.t) Sdl_types.Result.t
(** [load_wav ?auto_clean src ()] load a WAVE from the data source,
    automatically freeing that source if [auto_clean] is true.
    The default value of [auto_clean] is true, so default behaviour that is this free that source.

    If you want to free anytime what you want, [auto_clean] specified false and call [free_wav] with
    returned buffer from this.
*)

val free_wav: buf -> unit
(** [free_wav buf] free data previously allocated with [load_wav] *)

val close_device: id -> unit
(** [close_device id] shut down audio processing and close the audio device *)

val pause: id -> unit
(** [pause id] pause audio playback on a specified device *)

val unpause: id -> unit
(** [unpause id] unpause audio playback on a specified device *)

val queue: id:id -> data:'a Ctypes.carray -> unit Sdl_types.Result.t
(** [queue ~id ~data] queue more audio on non-callback device.
    The [data] arguments must have typing of Ctypes, but length of queue get from [data].
*)

val get_queued_size: id -> int32
(** [get_queued_size id] get the number of bytes of still-queued audio *)

val with_lock: id -> f:(unit -> 'a) -> 'a
(** [with_lock ~f id] lock out the audio callback function for specified device,
    and unlock finish [f].
*)

val clear: id -> unit
(** [clear id] drop any queued audio data waiting to be sent to the hardware *)
