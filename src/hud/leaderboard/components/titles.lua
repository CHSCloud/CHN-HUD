local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")
local titles = {}

---@param title string
---@param data leaderboardData
---@param textLenght number
local function drawTitle(title, data, textLenght)
    ui.setCursor(vec2(data.posX, 0):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned(title, 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center,
        ui.Alignment.Center, vec2(textLenght, data.posY):scale(leaderboardSettings.store.leaderboardScale),
        false, COLOR.BLACK)
    data.posX = data.posX + textLenght
end

---@param data leaderboardData
function titles.drawTitles(data)
    data.posX = data.positionLenght
    data.posY = 35
    ui.setCursor(vec2(7, 0):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned("Pos", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment
    .Center, vec2(35, data.posY):scale(leaderboardSettings.store.leaderboardScale), false, COLOR.BLACK)

    ui.setCursor(vec2(90, 0):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned("Driver name", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Start,
        ui.Alignment.Center, vec2(200, data.posY):scale(leaderboardSettings.store.leaderboardScale), false, COLOR.BLACK)

    for index = 1, 6, 1 do
        if index == leaderboardSettings.store.tyrePos and leaderboardSettings.store.tyreActive then
            drawTitle("Tyre", data, data.tyreLenght)

        elseif index == leaderboardSettings.store.lapCountPos and leaderboardSettings.store.lapCountActive then
            drawTitle("Lap", data, data.lapCountLenght)

        elseif index == leaderboardSettings.store.lastLapPos and leaderboardSettings.store.lastLapLeaderboardActive then
            drawTitle("Last", data, data.lastLapLenght)

        elseif index == leaderboardSettings.store.gapPos and leaderboardSettings.store.gapActive then
            drawTitle("Gap", data, data.gapLenght)

        elseif index == leaderboardSettings.store.overtakeArrowsPos and leaderboardSettings.store.overtakeArrowsActive then
            data.posX = data.posX + data.overtakingLenght

        elseif index == leaderboardSettings.store.statusPos and leaderboardSettings.store.statusActive then
            drawTitle("Status", data, data.statusLenght)
        end
    end
end

return titles
