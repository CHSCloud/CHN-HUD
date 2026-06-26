---@class pitLaneData
---@field currentWindowWidth number
---@field currentWindowHeight number
---@field currentWindowSize vec2
---@field posLimit vec2
---@field fontLimit number
---@field posSpeedLimit vec2
---@field fontSpeedLimit number
---@field posYou vec2
---@field fontYou number
---@field posSpeedYou vec2
---@field fontSpeedYou number
---@field fontSlowDown number
---@field kmhString string
---@field limitPitString string
---@field speedrgb rgbm
local pitLaneData = {}

---@return pitLaneData
function pitLaneData.new()
  return {
    currentWindowWidth = 0,
    currentWindowHeight = 0,
    currentWindowSize = vec2(0, 0),
    posLimit = vec2(-10, 5),
    fontLimit = 0,
    posSpeedLimit = vec2(6, 22),
    fontSpeedLimit = 0,
    posYou = vec2(63, 5),
    fontYou = 0,
    posSpeedYou = vec2(80, 22),
    fontSpeedYou = 0,
    fontSlowDown = 0,
    kmhString = "--",
    limitPitString = "--",
    speedrgb = COLOR.WHITE,
  }
end

return pitLaneData
