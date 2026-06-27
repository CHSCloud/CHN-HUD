---@class leaderboardData
---@field drivers table[]
---@field storedPositions table
---@field currentWindowSize vec2
---@field statusTexts string[]
---@field posY number
---@field posX number
---@field positionLenght number
---@field tyreLenght number
---@field lapCountLenght number
---@field lastLapLenght number
---@field gapLenght number
---@field statusLenght number
---@field overtakingLenght number
local leaderboardData = {}

---@return leaderboardData
function leaderboardData.new()
    return {
        drivers = {},
        storedPositions = {},
        currentWindowSize = vec2(),
        statusTexts = { "OFF", "RET", "END", "PIT" },
        posY = 2.5,
        posX = 0,
        positionLenght = 280,
        tyreLenght = 50,
        lapCountLenght = 60,
        lastLapLenght = 100,
        gapLenght = 80,
        statusLenght = 21,
        overtakingLenght = 70,
    }
end

return leaderboardData
