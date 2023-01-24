
-- reset state to be ready to record
function reset_state()
  STATE.notei = nil
  STATE.notes = nil
  STATE.recording.value = false
  STATE.layers = nil
  STATE.layeri = nil
  STATE.rrobin = nil
  STATE.rrobini = nil
  STATE.total = nil
  STATE.inst = nil
  STATE.inst_index = nil
  STATE.status.value = 0
      
  TOCALL = nil -- from util.lua
  KILL = false -- from util.lua

  -- erase any timers
  if renoise.tool():has_timer(start_note) then
    renoise.tool():remove_timer(start_note)
  end

  if renoise.tool():has_timer(stop_note) then
    renoise.tool():remove_timer(stop_note)
  end
end

function reset_midi_device_state()
  local index = 1
  local device_name = renoise.Midi.available_output_devices()[index]

  STATE.dev = device_name
  STATE.midi_device = nil
  STATE.midi_device_index = index
end
renoise.Midi.devices_changed_observable(reset_midi_device_state())

-- toggles the on/off state of a button
function toggle_button(button, ttype)
  print("toggling ", tostring(ttype), tostring(button))

  -- set data to 
  OPTIONS[ttype][button] = not OPTIONS[ttype][button]

  -- set visual
  vb.views[tostring(ttype).."_button_"..tostring(button)].color = 
    OPTIONS[ttype][button] and C_PRESSED or C_NOT_PRESSED
end

-- generate list of midi notes to send to the controller
function gen_notes()
  -- midi 0xc = c0
  -- renoise 0 = c0
  local ret = {}
  local step = 4  
  local low = prefs:read('low_octave',1)
  local high= prefs:read('high_octave',6) + 1
  
  for n = 12 * low, 12 * (high) - 1 do
    --@TODO replace OPTIONs with prefs
    if OPTIONS.notes[n%12] then
      table.insert(ret, n)
    end
  end  
  
  return ret
end

-- check for invalid options
function check()
  if OPTIONS.low > OPTIONS.high then
    renoise.app():show_prompt("Oops!", "Low octave must be <= high octave.", {"OK"})
    return false
  end
 
  local foundnote = false
  for i=0,11 do
    if OPTIONS.notes[i] == true then
      foundnote = true
      break
    end
  end
  if not foundnote then
    renoise.app():show_prompt("Oops!", "You must select at least one note.", {"OK"})
    return false
  end
 
  return true
end

-- start the recording process
function go()
  print("Starting...")
  reset_state()

  if not check() then
    stop()
    return false
  end
  
  -- create a new instrument and name it
  local total_insts = #renoise.song().instruments
  local new_inst_index = total_insts + 1
  local new_inst = renoise.song():insert_instrument_at(new_inst_index)
  renoise.song().selected_instrument_index = new_inst_index

  STATE.notes = gen_notes()
  STATE.notei = 1
  STATE.dev = get_midi_device()
  STATE.layers = math.floor(OPTIONS.layers)
  STATE.layeri = 1
  STATE.rrobin = math.floor(OPTIONS.rrobin)
  STATE.rrobini = 1
  STATE.total = table.count(STATE.notes) * STATE.layers * STATE.rrobin
  STATE.inst = renoise.song().selected_instrument
  STATE.inst_index = renoise.song().selected_instrument_index
  STATE.status.value = 1
  
  print("Going to create "..tostring(STATE.total).." samples.")
  print("start should be disabled. stop sholuld eb enabled")
  print("STATE status = ", STATE.status.value)

  -- get inst
  local inst = STATE.inst

  -- clear samples
  while table.count(inst.samples) > 0 do
    inst:delete_sample_at(1)
  end

  -- insert blank samples
  for i=1,STATE.total do
    inst:insert_sample_at(i)
  end

  -- start on first sample
  renoise.song().selected_sample_index = 1
  
  -- select the appropriate midi program
  select_program(MSTATE.current_program)

  -- go!
  prep_note()
end

-- returns dict mapping note -> [low, high] mapping boundaries
function get_mapping_dict()
  -- set up mappings
  local mapping_dict = {}
  
  for i=1,table.count(STATE.notes) do
    local low
    local high
    
    if OPTIONS.mapping == 1 then -- down
      if i == 1 then
        low = 0
      else
        low = STATE.notes[i-1] + 1
      end
      
      if i == table.count(STATE.notes) then
        high = 119
      else
        high = STATE.notes[i]
      end
    elseif OPTIONS.mapping == 2 then -- middle
      local function get_dists(note)
        local up = 1
        local down = 1
        
        -- up
        local i = (note + 1)%12
        while not OPTIONS.notes[i] do
          i = (i + 1)%12
          up = up + 1
        end
        
        -- down
        i = (note - 1)%12
        while not OPTIONS.notes[i] do
          i = (i - 1)%12
          down = down + 1
        end
        
        return {up = math.floor(up/2), down = math.floor((down-1)/2)}
      end
      
      local diffs = get_dists(STATE.notes[i])
      
      if i == 1 then
        diffs.down = STATE.notes[i]
      elseif i == table.count(STATE.notes) then
        diffs.up = 119 - STATE.notes[i]
      end
      
      low = STATE.notes[i] - diffs.down
      high = STATE.notes[i] + diffs.up
    elseif OPTIONS.mapping == 3 then -- up
      if i == 1 then
        low = 0
      else
        low = STATE.notes[i]
      end
      
      if i == table.count(STATE.notes) then
        high = 119
      else
        high = STATE.notes[i+1] - 1
      end
    end
    
    mapping_dict[STATE.notes[i]]={low, high}
  end
  
  return mapping_dict
end

function do_mapping(mapping_dict)
  local inst = STATE.inst
  
  for i=1,table.count(STATE.notes) do
    for l=1,STATE.layers do
      for r=1,STATE.rrobin do
        if mapping_dict[STATE.notes[i]] then
          local idx = get_sample_index(i, l, r)
          local mapping = inst.sample_mappings[1][idx]
          
          mapping.base_note = STATE.notes[i]
          mapping.note_range = mapping_dict[STATE.notes[i]]
          
          local lunit = 128/STATE.layers
          local lrange = {math.floor((l-1)*lunit), math.floor((l)*lunit - 1)}
          mapping.velocity_range = lrange
        end
      end
    end
  end
end

-- apply finishing touches
function finish()
  update_status("Finishing...")
  local inst = STATE.inst

  local lunit = 128/STATE.layers

  -- name samples
  for i=1,table.count(STATE.notes) do
    for l=1,STATE.layers do
      for r=1,STATE.rrobin do
        local vel = math.floor((l)*lunit - 1)
        local idx = get_sample_index(i, l, r)
        inst.samples[idx].name = note_to_name(STATE.notes[i]).."_"..string.format("%X", vel).."_"..string.format("%X", r)
      end
    end
  end
  
  -- update instrument name
  update_instrument_name()

  -- do mappings
  do_mapping(get_mapping_dict())

  -- set mapping to round robin if specified
  if STATE.rrobin > 1 then
    inst.sample_mapping_overlap_mode = renoise.Instrument.OVERLAP_MODE_CYCLED
  end

  -- close recording window
  renoise.app().window.sample_record_dialog_is_visible = false

  -- close midi
  STATE.dev:close()
  
  index()

  -- normalize samples if enabled
  if prefs:read('post_record_normalize_and_trim', false) == true then
    normalize_and_trim()
  end
  
  if OPTIONS.create_x_fade_loop then
    create_x_fade_loops()
  end
  
 local inst_name = renoise.song().selected_instrument.name
  
  if prefs:read("save_wav_files", false) then
    if isempty(vb.views["wav_output_path"].text) then
      local wav_path = renoise.app():prompt_for_path("Save wav files in...")
      vb.views["wav_output_path"].text = wav_path
      prefs:write("wav_output_path", wav_path)
    end
  
    -- save wav files
    save_inst_files(vb.views["wav_output_path"].text, inst_name)  
  end
  
  -- save instrument
  if OPTIONS.save_instrument then
    if isempty(vb.views["xrni_output_path"].text) then
      local xrni_path = renoise.app():prompt_for_path("Save xrni file in...")
      vb.views["xrni_output_path"].text = xrni_path
      prefs:write("xrni_output_path", xrni_path)
    end
    
    renoise.app():save_instrument(vb.views["xrni_output_path"].text.."/"..inst_name)    
  end
  
  STATE.status.value = 0
end

function create_x_fade_loops()

end

function save_inst_files(path, name)
  if isempty(name) then
    return
  end

  local samples = renoise.song().selected_instrument.samples
  
  -- nothing to do if there's no samples 
  if #samples == 0 or name == "" then
    return
  end
  
  os.mkdir(path.."/"..name)
  
  for key, sample in pairs(samples) do
    renoise.song().selected_sample_index = key
    renoise.app():save_instrument_sample(path.."/"..name.."/"..sample.name)
  end
end

function index()
  local samples = renoise.song().selected_instrument.samples
  
  -- nothing to do if there's no samples 
  if #samples == 0 then
    return
  end
  
  local i = 1
  local old_name, new_name = ""
  
  for key, value in pairs(samples) do
    old_name = value.name
    new_name = i.."_"..old_name
    value.name = new_name

    i = i + 1
  end
end

function normalize_and_trim_coroutine()
  -- call processing coroutines serially
  update_status("Normalizing samples...")
  normalize_coroutine()

  update_status("Trimming samples...")
  trim_coroutine()

  update_status("All samples normalized and trimmed.")
end

-- normalize and trim the samples
function normalize_and_trim()
  prep_processing(normalize_and_trim_coroutine)
  SAMPLE_PROCESSING_PROCESS:start()
end

-- kill switch
function stop()
  KILL = true
  if STATE.recording.value then
    renoise.app().window.sample_record_dialog_is_visible = true
    renoise.song().transport:start_stop_sample_recording()
    STATE.recording.value = false
    if STATE.dev and STATE.dev.is_open then
      STATE.dev:send({NOTE_OFF, STATE.notes[STATE.notei] + 0xC, 0x40}) -- release current note
      STATE.dev:send({ALL_NOTE_OFF_1 , ALL_NOTE_OFF_2, 0x00}) -- send all notes off
    end
  end
  renoise.app().window.sample_record_dialog_is_visible = false
  if STATE.dev and STATE.dev.is_open then
    STATE.dev:close()
  end
  update_status("Stopped")
  STATE.status.value = 0
end

-- open the recording settings window
function configure()
  renoise.app().window.sample_record_dialog_is_visible = true
end

function get_sample_index(notei, layeri, rrobini)
  return (notei-1)*STATE.layers*STATE.rrobin + STATE.rrobin*(layeri-1) + (rrobini-1) + 1
end

-- get ready to play a note
-- recording starts here
function prep_note()
  -- check that "new instrument on each take" is not selected by comparing the
  --   currently selected instrument index to the one we had when we started.
  if renoise.song().selected_instrument_index ~= STATE.inst_index then
    renoise.app():show_prompt("Oops!", "A different instrument became selected. The same instrument must remain selected throughout the process. Make sure the \"Create new instrument on each take\" option is NOT checked in the Renoise recording settings dialog.", {"OK"})
    stop()
    renoise.song().selected_instrument_index = STATE.inst_index
    renoise.app().window.sample_record_dialog_is_visible = true
    return
  end

  local idx = get_sample_index(STATE.notei, STATE.layeri, STATE.rrobini)
  print("Prepping note "..tostring(idx).."...")
  renoise.song().selected_sample_index = idx
  renoise.app().window.sample_record_dialog_is_visible = true
  renoise.song().transport:start_stop_sample_recording()
  STATE.recording.value = true
  select_program(MSTATE.current_program)
  call_in(start_note, 250)
end

function all_notes_off()
  local devices = renoise.Midi.available_output_devices()
  local dev = renoise.Midi.create_output_device(devices[2])
  dev:send({0xB0, 0x7B, 0x00})
end

function preview_note()
  all_notes_off()
  
  local dev = get_midi_device()
  if dev then
    local midi_channel  = tonumber(prefs:read('current_midi_channel', 1) - 1)  
    local status_byte   = tonumber(string.format("0x%x", bit.bor(0x90, midi_channel)))
    local note          = tonumber(string.format("0x%x", 60))
    local velocity      = tonumber(string.format("0x%x", 120))  
  
    print("midi_channel", midi_channel)
    print("dev name: ", dev.name)
  
    vb.views['preview_program_button'].active = false
    vb.views['single_midi_program'].active = false
    
    local a = dev:send({status_byte, note, velocity})
    print(a)
    
    -- kill all notes in .5 seconds
    call_in(function()
      print("asdfasd")
      all_notes_off()
      vb.views['preview_program_button'].active = true 
      vb.views['single_midi_program'].active = true
    end, 500)
  end

end

-- play the note
function start_note()
  print("Starting note...")
  STATE.dev:send({NOTE_OFF, STATE.notes[STATE.notei] + 0xC, 0x40}) -- just in case...
  
  local lunit = 128/STATE.layers
  local vel = math.floor((STATE.layeri)*lunit - 1)
  
  STATE.dev:send({NOTE_ON, STATE.notes[STATE.notei] + 0xC, vel})
  call_in(release_note, prefs:read('length') * 1000)
end

-- release the note
function release_note()
  print("Releasing note...")
  STATE.dev:send({NOTE_OFF, STATE.notes[STATE.notei] + 0xC, 0x40})
  call_in(stop_note, OPTIONS.release * 1000)
end

-- stop recording, prep next note
function stop_note()
  print("Stopping note...")
  renoise.app().window.sample_record_dialog_is_visible = true
  renoise.song().transport:start_stop_sample_recording()
  STATE.recording.value = false

  STATE.rrobini = STATE.rrobini + 1
  if STATE.rrobini > STATE.rrobin then
    STATE.rrobini = 1
    STATE.layeri = STATE.layeri + 1

    if STATE.layeri > STATE.layers then
      STATE.layeri = 1
      STATE.notei = STATE.notei + 1
    end
  end

  if STATE.notes[STATE.notei] ~= nil then
    call_in(prep_note, OPTIONS.between_time)
  else
    call_in(finish, OPTIONS.between_time)
  end
end



