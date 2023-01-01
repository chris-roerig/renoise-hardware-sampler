function panel_selector()
  return vb:column {
      width = "100%",
      -- mapping style
      vb:horizontal_aligner {
        margin = DEFAULT_MARGIN,
        spacing = DEFAULT_MARGIN,
        
        vb:switch {
          id = 'panel_selector_switch',
          width = "100%",
          items = {"Single Program", "Multi-Program", "Post Processing", "Options"},
          value = OPTIONS.visible_panel,
          notifier = function(x)
            if x == 1 then
              -- Single Program
              vb.views['panel_single_program'].visible = true
              vb.views['panel_multi_program'].visible = false
              vb.views['panel_post_processing'].visible = false
              vb.views['panel_options'].visible = false
              -- recording transport true
              vb.views['gui_note_settings'].visible = true
              vb.views['gui_big_buttons'].visible = true
            elseif x == 2 then
              -- Multi-Program
              vb.views['panel_single_program'].visible = false
              vb.views['panel_multi_program'].visible = true
              vb.views['panel_post_processing'].visible = false
              vb.views['panel_options'].visible = false
              -- recording transport true
              vb.views['gui_note_settings'].visible = true
              vb.views['gui_big_buttons'].visible = true
            elseif x == 3 then
              -- Post Processing
              vb.views['panel_single_program'].visible = false
              vb.views['panel_multi_program'].visible = false
              vb.views['panel_post_processing'].visible = true
              vb.views['panel_options'].visible = false
              -- recording transport false
              vb.views['gui_note_settings'].visible = false
              vb.views['gui_big_buttons'].visible = false   
            elseif x == 4 then
              -- Options
              vb.views['panel_single_program'].visible = false
              vb.views['panel_multi_program'].visible = false
              vb.views['panel_post_processing'].visible = false
              vb.views['panel_options'].visible = true
              -- recording transport false
              vb.views['gui_note_settings'].visible = false
              vb.views['gui_big_buttons'].visible = false           
            end
            
            OPTIONS.visible_panel = x 
          end,
          tooltip = ""
        }
      }
    }
end
