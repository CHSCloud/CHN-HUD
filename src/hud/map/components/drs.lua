local utils = require("common.utils")
local mapSettings = require("src.settings.tabs.mapSettings")

local drs = {}

-- Desenha DRS
--- @param data mapData
--- @param thickness number -- Espessura do DRS
function drs.drawDRS(data, thickness)
	for _, drsData in pairs(data.drs) do
		-- Início
		local left = utils.rotateVec(
			vec2((drsData.startLeft.x - data.trackCenterX) * data.canvasScale, (drsData.startLeft.y - data.trackCenterY) * data.canvasScale),
			data.angle
		)
		local center = utils.rotateVec(
			vec2((drsData.startCenter.x - data.trackCenterX) * data.canvasScale, (drsData.startCenter.y - data.trackCenterY) * data.canvasScale),
			data.angle
		)
		local right = utils.rotateVec(
			vec2((drsData.startRight.x - data.trackCenterX) * data.canvasScale, (drsData.startRight.y - data.trackCenterY) * data.canvasScale),
			data.angle
		)

		local dir = (right - left):normalize()
		local init = center + dir * thickness
		init = init + data.canvasCenter
		local final = center - dir * thickness
		final = final + data.canvasCenter
		ui.drawLine(init, final, mapSettings.store.colorDRS, 6)

		-- Final
		left = utils.rotateVec(
			vec2((drsData.finalLeft.x - data.trackCenterX) * data.canvasScale, (drsData.finalLeft.y - data.trackCenterY) * data.canvasScale),
			data.angle
		)
		center = utils.rotateVec(
			vec2((drsData.finalCenter.x - data.trackCenterX) * data.canvasScale, (drsData.finalCenter.y - data.trackCenterY) * data.canvasScale),
			data.angle
		)
		right = utils.rotateVec(
			vec2((drsData.finalRight.x - data.trackCenterX) * data.canvasScale, (drsData.finalRight.y - data.trackCenterY) * data.canvasScale),
			data.angle
		)

		dir = (right - left):normalize()
		init = center + dir * thickness
		init = init + data.canvasCenter
		final = center - dir * thickness
		final = final + data.canvasCenter
		ui.drawLine(init, final, mapSettings.store.colorDRS, 6)
	end
end

return drs
