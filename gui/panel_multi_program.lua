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
      vb:text {
        text = "First Program",
        width = "25%"
      },
      vb:popup {
        id = "first_midi_program",
        value = prefs:read("first_midi_program", 1),
        items = range(1, 255, true),
        notifier = function(x) 
          print("MIDI Program: ", x)
          
          if x > OPTIONS.last_midi_program then
            OPTIONS.last_midi_program = x
            vb.views["last_midi_program"].value = x
            prefs:write("last_midi_program", x)
          end
          
          OPTIONS.first_midi_program = x
          prefs:write("first_midi_program", x)

          select_midi_program("1", x)
        end,
        width = "50%",
        tooltip = ""
      }
    },
    vb:horizontal_aligner {
      vb:text {
        text = "Last Program",
        width = "25%"
      },
      vb:popup {
        id = "last_midi_program",
        value = prefs:read("last_midi_program", 1),
        items = range(1, 255, true),
        notifier = function(x)
          if x < OPTIONS.first_midi_program then
            OPTIONS.first_midi_program = x
            vb.views["first_midi_program"].value = x
            prefs:write("first_midi_program", x)
          end
          
          OPTIONS.last_midi_program = x
          prefs:write("last_midi_program", x)
        end,
        width = "50%",
        tooltip = ""
      },
    },
  }
end
