local pressureProcessing = require("src.data.tyres.utils.pressureProcessing")
local thermalProcessing = require("src.data.tyres.utils.thermalProcessing")

---@class tyresData
---@field currentWindowSize vec2
---@field wheelsPos vec2
---@field wheels ac.StateWheel[]
---@field pressure table<number, pressure>
---@field thermal table<number, thermal>
---@field optThermal thermal
local tyresData = {}

---@class thermal
---@field lutData ac.DataLUT11
---@field min number
---@field max number

---@class pressure
---@field ideal number

---@return tyresData
function tyresData.new()
    return {
        currentWindowSize = vec2(300, 300),
        wheelsPos = vec2(0, 0),
        wheels = CAR.wheels[1],

        pressure = {
            { ideal = -1 }, -- Pneu 1
            { ideal = -1 }, -- Pneu 2
            { ideal = -1 }, -- Pneu 3
            { ideal = -1 }  -- Pneu 4
        },

        thermal = {
            { lutData = nil, min = 0, max = 0 }, -- Pneu 1
            { lutData = nil, min = 0, max = 0 }, -- Pneu 2
            { lutData = nil, min = 0, max = 0 }, -- Pneu 3
            { lutData = nil, min = 0, max = 0 }  -- Pneu 4
        },

        optThermal = { min = math.huge, max = -math.huge },
    } 
end

---@param data tyresData
function tyresData.loadTyresData(data)
    local tyresConfig = ac.INIConfig.carData(CAR.index, "tyres.ini")
    if tyresConfig ~= nil then
        local sections = tyresConfig['sections']

        pressureProcessing.setPressureConfig(data, sections)

        thermalProcessing.setThermalConfig(data, sections)

    end
end

return tyresData