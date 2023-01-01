 function panel_advanced_multi_program()
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
      vb:chooser {
        items = {"Single Program", "Multi-Program"},
        notifier = function(x) 
          if x == 1 then 
            vb.views["auto_name_options"].visible = true
            vb.views["name_instrument_name"].visible = true
            vb.views["tags"].visible = true
            vb.views["name_tags_text"].visible = true              
            vb.views["from_file_options"].visible = false
            
            vb.views["multi_panel_options"].visible = false
            OPTIONS.multi_program = false
          else
            vb.views["auto_name_options"].visible = false
            vb.views["name_instrument_name"].visible = false
            vb.views["tags"].visible = false
            vb.views["name_tags_text"].visible = true              
            vb.views["from_file_options"].visible = true
            
            vb.views["multi_panel_options"].visible = true
            OPTIONS.multi_program = true
          end
        end
      }
    }
  }
end

function advanced_gui()
     -- multi program options
    return vb:column {
      style = "panel",
      width = "100%",
      
      margin = DEFAULT_MARGIN,
      id = "multi_panel_options",
      visible = false,
      
      vb:text {
        text = "Muti-Program Options",
        align = "center",
        width = "100%"
      },
      vb:space {
        height = UNIT/3
      },
      
      vb:horizontal_aligner {
        mode = "left",
        spacing = DEFAULT_MARGIN,

        vb:text {
          text = "File ",
          width = "25%"
        },
        vb:textfield {
          id = "multi_program_file",
          notifier =  function(x) update_instrument_name() end,
          width = "50%",
          tooltip = "Append the hardware device's name to further identify."
        },
        vb:button {
          text = "Open...",
          notifier = function(x)
            local filepath = renoise.app():prompt_for_filename_to_read({"*.csv"}, "Program List")
            
            if filepath == "" then
              vb.views.multi_program_file.value = ""
              vb.views.multi_program_csv_content.text = ""
            else
              vb.views.multi_program_file.value = filepath
              vb.views.multi_program_csv_content.text = ""
              
              local lines = lines_from(filepath)            
              for _, line in ipairs(lines) do
                vb.views.multi_program_csv_content:add_line(line)
              end
            end
           
          end
        },
      },
      
      vb:horizontal_aligner {
        spacing = DEFAULT_MARGIN,
        mode = "center",
        vb:text {
          width = "100%"
        }
      },
      
      vb:horizontal_aligner {
        mode = "center",
        spacing = DEFAULT_MARGIN,
        id = "from_file_options",
        visible = true,
        
        vb:multiline_textfield {
          id = "multi_program_csv_content",
          width = "100%",
          height = 100,
          font = "mono",
          style = "border",
          text = default_csv_content()
        },
      },
      
      vb:horizontal_aligner {
        mode = "left",
        spacing = DEFAULT_MARGIN,
        
        vb:button {
          text = "Init",
          notifier = function() 
            vb.views.multi_program_csv_content.text = default_csv_content()
            local content = vb.views.multi_program_csv_content.text
            local lines = strsplit(content, "\n")          

            for linex, line in ipairs(lines) do
              local values = strsplit(line, ",")
              local program = values[1]
              local name = values[2]
              local tags = values[3]
              local channel = values[4]
              local bank = values[5]
                                                       
              if tostring(program) == "nan" then
                -- todo: error reporting here
                program = 1
              end
              
              if isempty(name) then
                name = "chris"..linex
              end
              
              -- isnanorempty will catch nils
              if isnanorempty(tags) then
                tags = ""
              end
              
              
              if isnanorempty(channel) then
                channel = 1
              end
              
              if isnanorempty(bank) then
                bank = 1
              end
              
              print("Program: "..program.." Name: "..name.." Tags: "..tags.." Channel: "..channel.." Bank: "..bank)
            end
          end
        }
      },
      
      vb:horizontal_aligner {
        mode = "center",
        spacing = DEFAULT_MARGIN,
        id = "auto_name_options",
        visible = true,
        
        value_box("Start", "...", 1, 1, 255, {1, 1}),
        value_box("End", "...", 255, 1, 255, {1, 1}),
      }
    }
end

function default_csv_content()
  local content = "program,name,tags,channel,bank"
  --for i=1, 128 do
  for i=1, 5 do
    content = content.."\n"..i..",,,,"
  end
  return content
end

