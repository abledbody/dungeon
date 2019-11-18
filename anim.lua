--Functions--
local function fetch(frame,offset,timing)
 local fCount = #timing
 local ended = false
 
 while offset <= 0 do
  if frame == fCount then
   ended = true
   frame = 1
  else
   frame = frame+1
  end
  
  offset = offset+timing[frame]
 end
 
 return frame,offset,ended
end

--Module--
local anim = {}
anim.fetch = fetch

return anim