---@class sessionLapsData
---@field previousBestlap number
---@field currentWindowSize vec2
---@field currentWindowHeight number
---@field currentWindowWidth number
---@field lastLap string
---@field minutes number
---@field seconds number
---@field milliseconds number
---@field bestLap string
---@field currentLap string
---@field sectorsTime table
---@field lastSectorTime number
---@field sectorsDivisions table
local sessionLapsData = {}

---@return sessionLapsData
function sessionLapsData.new()
    return {
        previousBestlap = 0,
        currentWindowSize = vec2(0, 0),
        currentWindowHeight = 0,
        currentWindowWidth = 0,
        lastLap = "-:--.---",
        minutes = 0,
        seconds = 0,
        milliseconds = 0,
        bestLap = "-:--.---",
        currentLap = "0:00.000",
        sectorsTime = {
            [0] = -1,
            [1] = -1,
            [2] = -1
        },
        sectorsDivisions = {
            [0] = {},
            [1] = {},
            [2] = {}
        },
        lastSectorTime = -1
    }
end

---@param data sessionLapsData
---@param numberDivisions number
function sessionLapsData.setSectorsDivisions(data, numberDivisions)
    for i = 0, #SIM.lapSplits - 1 do
        table.clear(data.sectorsDivisions[i])
        local start = SIM.lapSplits[i]
        table.insert(data.sectorsDivisions[i], start)

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
end



function sessionLapsData.resetSectors(data)
    data.sectorsTime = {
        [0] = -1,
        [1] = -1,
        [2] = -1
    }
    data.lastSectorTime = -1
end
return sessionLapsData
