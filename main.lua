--[[ 
  MIDI hardware sampler helper
  
  @dogsplusplus & @jugwine1
]]

-- the only globals outside of the globals file
TOOL_VERSION = "2.0.0 ALPHA"
TOOL_NAME = "MIDI Hardware Sampler"
TOOL_FULLNAME = TOOL_NAME.." v"..TOOL_VERSION

require("globals")
require("lib/util")
require("lib/midi")
require("lib/prefs")
require("lib/fileio")
require("lib/func")
require("lib/process_slicer")
require("lib/crunch")

require("gui/gui_big_buttons")
require("gui/gui_note_settings")
require("gui/gui_status_bar")
require("gui/gui_helpers")
require("gui/panel_multi_program")
require("gui/panel_options")
require("gui/panel_post_processing")
require("gui/panel_selector")
require("gui/panel_single_program")
require("gui")

-- @TODO: refactor all from prefs to PREFS to keep with global convention
prefs = Prefs:new()

renoise.tool():add_menu_entry {
  name = "Sample Editor:"..TOOL_FULLNAME,
  invoke = show_menu
}

renoise.tool():add_menu_entry {
  name= "Main Menu:Tools:"..TOOL_FULLNAME,
  invoke = show_menu
}

-- User will need to manualy assign the keybinding by going to
-- File -> Prefs -> Keys. Look under Global -> Tools.
-- Shift + t is open.. that's what I'm using ;)
renoise.tool():add_keybinding {
  name = "Global:Tools:"..TOOL_FULLNAME,
  invoke = show_menu
}

-- use this for pre-gui initializations
renoise.tool().tool_finished_loading_observable:add_notifier(function(x)
  print(TOOL_FULLNAME.." has loaded. That was good work.")

  STATE.current_midi_channel = prefs:read('current_midi_channel', 1)
end)

-- use this for any initization that require the gui (the vb global) be fully availble
gui_finished_loading = renoise.Document.ObservableBang()
gui_finished_loading:add_notifier(function(x)
  print("GUI HAS FINISHED LOADING!")
  print('first_midi_program:', vb.views['first_midi_program'].value)
  print('last_midi_program:', vb.views['last_midi_program'].value)
  
  MSTATE.current_program, STATE.start_program = vb.views['first_midi_program'].value
  MSTATE.end_program = vb.views['last_midi_program'].value
  
  STATE.gui_loaded = true
  STATE.status.value = 0
end)



