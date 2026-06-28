local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")
local position = {}

-- Desenha posições
---@param data leaderboardData
---@param driverDrawNumber number
---@param carPosition number
---@param driverName string
---@param pos vec2
---@param color rgbm
function position.drawPosition(data, logoPath, driverDrawNumber, carPosition, driverName, pos, color)
    local backgroundColor
    if driverDrawNumber % 2 == 1 then
        backgroundColor = WindowsColor
    else
        backgroundColor = COLOR.GRAY_BG
    end
    ui.drawRectFilled(pos - vec2(0, 2.5):scale(leaderboardSettings.store.leaderboardScale),
        pos + vec2(data.currentWindowSize.x, 32.5 * leaderboardSettings.store.leaderboardScale), backgroundColor)

    -- Desenha posição do jogador
    ui.drawRectFilled(pos + vec2(10):scale(leaderboardSettings.store.leaderboardScale),
        pos + vec2(40, 30):scale(leaderboardSettings.store.leaderboardScale), color,
        5 * leaderboardSettings.store.leaderboardScale)
    ui.setCursor(pos + vec2(10):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned(tostring(carPosition), 20 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center,
        ui.Alignment.Center, vec2(30, 30):scale(leaderboardSettings.store.leaderboardScale), false, COLOR.BLACK)

    -- Desenha logo do carro
    ui.setCursor(pos + vec2(50, 2):scale(leaderboardSettings.store.leaderboardScale))
    ui.image(logoPath, vec2(28, 28):scale(leaderboardSettings.store.leaderboardScale), ui.ImageFit.Fill)

    -- Desenha nome do jogador
    ui.setCursor(pos + vec2(90):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned(driverName, 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Start,
        ui.Alignment.Center, vec2(200, 30):scale(leaderboardSettings.store.leaderboardScale), false, color)
    data.posX = data.posX + data.positionLenght
end

return position
