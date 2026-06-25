---@class pedalsData
---@field currentWindowSize vec2
---@field currentWindowWidth number
---@field currentWindowHeight number
---@field contentTop number
---@field contentMidle number
---@field contentBottom number
---@field currentGear number
---@field fontGear number
---@field gearBackgroundWidth number
---@field fontSpeed number
---@field initDRSActivation number
---@field oldKersCharge number
---@field fontBar any
---@field fontBarInfinite any
---@field fontContentBottom any
---@field barSize any
---@field barSpace any
---@field barLimitSize any
---@field barMidleSize any
---@field barPaddingMidle any
---@field contentPositions vec2[][]
local pedalsData = {}

---@return pedalsData
function pedalsData.new()
  return {
    currentWindowSize = vec2(0, 0),
    currentWindowWidth = 0,
    currentWindowHeight = 0,
    contentTop = 0,
    contentMidle = 0,
    contentBottom = 0,
    currentGear = 0,
    fontGear = 0,
    gearBackgroundWidth = 0,
    fontSpeed = 0,
    initDRSActivation = 0,
    oldKersCharge = 0,
    fontBar = nil,
    fontBarInfinite = nil,
    fontContentBottom = nil,
    barSize = nil,
    barSpace = nil,
    barLimitSize = nil,
    barMidleSize = nil,
    barPaddingMidle = nil,
    contentPositions = {},
  }
end

function pedalsData.resetContentPositions(data, windowSize)
  data.contentPositions = {
    { vec2(0, 0), vec2(0, 0) },
    { vec2(windowSize.x, 0), vec2(0, 0) },
    { vec2(0, windowSize.y), vec2(0, 0) },
    { vec2(windowSize.x, windowSize.y), vec2(0, 0) },
    { vec2(windowSize.x / 2, 0), vec2(0, 0) },
    { vec2(windowSize.x / 2, windowSize.y), vec2(0, 0) },
  }
end

function pedalsData.setPositionContentBorder(data, pos, size)
  local positions = data.contentPositions[pos]

  if positions[1].x > 0 then
    positions[1].x = positions[1].x - size.x
  end

  if positions[1].y > 0 then
    positions[1].y = positions[1].y - size.y
  end

  positions[2] = size
end

function pedalsData.setPositionContentCenter(data, pos, size)
  local positions = data.contentPositions[pos]

  if positions[1].y > 0 then
    positions[1].y = positions[1].y - size.y
  end

  positions[2] = size
end

return pedalsData
