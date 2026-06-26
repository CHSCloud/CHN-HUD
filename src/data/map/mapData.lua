---@class mapData
---@field minPos vec2
---@field maxPos vec2
---@field totalPoints number
---@field mapPoints vec2[]
---@field sectors table
---@field drs table
---@field trackSections table
---@field canvas any
---@field canvasZoom any
---@field canvasSize vec2
---@field canvasCenter vec2
---@field canvasScale number
---@field angle number
---@field offset vec2
---@field padding number
---@field baseWindowSize vec2
---@field currentWindowSize vec2
---@field windowCenter vec2
---@field trackLength number
---@field trackCenterX number
---@field trackCenterY number
---@field isTrackConnected boolean
---@field startTrack vec3
---@field endTrack vec3
---@field dirTrack vec2
---@field transparancy number
local mapData = {}

---@return mapData
function mapData.new()
    local baseWindowSize = vec2(300, 300)
    local currentWindowSize = baseWindowSize
    return {
        minPos = vec2(math.huge, math.huge),
        maxPos = vec2(-math.huge, -math.huge),
        totalPoints = 0,
        mapPoints = {},
        sectors = {},
        drs = {},
        trackSections = {},
        canvas = nil,
        canvasZoom = nil,
        canvasSize = vec2(600, 600),
        canvasCenter = vec2(600 / 2, 600 / 2),
        canvasScale = nil,
        angle = nil,
        offset = vec2(0, 0),
        padding = 40,
        baseWindowSize = baseWindowSize,
        currentWindowSize = currentWindowSize,
        windowCenter = currentWindowSize / 2,
        trackLength = 0,
        trackCenterX = 0,
        trackCenterY = 0,
        isTrackConnected = true,
        startTrack = nil,
        endTrack = nil,
        dirTrack = vec2(0, 0),
        transparancy = 0,
    }
end

return mapData
