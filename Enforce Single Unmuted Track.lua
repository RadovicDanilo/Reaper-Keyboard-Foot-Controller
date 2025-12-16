-- Allow only one guitar track unmuted at any time
-- For live use with footswitch/keyboard mute toggles
-- Keeps all tracks armed, avoids double-audio spikes
-- CPU: negligible

function enforce_single_unmuted()
  local track_count = reaper.CountTracks(0)
  local last_unmuted = nil
  local unmuted_count = 0

  -- Find the most recently unmuted track
  for i = 0, track_count - 1 do
    local tr = reaper.GetTrack(0, i)
    local mute = reaper.GetMediaTrackInfo_Value(tr, "B_MUTE")
    if mute == 0 then
      last_unmuted = tr
      unmuted_count = unmuted_count + 1
    end
  end

  -- If more than one is unmuted, mute all except last
  if unmuted_count > 1 and last_unmuted then
    for i = 0, track_count - 1 do
      local tr = reaper.GetTrack(0, i)
      if tr ~= last_unmuted then
        reaper.SetMediaTrackInfo_Value(tr, "B_MUTE", 1)
      end
    end
  end

  reaper.defer(enforce_single_unmuted)
end

enforce_single_unmuted()

