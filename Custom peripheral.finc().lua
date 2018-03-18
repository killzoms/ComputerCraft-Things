function unpack(t, i)
 i = i or 1
 if t[i] ~= nil then
  return t[i], unpack(t, i + 1)
 end
end
 
function peripheral.find(filter)
 names = peripheral.getNames()
 handles = {}
 for i,v in pairs(names) do
  if string.find(v, filter) then
   handle = peripheral.wrap(v)
   handle.name = v
   table.insert(handles, handle)
  end
 end
 if handles == {} then
  handles = nil
 end
 return unpack(handles)
end
