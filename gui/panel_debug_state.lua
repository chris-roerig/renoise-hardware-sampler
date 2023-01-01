function panel_debug_state()
  return vb:column {
    id = "panel_debug_state",
    visible = false,
    
    style = "border",
    margin = DEFAULT_MARGIN,
    width = "100%",

    vb:text {
      text = "DEBUG STATE",
      align = "center",
      width = "100%"
    },

    vb:space {
      height = UNIT/3
    },
    
    vb:horizontal_aligner {
      debug_stat('STATE.midi_device', STATE.midi_device),
      debug_stat('STATE.dev', STATE.dev),
      debug_stat('STATE.midi_device_index', STATE.midi_device_index),
      debug_stat('STATE.recording', STATE.recording),
      debug_stat('STATE.notes', STATE.notes),
      debug_stat('STATE.notei', STATE.notei),
      debug_stat('STATE.layers', STATE.layers),
      debug_stat('STATE.layeri', STATE.layeri),
      debug_stat('STATE.rrobin', STATE.rrobin),
      debug_stat('STATE.rrobini', STATE.rrobini),
      debug_stat('STATE.total', STATE.total),
      debug_stat('STATE.inst', STATE.inst),
      debug_stat('STATE.inst_index', STATE.inst_index),
      debug_stat('STATE.program_type', STATE.program_type),
      debug_stat('STATE.current_program', STATE.current_program),
      debug_stat('STATE.status.value', STATE.status.value),   
    }
  }
end
