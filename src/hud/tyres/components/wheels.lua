local tyresSettings = require("src.settings.tabs.tyresSettings")
local rect = require("src.ui.background.rect")
local utils = require("common.utils")
local wheels = {}

---@param lutData ac.DataLUT11
---@param currentTemp number
---@param initTemp number
---@param finalTemp number
---@param initialColor rgbm
---@param middleColor rgbm
---@param finalColor rgbm
---@return rgbm
local function getColorByTemperature(lutData, currentTemp, initTemp, finalTemp, initialColor, middleColor, finalColor)
	local gripOptimum = lutData:get(initTemp)
	local currentGrip = lutData:get(currentTemp)
	local transition = utils.remapIntervalWithLimits(currentGrip, gripOptimum * 0.97, gripOptimum, 0, 1)
	if currentTemp < initTemp then
		return utils.colorLerp(initialColor, middleColor, transition)
	elseif currentTemp >= initTemp and currentTemp <= finalTemp then
		return middleColor
	else
		return utils.colorLerp(finalColor, middleColor, transition)
	end
end

---@param lutData ac.DataLUT11
---@param wheel ac.StateWheel
---@param pos vec2
---@param initTemp number
---@param finalTemp number
local function drawWheel(lutData, wheel, pos, initTemp, finalTemp)
	local color
	color = getColorByTemperature(lutData, wheel.tyreInsideTemperature, initTemp, finalTemp, COLOR.BLUE, COLOR.GREEN, COLOR.RED)
	rect.drawRectRounded(pos, pos + vec2(14, 70):scale(tyresSettings.store.tyresScale), color, 50 * tyresSettings.store.tyresScale,20, ui.CornerFlags.Left)

	color = getColorByTemperature(lutData, wheel.tyreMiddleTemperature, initTemp, finalTemp, COLOR.BLUE, COLOR.GREEN, COLOR.RED)
	ui.drawRectFilled(pos + vec2(16):scale(tyresSettings.store.tyresScale), pos + vec2(30, 70):scale(tyresSettings.store.tyresScale), color)

	color = getColorByTemperature(lutData, wheel.tyreOutsideTemperature, initTemp, finalTemp, COLOR.BLUE, COLOR.GREEN, COLOR.RED)
	rect.drawRectRounded(
		pos + vec2(32):scale(tyresSettings.store.tyresScale),
		pos + vec2(46, 70):scale(tyresSettings.store.tyresScale),
		color,
		50 * tyresSettings.store.tyresScale,
		20,
		ui.CornerFlags.Right
	)

	if wheel.ndSlip > 1 then
		local init = 21 - utils.remapIntervalWithLimits(wheel.ndSlip, 1, 5, 0, 21)
		local final = 25 + utils.remapIntervalWithLimits(wheel.ndSlip, 1, 5, 0, 21)
		rect.drawPillFilled(
			pos + vec2(init, 30):scale(tyresSettings.store.tyresScale),
			pos + vec2(final, 40):scale(tyresSettings.store.tyresScale),
			COLOR.RED,
			20
		)
	end
end

---@param pos vec2
local function drawWheelBroken(pos)
	ui.drawRectFilled(pos, pos + vec2(14, 70):scale(tyresSettings.store.tyresScale), COLOR.GRAY_BG, 10 * tyresSettings.store.tyresScale, ui.CornerFlags.Left)

	ui.drawRectFilled(pos + vec2(16):scale(tyresSettings.store.tyresScale), pos + vec2(30, 70):scale(tyresSettings.store.tyresScale), COLOR.GRAY_BG)

	ui.drawRectFilled(
		pos + vec2(32):scale(tyresSettings.store.tyresScale),
		pos + vec2(46, 70):scale(tyresSettings.store.tyresScale),
		COLOR.GRAY_BG,
		10 * tyresSettings.store.tyresScale,
		ui.CornerFlags.Right
	)
end

---@param data tyresData
---@param pos vec2
---@param index number
function wheels.drawWheelInfo(data, pos, index)
	local posWheel = pos + vec2(50):scale(tyresSettings.store.tyresScale)
	local textAligment = ui.Alignment.End
	local posPsi = pos - vec2(30):scale(tyresSettings.store.tyresScale)
	local posPsiDelta = pos + vec2(-30, 23):scale(tyresSettings.store.tyresScale)
	local posCoreTemp = pos + vec2(-30, 50):scale(tyresSettings.store.tyresScale)
	local posWear = pos + vec2(50, -22):scale(tyresSettings.store.tyresScale)

	if index == 1 or index == 3 then
		posWheel = pos
		posPsi = pos + vec2(56):scale(tyresSettings.store.tyresScale)
		posPsiDelta = pos + vec2(56, 23):scale(tyresSettings.store.tyresScale)
		textAligment = ui.Alignment.Start
		posCoreTemp = pos + vec2(56, 50):scale(tyresSettings.store.tyresScale)
		posWear = pos + vec2(0, -22):scale(tyresSettings.store.tyresScale)
	end

	local wheel = data.wheels[index]
	local initTemp = data.thermal[index + 1].min
	local finalTemp = data.thermal[index + 1].max

	if wheel.isBlown then
		drawWheelBroken(posWheel)
	else
		drawWheel(data.thermal[index + 1].lutData, wheel, posWheel, initTemp, finalTemp)
		local colorWear
		if (1 - wheel.tyreWear) >= 0.5 then
			colorWear = utils.colorLerp(COLOR.WHITE, COLOR.YELLOW, utils.remapIntervalWithLimits((1 - wheel.tyreWear), 1, 0.5, 0, 1))
		elseif (1 - wheel.tyreWear) < 0.5 then
			colorWear = utils.colorLerp(COLOR.YELLOW, COLOR.RED, utils.remapIntervalWithLimits((1 - wheel.tyreWear), 0.5, 0, 0, 1))
		end

		if tyresSettings.store.wearActive then
			ui.setCursor(posWear)
			ui.dwriteTextAligned(
				string.format("%0.f%%", (1 - wheel.tyreWear) * 100),
				15 * tyresSettings.store.tyresScale,
				ui.Alignment.Center,
				ui.Alignment.Center,
				vec2(50, 20):scale(tyresSettings.store.tyresScale),
				false,
				colorWear
			)
		end

		if tyresSettings.store.psiActive then
			ui.setCursor(posPsi)
			ui.dwriteTextAligned(
				string.format("%0.f psi", wheel.tyrePressure),
				16 * tyresSettings.store.tyresScale,
				textAligment,
				ui.Alignment.Center,
				vec2(70, 20):scale(tyresSettings.store.tyresScale)
			)
		end

		if tyresSettings.store.psiDeltaActive then
			local psiDelta = wheel.tyrePressure - data.pressure[index + 1].ideal
			local psiDeltaString = ""
			if psiDelta > 0 then
				psiDeltaString = string.format("+" .. "%0.2f psi", math.abs(psiDelta))
			else
				psiDeltaString = string.format("-" .. "%0.2f psi", math.abs(psiDelta))
			end
			local psiDeltaColor = utils.colorLerp(COLOR.BLUE_SKY, COLOR.GREEN, utils.remapIntervalWithLimits(psiDelta, -2, 2, 0, 1))
			ui.setCursor(posPsiDelta)
			ui.dwriteTextAligned(
				psiDeltaString,
				12 * tyresSettings.store.tyresScale,
				textAligment,
				ui.Alignment.Center,
				vec2(70, 20):scale(tyresSettings.store.tyresScale),
				false,
				psiDeltaColor
			)
		end
		if tyresSettings.store.coreTempActive then
			local tyreCoreColor =
				getColorByTemperature(data.thermal[index + 1].lutData, wheel.tyreCoreTemperature, initTemp, finalTemp, COLOR.BLUE_SKY, COLOR.GREEN, COLOR.RED)
			local tempString
			if SelectedTemperature == 1 then
				tempString = string.format("%0.f ºC", wheel.tyreCoreTemperature)
			else
				tempString = string.format("%0.f ºF", wheel.tyreCoreTemperature * 9 / 5 + 32)
			end
			ui.setCursor(posCoreTemp)
			ui.dwriteTextAligned(
				tempString,
				16 * tyresSettings.store.tyresScale,
				textAligment,
				ui.Alignment.Center,
				vec2(70, 20):scale(tyresSettings.store.tyresScale),
				false,
				tyreCoreColor
			)
		end
	end
end

return wheels
