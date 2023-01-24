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
        notifier = go,
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
