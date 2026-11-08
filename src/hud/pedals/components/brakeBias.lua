local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")
local brakeBias = {}

---@param data pedalsData
function brakeBias.drawBrakeBias(data)
	local brakeBiasString = string.format("%.1f", CAR.brakeBias * 100)
	local lenght = ui.measureDWriteText(brakeBiasString, data.fontContentBottom).x
	pedalsData.setPositionContentBorder(data, pedalsSettings.store.brakebiasPos, vec2(lenght + 28 * pedalsSettings.store.pedalsScale, 20 * pedalsSettings.store.pedalsScale))
	ui.setCursor(data.contentPositions[pedalsSettings.store.brakebiasPos][1] + vec2(23) * pedalsSettings.store.pedalsScale)
	ui.dwriteTextAligned(
		brakeBiasString,
		data.fontContentBottom,
		ui.Alignment.Start,
		ui.Alignment.Center,
		vec2(lenght, 20):scale(pedalsSettings.store.pedalsScale),
		false,
		COLOR.WHITE
	)

	ui.setCursor(data.contentPositions[pedalsSettings.store.brakebiasPos][1] + vec2(4, 2) * pedalsSettings.store.pedalsScale)
	ui.image("assets/pedals/BrakeBias.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), ui.ImageFit.Fit)
end

return brakeBias
