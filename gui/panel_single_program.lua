function panel_single_program()
  return vb:column {
    id = "panel_single_program",
    visible = true,
    
    style = "panel",
    margin = DEFAULT_MARGIN,
    width = "100%",

    vb:text {
      text = "Single Program",
      align = "center",
      width = "100%"
    },

    vb:space {
      height = UNIT/3
    },
    
    vb:horizontal_aligner {
      margin = DEFAULT_MARGIN,

      vb:text {
        text = "MIDI Program",
        width = "25%"
      },
      vb:valuebox {
        min = 1,
        max = 128,
        id = "single_midi_program",
        value = prefs:read("single_midi_program", 1),
        notifier = function(x)    
          MSTATE.current_program = x
          prefs:write("single_midi_program", x)
          
          select_program(x - 1)

          if prefs:read('auto_preview_enabled', false) == true then
            preview_note()
          end
        end,
      },
      vb:button {
        text = "Preview",
        id = "preview_program_button",
        notifier = function()
          preview_note()
        end
      },
      vb:checkbox {
        id = 'auto_preview_enabled',
        value = prefs:read('auto_preview_enabled', false),
        notifier = function(x)
          prefs:write('auto_preview_enabled', x)
        end
      },
      vb:text {
        text = "Auto Preview",
      },      
    },
    
    vb:horizontal_aligner {
      margin = DEFAULT_MARGIN,

      vb:text {
        text = "Instrument name ",
        width = "25%"
      },
      
      vb:textfield {
        id = "instrument_name_textfield",
        value = OPTIONS.name,
        notifier = update_instrument_name,
        width = "50%",
        tooltip = "Instrument name to set when sampling is over."
      },
      
      vb:button {
        text = "Auto-Name",
        notifier = function(e)
          autoname()
        end,
        width = "25%",
        tooltip = "Generate a random instrument name"
      }
    },
    
    vb:horizontal_aligner {
      margin = DEFAULT_MARGIN,
      
      vb:text {
        text = "Hardware name ",
        width = "25%"
      },
      vb:textfield {
        id = "hardware_name_textfield",
        value = OPTIONS.hardware_name,
        notifier = update_instrument_name,
        width = "50%",
        tooltip = "Append the hardware device's name to further identify."
      }
    },
    
    vb:horizontal_aligner {
      margin = DEFAULT_MARGIN,
      id ="name_tags_text",
      
      vb:text {
        text = "Tags:",
        width = "25%"
      }
    },
    
    -- produces the tag buttons
    tag_matrix()
  }
end

function note_matrix()
  local tooltip = "Select notes that will be sampled in each octave."

  return button_matrix(NOTES, "notes", OPTIONS.notes, tooltip)
end

function tag_matrix()
  local tooltip = "Select tags to include in instrument name"
  local callback = function () update_instrument_name() end
  
  return button_matrix(TAGS, "tags", OPTIONS.tags, tooltip, callback)
end

