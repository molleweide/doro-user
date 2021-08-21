-- Urban ears Hellas
local headphoneDeviceId = "5c-eb-68-27-08-de"

local function run(cmd)
  local result, success = hs.execute(cmd)
  result = string.gsub(result, "\n$", "")

  return result, success
end

local function disconnectHeadphones()
  hs.timer.doAfter(0, function()
    local cmd = "/usr/local/bin/blueutil --disconnect " .. headphoneDeviceId

    run(cmd)
    hs.alert("Disconnected headphones")
  end)
end

local function connectHeadphones()
  hs.timer.doAfter(0, function()
    local cmd = "/usr/local/bin/blueutil --connect " .. headphoneDeviceId

    run(cmd)
    hs.alert("Connected headphones")
  end)
end

local function areHeadphonesConnected()
  local result = run("/usr/local/bin/blueutil --is-connected " .. headphoneDeviceId)
  return result == "1"
end

local function toggleHeadphones()
  if areHeadphonesConnected() then
    disconnectHeadphones()
  else
    connectHeadphones()
  end
end

hyperKey:bind('b'):toFunction("Toggle 🎧 connection", toggleHeadphones)
