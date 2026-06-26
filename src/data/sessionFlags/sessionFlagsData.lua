---@class sessionFlagsData
---@field currentTime number
---@field add number
---@field lenght number
---@field currentWindowSize vec2
---@field fontSize1 number
---@field fontSize2 number
---@field rounding number
---@field posFlag vec2
---@field flagLenght vec2
local sessionFlagsData = {}

---@return sessionFlagsData
function sessionFlagsData.new()
  return {
    currentTime = 0,
    add = -1,
    lenght = 110,
    currentWindowSize = vec2(0, 0),
    fontSize1 = 0,
    fontSize2 = 0,
    rounding = 0,
    posFlag = vec2(0, 0),
    flagLenght = vec2(0, 0),
  }
end

return sessionFlagsData
