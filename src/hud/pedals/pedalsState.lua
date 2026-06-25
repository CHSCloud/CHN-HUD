local PedalsState = {}
PedalsState.__index = PedalsState

function PedalsState:new()
  local instance = {
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

  setmetatable(instance, self)
  return instance
end

function PedalsState:resetContentPositions(windowSize)
  self.contentPositions = {
    { vec2(0, 0), vec2(0, 0) },
    { vec2(windowSize.x, 0), vec2(0, 0) },
    { vec2(0, windowSize.y), vec2(0, 0) },
    { vec2(windowSize.x, windowSize.y), vec2(0, 0) },
    { vec2(windowSize.x / 2, 0), vec2(0, 0) },
    { vec2(windowSize.x / 2, windowSize.y), vec2(0, 0) },
  }
end

function PedalsState:setPositionContentBorder(pos, size)
  local positions = self.contentPositions[pos]

  if positions[1].x > 0 then
    positions[1].x = positions[1].x - size.x
  end

  if positions[1].y > 0 then
    positions[1].y = positions[1].y - size.y
  end

  positions[2] = size
end

function PedalsState:setPositionContentCenter(pos, size)
  local positions = self.contentPositions[pos]

  if positions[1].y > 0 then
    positions[1].y = positions[1].y - size.y
  end

  positions[2] = size
end

return PedalsState
