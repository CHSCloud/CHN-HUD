local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")
local fuel = {}

---@return string
local function setFuel()
	local fuel = ""
	if pedalsSettings.store.fuelOption == 1 then
		if SelectedFuel == 1 then
			fuel = string.format("%.1fL", math.max(0, CAR.fuel))
		else
			fuel = string.format("%.1fgal", math.max(0, CAR.fuel * 0.264172))
		end
	elseif pedalsSettings.store.fuelOption == 2 then
		if SelectedFuel == 1 then
			fuel = string.format("%.1f/Lap", CAR.fuelPerLap)
		else
			fuel = string.format("%.1f/Lap", CAR.fuelPerLap * 0.264172)
		end
	else
		if SelectedFuel == 1 then
			fuel = string.format("%.1f Laps", CAR.fuel / CAR.fuelPerLap)
		else
			fuel = string.format("%.1f Laps", (CAR.fuel / CAR.fuelPerLap) * 0.264172)
		end
	end
	return fuel
end

---@param data pedalsData
function fuel.drawFuel(data)
	if data.initFuelInLap == nil then
		data.initFuelInLap = CAR.fuel
	end
	local fuelColor = COLOR.WHITE
	if CAR.fuel < 5.005 then
		fuelColor = COLOR.RED_DARK
	elseif CAR.fuel < 9.995 then
		fuelColor = COLOR.YELLOW_DARK
	end

	local fuelString = setFuel()
	local lenght = ui.measureDWriteText(fuelString, data.fontContentBottom).x + 23 * pedalsSettings.store.pedalsScale
	pedalsData.setPositionContentBorder(data, pedalsSettings.store.fuelPos, vec2(lenght, 20 * pedalsSettings.store.pedalsScale))

	ui.setCursor(data.contentPositions[pedalsSettings.store.fuelPos][1] + vec2(-4, 1):scale(pedalsSettings.store.pedalsScale))
	ui.dwriteTextAligned(
		fuelString,
		data.fontContentBottom,
		ui.Alignment.End,
		ui.Alignment.Center,
		vec2(lenght, 20 * pedalsSettings.store.pedalsScale),
		false,
		fuelColor
	)

	ui.setCursor(data.contentPositions[pedalsSettings.store.fuelPos][1]+ vec2(0, 2.5 * pedalsSettings.store.pedalsScale))
	if CAR.fuel < 5.005 then
		if (4 * TIMER) % 2 >= 1 then
			ui.image("assets/pedals/Fuel.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), fuelColor, ui.ImageFit.Fit)
		end
	else
		ui.image("assets/pedals/Fuel.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), fuelColor, ui.ImageFit.Fit)
	end
end

return fuel
