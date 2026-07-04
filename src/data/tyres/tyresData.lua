---@class tyresData
---@field currentWindowSize vec2
---@field wheels ac.StateWheel[]
---@field thermal table<number, range>
---@field optThermal range
---@field pressureIdealFront number
---@field pressureIdealRear number
local tyresData = {}

---@class range
---@field lutData ac.DataLUT11
---@field min number
---@field max number

---@return tyresData
function tyresData.new()
    return {
        currentWindowSize = vec2(300, 300),
        wheels = CAR.wheels[1],

        lutFrontData = nil,
        lutRearData = nil,

        thermal = {
            { lutData = nil, min = 0, max = 0 }, -- Pneu 1
            { lutData = nil, min = 0, max = 0 }, -- Pneu 2
            { lutData = nil, min = 0, max = 0 }, -- Pneu 3
            { lutData = nil, min = 0, max = 0 }  -- Pneu 4
        },
        optThermal = { min = math.huge, max = -math.huge },

        pressureIdealFront = nil,
        pressureIdealRear = nil

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

        data.pressureIdealFront = tonumber(sections['FRONT']['PRESSURE_IDEAL'][1]) or -1
        data.pressureIdealRear = tonumber(sections['REAR']['PRESSURE_IDEAL'][1]) or -1

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

        ac.log("Front 1:")
        ac.log(data.thermal[1].min)
        ac.log(data.thermal[1].max)
        ac.log("Front 2:")
        ac.log(data.thermal[2].min)
        ac.log(data.thermal[2].max)
        ac.log("Rear 1:")
        ac.log(data.thermal[3].min)
        ac.log(data.thermal[3].max)
        ac.log("Rear 2:")
        ac.log(data.thermal[4].min)
        ac.log(data.thermal[4].max)
        ac.log("Optimal:")
        ac.log(data.optThermal.min .. " - " .. data.optThermal.max)
    end
end

return tyresData