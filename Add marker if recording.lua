-- Adds a unique marker each time tone is switched, but only if REAPER is recording

function add_marker_if_recording()
  local state = reaper.GetPlayState()
  if (state & 4) == 4 then  -- 4 = recording
    local pos = reaper.GetPlayPosition()
    reaper.AddProjectMarker2(0, false, pos, 0, "Tone switch", -1, 0)
  end
end

add_marker_if_recording()

