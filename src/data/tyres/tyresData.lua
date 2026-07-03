---@class tyresData
---@field currentWindowSize vec2
---@field wheels ac.StateWheel[]
---@field lutFrontData ac.DataLUT11
---@field lutRearData ac.DataLUT11
---@field frontMinTemp number
---@field frontMaxTemp number
---@field rearMinTemp number
---@field rearMaxTemp number
local tyresData = {}

---@return tyresData
function tyresData.new()
    return {
        currentWindowSize = vec2(300, 300),
        wheels = CAR.wheels[1],
        lutFrontData = nil,
        lutRearData = nil,
        frontMinTemp = nil,
        frontMaxTemp = nil,
        rearMinTemp = nil,
        rearMaxTemp = nil
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
    data.frontMinTemp = nil
    data.frontMaxTemp = nil
    data.rearMinTemp = nil
    data.rearMaxTemp = nil   
    local tyresConfig = ac.INIConfig.carData(CAR.index, "tyres.ini")
    if tyresConfig ~= nil then
        local sections = tyresConfig['sections']

        local nameLutFrontFile = sections['THERMAL_FRONT']['PERFORMANCE_CURVE'][1]
        local nameLutRearFile = sections['THERMAL_REAR']['PERFORMANCE_CURVE'][1]

        local lutFrontData =  ac.DataLUT11.carData(CAR.index, nameLutFrontFile)
        data.frontMinTemp, data.frontMaxTemp = getTempOptimumRange(lutFrontData)
        data.lutFrontData = lutFrontData
        local lutRearData =  ac.DataLUT11.carData(CAR.index, nameLutRearFile)
        data.rearMinTemp, data.rearMaxTemp = getTempOptimumRange(lutRearData)
        data.lutRearData = lutRearData

        ac.log(data.frontMinTemp)
        ac.log(data.frontMaxTemp)

    end
end

return tyresData