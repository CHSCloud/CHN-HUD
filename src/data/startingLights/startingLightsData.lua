---@class startingLightsData
---@field radius number
---@field pos number
---@field distance number
---@field thickness number
---@field distanceBorder number
---@field polygons number
---@field rounding number
---@field currentWindowHeight number
---@field currentWindowWidth number
local startingLightsData = {}

---@return startingLightsData
function startingLightsData.new()
  return {
    radius = 20,
    pos = 0,
    distance = 0,
    thickness = 1.5,
    distanceBorder = 4,
    polygons = 50,
    rounding = 50,
    currentWindowHeight = 0,
    currentWindowWidth = 0,
  }
end

return startingLightsData
