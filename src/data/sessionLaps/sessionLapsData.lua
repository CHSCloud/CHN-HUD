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
        lastSectorTime = -1
    }
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
