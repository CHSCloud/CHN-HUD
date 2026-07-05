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
            { ideal = 0 }, -- Pneu 1
            { ideal = 0 }, -- Pneu 2
            { ideal = 0 }, -- Pneu 3
            { ideal = 0 }  -- Pneu 4
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

---@param lutData ac.DataLUT11
---@return number, number
local function getTempOptimumRange(lutData)
    local minTemp = 0
    local maxTemp = 0
    local maxGrip = -math.huge

    local index = 0
    local input = lutData:getPointInput(index)
    local output = lutData:getPointOutput(index)
    while not math.isnan(input) do
        if output > maxGrip then
            maxGrip = output
            minTemp = input
        end
        if output == maxGrip then
            maxTemp = input
        end
        
        index = index + 1
        input = lutData:getPointInput(index)
        output = lutData:getPointOutput(index)
    end
    return minTemp, maxTemp
end

---@param data tyresData
function tyresData.loadTyresData(data)
    local tyresConfig = ac.INIConfig.carData(CAR.index, "tyres.ini")
    if tyresConfig ~= nil then
        local sections = tyresConfig['sections']

        data.pressure[1].ideal = tonumber(sections['FRONT_1']['PRESSURE_IDEAL'][1]) or 0
        data.pressure[2].ideal = tonumber(sections['FRONT_2']['PRESSURE_IDEAL'][1]) or 0
        data.pressure[3].ideal = tonumber(sections['REAR_1']['PRESSURE_IDEAL'][1]) or 0
        data.pressure[4].ideal = tonumber(sections['REAR_2']['PRESSURE_IDEAL'][1]) or 0

        local nameLutFront1File = sections['THERMAL_FRONT_1']['PERFORMANCE_CURVE'][1]
        local nameLutFront2File = sections['THERMAL_FRONT_2']['PERFORMANCE_CURVE'][1]
        local nameLutRear1File = sections['THERMAL_REAR_1']['PERFORMANCE_CURVE'][1]
        local nameLutRear2File = sections['THERMAL_REAR_2']['PERFORMANCE_CURVE'][1]

        local lutData =  ac.DataLUT11.carData(CAR.index, nameLutFront1File)
        data.thermal[1].lutData = lutData
        data.thermal[1].min, data.thermal[1].max = getTempOptimumRange(lutData)

        lutData =  ac.DataLUT11.carData(CAR.index, nameLutFront2File)
        data.thermal[2].lutData = lutData
        data.thermal[2].min, data.thermal[2].max = getTempOptimumRange(lutData)

        lutData =  ac.DataLUT11.carData(CAR.index, nameLutRear1File)
        data.thermal[3].lutData = lutData
        data.thermal[3].min, data.thermal[3].max = getTempOptimumRange(lutData)

        lutData =  ac.DataLUT11.carData(CAR.index, nameLutRear2File)
        data.thermal[4].lutData = lutData
        data.thermal[4].min, data.thermal[4].max = getTempOptimumRange(lutData)

        for _, range in pairs(data.thermal) do
            if range.min < data.optThermal.min then
                data.optThermal.min = range.min
            end
            if range.max > data.optThermal.max then
                data.optThermal.max = range.max
            end
        end
    end
end

return tyresData