local rect = {}

---@param p1 vec2
---@param p2 vec2
---@param segments number
local function pillPath(p1, p2, segments)
	local radius = math.min((p2.y - p1.y) / 2, (p2.x - p1.x) / 2)
	local midY = (p1.y + p2.y) / 2
	ui.pathClear()
	ui.pathArcTo(vec2(p1.x + radius, midY), radius, math.pi * 0.5, math.pi * 1.5, segments)
	ui.pathArcTo(vec2(p2.x - radius, midY), radius, -math.pi * 0.5, math.pi * 0.5, segments)
end

-- Desenha um retangulo em formato de pílula preenchido
---@param p1 vec2
---@param p2 vec2
---@param color rgbm
---@param segments number
function rect.drawPillFilled(p1, p2, color, segments)
	pillPath(p1, p2, segments)
	ui.pathFillConvex(color)
end

-- Desenha um retângulo em formato de pílula traçado
---@param p1 vec2
---@param p2 vec2
---@param color rgbm
---@param segments number
function rect.drawPillStroke(p1, p2, color, thickness, segments)
	pillPath(p1, p2, segments)
	ui.pathStroke(color, true, thickness)
end

---@param p1 vec2
---@param p2 vec2
---@param color rgbm
---@param rounding number
---@param segments integer
---@param roundingFlags ui.CornerFlags?
function rect.drawRectRounded(p1, p2, color, rounding, segments, roundingFlags)
    roundingFlags = roundingFlags or ui.CornerFlags.All
	local radius = math.max(0, math.min(rounding, (p2.x - p1.x) / 2, (p2.y - p1.y) / 2))

	local radiusTL = bit.band(roundingFlags, ui.CornerFlags.TopLeft) ~= 0 and radius or 0
	local radiusTR = bit.band(roundingFlags, ui.CornerFlags.TopRight) ~= 0 and radius or 0
	local radiusBR = bit.band(roundingFlags, ui.CornerFlags.BottomRight) ~= 0 and radius or 0
	local radiusBL = bit.band(roundingFlags, ui.CornerFlags.BottomLeft) ~= 0 and radius or 0

	ui.pathClear()
	ui.pathArcTo(vec2(p1.x + radiusTL, p1.y + radiusTL), radiusTL, math.pi, math.pi * 1.5, segments)
	ui.pathArcTo(vec2(p2.x - radiusTR, p1.y + radiusTR), radiusTR, math.pi * 1.5, math.pi * 2, segments)
	ui.pathArcTo(vec2(p2.x - radiusBR, p2.y - radiusBR), radiusBR, 0, math.pi * 0.5, segments)
	ui.pathArcTo(vec2(p1.x + radiusBL, p2.y - radiusBL), radiusBL, math.pi * 0.5, math.pi, segments)
	ui.pathFillConvex(color)
end




return rect