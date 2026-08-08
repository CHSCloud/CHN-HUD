local sessionLapsSettings = require("src.settings.tabs.sessionLapsSettings")
---@class sessionLapsData
---@field previousBestlap number
---@field currentWindowSize vec2
---@field currentWindowHeight number
---@field currentWindowWidth number
---@field lastLap string
---@field lastLapNumber number
---@field minutes number
---@field seconds number
---@field milliseconds number
---@field bestLap string
---@field currentLap string
---@field sectorsTime table
---@field sectorsDivisions table
---@field lastSectorsDivisionsTime table
---@field currentSectorsDivisionsTime table
---@field lastSectorTime number
---@field currentNumberDivisions number
---@field showLastDivisions boolean
local sessionLapsData = {}

---@return table
local function generateSectorsTime()
	local times = {}
	for i = 0, #SIM.lapSplits - 1 do
		times[i] = -1
	end
	return times
end

---@return table
local function generateDivision()
	local division = {}
	for i = 0, #SIM.lapSplits - 1 do
		division[i] = {}
	end
	return division
end

---@return sessionLapsData
function sessionLapsData.new()
	return {
		previousBestlap = 0,
		currentWindowSize = vec2(0, 0),
		currentWindowHeight = 0,
		currentWindowWidth = 0,
		lastLap = "-:--.---",
		lastLapNumber = CAR.lapCount,
		minutes = 0,
		seconds = 0,
		milliseconds = 0,
		bestLap = "-:--.---",
		currentLap = "0:00.000",
		sectorsTime = generateSectorsTime(),
		sectorsDivisions = generateDivision(),
		lastSectorsDivisionsTime = generateDivision(),
		currentSectorsDivisionsTime = generateDivision(),
		lastSectorTime = -1,
		currentNumberDivisions = sessionLapsSettings.store.numberDivisions,
		showLastDivisions = false,
	}
end

---@param data sessionLapsData
---@param numberDivisions number
function sessionLapsData.setSectorsDivisions(data, numberDivisions)
	for i = 0, #SIM.lapSplits - 1 do
		table.clear(data.sectorsDivisions[i])
		local start = SIM.lapSplits[i]

		local final = SIM.lapSplits[i == #SIM.lapSplits - 1 and 0 or i + 1]

		local distance = final - start
		if distance < 0 then
			distance = distance + 1
		end
		local pass = distance / (numberDivisions + 1)
		for j = 1, numberDivisions do
			local value = start + (j * pass)
			if value >= 1 then
				value = value - 1
			end
			table.insert(data.sectorsDivisions[i], value)
		end
		table.insert(data.sectorsDivisions[i], final)
	end

	for i = 0, #data.lastSectorsDivisionsTime do
		table.clear(data.lastSectorsDivisionsTime[i])
		table.clear(data.currentSectorsDivisionsTime[i])
		for _ = 1, numberDivisions + 1 do
			table.insert(data.lastSectorsDivisionsTime[i], -1)
			table.insert(data.currentSectorsDivisionsTime[i], -1)
		end
	end
end

---@param data sessionLapsData
---@param numberDivisions number
function sessionLapsData.resetCurrentDivision(data, numberDivisions)
	for i = 0, #data.currentSectorsDivisionsTime do
		table.clear(data.currentSectorsDivisionsTime[i])
		for _ = 1, numberDivisions + 1 do
			table.insert(data.currentSectorsDivisionsTime[i], -1)
		end
	end
end

---@param data sessionLapsData
function sessionLapsData.resetSectors(data)
	for i = 0, #SIM.lapSplits - 1 do
		data.sectorsTime[i] = -1
	end
	data.lastSectorTime = -1
end

---@param data sessionLapsData
---@param sectorNumber number
---@param division number
---@return number
function sessionLapsData.getTimeOfDivision(data, sectorNumber, division)
	local lastTimeDivisions = 0
	if sectorNumber == 0 and division == 0 then
		return CAR.lapTimeMs
	end

	for sector = 0, sectorNumber do
		if sector == sectorNumber then
			for div = 1, division - 1 do
				lastTimeDivisions = lastTimeDivisions + data.currentSectorsDivisionsTime[sector][div]
			end
		else
			for div = 1, sessionLapsSettings.store.numberDivisions do
				lastTimeDivisions = lastTimeDivisions + data.currentSectorsDivisionsTime[sector][div]
			end
		end
	end

	return (CAR.lapTimeMs - lastTimeDivisions)
end

return sessionLapsData
