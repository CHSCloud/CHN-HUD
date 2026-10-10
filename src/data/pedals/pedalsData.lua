local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local utils = require("common.utils")

---@class pedalsData
---@field currentWindowSize vec2
---@field currentWindowWidth number
---@field currentWindowHeight number
---@field contentTop number
---@field contentMidle number
---@field contentBottom number
---@field currentGear number
---@field fontGear number
---@field gearBackgroundWidth number
---@field fontSpeed number
---@field initDRSActivation number
---@field oldKersCharge number
---@field fontBar any
---@field fontBarInfinite any
---@field fontContentBottom any
---@field barSize any
---@field barSpace any
---@field barLimitSize any
---@field barMidleSize any
---@field barPaddingMidle any
---@field contentPositions vec2[][]
---@field initFuelInLap number
---@field fuelPerLap number[]
---@field lapCount number
---@field throttleTelemetry table
---@field brakeTelemetry table
---@field clutchTelemetry table
---@field handbrakeTelemetry table
---@field lastTelemetryPeriod number
local pedalsData = {}

---@param points number
---@return table
local function getEmptyTableDefault(points)
	local table = {}
	for i = 1, points, 1 do
		table[i] = 0
	end
	return table
end

---@param points number
---@return table
local function getEmptyTableBrake(points)
	local table = {}
	for i = 1, points, 1 do
		table[i] = {}
		table[i].value = 0
		table[i].absAction = false
	end
	return table
end

---@return pedalsData
function pedalsData.new()
	return {
		currentWindowSize = vec2(0, 0),
		currentWindowWidth = 0,
		currentWindowHeight = 0,
		contentTop = 0,
		contentMidle = 0,
		contentBottom = 0,
		currentGear = 0,
		fontGear = 0,
		gearBackgroundWidth = 0,
		fontSpeed = 0,
		initDRSActivation = 0,
		oldKersCharge = 0,
		fontBar = nil,
		fontBarInfinite = nil,
		fontContentBottom = nil,
		barSize = nil,
		barSpace = nil,
		barLimitSize = nil,
		barMidleSize = nil,
		barPaddingMidle = nil,
		contentPositions = {},
		initFuelInLap = nil,
		fuelPerLap = {},
		lapCount = 0,
		throttleTelemetry = getEmptyTableDefault(pedalsSettings.store.telemetryPeriod),
		brakeTelemetry = getEmptyTableBrake(pedalsSettings.store.telemetryPeriod),
		clutchTelemetry = getEmptyTableDefault(pedalsSettings.store.telemetryPeriod),
		handbrakeTelemetry = getEmptyTableDefault(pedalsSettings.store.telemetryPeriod),
		lastTelemetryPeriod = pedalsSettings.store.telemetryPeriod,
	}
end
---@param tlb table
---@param newSize number
local function resizeTelemetryDefault(tlb, newSize)
	local currentSize = #tlb
	if newSize < currentSize then
		table.move(tlb, newSize, currentSize, newSize)
	elseif newSize > currentSize then
		for i = currentSize + 1, newSize do
			tlb[i] = 0
		end
	end
end

---@param tlb table
---@param newSize number
local function resizeTelemetryBrake(tlb, newSize)
	local currentSize = #tlb
	if newSize < currentSize then
		table.move(tlb, newSize, currentSize, newSize)
	elseif newSize > currentSize then
		for i = currentSize + 1, newSize do
			tlb[i] = {}
			tlb[i].value = 0
			tlb[i].absAction = false
		end
	end
end

---@param data pedalsData
function pedalsData.remapTelemetry(data)
	resizeTelemetryDefault(data.throttleTelemetry, pedalsSettings.store.telemetryPeriod)
	resizeTelemetryBrake(data.brakeTelemetry, pedalsSettings.store.telemetryPeriod)
	resizeTelemetryDefault(data.clutchTelemetry, pedalsSettings.store.telemetryPeriod)
	resizeTelemetryDefault(data.handbrakeTelemetry, pedalsSettings.store.telemetryPeriod)
end

---@param data pedalsData
---@param windowSize vec2
function pedalsData.resetContentPositions(data, windowSize)
	local distanceLeft = 0
	local distanceRight = windowSize.x
	if pedalsSettings.store.telemetryActive and pedalsSettings.store.telemetryPos == 1 then
		distanceLeft = pedalsSettings.store.telemetryLenght * pedalsSettings.store.pedalsScale
	end
	if pedalsSettings.store.telemetryActive and pedalsSettings.store.telemetryPos == 2 then
		distanceRight = windowSize.x - (pedalsSettings.store.telemetryLenght * pedalsSettings.store.pedalsScale + 60 * pedalsSettings.store.pedalsScale)
	end
	data.contentPositions = {
		{ vec2(distanceLeft, 0), vec2(0, 0) },
		{ vec2(distanceRight, 0), vec2(0, 0) },
		{ vec2(distanceLeft, windowSize.y), vec2(0, 0) },
		{ vec2(distanceRight, windowSize.y), vec2(0, 0) },
		{ vec2(windowSize.x / 2, 0), vec2(0, 0) },
		{ vec2(windowSize.x / 2, windowSize.y), vec2(0, 0) },
	}
end

---@param data pedalsData
---@param pos number
---@param size vec2
function pedalsData.setPositionContentBorder(data, pos, size)
	local positions = data.contentPositions[pos]

	if positions[1].x == data.currentWindowSize.x then
		positions[1].x = positions[1].x - size.x
	end

	if positions[1].y > 0 then
		positions[1].y = positions[1].y - size.y
	end

	positions[2] = size
end

---@param data pedalsData
---@param pos number
---@param size vec2
function pedalsData.setPositionContentCenter(data, pos, size)
	local positions = data.contentPositions[pos]

	if positions[1].y > 0 then
		positions[1].y = positions[1].y - size.y
	end

	positions[2] = size
end

return pedalsData
