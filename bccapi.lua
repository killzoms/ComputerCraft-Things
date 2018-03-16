function get(name)
  for i,side in pairs(peripheral.getNames()) do
    if peripheral.getType(side):lower() == name:lower() then
      return peripheral.wrap(side)
    end
  end
  return nil
end

function tableToFile(table, fileName)
  local file = fs.open(fileName, "w")
  if not file then error("Could not open file "..fileName.."!",0) end
  
  file.write(textutils.serialize(table))
  file.close()
end

function fileToTable(fileName)
  local file = fs.open(fileName, "r")
  if not file then return nil end
  
  local read = file.readAll()
  local unserialized = textutils.unserialize(read)

  file.close()
  return unserialized
end
