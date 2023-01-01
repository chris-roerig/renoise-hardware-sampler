


WINDOW = nil  -- the main tool window
vb = nil      -- The global ViewBuider instance. 
              -- Sadly, not uppercase, but too much work to change it ATM.

-- measurements
DEFAULT_MARGIN = renoise.ViewBuilder.DEFAULT_CONTROL_MARGIN
UNIT = renoise.ViewBuilder.DEFAULT_CONTROL_HEIGHT

TAGS = {[0]="Bass", "Drum", "FX", "Keys", "Lead", "Pad", "Strings",  "Vocal"}
NOTES = {[0]="C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}

-- note/tag button colors
C_PRESSED = {100, 200, 100}
C_NOT_PRESSED = {20, 20, 20}

-- global options box
OPTIONS = {
  low = 1,
  high = 6,
  length = 2,
  release = .2,
  tags = {[0]=false, false, false, false, false, false, false, false},
  notes = {[0]=true, false, false, false, true, false, false, false, true, false, false, false},
  name = "Recorded Hardware",
  hardware_name = "",
  background = false,
  post_record_normalize_and_trim = false,
  mapping = 2,
  layers = 1,
  rrobin = 1,
  between_time = 100,
  create_x_fade_loop = false,
  multi_program = false,
  first_midi_program = 1,
  last_midi_program = 1,
  single_midi_program = 1
}

-- state
STATE = renoise.Document.create("StateDocument"){
  midi_device = nil,    -- current midi device name
  dev = nil,            -- current midi device object
  midi_device_index = 1,-- current midi device selected in options list
  recording = false,    -- are we actively recording
  notes = nil,          -- list of notes to send to the midi device
  notei = nil,          -- current index in note list
  layers = nil,         -- number of velocity layers for each note
  layeri = nil,         -- current layer
  rrobin = nil,         -- number of round robin layers for each note
  rrobini = nil,        -- current round robin layer
  total = nil,          -- total amount of notes that will be sampled
  inst = nil,           -- instrument to which samples will be saved
  inst_index = nil,     -- instrument index
  program_type = 1,     -- 1 means single program. Anything greater means multi-program
  current_program = 0,
  gui_loaded = false
}
-- 0 means there's no job running. 1 means there is.
STATE.status = renoise.Document.ObservableNumber()
STATE.status.value = 0
-- add notifier callbacks
STATE.status:add_notifier(function(x)
  print("STATE.status.value =", STATE.status.value)
  print("YOU'VE BEEN NOTIFIED!", STATE.status.value)
  
  toggle_buttons(STATE.status.value)
 
  -- nothing to do if this is a single program
  if STATE.program_type.value < 2 then
    return
  end
  
  if STATE.status.value == 0 then
    print("Current program: ", STATE.current_program.value)
    if STATE.current_program.value ~= OPTIONS.last_midi_program then
      print("doing next program")
      select_midi_program("1", STATE.current_program.value)
      autoname()
      call_in(go, 500)
      STATE.current_program.value = STATE.current_program.value + 1
    end
  end
end)

STATE.recording = renoise.Document.ObservableBoolean()
STATE.recording.value = false
STATE.recording:add_notifier(function(x)
  print("RECORDING STATE CHANGED!", STATE.recording.value)
  if STATE.recording.value == true then
    status_text("Recording...")
  else
    status_text("Waiting")
  end
end)
