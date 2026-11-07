---@class fuelData
---@field windowWidth number
---@field windowHeight number
---@field fontTitle number
---@field fontContent number
---@field fuelPerLap number
local fuelData = {}

---@return fuelData
function fuelData.new()
	return {
        windowWidth = 0,
        windowHeight = 0,
        fontTitle = 16,
        fontContent = 10,
        ---@diagnostic disable-next-line: undefined-field
        fuelPerLap = ac.storage(ac.getTrackName() .. ac.getCarID(0) .. "fuelPerLap", nil):get() or CAR.fuelPerLap
    }
end

return fuelData
