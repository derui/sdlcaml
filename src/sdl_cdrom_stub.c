#include <SDL.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/custom.h>

#include "common.h"

/* Encapsulation of opaque SDL_CD (of type SDL_CD*)
   as Caml custom blocks
 */
static struct custom_operations sdl_cd_ops = {
  "sdlcaml.sdl_cd",
  custom_finalize_default,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

/* Accessing the SDL_CD * part of a Caml custom block */
#define CD_val(v) (*((SDL_CD**)Data_custom_val(v)))

/* Allocating a Caml custom block to hold the given SDL_CD *  */
static value alloc_cd(SDL_CD* chunk) {
  value v = alloc_custom(&sdl_cd_ops, sizeof(SDL_CD*), 0, 1);
  CD_val(v) = chunk;
  return v;
}

value ml_convert_cd_status_from_c(CDstatus stat) {
  CAMLparam0();

  switch (stat) {
    case CD_TRAYEMPTY: CAMLreturn(Val_int(0));
    case CD_STOPPED: CAMLreturn(Val_int(1));
    case CD_PLAYING: CAMLreturn(Val_int(2));
    case CD_PAUSED: CAMLreturn(Val_int(3));
    case CD_ERROR: CAMLreturn(Val_int(4));
  }
}

CAMLprim value sdlcaml_cd_num_drives(value unit) {
  CAMLparam1(unit);
  CAMLreturn(Val_int(SDL_CDNumDrives()));
}

CAMLprim value sdlcaml_cd_name(value drive) {
  CAMLparam1(drive);
  CAMLreturn(caml_copy_string(SDL_CDName(Int_val(drive))));
}

CAMLprim value sdlcaml_cd_open(value drive) {
  CAMLparam1(drive);
  SDL_CD *cd = SDL_CDOpen(Int_val(drive));

  if (cd == NULL) {
    CAMLreturn(Val_none);
  }

  /* when opening successful, update current CD status. */
  SDL_CDStatus(cd);
  CAMLreturn(Val_some(alloc_cd(cd)));
}

CAMLprim value sdlcaml_cd_status(value cd) {
  CAMLparam1(cd);

  CDstatus stat = SDL_CDStatus(CD_val(cd));

  CAMLreturn(ml_convert_cd_status_from_c(stat));
}

CAMLprim value sdlcaml_cd_indrive(value cd) {
  CAMLparam1(cd);

  int ret = CD_INDRIVE(CD_val(cd));
  CAMLreturn(ret == 1 ? Val_true : Val_false);
}

CAMLprim value sdlcaml_cd_play(value cd, value start, value length) {
  CAMLparam3(cd, start, length);

  if (SDL_CDPlay(CD_val(cd), Int_val(start), Int_val(length))) {
    CAMLreturn(Val_false);
  } else {
    CAMLreturn(Val_true);
  }
}

CAMLprim value sdlcaml_cd_play_tracks(value cd, value track, value frame,
                                      value ntracks, value nframes) {
  CAMLparam5(cd, track, frame, ntracks, nframes);

  if (SDL_CDPlayTracks(CD_val(cd), Int_val(track), Int_val(frame),
                       Int_val(ntracks), Int_val(nframes))) {
    CAMLreturn(Val_false);
  } else {
    CAMLreturn(Val_true);
  }
}

CAMLprim value sdlcaml_cd_pause(value cd) {
  CAMLparam1(cd);
  if (SDL_CDPause(CD_val(cd))) {
    CAMLreturn(Val_false);
  } else {
    CAMLreturn(Val_true);
  }
}

CAMLprim value sdlcaml_cd_resume(value cd) {
  CAMLparam1(cd);
  if (SDL_CDResume(CD_val(cd))) {
    CAMLreturn(Val_false);
  } else {
    CAMLreturn(Val_true);
  }
}


CAMLprim value sdlcaml_cd_stop(value cd) {
  CAMLparam1(cd);
  if (SDL_CDStop(CD_val(cd))) {
    CAMLreturn(Val_false);
  } else {
    CAMLreturn(Val_true);
  }
}

CAMLprim value sdlcaml_cd_eject(value cd) {
  CAMLparam1(cd);

  if (SDL_CDEject(CD_val(cd))) {
    CAMLreturn(Val_false);
  } else {
    CAMLreturn(Val_true);
  }
}

CAMLprim value sdlcaml_cd_close(value cd) {
  CAMLparam1(cd);

  SDL_CDClose(CD_val(cd));
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_cd_track_status(value cd) {
  CAMLparam1(cd);
  CAMLlocal2(track_list, track);
  track_list = Val_emptylist;

  SDL_CD* real = CD_val(cd);

  for (int i = real->numtracks - 1; i >= 0; --i) {
    track = caml_alloc(4, 0);
    Store_field(track, 0, Val_int(real->track[i].id));

    switch (real->track[i].type) {
      case SDL_AUDIO_TRACK: Store_field(track, 1, Val_int(0)); break;
      case SDL_DATA_TRACK: Store_field(track, 1, Val_int(1)); break;
    }
    Store_field(track, 2, Val_int(real->track[i].length));
    Store_field(track, 3, Val_int(real->track[i].offset));

    track_list = add_head(track_list, track);
  }

  CAMLreturn(track_list);
}

CAMLprim value sdlcaml_cd_get_info(value cd) {
  CAMLparam1(cd);
  CAMLlocal1(info);
  info = caml_alloc(5, 0);

  Store_field(info, 0, Val_int(CD_val(cd)->id));
  Store_field(info, 1, ml_convert_cd_status_from_c((CD_val(cd)->status)));
  Store_field(info, 2, Val_int(CD_val(cd)->numtracks));
  Store_field(info, 3, Val_int(CD_val(cd)->cur_track));
  Store_field(info, 4, Val_int(CD_val(cd)->cur_frame));

  CAMLreturn(info);
}

CAMLprim value sdlcaml_cd_frame_to_msf(value frame_from) {
  CAMLparam1(frame_from);
  CAMLlocal1(tuple);
  tuple = caml_alloc(3, 0);

  int min, sec, frame;
  FRAMES_TO_MSF(Int_val(frame_from), &min, &sec, &frame);
  Store_field(tuple, 0, Val_int(min));
  Store_field(tuple, 1, Val_int(sec));
  Store_field(tuple, 2, Val_int(frame));

  CAMLreturn(tuple);
}

CAMLprim value sdlcaml_cd_msf_to_frame(value min, value sec, value frame) {
  CAMLparam3(min, sec, frame);
  int offset = MSF_TO_FRAMES(Int_val(min), Int_val(sec), Int_val(frame));
  CAMLreturn(Val_int(offset));
}
