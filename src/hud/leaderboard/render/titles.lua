local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")
local titles = {}

---@param data leaderboardData
function titles.drawTitles(data)
    local color = COLOR.BLACK
    data.posX = data.positionLenght
    data.posY = 35
    ui.setCursor(vec2(7, 0):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned("Pos", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment
    .Center, vec2(35, data.posY):scale(leaderboardSettings.store.leaderboardScale), false, color)

    ui.setCursor(vec2(90, 0):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned("Driver name", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Start,
        ui.Alignment.Center, vec2(200, data.posY):scale(leaderboardSettings.store.leaderboardScale), false, color)

    for index = 1, 6, 1 do
        if index == leaderboardSettings.store.tyrePos and leaderboardSettings.store.tyreActive then
            ui.setCursor(vec2(data.posX, 0):scale(leaderboardSettings.store.leaderboardScale))
            ui.dwriteTextAligned("Tyre", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center,
                ui.Alignment.Center, vec2(data.tyreLenght, data.posY):scale(leaderboardSettings.store.leaderboardScale),
                false, color)
            data.posX = data.posX + data.tyreLenght
        elseif index == leaderboardSettings.store.lapCountPos and leaderboardSettings.store.lapCountActive then
            ui.setCursor(vec2(data.posX, 0):scale(leaderboardSettings.store.leaderboardScale))
            ui.dwriteTextAligned("Lap", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center,
                ui.Alignment.Center,
                vec2(data.lapCountLenght, data.posY):scale(leaderboardSettings.store.leaderboardScale), false, color)
            data.posX = data.posX + data.lapCountLenght
        elseif index == leaderboardSettings.store.lastLapPos and leaderboardSettings.store.lastLapActive then
            ui.setCursor(vec2(data.posX, 0):scale(leaderboardSettings.store.leaderboardScale))
            ui.dwriteTextAligned("Last", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center,
                ui.Alignment.Center,
                vec2(data.lastLapLenght, data.posY):scale(leaderboardSettings.store.leaderboardScale), false, color)
            data.posX = data.posX + data.lastLapLenght
        elseif index == leaderboardSettings.store.gapPos and leaderboardSettings.store.gapPos then
            ui.setCursor(vec2(data.posX, 0):scale(leaderboardSettings.store.leaderboardScale))
            ui.dwriteTextAligned("Gap", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center,
                ui.Alignment.Center, vec2(data.gapLenght, data.posY):scale(leaderboardSettings.store.leaderboardScale),
                false, color)
            data.posX = data.posX + data.gapLenght
        elseif index == leaderboardSettings.store.overtakeArrowsPos and leaderboardSettings.store.overtakeArrowsActive then
            data.posX = data.posX + data.overtakingLenght
        elseif index == leaderboardSettings.store.statusPos and leaderboardSettings.store.statusActive then
            ui.setCursor(vec2(data.posX, 0):scale(leaderboardSettings.store.leaderboardScale))
            ui.dwriteTextAligned("Status", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center,
                ui.Alignment.Center, vec2(data.statusLenght, data.posY):scale(leaderboardSettings.store.leaderboardScale),
                false, color)
            data.posX = data.posX + data.statusLenght
        end
    end
end

return titles
