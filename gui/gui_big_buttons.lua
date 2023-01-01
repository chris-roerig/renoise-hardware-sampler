function gui_big_buttons()
    -- big buttons
    return vb:horizontal_aligner {
      id = "gui_big_buttons",
      visible = true,
      mode = "center",
      width = "100%",

      vb:button {
        width = "33%",
        height = 2*UNIT,
        text = "Start",
        id = "big_button_start",
        active = true,
        notifier = function() 
          if OPTIONS.multi_program == true then
            local content = vb.views.multi_program_csv_content.text
            local lines = strsplit(content, "\n")
            table.remove(lines, 1)
            
            for n, line in ipairs(lines) do
              
              local values = strsplit(line, ",")
              local program = values[1]
              local name = values[2]
              local tags = values[3]
              local channel = values[4]
              local bank = values[5]
                                                       
              if tostring(program) == "nan" then
                -- todo: error reporting here
                program = 1
              else
                
              end
              
              if isempty(name) then
                autoname()
              else
                vb.views.instrument_name_textfield.text = name
                update_instrument_name()  
              end
              
              -- isnanorempty will catch nils
              if isnanorempty(tags) then
                tags = ""
              end
              
              if isnanorempty(channel) then
                channel = 1
              else
                select_midi_channel(tonumber(channel))
              end
              
              if isnanorempty(tonumber(bank)) then
                bank = 1
              end
              
              go()
            end

          else
            go()       
          end
        end,
        tooltip = "Start the recording process."
      },
      vb:button {
        id = "big_button_stop",
        active = false,
        width = "33%",
        height = 2*UNIT,
        text = "Stop",
        notifier = stop,
        tooltip = "Stop the recording process."
      },
      vb:button {
        width = "33%",
        height = 2*UNIT,
        text = "Recording Settings",
        notifier = configure,
        tooltip = "Open the Renoise sample recording window. Tweak your input settings to your liking here."
      }
    }
end
