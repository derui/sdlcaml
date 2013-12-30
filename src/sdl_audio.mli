(**
   Define a module to provide operations for handling audio devices and audio input/output.
   This module define some of SDL_audio API for [new] API.

   @author derui
   @since 0.2
*)

(* Initialization audio subsystem is always executed [Sdl_init.init] or [Sdl_init.init_subsystem]. *)

type id

val get_device_names: unit -> string list
(* [get_device_names ()] get names of all available audio devices. *)

val open_device: ?device:string ->
  desired:Sdlcaml_structures.Audio_spec.t ->
  allowed:Sdlcaml_flags.Sdl_audio_allow_status.t list -> unit ->
  (id * Sdlcaml_structures.Audio_spec.t) Sdl_types.Result.t
(* [open_device ?device ~desired ~allowed ()] open a specifie audio device. *)

val close_device: id -> unit
(* [close_device id] shut down audio processing and close the audio device *)

val pause: id -> unit
(* [pause id] pause audio playback on a specified device *)

val unpause: id -> unit
(* [unpause id] unpause audio playback on a specified device *)

val queue: id:id -> data:'a Ctypes.carray -> unit Sdl_types.Result.t
(* [queue ~id ~data] queue more audio on non-callback device.
   The [data] arguments must have typing of Ctypes, but length of queue get from [data].
*)

val get_queued_size: id -> int32
(* [get_queued_size id] get the number of bytes of still-queued audio *)

val with_lock: id -> f:(unit -> 'a) -> 'a
(* [with_lock ~f id] lock out the audio callback function for specified device,
   and unlock finish [f].
*)

val clear: id -> unit
(* [clear id] drop any queued audio data waiting to be sent to the hardware *)
