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

--- @param p1 vec2
--- @param p2 vec2
--- @param rounding number 
--- @param segments integer
--- @param roundingFlags ui.CornerFlags?
local function rectRoundedPath(p1, p2, rounding, segments, roundingFlags)
	roundingFlags = roundingFlags or ui.CornerFlags.All
	local r = math.max(0, math.min(rounding, (p2.x - p1.x) / 2, (p2.y - p1.y) / 2))

	local rTL = bit.band(roundingFlags, ui.CornerFlags.TopLeft) ~= 0 and r or 0
	local rTR = bit.band(roundingFlags, ui.CornerFlags.TopRight) ~= 0 and r or 0
	local rBR = bit.band(roundingFlags, ui.CornerFlags.BottomRight) ~= 0 and r or 0
	local rBL = bit.band(roundingFlags, ui.CornerFlags.BottomLeft) ~= 0 and r or 0

	ui.pathClear()
	ui.pathArcTo(vec2(p1.x + rTL, p1.y + rTL), rTL, math.pi, math.pi * 1.5, segments)
	ui.pathArcTo(vec2(p2.x - rTR, p1.y + rTR), rTR, math.pi * 1.5, math.pi * 2, segments)
	ui.pathArcTo(vec2(p2.x - rBR, p2.y - rBR), rBR, 0, math.pi * 0.5, segments)
	ui.pathArcTo(vec2(p1.x + rBL, p2.y - rBL), rBL, math.pi * 0.5, math.pi, segments)
end

---@param p1 vec2
---@param p2 vec2
---@param color rgbm
---@param rounding number
---@param segments integer
---@param roundingFlags ui.CornerFlags?
function rect.drawRectRounded(p1, p2, color, rounding, segments, roundingFlags)
	rectRoundedPath(p1, p2, rounding, segments, roundingFlags)
	ui.pathFillConvex(color)
end

---@param p1 vec2
---@param p2 vec2
---@param color rgbm
---@param rounding number
---@param thickness number
---@param segments integer
---@param roundingFlags ui.CornerFlags?
function rect.drawRectRoundedOutline(p1, p2, color, rounding, thickness, segments, roundingFlags)
	rectRoundedPath(p1, p2, rounding, segments, roundingFlags)
	ui.pathStroke(color, true, thickness)
end




return rect