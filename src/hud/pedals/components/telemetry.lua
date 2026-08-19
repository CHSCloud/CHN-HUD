local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")
local utils = require("common.utils")

local telemetry = {}
---@param telemetryData table
---@param parameter number
---@param color rgbm
---@param min vec2
---@param max vec2
local function drawGraphDefault(telemetryData, parameter, color, min, max)
	telemetryData[#telemetryData + 1] = utils.smoothValue(telemetryData[#telemetryData], parameter, 0.4)
	table.remove(telemetryData, 1)

	local lenght = (400 * pedalsSettings.store.pedalsScale) / pedalsSettings.store.telemetryPeriod

	ui.pathClear()
	for i, value in ipairs(telemetryData) do
		local xAxis = max.x - (#telemetryData - i) * lenght

		if xAxis >= min.x then
			ui.pathLineTo(vec2(xAxis, max.y - value * (max.y - 10 * pedalsSettings.store.pedalsScale)))
		end
	end
	ui.pathSmoothStroke(color, false, 2 * pedalsSettings.store.pedalsScale)
end

---@param telemetryData table
---@param parameter number
---@param color rgbm
---@param min vec2
---@param max vec2
local function drawGraphDefaultInverted(telemetryData, parameter, color, min, max)
	table.insert(telemetryData, 1, utils.smoothValue(telemetryData[1], parameter, 0.4))
	table.remove(telemetryData, #telemetryData)

	local lenght = (400 * pedalsSettings.store.pedalsScale) / pedalsSettings.store.telemetryPeriod

	ui.pathClear()
	for i, value in ipairs(telemetryData) do
		local xAxis = min.x + i * lenght
		if xAxis < max.x then
			ui.pathLineTo(vec2(xAxis, max.y - value * (max.y - 10 * pedalsSettings.store.pedalsScale)))
		end
	end
	ui.pathSmoothStroke(color, false, 2 * pedalsSettings.store.pedalsScale)
end

---@param telemetryData table
---@param parameter number
---@param color rgbm
---@param min vec2
---@param max vec2
local function drawGraphBrake(telemetryData, parameter, color, min, max)
	telemetryData[#telemetryData + 1] = {}
	telemetryData[#telemetryData].value = utils.smoothValue(telemetryData[#telemetryData - 1].value, parameter, 0.4)
	telemetryData[#telemetryData].absAction = false
	table.remove(telemetryData, 1)

	local lenght = (400 * pedalsSettings.store.pedalsScale) / pedalsSettings.store.telemetryPeriod
	if CAR.absInAction then
		telemetryData[#telemetryData].absAction = true
	end
	if pedalsSettings.store.telemetryAbs then
		local segmentStart = 1
		local currentColor = telemetryData[1].absAction and COLOR.YELLOW or color

		for i = 2, #telemetryData do
			local currentStatus = telemetryData[i].absAction
			local nextColor = currentStatus and COLOR.YELLOW or color

			if nextColor ~= currentColor then
				ui.pathClear()
				for j = segmentStart, i do
					local xAxis = max.x - (#telemetryData - j) * lenght

					if xAxis >= min.x then
						ui.pathLineTo(vec2(xAxis, max.y - telemetryData[j].value * (max.y - 10 * pedalsSettings.store.pedalsScale)))
					end
				end
				ui.pathSmoothStroke(currentColor, false, 2 * pedalsSettings.store.pedalsScale)

				segmentStart = i
				currentColor = nextColor
			end
		end

		ui.pathClear()
		for j = segmentStart, #telemetryData do
			local xAxis = max.x - (#telemetryData - j) * lenght

			if xAxis >= min.x then
				ui.pathLineTo(vec2(xAxis, max.y - telemetryData[j].value * (max.y - 10 * pedalsSettings.store.pedalsScale)))
			end
		end
		ui.pathSmoothStroke(currentColor, false, 2 * pedalsSettings.store.pedalsScale)
	else
		ui.pathClear()
		for i, value in ipairs(telemetryData) do
			local xAxis = max.x - (#telemetryData - i) * lenght

			if xAxis >= min.x then
				ui.pathLineTo(vec2(xAxis, max.y - value.value * (max.y - 10 * pedalsSettings.store.pedalsScale)))
			end
		end
		ui.pathSmoothStroke(color, false, 2 * pedalsSettings.store.pedalsScale)
	end
end

---@param telemetryData table
---@param parameter number
---@param color rgbm
---@param min vec2
---@param max vec2
local function drawGraphBrakeInverted(telemetryData, parameter, color, min, max)
	table.insert(telemetryData, 1, {})
	telemetryData[1].value = utils.smoothValue(telemetryData[2].value, parameter, 0.4)
	telemetryData[1].absAction = false
	table.remove(telemetryData, #telemetryData)

	local lenght = (400 * pedalsSettings.store.pedalsScale) / pedalsSettings.store.telemetryPeriod
	if CAR.absInAction then
		telemetryData[1].absAction = true
	end
	if pedalsSettings.store.telemetryAbs then
		local segmentStart = 1
		local currentColor = telemetryData[1].absAction and COLOR.YELLOW or color

		for i = 2, #telemetryData do
			local currentStatus = telemetryData[i].absAction
			local nextColor = currentStatus and COLOR.YELLOW or color

			if nextColor ~= currentColor then
				ui.pathClear()
				for j = segmentStart, i do
					local xAxis = min.x + j * lenght

					if xAxis < max.x then
						ui.pathLineTo(vec2(xAxis, max.y - telemetryData[j].value * (max.y - 10 * pedalsSettings.store.pedalsScale)))
					end
				end
				ui.pathSmoothStroke(currentColor, false, 2 * pedalsSettings.store.pedalsScale)

				segmentStart = i
				currentColor = nextColor
			end
		end

		ui.pathClear()
		for j = segmentStart, #telemetryData do
			local xAxis = min.x + j * lenght

			if xAxis < max.x then
				ui.pathLineTo(vec2(xAxis, max.y - telemetryData[j].value * (max.y - 10 * pedalsSettings.store.pedalsScale)))
			end
		end
		ui.pathSmoothStroke(currentColor, false, 2 * pedalsSettings.store.pedalsScale)
	else
		ui.pathClear()
		for i, value in ipairs(telemetryData) do
			local xAxis = min.x + i * lenght
			if xAxis < max.x then
				ui.pathLineTo(vec2(xAxis, max.y - value.value * (max.y - 10 * pedalsSettings.store.pedalsScale)))
			end
		end
		ui.pathSmoothStroke(color, false, 2 * pedalsSettings.store.pedalsScale)
	end
end

---@param data pedalsData
function telemetry.drawTelemetry(data)
	data.contentMidle = 73 * pedalsSettings.store.pedalsScale
	if data.lastTelemetryPeriod ~= pedalsSettings.store.telemetryPeriod then
		data.lastTelemetryPeriod = pedalsSettings.store.telemetryPeriod
		pedalsData.remapTelemetry(data)
	end

	local min = vec2(data.currentWindowWidth + 10 * pedalsSettings.store.pedalsScale, 10 * pedalsSettings.store.pedalsScale)
	local max = vec2(
		data.currentWindowWidth + pedalsSettings.store.telemetryLenght * pedalsSettings.store.pedalsScale - 10 * pedalsSettings.store.pedalsScale,
		data.currentWindowSize.y - 10 * pedalsSettings.store.pedalsScale
	)

	local totalHeight = max.y - min.y
	local rectHeight = totalHeight / 6
	local rectWidth = max.x - min.x
	local padding
	local init = min
	for i = 1, 6, 1 do
		if i == 6 then
			padding = 0
		else
			padding = 2 * pedalsSettings.store.pedalsScale
		end

		ui.drawRectFilled(init, init + vec2(rectWidth, rectHeight - padding), COLOR.GRAY_BG)
		init = init + vec2(0, rectHeight)
	end

	local functionGraphDefault
	local functionGraphBrake
	if pedalsSettings.store.telemetryInverted then
		functionGraphDefault = drawGraphDefaultInverted
		functionGraphBrake = drawGraphBrakeInverted
	else
		functionGraphDefault = drawGraphDefault
		functionGraphBrake = drawGraphBrake
	end

	if pedalsSettings.store.telemetryThrottle then
		functionGraphDefault(data.throttleTelemetry, CAR.gas, COLOR.GREEN, min, max)
	end

	if pedalsSettings.store.telemetryBrake then
		functionGraphBrake(data.brakeTelemetry, CAR.brake, COLOR.RED, min, max)
	end

	if pedalsSettings.store.telemetryClucth then
		functionGraphDefault(data.clutchTelemetry, 1 - CAR.clutch, COLOR.BLUE, min, max)
	end

	if pedalsSettings.store.telemetryHandbrake then
		functionGraphDefault(data.handbrakeTelemetry, CAR.handbrake, COLOR.YELLOW, min, max)
	end
end

return telemetry
