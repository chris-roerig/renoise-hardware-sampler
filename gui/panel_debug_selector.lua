function panel_debug_selector()
  return vb:column {
      width = "100%",
      -- mapping style
      vb:horizontal_aligner {
        margin = DEFAULT_MARGIN,
        spacing = DEFAULT_MARGIN,
        
        vb:switch {
          width = "100%",
          items = {"Log", "prefs", "OPTIONS", "STATE", "Other"},
          value = OPTIONS.visible_debug_panel,
          notifier = function(x)
            if x == 1 then
              -- Log
              vb.views['panel_debug_log'].visible = true
              vb.views['panel_debug_prefs'].visible = false
              vb.views['panel_debug_options'].visible = false
              vb.views['panel_debug_state'].visible = false
              vb.views['panel_debug_other'].visible = false
            elseif x == 2 then
              -- prefs
              vb.views['panel_debug_log'].visible = false
              vb.views['panel_debug_prefs'].visible = true
              vb.views['panel_debug_options'].visible = false
              vb.views['panel_debug_state'].visible = false
              vb.views['panel_debug_other'].visible = false
            elseif x == 3 then
              -- OPTIONS
              vb.views['panel_debug_log'].visible = false
              vb.views['panel_debug_prefs'].visible = false
              vb.views['panel_debug_options'].visible = true
              vb.views['panel_debug_state'].visible = false
              vb.views['panel_debug_other'].visible = false
            elseif x == 4 then
              -- STATE
              vb.views['panel_debug_log'].visible = false
              vb.views['panel_debug_prefs'].visible = false
              vb.views['panel_debug_options'].visible = false
              vb.views['panel_debug_state'].visible = true
              vb.views['panel_debug_other'].visible = false         
            elseif x == 5 then
              -- Other
              vb.views['panel_debug_log'].visible = false
              vb.views['panel_debug_prefs'].visible = false
              vb.views['panel_debug_options'].visible = false
              vb.views['panel_debug_state'].visible = false
              vb.views['panel_debug_other'].visible = true
            end
            
            OPTIONS.visible_debug_panel = x 
          end,
          tooltip = ""
        }
      }
    }
end
