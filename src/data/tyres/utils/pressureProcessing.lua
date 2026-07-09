local pressureProcessing = {}

---@param data tyresData
---@return boolean
local function verifyValues(data)
    for _, value in ipairs(data.pressure) do
        if value.ideal == -1 then
            return false
        end
    end
    return true
end

---@param data tyresData
---@param sections ac.INIConfig
local function trySetPressureIndividual(data, sections)
    if sections['FRONT_1'] and sections['FRONT_1']['PRESSURE_IDEAL'] then
        data.pressure[1].ideal = tonumber(sections['FRONT_1']['PRESSURE_IDEAL'][1]) or -1
    end
    if sections['FRONT_2'] and sections['FRONT_2']['PRESSURE_IDEAL'] then
        data.pressure[2].ideal = tonumber(sections['FRONT_2']['PRESSURE_IDEAL'][1]) or -1
    end
    if sections['REAR_1'] and sections['REAR_1']['PRESSURE_IDEAL'] then
        data.pressure[3].ideal = tonumber(sections['REAR_1']['PRESSURE_IDEAL'][1]) or -1
    end
    if sections['REAR_2'] and sections['REAR_2']['PRESSURE_IDEAL'] then
        data.pressure[4].ideal = tonumber(sections['REAR_2']['PRESSURE_IDEAL'][1]) or -1
    end
end

---@param data tyresData
---@param sections ac.INIConfig
local function trySetPressureSections(data, sections)
    if sections['FRONT'] and sections['FRONT']['PRESSURE_IDEAL'] then
        data.pressure[1].ideal = tonumber(sections['FRONT']['PRESSURE_IDEAL'][1]) or -1
        data.pressure[2].ideal = tonumber(sections['FRONT']['PRESSURE_IDEAL'][1]) or -1
    end
    if sections['REAR'] and sections['REAR']['PRESSURE_IDEAL'] then
        data.pressure[3].ideal = tonumber(sections['REAR']['PRESSURE_IDEAL'][1]) or -1
        data.pressure[4].ideal = tonumber(sections['REAR']['PRESSURE_IDEAL'][1]) or -1
    end
end

---@param data tyresData
---@param sections ac.INIConfig
function pressureProcessing.setPressureConfig(data, sections)

    trySetPressureIndividual(data, sections)
    if verifyValues(data) then
        return
    end

    trySetPressureSections(data, sections)
    if verifyValues(data) then
        return
    end

    for i = 1, table.count(data.pressure), 1 do
        data.pressure[i].ideal = 30
    end
end



return pressureProcessing