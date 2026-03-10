local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")

local leaderboard = {}


-- Desenha posições
---@param carPosition number
---@param pos vec2
local function drawPositions(carPosition, pos)

    ui.drawRectFilled(pos, pos + vec2(30, 30):scale(leaderboardSettings.store.leaderboardScale), COLOR.WHITE, 5 * leaderboard.store.leaderboardScale)
    
end

function leaderboard.windowMain()

    local currentWindowSize = vec2(500, 500):scale(leaderboardSettings.store.leaderboardScale)
    
    ui.drawRectFilled(vec2(0,0), currentWindowSize, WindowsColor, 5)

    local initPos = 20
    for index, car in ac.iterateCars() do
        
        drawPositions(car.racePosition, vec2(20, initPos):scale(leaderboardSettings.store.leaderboardScale))
    end


    config.resize(currentWindowSize:scale(leaderboardSettings.store.leaderboardScale), "Leaderboard")
    pinCheckBox.main(leaderboardSettings.store.leaderboardScale, "Leaderboard", config.getWindow("Leaderboard"):pinned(), vec2(500,70):scale(leaderboardSettings.store.leaderboardScale))
end

return leaderboard