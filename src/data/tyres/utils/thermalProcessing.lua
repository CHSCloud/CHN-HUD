local thermalProcessing = {}

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

---@param lutFiles table
---@return boolean
local function verifyValues(lutFiles)
    for _, value in ipairs(lutFiles) do
        if value == "" then
            return false
        end
    end
    return true
end

---@param lutFiles table
---@param sections ac.INIConfig
local function trySetThermalIndividual(lutFiles, sections)
    if sections['THERMAL_FRONT_1'] and sections['THERMAL_FRONT_1']['PERFORMANCE_CURVE'] then
        lutFiles[1] = sections['THERMAL_FRONT_1']['PERFORMANCE_CURVE'][1] or ""
    end
    if sections['THERMAL_FRONT_2'] and sections['THERMAL_FRONT_2']['PERFORMANCE_CURVE'] then
        lutFiles[2] = sections['THERMAL_FRONT_2']['PERFORMANCE_CURVE'][1] or ""
    end
    if sections['THERMAL_REAR_1'] and sections['THERMAL_REAR_1']['PERFORMANCE_CURVE'] then
        lutFiles[3] = sections['THERMAL_REAR_1']['PERFORMANCE_CURVE'][1] or ""
    end
    if sections['THERMAL_REAR_2'] and sections['THERMAL_REAR_2']['PERFORMANCE_CURVE'] then
        lutFiles[4] = sections['THERMAL_REAR_2']['PERFORMANCE_CURVE'][1] or ""
    end
end

---@param lutFiles table
---@param sections ac.INIConfig
local function trySetThermalSections(lutFiles, sections)
    if sections['THERMAL_FRONT'] and sections['THERMAL_FRONT']['PERFORMANCE_CURVE'] then
        lutFiles[1] = sections['THERMAL_FRONT']['PERFORMANCE_CURVE'][1] or ""
        lutFiles[2] = sections['THERMAL_FRONT']['PERFORMANCE_CURVE'][1] or ""
    end
    if sections['THERMAL_REAR'] and sections['THERMAL_REAR']['PERFORMANCE_CURVE'] then
        lutFiles[3] = sections['THERMAL_REAR']['PERFORMANCE_CURVE'][1] or ""
        lutFiles[4] = sections['THERMAL_REAR']['PERFORMANCE_CURVE'][1] or ""
    end
end

---@param sections ac.INIConfig
---@return table
local function getLutData(sections)
    local lutFiles = {
        "",
        "",
        "",
        ""
    }
    
    trySetThermalIndividual(lutFiles, sections)
    if verifyValues(lutFiles) then
        return lutFiles
    end

    trySetThermalSections(lutFiles, sections)

    return lutFiles
end

---@param data tyresData
---@param sections ac.INIConfig
function thermalProcessing.setThermalConfig(data, sections)
    local lutData = nil
    local lutFiles = getLutData(sections)

    lutData =  ac.DataLUT11.carData(CAR.index, lutFiles[1])
    data.thermal[1].lutData = lutData
    data.thermal[1].min, data.thermal[1].max = getTempOptimumRange(lutData)

    lutData =  ac.DataLUT11.carData(CAR.index, lutFiles[2])
    data.thermal[2].lutData = lutData
    data.thermal[2].min, data.thermal[2].max = getTempOptimumRange(lutData)

    lutData =  ac.DataLUT11.carData(CAR.index, lutFiles[3])
    data.thermal[3].lutData = lutData
    data.thermal[3].min, data.thermal[3].max = getTempOptimumRange(lutData)

    lutData =  ac.DataLUT11.carData(CAR.index, lutFiles[4])
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



return thermalProcessing