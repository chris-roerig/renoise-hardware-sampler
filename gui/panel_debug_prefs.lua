function panel_debug_prefs()
  return vb:column {
    id = "panel_debug_prefs",
    visible = true,
    
    style = "border",
    margin = DEFAULT_MARGIN,
    width = "100%",

    vb:text {
      text = "DEBUG PREFS",
      align = "center",
      width = "100%"
    },

    vb:space {
      height = UNIT/3
    },
    
    vb:horizontal_aligner {
      debug_stat('prefs:midi_device_index', prefs:read('midi_device_index')),
      debug_stat('prefs:first_midi_program', prefs:read('first_midi_program', "NO ENTRY")),
      debug_stat('prefs:last_midi_program', prefs:read('last_midi_program')),
      debug_stat('prefs:low_octave', prefs:read('low_octave')),
      debug_stat('prefs:high_octave', prefs:read('high_octave')),
      debug_stat('prefs:num_vel_layers', prefs:read('num_vel_layers')),
      debug_stat('prefs:num_rr_layers', prefs:read('num_rr_layers')),
      debug_stat('prefs:xrni_output_path', prefs:read('xrni_output_path')),
      debug_stat('prefs:wav_output_path', prefs:read('wav_output_path')),
      debug_stat('prefs:save_wav_files', prefs:read('save_wav_files')),
      debug_stat('prefs:save_renoise_instrument', prefs:read('save_renoise_instrument'))
   }
  }
end
