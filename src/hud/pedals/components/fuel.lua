local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")
local fuel = {}

---@param data pedalsData
---@return string
local function setFuel(data)
	local fuel = ""
	if pedalsSettings.store.fuelOption == 1 then
		if SelectedFuel == 1 then
			fuel = string.format("%.1fL", math.max(0, MY_CAR.fuel))
		else
			fuel = string.format("%.1fgal", math.max(0, MY_CAR.fuel * 0.264172))
		end
	elseif pedalsSettings.store.fuelOption == 2 then
		if data.fuelPerLap == 0 then
			return string.format("--L")
		end
		
		if SelectedFuel == 1 then
			fuel = string.format("%.1fL", data.fuelPerLap)
		else
			fuel = string.format("%.1fL", data.fuelPerLap * 0.264172)
		end
	else
		if data.fuelPerLap == 0 then
			return string.format("--")
		end
		if SelectedFuel == 1 then
			fuel = string.format("%.1f", MY_CAR.fuel / data.fuelPerLap)
		else
			fuel = string.format("%.1f", (MY_CAR.fuel / data.fuelPerLap) * 0.264172)
		end
	end
	return fuel
end

---@param data pedalsData
function fuel.drawFuel(data)
	local fuelColor = COLOR.WHITE
	if MY_CAR.fuel < 5.005 then
		fuelColor = COLOR.RED_DARK
	elseif MY_CAR.fuel < 9.995 then
		fuelColor = COLOR.YELLOW_DARK
	end

	local fuelString = setFuel(data)
	local lenght = ui.measureDWriteText(fuelString, data.fontContentBottom).x
	pedalsData.setPositionContentBorder(data, pedalsSettings.store.fuelPos, vec2(lenght + 25 * pedalsSettings.store.pedalsScale, 20 * pedalsSettings.store.pedalsScale))

	ui.setCursor(data.contentPositions[pedalsSettings.store.fuelPos][1] + vec2(20 * pedalsSettings.store.pedalsScale))
	ui.dwriteTextAligned(
		fuelString,
		data.fontContentBottom,
		ui.Alignment.Start,
		ui.Alignment.Center,
		vec2(lenght, 20):scale(pedalsSettings.store.pedalsScale),
		false,
		fuelColor
	)

	ui.setCursor(data.contentPositions[pedalsSettings.store.fuelPos][1] + vec2(0, 2):scale(pedalsSettings.store.pedalsScale))
	if MY_CAR.fuel < 5.005 then
		if (4 * TIMER) % 2 >= 1 then
			ui.image("assets/pedals/Fuel.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), fuelColor, ui.ImageFit.Fit)
		end
	else
		ui.image("assets/pedals/Fuel.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), fuelColor, ui.ImageFit.Fit)
	end
end

return fuel
