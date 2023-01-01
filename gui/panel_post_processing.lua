function panel_post_processing()
  return vb:column {
    id = "panel_post_processing",
    visible = false,
    
    style = "panel",
    margin = DEFAULT_MARGIN,
    width = "100%",

    vb:text {
      text = "Post Processing",
      align = "center",
      width = "100%"
    },
    vb:space {
      height = UNIT/3
    }, 
    
    vb:horizontal_aligner {
      spacing = UNIT,
      margin = DEFAULT_MARGIN,

      vb:row {
        spacing = UNIT/3,
        
        vb:checkbox{
          value = OPTIONS.background,
          notifier = function(x) OPTIONS.background = x end,
          tooltip = "If checked, process the samples a little bit slower in order to make Renoise more usable while the processing is done."
        },
        vb:text {
          text = "Process in background"
        },

          --[[ @TODO: Implement this
          vb:checkbox{
            value = OPTIONS.create_x_fade_loop,
            notifier = function(x) OPTIONS.create_x_fade_loop = x end,
            tooltip = "If checked..."
          },
  
          vb:text {
            text = "Create Cross-Fading loop for each sample"
          },]]
        }
      },
         
      vb:horizontal_aligner {
        spacing = UNIT,
        margin = DEFAULT_MARGIN,
        mode = "left",
        
        vb:button {
          text = "Normalize Sample Volumes",
          notifier = normalize,
          tooltip = "Raise the volume of each sample an equal amount. The amount will be the amount that the loudest sample can be raised before clipping."
        },
        vb:button {
          text = "Trim Silences",
          notifier = trim,
          tooltip = "Remove any silence at the beginning of all samples."
        }
      }
  }
end
