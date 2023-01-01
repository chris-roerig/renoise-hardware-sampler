function panel_debug_log()
  return vb:column {
    id = "panel_debug_log",
    visible = false,
    
    style = "border",
    margin = DEFAULT_MARGIN,
    width = "100%",

    vb:text {
      text = "DEBUG LOG",
      align = "center",
      width = "100%"
    },

    vb:space {
      height = UNIT/3
    },
    
    vb:horizontal_aligner {
    }
  }
end
