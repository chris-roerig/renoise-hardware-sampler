function show_menu()
  local title = TOOL_FULLNAME
  vb = renoise.ViewBuilder()
  
  local content = 
    vb:row{
     --height = UNIT*24,
      vb:column {
        margin = DEFAULT_MARGIN*2,
        width = UNIT*24,
        spacing = UNIT/2,
       
        panel_selector(),
        gui_note_settings(),
        panel_single_program(),
        panel_multi_program(),
        -- panel_advanced_multi_program()
        panel_post_processing(),
        panel_options(),
        
        gui_big_buttons(),
        gui_status_bar(),
      },
      
      --[[ @TODO make this toggable
      vb:column {
        id = "debug_window",
        visible = true,
        margin = DEFAULT_MARGIN*2,
        spacing = UNIT/2,
        width = 800,
        panel_debug_selector(),
        panel_debug_log(),
        panel_debug_prefs(),
        panel_debug_options(),
        panel_debug_state(),
        panel_debug_other(),
      }]]
  }
  toggle_buttons(STATE.status.value)

  WINDOW = renoise.app():show_custom_dialog(
    title, content
  )
  -- bang on any gui inits
  gui_finished_loading:bang()
end
