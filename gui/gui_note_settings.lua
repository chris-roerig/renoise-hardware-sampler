function gui_note_settings()
    return vb:column {
      id = "gui_note_settings",
      visible = true,
      style = "panel",
      margin = DEFAULT_MARGIN,
      
      vb:text {
        text = "Note Settings",
        align = "center",
        width = "100%"
      },
      vb:space {
        height = UNIT/3
      },
      
      -- octave options
      vb:horizontal_aligner {
        mode = "center",
        spacing = DEFAULT_MARGIN,
  
        value_box("Low Octave", "The lowest octave from which to sample.", 
                  prefs:read("low_octave", 1), 0, 9, {1, 2}, 
                  function(x)
                    OPTIONS.low = x
                    update_total_sample_time_display()
                    prefs:write("low_octave", x)
                  end, 
                  tostring, math.floor),
        value_box("High Octave", "The highest octave from which to sample.", 
                  prefs:read("high_octave", 6), 0, 9, {1, 2}, 
                  function(x) 
                    OPTIONS.high = x 
                    update_total_sample_time_display()
                    prefs:write("high_octave", x)
                  end, 
                  tostring, math.floor),
        value_box("Vel. Layers", "How many different equally spaced velocities to sample for a given note.", 
                  prefs:read("num_vel_layers", 1), 1, 32, {1, 2}, 
                  function(x) 
                    OPTIONS.layers = x 
                    update_total_sample_time_display()
                    prefs:write("num_vel_layers", x)
                  end,
                  tostring, math.floor),
        value_box("R.R. Layers", "For each mapping, record this many samples and apply round robin selection to them.", 
                  prefs:read("num_rr_layers", 1), 1, 32, {1, 2}, 
                  function(x) 
                    OPTIONS.rrobin = x 
                    update_total_sample_time_display()
                    prefs:write("num_rr_layers", x)
                  end, 
                  tostring, math.floor)
      },
      
      -- notes selection
      note_matrix(),
      
      -- mapping style
      vb:horizontal_aligner {
        margin = DEFAULT_MARGIN,
        spacing = DEFAULT_MARGIN,
        
        vb:text {
          text = "Mapping style:"
        },
        vb:switch {
          width = "80%",
          items = {"Down", "Middle", "Up"},
          value = OPTIONS.mapping,
          notifier = function(x) OPTIONS.mapping = x end,
          tooltip = "How samples are mapped to keys.\n"..
          "\nDown: Sampled notes will be mapped to their root note and to notes between the root and the next lowest sample.\n"..
          "\nMiddle: Given a key, it will be mapped to the closest existing sample.\n"..
          "\nUp: Sampled notes will be mapped to their root note and to notes between the root and the next highest sample."
        }
      },
      
      -- sample length
      vb:horizontal_aligner {
        mode = "center",
        spacing = DEFAULT_MARGIN,
  
        value_box("Hold time", "How long the note on signal will be held.", 
          prefs:read('length', 1), 0.1, 60, {0.1, 1}, 
          function(x)
            OPTIONS.length = x
            prefs:write('length',x)
            update_total_sample_time_display()
          end, 
          function(x)
            return tostring(x).." s."
          end, 
          tonumber),
        value_box("Release time", "How long the tool will wait for the note to release after note off.",
          OPTIONS.release, 0.1, 60, {0.1, 1}, 
          function (x)
            OPTIONS.release = x
            update_total_sample_time_display()
          end,
          function(x) 
            return tostring(x).." s."
          end, 
          tonumber),
        value_box("Between time", "Time between the end of each sample recording and the start of the next one. Increase this if you find that not every sample gets stored into its slot in time because Renoise is still processing the recorded sample when the next sample recording starts.", 
          OPTIONS.between_time, 10, 1000, {10, 100}, 
          function (x)
            OPTIONS.between_time = x
            update_total_sample_time_display()
          end,
          function(x)
            return tostring(x).." ms."
          end, 
          tonumber)
      },
      
      vb:horizontal_aligner {
        mode = "center",
        spacing = DEFAULT_MARGIN,
        vb:text {
          id = "total_sample_time",
          text = "Hello"
        }
      }
    }
end

function update_total_sample_time_display()
  local total = 0
  local low = OPTIONS.low
  local high = OPTIONS.high
  local layers = OPTIONS.layers
  local robin = OPTIONS.robin
  local length =  OPTIONS.length
  local release = OPTIONS.release
  local between = OPTIONS.between_time
  
  -- the total number of notes set to true
  local on_notes = 0
  for i, v in ipairs(OPTIONS.notes) do
    if v == true then
      on_notes = on_notes + 1
    end
  end
  
  local single_octave = 0
  
  -- for a single octave
  single_octave = ((length + release) * on_notes)
  
  if high == low then
    total = single_octave
  else
    total = (high - low) * single_octave
  end
  
  if total > 60 then
    total = "~" .. tostring(total / 60) .. " minutes"
  else
    total = tostring(total) .. " seconds"
  end
  
  
  vb.views['total_sample_time'].text = total
end
