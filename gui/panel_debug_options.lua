function panel_debug_options()
  return vb:column {
    id = "panel_debug_options",
    visible = false,
    
    style = "border",
    margin = DEFAULT_MARGIN,
    width = "100%",

    vb:text {
      text = "DEBUG OPTIONS",
      align = "center",
      width = "100%"
    },

    vb:space {
      height = UNIT/3
    },
    
    vb:horizontal_aligner {
      debug_stat('OPTIONS.low', OPTIONS.low),
      debug_stat('OPTIONS.high', OPTIONS.high),
      debug_stat('OPTIONS.length', OPTIONS.length),
      debug_stat('OPTIONS.release', OPTIONS.release),
      debug_stat('OPTIONS.tags', OPTIONS.tags),
      debug_stat('OPTIONS.notes', OPTIONS.notes),
      debug_stat('OPTIONS.name', OPTIONS.name),
      debug_stat('OPTIONS.hardware_name', OPTIONS.hardware_namehardware_name),
      debug_stat('OPTIONS.background', OPTIONS.background),
      debug_stat('OPTIONS.post_record_normalize_and_trim', OPTIONS.post_record_normalize_and_trim),
      debug_stat('OPTIONS.mapping', OPTIONS.mapping),
      debug_stat('OPTIONS.layers', OPTIONS.layerslayers),
      debug_stat('OPTIONS.rrobin', OPTIONS.rrobin),
      debug_stat('OPTIONS.between_time', OPTIONS.between_time),
      debug_stat('OPTIONS.create_x_fade_loop', OPTIONS.create_x_fade_loop),
      debug_stat('OPTIONS.multi_program', OPTIONS.multi_program),
      debug_stat('OPTIONS.first_midi_program', OPTIONS.first_midi_program),
      debug_stat('OPTIONS.last_midi_program', OPTIONS.last_midi_program),    
      debug_stat('OPTIONS.visible_pannel', OPTIONS.visible_panel),  
      debug_stat('OPTIONS.visible_debug_pannel', OPTIONS.visible_debug_panel),  
    }
  }
end
