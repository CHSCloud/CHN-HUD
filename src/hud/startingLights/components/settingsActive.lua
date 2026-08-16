local startingLightsSettings = require("src.settings.tabs.startingLightsSettings")
local rect = require("src.ui.background.rect")

local settingsActive = {}

--- @param data startingLightsData
function settingsActive.drawSettingsActive(data)
	-- Background
	rect.drawPillFilled(vec2(0, 0), vec2(data.currentWindowWidth, data.currentWindowHeight), WindowsColor, data.polygons)
	rect.drawPillStroke(
		vec2(data.distanceBorder, data.distanceBorder),
		vec2(data.currentWindowWidth - data.distanceBorder, data.currentWindowHeight - data.distanceBorder),
		COLOR.WHITE,
		data.thickness,
		data.polygons
	)

	-- Círculos Azuis (sem alteração)
	for i = 0, startingLightsSettings.store.numStartingLights - 1, 1 do
		ui.drawCircleFilled(vec2(data.pos + i * data.distance, data.currentWindowHeight / 2), data.radius, COLOR.BLUE, data.polygons)
		ui.drawCircle(vec2(data.pos + i * data.distance, data.currentWindowHeight / 2), data.radius, COLOR.WHITE, data.polygons, data.thickness)
	end
end

return settingsActive
