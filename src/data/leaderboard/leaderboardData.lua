local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")
local language = require("language.language")

---@class leaderboardData
---@field drivers table[]
---@field storedPositions table
---@field currentWindowSize vec2
---@field statusTexts string[]
---@field posY number
---@field posX number
---@field positionLenght number
---@field nameLenght number
---@field tyreLenght number
---@field lapCountLenght number
---@field lastLapLenght number
---@field bestLapLenght number
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
        nameLenght = 200,
        tyreLenght = 50,
        lapCountLenght = 60,
        lastLapLenght = 100,
        bestLapLenght = 100,
        gapLenght = 80,
        statusLenght = 21,
        overtakingLenght = 70,
    }
end

---@param data leaderboardData
function leaderboardData.setTitlesLeght(data)
    data.nameLenght = math.max(ui.measureDWriteText(language.get("NAME"), 18).x + 20, 200)
    data.tyreLenght = math.max(ui.measureDWriteText(language.get("TYRES"), 18).x + 20, 50)
    data.lapCountLenght = math.max(ui.measureDWriteText(language.get("LAPS"), 18).x + 20, 60)
    data.lastLapLenght = math.max(ui.measureDWriteText(language.get("LAST"), 18).x + 20, 100)
    data.bestLapLenght = math.max(ui.measureDWriteText(language.get("BEST"), 18).x + 20, 100)
    data.gapLenght = math.max(ui.measureDWriteText(language.get("GAP"), 18).x + 20, 80)
    data.statusLenght = math.max(ui.measureDWriteText(language.get("STATUS"), 18).x + 20, 21)
end

return leaderboardData
