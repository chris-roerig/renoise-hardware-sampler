TOCALL = nil      -- function to call when the timer runs out
KILL = false      -- has the stop button been pushed

-- use a renoise timer to call a function in approx. mill milleseconds
function call_in(func, mill)
  TOCALL = func
  renoise.tool():add_timer(call, mill)
end

-- do the actual function call
function call()
  renoise.tool():remove_timer(call)
  if TOCALL and not KILL then
    TOCALL()
  end
end

function update_status(status)
  renoise.app():show_status(status)
  print(status)
end

-- convert a renoise note number to its name
function note_to_name(note)
  local octave = math.floor(note/12)
  local key = note % 12
  local keys = {[0]="C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
  return keys[key] .. tostring(octave)
end

-- capitalize a word
function upcase(word)
  return string.gsub(" "..word, "%W%l", string.upper):sub(2)
end

-- splits string to table
-- thanks https://stackoverflow.com/a/7615129
function strsplit (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

-- check if string is empty string or nil
function isempty(s)
  return s == nil or s == ''
end

function isnan(n)
 return n ~= n
end

function isnanorempty(s)
  return isempty(s) or isnan(s)
end

function range(start, finish, as_string )
  as_string = as_string or false
  
  local range = {}
  for i = start, finish do
    if as_string then
      local s = string.format("%s", i)
      table.insert(range, i, s)
    else
      table.insert(range, i, i)
    end
  end

  return range
end

