-- midi signal constants
-- can be changed by select_midi_channel
NOTE_ON = 0x90
NOTE_OFF = 0x80
ALL_NOTE_OFF_1 = 0xB0
ALL_NOTE_OFF_2 = 0x7B

function select_midi_device(midi_device_name)
  local devices = renoise.Midi.available_output_devices()
  rprint(devices)
  print(midi_device_name)
  
  if table.find(devices, midi_device_name) == nil then
    return
  end
  
  prefs:write('midi_device_name', midi_device_name)
  return renoise.Midi.create_output_device(midi_device_name), midi_device_name
end

function midi_device_list()
  local devices = renoise.Midi.available_output_devices()
  table.insert(devices, 1, "")
  return devices
end

function get_midi_device()
  if STATE.gui_loaded == false then
    return
  end
  
  local pref_device_name = prefs:read('midi_device_name', nil)

  if pref_device_name == nil then
    prompt_for_midi_device_selection()
    return
  end
  
  local devices = renoise.Midi.available_output_devices()

  if not table.find(devices, pref_device_name) then
    prompt_for_midi_device_selection()
    return
  end

  -- else load the pref device 
  return renoise.Midi.create_output_device(pref_device_name), pref_device_name
end

function prompt_for_midi_device_selection()
  renoise.app():show_prompt("Oops!", "No MIDI device selected. Choose one from the Options menu", {"OK"})
  print("GUI LOADED: ", STATE.gui_loaded)
  
  if STATE.gui_loaded == true then
    vb.views['panel_selector_switch'].value = 4
  end
end


-- changes NOTE_ON and NOTE_OFF globals
function select_midi_channel(channel)
  print("Selected channel: "..channel)
  NOTE_ON = bit.bor(0x90, channel-1)
  NOTE_OFF = bit.bor(0x80, channel-1)
  ALL_NOTE_OFF_1 = bit.bor(0xB0, channel-1)
  ALL_NOTE_OFF_2 = bit.bor(0x7B, channel-1)
end

function select_midi_program(channel, program_number)
  
  if tonumber(program_number) > 255 or tonumber(program_number) < 0 then
    print("Program number must be between 0 and 255")
    return
  end
  
  if tonumber(channel) < 1 or tonumber(channel) > 16 then
    print("Channel number must be between 1 and 16")
  end
  
  local ch = string.format("0x%x", channel)
  local pg = string.format("0x%x", program_number)
  local msg = bit.bor(pg, ch)
  local dev = get_midi_dev()
  
  -- PROGRAM_CHANGE = 0xC0
  dev:send({0xC0, msg})
end
