function panel_multi_program()
  return vb:column {
    id = "panel_multi_program",
    visible = false,
    
    style = "panel",
    margin = DEFAULT_MARGIN,
    width = "100%",

    vb:text {
      text = "Multi Program",
      align = "center",
      width = "100%"
    },

    vb:space {
      height = UNIT/3
    },
    
    vb:horizontal_aligner {
      margin = DEFAULT_MARGIN,
      
      vb:text {
        text = "Hardware name ",
        width = "25%"
      },
      vb:textfield {
        id = "hardware_name_textfield_multi",
        value = OPTIONS.hardware_name,
        notifier = update_instrument_name,
        width = "50%",
        tooltip = "Append the hardware device's name to further identify."
      }
    },    
    vb:horizontal_aligner {
      margin = DEFAULT_MARGIN,
      
      vb:text {
        text = "Instrument name ",
        width = "25%"
      },

      vb:textfield {
        id = "instrument_name_textfield_multi",
        value = OPTIONS.instrument_name,
        notifier = update_instrument_name,
        width = "35%",
        tooltip = "Append the hardware device's name to further identify."
      },
      vb:checkbox {
        id = 'instrument_name_num_prefix',
        value = true
      },
      vb:text {
        text = "Prefix",
        tooltip = "When checked, the instrument name will be prefixed with the program number"
      },
    }, 
    
    vb:horizontal_aligner {
      margin = DEFAULT_MARGIN,
      
    },   
         
    vb:horizontal_aligner {
      margin = DEFAULT_MARGIN,
      vb:text {
        text = "First Program",
        width = "25%"
      },
      vb:popup {
        id = "first_midi_program",
        value = prefs:read("first_midi_program", 1),
        items = range(1, 128, true),
        notifier = function(x)
          print("MIDI Program: ", x)
         
          if x > MSTATE.end_program then
            MSTATE.end_program = x
            vb.views["last_midi_program"].value = x
            prefs:write("last_midi_program", x)
          end
          
          MSTATE.current_program = x
          prefs:write("first_midi_program", x)

          select_program(x - 1)
        end,
        width = "50%",
        tooltip = ""
      }
    },
    vb:horizontal_aligner {
      margin = DEFAULT_MARGIN,
      vb:text {
        text = "Last Program",
        width = "25%"
      },
      vb:popup {
        id = "last_midi_program",
        value = prefs:read("last_midi_program", 1),
        items = range(1, 128, true),
        notifier = function(x)
          if x < MSTATE.start_program then
            MSTATE.end_program= x
            vb.views["first_midi_program"].value = x
            prefs:write("first_midi_program", x)
          end
          
          MSTATE.end_program = x
          prefs:write("last_midi_program", x)
        end,
        width = "50%",
        tooltip = ""
      },
    },    
  }
end
