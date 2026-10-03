local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")
local fuel = {}

local function setFuel(data)
	local fuel = ""
	if CAR.lapCount > data.lapCount then
		data.lapCount = CAR.lapCount
		data.fuelPerLap[CAR.lapCount] = data.maxFuelInLap - data.minFuelInLap
		data.maxFuelInLap = -math.huge
		data.minFuelInLap = math.huge
	end

	if CAR.fuel > data.maxFuelInLap then
		data.maxFuelInLap = CAR.fuel
	end

	if CAR.fuel < data.minFuelInLap then
		data.minFuelInLap = CAR.fuel
	end

	if false then
		if SelectedFuel == 1 then
			fuel = string.format("%.2fL", math.max(0, CAR.fuel))
		else
			fuel = string.format("%.2fgal", math.max(0, CAR.fuel * 0.264172))
		end
	else
		local sum = 0
		for i = 1, #data.fuelPerLap do
			sum = sum + data.fuelPerLap[i]
		end
		if #data.fuelPerLap == 0 then
			fuel = "0.00/Lap"
		else
			fuel = string.format("%.2f/Lap", sum / #data.fuelPerLap)
		end
	end
	return fuel
end

---@param data pedalsData
function fuel.drawFuel(data)
	local fuelString = setFuel(data)
	local fuelColor = COLOR.WHITE
	if CAR.fuel < 5.005 then
		fuelColor = COLOR.RED_DARK
	elseif CAR.fuel < 9.995 then
		fuelColor = COLOR.YELLOW_DARK
	end

	pedalsData.setPositionContentBorder(data, pedalsSettings.store.fuelPos, vec2(100, 20):scale(pedalsSettings.store.pedalsScale))

	ui.setCursor(data.contentPositions[pedalsSettings.store.fuelPos][1] + vec2(-4) * pedalsSettings.store.pedalsScale)
	ui.dwriteTextAligned(
		fuelString,
		data.fontContentBottom,
		ui.Alignment.End,
		ui.Alignment.Center,
		vec2(100, 20):scale(pedalsSettings.store.pedalsScale),
		false,
		fuelColor
	)
	ac.log(fuelString)
	local fuelLenght = string.len(fuelString)
	local charWidthUnscaled = (data.fontContentBottom / pedalsSettings.store.pedalsScale) * 0.65
	local xUnscaled = 100 - (fuelLenght * charWidthUnscaled) - 16
	ui.setCursor(data.contentPositions[pedalsSettings.store.fuelPos][1] + vec2(xUnscaled, 2.5):scale(pedalsSettings.store.pedalsScale))
	if CAR.fuel < 5.005 then
		if (4 * TIMER) % 2 >= 1 then
			ui.image("assets/pedals/Fuel.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), fuelColor, ui.ImageFit.Fit)
		end
	else
		ui.image("assets/pedals/Fuel.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), fuelColor, ui.ImageFit.Fit)
	end
end

return fuel
