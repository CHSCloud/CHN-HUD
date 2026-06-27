---@class deltaBarData
---@field currentLapSamples table
---@field previousLapSamples table
---@field lastPreviousLapTimeMs number
---@field sampleResolution number
---@field smoothingAlpha number
---@field smoothedDelta number
---@field smoothedDeltaMeter number
local deltaBarData = {}

---@return deltaBarData
function deltaBarData.new()
    return {
        currentLapSamples = {},
        previousLapSamples = {},
        lastPreviousLapTimeMs = 0,
        sampleResolution = 1000,
        smoothingAlpha = 0.1,
        smoothedDelta = 0,
        smoothedDeltaMeter = 0,
    }
end

---@param data deltaBarData
function deltaBarData.clean(data)
    data.currentLapSamples = {}
    data.previousLapSamples = {}
    data.lastPreviousLapTimeMs = 0
    data.sampleResolution = 1000
    data.smoothingAlpha = 0.1
    data.smoothedDelta = 0
    data.smoothedDeltaMeter = 0
end

return deltaBarData
