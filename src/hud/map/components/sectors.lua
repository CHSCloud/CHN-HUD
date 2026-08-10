local utils = require("common.utils")
local sectors = {}

-- Desenha setores
--- @param data mapData
--- @param thickness number -- Espessura do setor
--- @param color rgbm -- Cor do setor
function sectors.drawSectors(data, thickness, color)
	for i, sector in ipairs(data.sectors) do
		if i > 1 then
			-- Posição do setor
			local left = utils.rotateVec(
				vec2((sector.left.x - data.trackCenterX) * data.canvasScale, (sector.left.y - data.trackCenterY) * data.canvasScale),
				data.angle
			)
			local center = utils.rotateVec(
				vec2((sector.center.x - data.trackCenterX) * data.canvasScale, (sector.center.y - data.trackCenterY) * data.canvasScale),
				data.angle
			)
			local right = utils.rotateVec(
				vec2((sector.right.x - data.trackCenterX) * data.canvasScale, (sector.right.y - data.trackCenterY) * data.canvasScale),
				data.angle
			)

			-- Direção do setor
			local dir = (right - left):normalize()
			ui.drawLine(center + dir * thickness + data.canvasCenter, center - dir * thickness + data.canvasCenter, color, 6)
		end
	end
end

-- Desenha a bandeira de largada
--- @param thickness number -- Espessura da bandeira
function sectors.drawStartFlag(data, thickness)
	-- Posição do setor
	local left = utils.rotateVec(
		vec2((data.sectors[1].left.x - data.trackCenterX) * data.canvasScale, (data.sectors[1].left.y - data.trackCenterY) * data.canvasScale),
		data.angle
	)
	local center = utils.rotateVec(
		vec2((data.sectors[1].center.x - data.trackCenterX) * data.canvasScale, (data.sectors[1].center.y - data.trackCenterY) * data.canvasScale),
		data.angle
	)
	local right = utils.rotateVec(
		vec2((data.sectors[1].right.x - data.trackCenterX) * data.canvasScale, (data.sectors[1].right.y - data.trackCenterY) * data.canvasScale),
		data.angle
	)

	-- Direção do setor
	local dir = (right - left):normalize()
	local init = center + dir * thickness + data.canvasCenter
	local final = center - dir * thickness + data.canvasCenter
	local flagLenght = utils.rotateVec(data.dirTrack * thickness / 2, data.angle)
	ui.drawImageQuad("assets/map/checkered.png", init + flagLenght, final + flagLenght, final - flagLenght, init - flagLenght)
end

return sectors
