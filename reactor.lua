os.loadAPI("bccapi")
 
if not bccapi then error("BCCAPI not found!", 0) end
 
local reactor = bccapi.get("BigReactors-Reactor")
if not reactor then error("No reactor found!", 0) end
 
 
--[[  Program Settings  ]]--
local maxEnergy   -- Max reactor energy before cutoff
local minEnergy   -- Min reactor energy before start
local waitTime    -- Time to wait before each cycle
local checkUpdate -- Check for updates on startup?
--[[   INTERNAL VARS    ]]--
local loop = true
local pastebinId = "SJryzsjC"
--[[         END        ]]--
 
local function loadSettings()
  local table = bccapi.fileToTable("rsettings")
  if not table then -- Ensure settings exist
    table = {}
    table["max-energy"] = 9000000
    table["min-energy"] = 1000000
    table["wait-time"] = 1
    table["check-updates"] = true
    bccapi.tableToFile(table, "rsettings")
  end
 
  maxEnergy = table["max-energy"]
  minEnergy = table["min-energy"]
  waitTime = table["wait-time"]
  checkUpdate = table["check-updates"]
end
 
local function checkForUpdates()
  local headers = { [ "User-Agent" ] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" }
  local url = "https://pastebin.com/raw/"..pastebinId
  if not http.checkURL(url) then
    error("URL check failed!", 0)
  end
 
  local get = http.get(url, headers)
  local new = get.readAll()
  get.close()
 
 
 
  local old = bccapi.fileToString(shell.getRunningProgram())
  if old ~= new then error("Not up to date, please update with pastebin get "..pastebinId.."!", 0)
end
 
 
local function statusLoop()
  while loop do
    local energy = reactor.getEnergyStored()
   
    if energy > maxEnergy then
      reactor.setActive(false)
    elseif energy < minEnergy then
      reactor.setActive(true)
    end
    print("Sleeping for "..waitTime.." seconds...")
    os.sleep(waitTime)
  end
end
 
local function other()
end
 
loadSettings()
if checkUpdate then checkForUpdates() end
 
parallel.waitForAll(statusLoop(), other())
