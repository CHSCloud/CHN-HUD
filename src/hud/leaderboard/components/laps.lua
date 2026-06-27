local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")
local lap = {}

-- Desenha contagem de voltas
---@param data leaderboardData
---@param lap number
---@param pos vec2
function lap.drawLapCount(data, lap, pos, color)
    if leaderboardSettings.store.lapCountActive then
        ui.setCursor(pos)
        ui.dwriteTextAligned(tostring(lap + 1), 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center,
            ui.Alignment.Center, vec2(data.lapCountLenght, 30):scale(leaderboardSettings.store.leaderboardScale), false,
            color)
        data.posX = data.posX + data.lapCountLenght
    end
end

-- Desenha tempo da última volta
---@param data leaderboardData
---@param time number
---@param pos vec2
function lap.drawLastLap(data, time, pos, color)
    if leaderboardSettings.store.lastLapActive then
        local lastLapText
        if time == 0 then
            lastLapText = "-:--.---"
        else
            local minutes = time / 60E3
            local seconds = (minutes % 1) * 60
            local milliseconds = math.round((seconds % 1) * 1000)
            lastLapText = string.format("%d:%02d.%03d", minutes, seconds, milliseconds)
        end
        ui.setCursor(pos)
        ui.dwriteTextAligned(lastLapText, 20 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center,
            ui.Alignment.Center, vec2(data.lastLapLenght, 30):scale(leaderboardSettings.store.leaderboardScale), false,
            color)
        data.posX = data.posX + data.lastLapLenght
    end
end

return lap
