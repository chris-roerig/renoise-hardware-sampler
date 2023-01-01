function panel_debug_other()
  return vb:column {
    id = "panel_debug_other",
    visible = false,
    
    style = "border",
    margin = DEFAULT_MARGIN,
    width = "100%",

    vb:text {
      text = "DEBUG OTHER",
      align = "center",
      width = "100%"
    },

    vb:space {
      height = UNIT/3
    },
    
    vb:horizontal_aligner {
      debug_stat("TOOL_VERSION", TOOL_VERSION),    
    }
  }
end
