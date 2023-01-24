Prefs = {}
  -- return a new Prefs instance
  -- kicks off all the Renoise preference tooling and 
  -- loads stored preferences into the global STATE
  function Prefs:new()
    
    self.options = renoise.Document.create("HWSamplerPreferences") {
      -- midi
      midi_device_name      = "",
      first_midi_program    = 1,
      last_midi_program     = 1,
      current_midi_channel  = 0,
      single_midi_program   = 1,
      
      -- sampling options
      low_octave      = 1,
      high_octave     = 6,
      num_vel_layers  = 1,
      num_rr_layers   = 1,
      length          = 1,
      
      -- paths
      xrni_output_path  = "",
      wav_output_path   = "",
      
      -- booleans
      save_wav_files            = false,
      save_renoise_instrument   = false,
      auto_preview_enabled      = false,
      use_tag_envelope_settings = false,
      post_record_normalize_and_trim = true,
    }
    
    renoise.tool().preferences = self.options
    
    return self
  end
  
  -- reads saved preferences. 
  -- default argument required and is used (and saved) if
  -- the preference doesn't exist
  function Prefs:read(pref, default)
    local value = nil
    
    if self.options[tostring(pref)] then
      value = self.options[tostring(pref)].value
    else
      self:write(pref, default)
      value = default
    end
      
    return value
  end
  
  -- writes or updates prefernces for later recall
  function Prefs:write(pref, value)
    -- if the setting exists, update its value
    if self.options[tostring(pref)] then
      self.options[tostring(pref)].value = value
    -- if the settind doesn't exist yet, save it.
    else
      self.options[tostring(pref)] = value
    end
  end
