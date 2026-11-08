---@class fuelData
---@field windowWidth number
---@field windowHeight number
---@field fontTitle number
---@field fontContent number
---@field previousFuelPerLap number
local fuelData = {}

---@return fuelData
function fuelData.new()
	return {
        windowWidth = 0,
        windowHeight = 0,
        fontTitle = 16,
        fontContent = 10,
        ---@diagnostic disable-next-line: undefined-field
        previousFuelPerLap = ac.storage(ac.getTrackName() .. ac.getCarID(0) .. "previousFuelPerLap", nil):get() or 0
    }
end

return fuelData
