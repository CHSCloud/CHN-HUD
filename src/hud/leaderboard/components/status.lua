local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")
local utils = require("common.utils")
local status = {}

---@param data leaderboardData
---@param statusText string
---@param statusColor rgbm
---@param pos vec2
function status.drawDriverStatus(data, statusText, statusColor, pos)
    if leaderboardSettings.store.statusActive then
        data.statusLenght = utils.findLenghtLongestString(data.statusTexts, 18).x + 40
        ui.setCursor(pos)
        ui.dwriteTextAligned(statusText, 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center,
            ui.Alignment.Center, vec2(data.statusLenght, 30):scale(leaderboardSettings.store.leaderboardScale), false,
            statusColor)
        data.posX = data.posX + data.statusLenght
    end
end

return status
