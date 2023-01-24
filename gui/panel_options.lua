function panel_options()    
    -- OPTIONS  PANEL
    return vb:column {
      id = "panel_options",
      visible = false,
      
      style = "panel",
      margin = DEFAULT_MARGIN,
      width = "100%",

      vb:text {
        text = "Options",
        align = "center",
        width = "100%"
      },

      vb:space {
        height = UNIT/3
      },
      --

      -- midi device selection
      midi_list(),

      --
      vb:horizontal_aligner {
        spacing = UNIT/3,
        margin = DEFAULT_MARGIN,

        vb:checkbox {
          id = "option_save_wav_files",
          value = prefs:read("save_wav_files", true),
          notifier = function(x)
            prefs:write("save_wav_files", x)
          end        
        },
        vb:text {
          text = "Save WAV files",
          width = "25%"
        },
        vb:textfield {
          id = "wav_output_path",
          value = prefs:read("wav_output_path", ""),
          width = "50%",
          tooltip = ""
        },
        vb:button {
          text = "...",
          notifier = function()
            local wav_path = renoise.app():prompt_for_path("Root folder path...")
            vb.views["wav_output_path"].text = wav_path
            prefs:write("wav_output_path", wav_path)
          end
        }
      },
      --
      vb:horizontal_aligner {
        spacing = UNIT/3,
        margin = DEFAULT_MARGIN,
       
        vb:checkbox {
          id = "option_save_renoise_instrument",
          value = prefs:read("save_renoise_instrument", false),
          notifier = function(x)
            prefs:write("save_renoise_instrument", x)
          end
        },
       
        vb:text {
          text = "Save Renoise Instrument",
          width = "25%"
        },
        
        vb:textfield {
          id = "xrni_output_path",
          width = "50%",
          value = prefs:read("xrni_output_path", ""),
          tooltip = ""
        },
        vb:button {
          text = "...",
          notifier = function()
            local xrni_path = renoise.app():prompt_for_path("Save xrni file in...")
            vb.views["xrni_output_path"].text = xrni_path
            prefs:write("xrni_output_path", xrni_path)
          end
        }
      },
      --
      vb:horizontal_aligner {
        spacing = UNIT,
        margin = DEFAULT_MARGIN,

        vb:row {
          spacing = UNIT/3,
  
          vb:checkbox {
            value = prefs:read('post_record_normalize_and_trim', false),
            notifier = function(x) 
              prefs:write('post_record_normalize_and_trim', x)
            end,
            tooltip = "If checked, all samples will be normalized and trimmed after recording has completed."
          },
  
          vb:text {
            text = "Normalize and Trim samples after recording"
          }
        },
       },
       --
       vb:horizontal_aligner {
         spacing = UNIT,
         margin = DEFAULT_MARGIN,
          
         vb:row {
           spacing = UNIT/3,
           
           vb:checkbox {
             value = prefs:read('use_tag_envelope_settings', false),
             notifier = function(x) 
               prefs:write('use_tag_envelope_settings', x)
             end,
             tooltip = "If checked, an envelope setting will be used based on selected tags"
           },
            
           vb:text {
             text = "Use Tag envelope settings"
           }
         },
       }
    }
end

function midi_list()
  local devices, selected_idx = midi_device_list()
  local selected, selected_name, selected_idx = get_midi_device()
  
  return vb:horizontal_aligner {
    margin = DEFAULT_MARGIN,
    spacing = 1,
    vb:text {
      width = "30%",
      text = "MIDI Output Device"
    },
    vb:popup {
      width = "30%",
      items = devices,
      value = selected_idx,
      notifier = function(i)
        print("devices:", devices[i])
        select_midi_device(devices[i])
      end,
      tooltip = "MIDI device to send MIDI signals to."
    },
    vb:text {
      width = "15%",
      text = "Channel"
    },
    vb:popup {
      width = "15%",
      value = 1,
      items = range(1, 16, true),
      notifier = function(x)
        select_midi_channel(x)
      end,
      tooltip = "Which MIDI channel to send signals over."
    }
  }
end

