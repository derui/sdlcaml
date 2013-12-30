open Core.Std
open Ctypes
open Foreign
open Sdlcaml_structures

type id = int32

module Inner = struct
  let get_audio_device_name = foreign "SDL_GetAudioDeviceName" (int @-> int @-> returning string)
  let get_num_audio_devices = foreign "SDL_GetNumAudioDevices" (int @-> returning int)
  let open_audio_device = foreign "SDL_OpenAudioDevice"
    (string_opt @-> int @-> ptr Audio_spec.t @-> ptr Audio_spec.t @-> int @-> returning uint32_t)
  let close_audio_device = foreign "SDL_CloseAudioDevice" (uint32_t @-> returning void)
  let pause_audio_device = foreign "SDL_PauseAudioDevice" (uint32_t @-> int @-> returning void)
  let get_queued_audio_size = foreign "SDL_GetQueuedAudioSize" (uint32_t @-> returning uint32_t)
  let clear_queued_audio = foreign "SDL_ClearQueuedAudio" (uint32_t @-> returning void)
  let lock_audio_device = foreign "SDL_LockAudioDevice" (uint32_t @-> returning void)
  let unlock_audio_device = foreign "SDL_UnlockAudioDevice" (uint32_t @-> returning void)
  let queue_audio = foreign "SDL_QueueAudio" (uint32_t @-> ptr void @-> uint32_t @-> returning int)
end

let catch = Sdl_util.catch

let get_device_names () =
  let count = Inner.get_num_audio_devices 0 in
  List.range 0 count |> List.fold_left ~f:(fun memo index ->
    (Inner.get_audio_device_name index 0) :: memo
  ) ~init:[]

let open_device ?device ~desired ~allowed () =
  let obtained = make Audio_spec.t in
  let desired = Audio_spec.of_ocaml desired in
  let allowed = Sdlcaml_flags.Sdl_audio_allow_status.of_list allowed in
  let id = Inner.open_audio_device device 0 (addr desired) (addr obtained) allowed in
  let open Unsigned in
  catch (fun () -> UInt32.(to_int32 id) <> 0l) (fun () ->
    (UInt32.(to_int32 id), Audio_spec.to_ocaml obtained)
  )

let close_device id = Inner.close_audio_device Unsigned.UInt32.(of_int32 id)

let pause id = Inner.pause_audio_device Unsigned.UInt32.(of_int32 id) 1
let unpause id = Inner.pause_audio_device Unsigned.UInt32.(of_int32 id) 0

let get_queued_size id = Unsigned.UInt32.(
  Inner.get_queued_audio_size (of_int32 id) |> to_int32
)

let clear id = Unsigned.UInt32.(
  Inner.clear_queued_audio (of_int32 id)
)

let with_lock id ~f =
  let open Unsigned in
  Inner.lock_audio_device UInt32.(of_int32 id);
  protect ~f ~finally:(fun () -> Inner.unlock_audio_device (UInt32.of_int32 id))

let queue ~id ~data =
  let open Unsigned in
  let len = CArray.length data in
  let size_of_type = sizeof (CArray.element_type data) in
  let data = CArray.start data |> to_voidp in
  let ret = Inner.queue_audio UInt32.(of_int32 id) data (len * size_of_type |> UInt32.of_int) in
  catch (fun () -> ret <> 0) ignore
