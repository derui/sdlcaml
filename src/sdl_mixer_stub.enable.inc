/* Encapsulation of opaque SDL_mixer Chunk (of type Mix_Chunk *)
   as Caml custom blocks
 */
static struct custom_operations mix_chunk_ops = {
  "sdlcaml.mix_chunk",
  custom_finalize_default,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

/* Accessing the Mix_Chunk * part of a Caml custom block */
#define Chunk_val(v) (*((Mix_Chunk**)Data_custom_val(v)))

/* Allocating a Caml custom block to hold the given Mix_Chunk *  */
static value alloc_chunk(Mix_Chunk* chunk) {
  value v = alloc_custom(&mix_chunk_ops, sizeof(Mix_Chunk*), 0, 1);
  Chunk_val(v) = chunk;
  return v;
}

/* Encapsulation of opaque SDL_mixer Music (of type Mix_Music *)
   as Caml custom blocks
 */
static struct custom_operations mix_music_ops = {
  "sdlcaml.mix_music",
  custom_finalize_default,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

/* Accessing the Mix_Music * part of a Caml custom block */
#define Music_val(v) (*((Mix_Music**)Data_custom_val(v)))

/* Allocating a Caml custom block to hold the given Mix_Music *  */
static value alloc_music(Mix_Music* music) {
  value v = alloc_custom(&mix_music_ops, sizeof(Mix_Music*), 0, 1);
  Music_val(v) = music;
  return v;
}

int ml_mixer_tag_to_flag(value tag) {
  CAMLparam1(tag);
  CAMLreturnT(int, ml_lookup_to_c(ml_mixer_flag_table, tag));
}

static int ml_make_mixer_flag(value flags) {
  CAMLparam1(flags);
  value list = flags;
  int flag = 0;

  while (is_not_nil(list)) {
    int converted_tag = ml_mixer_tag_to_flag(head(list));
    flag |= converted_tag;
    list = tail(list);
  }
  CAMLreturnT(int, flag);
}

value ml_convert_audio_format_from_c(Uint16 format) {
  CAMLparam0();
  CAMLlocal1(result_format);
  result_format = Val_int(0);

  switch (format) {
    case AUDIO_U8: result_format = Val_int(0); break;
    case AUDIO_S8: result_format = Val_int(1); break;
    case AUDIO_U16LSB: result_format = Val_int(2); break;
    case AUDIO_S16LSB: result_format = Val_int(3); break;
    case AUDIO_U16MSB: result_format = Val_int(4); break;
    case AUDIO_S16MSB: result_format = Val_int(5); break;
  }
  CAMLreturn(result_format);
}

Uint16 ml_convert_audio_format_to_c(value format) {
  CAMLparam1(format);

  switch (Int_val(format)) {
    case 0: CAMLreturnT(Uint16, AUDIO_U8);
    case 1: CAMLreturnT(Uint16, AUDIO_S8);
    case 2: CAMLreturnT(Uint16, AUDIO_U16LSB);
    case 3: CAMLreturnT(Uint16, AUDIO_S16LSB);
    case 4: CAMLreturnT(Uint16, AUDIO_U16MSB);
    case 5: CAMLreturnT(Uint16, AUDIO_S16MSB);
  }
}

/* binding implements */

CAMLprim value sdlcaml_mixer_compile_version(value unit) {
  CAMLparam1(unit);
  CAMLlocal1(tuple);
  tuple = caml_alloc(3, 0);

  SDL_version version;
  SDL_MIXER_VERSION(&version);

  Store_field(tuple, 0, version.major);
  Store_field(tuple, 1, version.minor);
  Store_field(tuple, 2, version.patch);

  CAMLreturn(tuple);
}

CAMLprim value sdlcaml_mixer_linked_version(value unit) {
  CAMLparam1(unit);
  CAMLlocal1(tuple);
  tuple = caml_alloc(3, 0);

  const SDL_version* version = Mix_Linked_Version();

  Store_field(tuple, 0, version->major);
  Store_field(tuple, 1, version->minor);
  Store_field(tuple, 2, version->patch);

  CAMLreturn(tuple);
}

CAMLprim value sdlcaml_mixer_init(value mixerinit) {
  CAMLparam1(mixerinit);
  CAMLlocal1(result);
  result = Val_emptylist;

  int init_flag_list[] = {
    MIX_INIT_FLAC,
    MIX_INIT_MOD,
    MIX_INIT_MP3,
    MIX_INIT_OGG
  };

  int flag = ml_make_mixer_flag(mixerinit);

  int initialized = Mix_Init(flag);

  for (int i = 0; i < sizeof(init_flag_list) / sizeof(int); ++i) {
    if (initialized & init_flag_list[i]) {
      result = add_head(result, ml_lookup_to_c(ml_mixer_flag_table,
                                               init_flag_list[i]));
    }
  }

  CAMLreturn(result);
}

CAMLprim value sdlcaml_mixer_quit(value unit) {
  CAMLparam1(unit);
  Mix_Quit();
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_open_audio(value freq, value format, value channels,
                                        value chunk) {
  CAMLparam4(freq, format, channels, chunk);
  CAMLlocal1(result);

  int format_of_c = ml_convert_audio_format_to_c(format);

  if (Mix_OpenAudio(Int_val(freq), format_of_c, Int_val(channels), Int_val(chunk)) == -1) {
    result = caml_alloc(1, 0);
    Store_field(result, 0, caml_copy_string(Mix_GetError()));
    CAMLreturn(result);
  }

  result = caml_alloc(1, 1);
  Store_field(result, 0, Val_unit);
  CAMLreturn(result);
}

CAMLprim value sdlcaml_mixer_close_audio(value unit) {
  CAMLparam1(unit);
  Mix_CloseAudio();
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_query_spec(value unit) {
  CAMLparam1(unit);
  CAMLlocal1(tuple);
  tuple = caml_alloc(3, 0);

  int num_times_opened, frequency, channels;
  Uint16 format;
  num_times_opened = Mix_QuerySpec(&frequency, &format,&channels);

  if (!num_times_opened) {
    CAMLreturn(Val_none);
  } else {
    Store_field(tuple, 0, Val_int(frequency));
    Store_field(tuple, 1, ml_convert_audio_format_from_c(format));
    Store_field(tuple, 2, Val_int(channels));
    CAMLreturn(Val_some(tuple));
  }
}

CAMLprim value sdlcaml_mixer_get_num_chunk_decoders(value unit) {
  CAMLparam1(unit);

  CAMLreturn(Val_int(Mix_GetNumChunkDecoders()));
}


CAMLprim value sdlcaml_mixer_get_chunk_decoder(value chunk) {
  CAMLparam1(chunk);
  CAMLlocal1(name);

  if (Int_val(chunk) >= Mix_GetNumChunkDecoders()) {
    name = caml_copy_string("");
  } else {
    const char* chunk_name = Mix_GetChunkDecoder(Int_val(chunk));
    name = caml_copy_string(chunk_name);
  }

  CAMLreturn(name);
}

CAMLprim value sdlcaml_mixer_load_wav(value file) {
  CAMLparam1(file);
  CAMLlocal1(ret_chunk);

  Mix_Chunk* sample = Mix_LoadWAV(String_val(file));
  if (sample == NULL) {
    CAMLreturn(Val_left(caml_copy_string(Mix_GetError())));
  }

  ret_chunk = alloc_chunk(sample);
  CAMLreturn(Val_right(ret_chunk));
}

CAMLprim value sdlcaml_mixer_volume_chunk(value chunk, value volume) {
  CAMLparam1(chunk);

  int previous = Mix_VolumeChunk(Chunk_val(chunk), Int_val(volume));

  CAMLreturn(Val_int(previous));
}

CAMLprim value sdlcaml_mixer_free_chunk(value chunk) {
  CAMLparam1(chunk);

  Mix_FreeChunk(Chunk_val(chunk));

  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_allocate_channels(value numchans) {
  CAMLparam1(numchans);
  CAMLreturn(Val_int(Mix_AllocateChannels(Int_val(numchans))));
}

CAMLprim value sdlcaml_mixer_volume(value channel, value volume) {
  CAMLparam2(channel, volume);

  int channel_raw = 0;
  switch (channel) {
    case MLTAG_All: channel_raw = -1; break;
    default: channel_raw = Int_val(Field(channel, 1)); break;
  }

  int vol = Mix_Volume(channel_raw, Int_val(volume));
  CAMLreturn(Val_int(vol));
}

CAMLprim value sdlcaml_mixer_play_channel(value channel, value chunk, value loops, value tick, value unit) {
  CAMLparam5(channel, chunk, loops, tick, unit);

  int channel_raw = 0;

  switch (channel) {
    case MLTAG_Unreserved: channel_raw = -1; break;
    default: channel_raw = Int_val(Field(channel, 1)); break;
  }

  int ticks = -1;
  if (is_some(tick)) {
    ticks = Int_val(Field(tick, 0));
  }

  int samples = Mix_PlayChannelTimed(channel_raw, Chunk_val(chunk), Int_val(loops), ticks);

  if (samples == -1) {
    CAMLreturn(Val_left(caml_copy_string(Mix_GetError())));
  }

  CAMLreturn(Val_right(Val_int(samples)));
}

CAMLprim value sdlcaml_mixer_fadein_channel_native(value channel, value chunk, value loops,
                                            value fade, value tick, value unit) {
  CAMLparam5(channel, chunk, loops, fade, tick);
  CAMLxparam1(unit);

  int channel_raw = 0;
  switch (channel) {
    case MLTAG_Unreserved: channel_raw = -1; break;
    default: channel_raw = Int_val(Field(channel, 1)); break;
  }

  int ticks = -1;
  if (is_some(tick)) {
    ticks = Int_val(Field(0, tick));
  }

  int samples = Mix_FadeInChannelTimed(channel_raw, Chunk_val(chunk), Int_val(loops),
                                       Int_val(fade), ticks);
  if (samples == -1) {
    CAMLreturn(Val_left(caml_copy_string(Mix_GetError())));
  }

  CAMLreturn(Val_right(Val_int(samples)));
}

CAMLprim value sdlcaml_mixer_fadein_channel_bytecode(value *argv, int argn) {
  return sdlcaml_mixer_fadein_channel_native(argv[0], argv[1], argv[2],
                                             argv[3], argv[4], argv[5]);
}

CAMLprim value sdlcaml_mixer_pause(value channel) {
  CAMLparam1(channel);

  int channel_raw = 0;
  switch (channel) {
    case MLTAG_All: channel_raw = -1; break;
    default: channel_raw = Int_val(Field(channel, 1));
  }

  Mix_Pause(channel_raw);
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_resume(value channel) {
  CAMLparam1(channel);

  int channel_raw = 0;
  switch (channel) {
    case MLTAG_All: channel_raw = -1; break;
    default: channel_raw = Int_val(Field(channel, 1));
  }

  Mix_Resume(channel_raw);
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_halt_channel(value channel) {
  CAMLparam1(channel);

  int channel_raw = 0;
  switch (channel) {
    case MLTAG_All: channel_raw = -1; break;
    default: channel_raw = Int_val(Field(channel, 1));
  }

  Mix_HaltChannel(channel_raw);
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_expire_channel(value channel, value fade) {
  CAMLparam2(channel, fade);

  int channel_raw = 0;
  switch (channel) {
    case MLTAG_All: channel_raw = -1; break;
    default: channel_raw = Int_val(Field(channel, 1));
  }

  CAMLreturn(Val_int(Mix_ExpireChannel(channel_raw, Int_val(fade))));
}

CAMLprim value sdlcaml_mixer_fadeout_channel(value channel, value fade) {
  CAMLparam2(channel, fade);

  int channel_raw = 0;
  switch (channel) {
    case MLTAG_All: channel_raw = -1; break;
    default: channel_raw = Int_val(Field(channel, 1));
  }

  CAMLreturn(Val_int(Mix_FadeOutChannel(channel_raw, Int_val(fade))));
}

CAMLprim value sdlcaml_mixer_playing(value channel) {
  CAMLparam1(channel);

  int channel_raw = Int_val(Field(channel, 1));

  int playing = Mix_Playing(channel_raw);
  CAMLreturn( playing == 1 ? Val_true : Val_false);
}

CAMLprim value sdlcaml_mixer_paused(value channel) {
  CAMLparam1(channel);

  int channel_raw = Int_val(Field(channel, 1));

  int paused = Mix_Paused(channel_raw);

  CAMLreturn( paused == 1 ? Val_true : Val_false);
}

CAMLprim value sdlcaml_mixer_fading_channel(value channel) {
  CAMLparam1(channel);

  int channel_raw = Int_val(Field(channel, 1));

  if (Mix_Playing(channel_raw) || Mix_Paused(channel_raw)) {
    CAMLreturn(Val_none);
  }

  switch (Mix_FadingChannel(channel_raw)) {
    case MIX_NO_FADING:
      CAMLreturn(Val_some(Val_int(0)));
    case MIX_FADING_OUT:
      CAMLreturn(Val_some(Val_int(1)));
    case MIX_FADING_IN:
      CAMLreturn(Val_some(Val_int(2)));
  }
}

CAMLprim value sdlcaml_mixer_get_chunk(value channel) {
  CAMLparam1(channel);

  int channel_raw = Int_val(Field(channel, 1));

  Mix_Chunk* chunk = Mix_GetChunk(channel_raw);
  if (chunk == NULL) {
    CAMLreturn(Val_none);
  } else {
    CAMLreturn(Val_some(alloc_chunk(chunk)));
  }
}

CAMLprim value sdlcaml_mixer_reserve_channels(value numchuns) {
  CAMLparam1(numchuns);

  CAMLreturn(Val_int(Mix_ReserveChannels(Int_val(numchuns))));
}

CAMLprim value sdlcaml_mixer_group_channel(value which, value tag) {
  CAMLparam2(which, tag);

  int channel_raw = Int_val(Field(which, 1));
  if (Mix_GroupChannel(channel_raw, Int_val(tag))) {
    CAMLreturn(Val_true);
  } else {
    CAMLreturn(Val_false);
  }
}

CAMLprim value sdlcaml_mixer_group_channels(value from_to, value tag) {
  CAMLparam2(from_to, tag);
  int channel_raw_from = Int_val(Field(Field(from_to, 0), 1));
  int channel_raw_to = Int_val(Field(Field(from_to, 1), 1));

  CAMLreturn(Val_int(Mix_GroupChannels(channel_raw_from, channel_raw_to,
                                       Int_val(tag))));
}

CAMLprim value sdlcaml_mixer_group_count(value tag) {
  CAMLparam1(tag);

  CAMLreturn(Val_int(Mix_GroupCount(Int_val(tag))));
}

CAMLprim value sdlcaml_mixer_group_available(value group) {
  CAMLparam1(group);

  int channel = Mix_GroupAvailable(group);
  if (channel == -1) {
    CAMLreturn(Val_none);
  } else {
    CAMLlocal1(chun);
    chun = caml_alloc(2, 0);
    Store_field(chun, 0, MLTAG_Channel);
    Store_field(chun, 1, Val_int(channel));
    CAMLreturn(Val_some(Val_int(chun)));
  }
}

CAMLprim value sdlcaml_mixer_group_oldest(value group) {
  CAMLparam1(group);
  int channel = Mix_GroupOldest(group);
  if (channel == -1) {
    CAMLreturn(Val_none);
  } else {
    CAMLlocal1(chun);
    chun = caml_alloc(2, 0);
    Store_field(chun, 0, MLTAG_Channel);
    Store_field(chun, 1, Val_int(channel));
    CAMLreturn(Val_some(Val_int(chun)));
  }
}

CAMLprim value sdlcaml_mixer_group_newer(value group) {
  CAMLparam1(group);
  int channel = Mix_GroupNewer(group);
  if (channel == -1) {
    CAMLreturn(Val_none);
  } else {
    CAMLlocal1(chun);
    chun = caml_alloc(2, 0);
    Store_field(chun, 0, MLTAG_Channel);
    Store_field(chun, 1, Val_int(channel));
    CAMLreturn(Val_some(Val_int(chun)));
  }
}

CAMLprim value sdlcaml_mixer_fadeout_group(value group, value fade) {
  CAMLparam2(group, fade);

  CAMLreturn(Val_int(Mix_FadeOutGroup(Int_val(group), Int_val(fade))));
}

CAMLprim value sdlcaml_mixer_halt_group(value group) {
  CAMLparam1(group);

  Mix_HaltGroup(Int_val(group));
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_get_num_music_decoders(value unit) {
  CAMLparam1(unit);

  CAMLreturn(Val_int(Mix_GetNumMusicDecoders()));
}

CAMLprim value sdlcaml_mixer_get_music_decoder(value index) {
  CAMLparam1(index);

  CAMLreturn(caml_copy_string(
      Mix_GetMusicDecoder(Int_val(index))));
}

CAMLprim value sdlcaml_mixer_load_mus(value file) {
  CAMLparam1(file);

  Mix_Music *music = Mix_LoadMUS(String_val(file));
  if (music == NULL) {
    CAMLreturn(Val_left(caml_copy_string(Mix_GetError())));
  } else {
    CAMLreturn(Val_right(alloc_music(music)));
  }
}

CAMLprim value sdlcaml_mixer_free_music(value music) {
  CAMLparam1(music);

  Mix_FreeMusic(Music_val(music));
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_play_music(value music, value loops) {
  CAMLparam2(music, loops);

  if (Mix_PlayMusic(Music_val(music), Int_val(loops)) == -1) {
    CAMLreturn(Val_left(caml_copy_string(Mix_GetError())));
  }

  CAMLreturn(Val_right(Val_none));
}

CAMLprim value sdlcaml_mixer_fadein_music(value music, value loops,
                                          value ms, value pos) {
  CAMLparam4(music, loops, ms, pos);

  double raw_pos = 0.0;
  if (is_some(pos)) {
    raw_pos = Double_val(pos);
  }

  if (Mix_FadeInMusicPos(Music_val(music), Int_val(loops),
                         Int_val(ms), raw_pos) == -1) {
    CAMLreturn(Val_left(caml_copy_string(Mix_GetError())));
  }

  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_volume_music(value volume) {
  CAMLparam1(volume);

  CAMLreturn(Val_int(Mix_VolumeMusic(Int_val(volume))));
}

CAMLprim value sdlcaml_mixer_pause_music(value unit) {
  CAMLparam1(unit);

  Mix_PauseMusic();
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_resume_music(value unit) {
  CAMLparam1(unit);
  Mix_ResumeMusic();
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_rewind_music(value unit) {
  CAMLparam1(unit);
  Mix_RewindMusic();
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_set_music_position(value pos) {
  CAMLparam1(pos);

  if (Mix_SetMusicPosition(Double_val(pos)) == -1) {
    CAMLreturn(Val_left(caml_copy_string(Mix_GetError())));
  }
  CAMLreturn(Val_right(Val_unit));
}

CAMLprim value sdlcaml_mixer_halt_music(value unit) {
  CAMLparam1(unit);
  Mix_HaltMusic();
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_mixer_fadeout_music(value ms) {
  CAMLparam1(ms);

  int result = Mix_FadeOutMusic(Int_val(ms));
  CAMLreturn(result == 1 ? Val_true : Val_false);
}

CAMLprim value sdlcaml_mixer_get_music_type(value music) {
  CAMLparam1(music);

  switch (Mix_GetMusicType(Music_val(music))) {
    case MUS_NONE: CAMLreturn(Val_int(0));
    case MUS_CMD: CAMLreturn(Val_int(1));
    case MUS_WAV: CAMLreturn(Val_int(2));
    case MUS_MOD: CAMLreturn(Val_int(3));
    case MUS_MID: CAMLreturn(Val_int(4));
    case MUS_OGG: CAMLreturn(Val_int(5));
    case MUS_MP3: CAMLreturn(Val_int(6));
    case MUS_MP3_MAD: CAMLreturn(Val_int(7));
    case MUS_FLAC: CAMLreturn(Val_int(8));
  }
}

CAMLprim value sdlcaml_mixer_playing_music(value unit) {
  CAMLparam1(unit);

  CAMLreturn(Mix_PlayingMusic() ? Val_true : Val_false);
}

CAMLprim value sdlcaml_mixer_paused_music(value unit) {
  CAMLparam1(unit);
  CAMLreturn(Mix_PausedMusic() ? Val_true : Val_false);
}

CAMLprim value sdlcaml_mixer_fading_music(value unit) {
  CAMLparam1(unit);

  switch (Mix_FadingMusic()) {
    case MIX_NO_FADING:
      CAMLreturn(Val_some(Val_int(0)));
    case MIX_FADING_OUT:
      CAMLreturn(Val_some(Val_int(1)));
    case MIX_FADING_IN:
      CAMLreturn(Val_some(Val_int(2)));
  }

}

CAMLprim value sdlcaml_mixer_set_panning(value channel, value left, value right) {
  CAMLparam3(channel, left, right);

  int channel_raw = Int_val(Field(channel, 1));

  if (!Mix_SetPanning(channel_raw, Int_val(left), Int_val(right))) {
    CAMLreturn(Val_left(caml_copy_string(Mix_GetError())));
  }

  CAMLreturn(Val_right(Val_unit));
}

CAMLprim value sdlcaml_mixer_set_distance(value channel, value dist) {
  CAMLparam2(channel, dist);

  int channel_raw = Int_val(Field(channel, 1));

  if (!Mix_SetDistance(channel_raw, Int_val(dist))) {
    CAMLreturn(Val_left(caml_copy_string(Mix_GetError())));
  }

  CAMLreturn(Val_right(Val_unit));
}

CAMLprim value sdlcaml_mixer_set_position(value channel, value angle, value dist) {
  CAMLparam3(channel, angle, dist);

  int channel_raw = Int_val(Field(channel, 1));

  if (!Mix_SetPosition(channel_raw, Int_val(angle), Int_val(dist))) {
    CAMLreturn(Val_left(caml_copy_string(Mix_GetError())));
  }

  CAMLreturn(Val_right(Val_unit));
}

CAMLprim value sdlcaml_mixer_unregister_all_effects(value channel) {
  CAMLparam1(channel);

  int channel_raw = Int_val(Field(channel, 1));

  if (!Mix_UnregisterAllEffects(channel_raw)) {
    CAMLreturn(Val_left(caml_copy_string(Mix_GetError())));
  }

  CAMLreturn(Val_right(Val_unit));
}
