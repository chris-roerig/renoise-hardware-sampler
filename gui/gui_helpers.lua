function textfield(_text, _value, _notif)
  return
end

function value_box(_text, _tip, _value, _min, _max, _steps, _notif, _tostring, _tonum, _width)
  return vb:row {
    vb:text {
      text = _text.." " 
    },
    vb:valuebox {
      min = _min,
      max = _max,
      tostring = _tostring,
      tonumber = _tonum,
      notifier = _notif,
      value = _value,
      steps = _steps,
      width = _width or UNIT*4,
      tooltip = _tip
    }
  }
end

-- generic button matrix. Use this to create specific button matricies
function button_matrix(buttons, name, options, tooltip, callback)
  local row = vb:horizontal_aligner {
    margin = DEFAULT_MARGIN,
    mode = "distribute",
    id = name,
    spacing = 1
  }

  -- callback is the is the callback the notifier should run
  local notifier = function(button, name, callback)
    -- do GUI work
    toggle_button(button, name)

    -- run callback
    if callback then
      print("Running callback for button matrix:", name)
      callback()
    end
  end

  for button = 0,#buttons do
    local button = vb:button {
      id = name.."_button_"..tostring(button),
      text = buttons[button],
      width = UNIT*1.5,
      height = UNIT*1.5,
      color = options[button] and C_PRESSED or C_NOT_PRESSED,
      notifier = function(x) notifier(button, name, callback) end,
      tooltip = tooltip
    }
    row:add_child(button)
  end

  return row
end

function status_text(text)
  vb.views['processing_status_text'].text = text
end

function debug_stat(name, value)
   --[[
  
  -- print("name: ", name, " type:", type(value))
  if type(value) == "table" then
    local tmp_value = ""
    for k,v in pairs(value) do 
      tmp_value = tmp_value .. tostring(v) .. ","
    end
    value = tmp_value
  elseif type(value) == "boolean" then
    value = "its a boolean"
  end
  
  return vb:horizontal_aligner {
          spacing = UNIT/8,
          vb:text {
            text = name,
            width = "50%"
          },
          vb:text {
            text = tostring(value),
            width = "50%",
          },
        }
        ]]
end

function toggle_buttons(state)
  -- no activity
  if state == 0 then
    vb.views['big_button_stop'].active = false
    vb.views['big_button_start'].active = true
    vb.views['panel_selector_switch'].active = true
  -- job in process      
  else
    vb.views['big_button_stop'].active = true
    vb.views['big_button_start'].active = false 
    vb.views['panel_selector_switch'].active = false    
    --vb.views[''].active = false
    --vb.views[''].active = false
  end
end
