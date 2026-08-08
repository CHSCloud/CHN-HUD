local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")
local brakeBias = {}

---@param data pedalsData
function brakeBias.drawBrakeBias(data)
	pedalsData.setPositionContentBorder(data, pedalsSettings.store.brakebiasPos, vec2(60, 20):scale(pedalsSettings.store.pedalsScale))
	ui.setCursor(data.contentPositions[pedalsSettings.store.brakebiasPos][1] + vec2(25) * pedalsSettings.store.pedalsScale)
	ui.dwriteTextAligned(
		string.format("%.1f", CAR.brakeBias * 100),
		data.fontContentBottom,
		ui.Alignment.Start,
		ui.Alignment.Center,
		vec2(30, 20):scale(pedalsSettings.store.pedalsScale),
		false,
		COLOR.WHITE
	)

	ui.setCursor(data.contentPositions[pedalsSettings.store.brakebiasPos][1] + vec2(4, 2) * pedalsSettings.store.pedalsScale)
	ui.image("assets/pedals/BrakeBias.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), ui.ImageFit.Fit)
end

return brakeBias
