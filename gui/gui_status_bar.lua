function gui_status_bar()
  return vb:column {
    id = "gui_status_bar",
    visible = true,
    style = "panel",
    margin = DEFAULT_MARGIN,
    width = "100%",
    
    -- octave options
    --[[
    vb:horizontal_aligner {
      mode = "center",
      spacing = DEFAULT_MARGIN,
      vb:text {
        id = "gui_main_status",
        text = "Welcome...",
        width = "100%"
      },
    },
    ]]
    vb:horizontal_aligner {
      spacing = UNIT,
      margin = DEFAULT_MARGIN,

      vb:row {
        spacing = UNIT,
        style = "group",
        width = "100%",
        vb:text {
          text = "Waiting",
          width = "90%",
          id = "processing_status_text"
        }
      }
    },
  }
end

function wstatus(message)
  vb.views['gui_main_status'].text = message
end
