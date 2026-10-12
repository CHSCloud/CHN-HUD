---@class fuelData
---@field windowWidth number
---@field windowHeight number
---@field fontTitle number
---@field fontContent number
local fuelData = {}

---@return fuelData
function fuelData.new()
	return {
        windowWidth = 0,
        windowHeight = 0,
        fontTitle = 16,
        fontContent = 10,
    }
end

return fuelData
