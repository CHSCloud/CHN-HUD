local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local speed = {}

---@param data pedalsData
function speed.drawSpeed(data)
	data.contentMidle = 73 * pedalsSettings.store.pedalsScale
	data.fontSpeed = 20 * pedalsSettings.store.pedalsScale
	local speed
	if SelectedSpeed == 1 then
		speed = string.format("%.0f", CAR.speedKmh)
	else
		speed = string.format("%.0f", CAR.speedKmh * 0.621371)
	end

	if pedalsSettings.store.gearActive then
		ui.setCursor(vec2(data.currentWindowWidth + 11 * pedalsSettings.store.pedalsScale, 41 * pedalsSettings.store.pedalsScale) + vec2(0, data.contentTop))
		ui.dwriteTextAligned(
			speed,
			data.fontSpeed,
			ui.Alignment.Center,
			ui.Alignment.Center,
			vec2(50, 30):scale(pedalsSettings.store.pedalsScale),
			false,
			COLOR.WHITE
		)
	else
		data.fontSpeed = 25 * pedalsSettings.store.pedalsScale
		ui.setCursor(vec2(data.currentWindowWidth + 11 * pedalsSettings.store.pedalsScale, 19 * pedalsSettings.store.pedalsScale) + vec2(0, data.contentTop))
		ui.dwriteTextAligned(
			speed,
			data.fontSpeed,
			ui.Alignment.Center,
			ui.Alignment.Center,
			vec2(50, 35):scale(pedalsSettings.store.pedalsScale),
			false,
			COLOR.WHITE
		)
	end
end

return speed
