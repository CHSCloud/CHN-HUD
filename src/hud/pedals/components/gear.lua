local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local gear = {}

---@param data pedalsData
---@param maxFontGear number
local function animateGear(data, maxFontGear)
	if data.fontGear < maxFontGear - 3 then
		if (40 * TIMER) % 2 >= 1 then
			data.fontGear = data.fontGear + 10 * pedalsSettings.store.pedalsScale
		end
	else
		data.fontGear = maxFontGear
	end
end

---@param data pedalsData
function gear.drawGear(data)
	data.contentMidle = 73 * pedalsSettings.store.pedalsScale
	if data.currentGear ~= CAR.gear then
		data.fontGear = 0
		data.currentGear = CAR.gear
	end
	local gear = tostring(CAR.gear)
	if gear == "0" then
		gear = "N"
	elseif gear == "-1" then
		gear = "R"
	end

	if pedalsSettings.store.speedActive then
		animateGear(data, 40 * pedalsSettings.store.pedalsScale)
		ui.setCursor(vec2(data.currentWindowWidth + 20 * pedalsSettings.store.pedalsScale, 11 * pedalsSettings.store.pedalsScale) + vec2(0, data.contentTop))
		ui.dwriteTextAligned(
			gear,
			data.fontGear,
			ui.Alignment.Center,
			ui.Alignment.Center,
			vec2(30, 30):scale(pedalsSettings.store.pedalsScale),
			false,
			COLOR.YELLOW_DARK
		)
	else
		animateGear(data, 45 * pedalsSettings.store.pedalsScale)
		ui.setCursor(vec2(data.currentWindowWidth + 20 * pedalsSettings.store.pedalsScale, 15 * pedalsSettings.store.pedalsScale) + vec2(0, data.contentTop))
		ui.dwriteTextAligned(
			gear,
			data.fontGear,
			ui.Alignment.Center,
			ui.Alignment.Center,
			vec2(30, 40):scale(pedalsSettings.store.pedalsScale),
			false,
			COLOR.YELLOW_DARK
		)
	end
end

return gear
