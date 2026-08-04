local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")
local language = require("language.language")
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
    ui.drawRectFilled(vec2(0, 0), vec2(data.currentWindowSize.x, 35 * leaderboardSettings.store.leaderboardScale),
        COLOR.WHITE, 5 * leaderboardSettings.store.leaderboardScale, ui.CornerFlags.Top)
    data.posX = data.positionLenght
    data.posY = 35
    ui.setCursor(vec2(7, 0):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned("Pos", 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Center, ui.Alignment
    .Center, vec2(35, data.posY):scale(leaderboardSettings.store.leaderboardScale), false, COLOR.BLACK)

    ui.setCursor(vec2(90, 0):scale(leaderboardSettings.store.leaderboardScale))
    ui.dwriteTextAligned(language.get("NAME"), 18 * leaderboardSettings.store.leaderboardScale, ui.Alignment.Start,
        ui.Alignment.Center, vec2(data.nameLenght, data.posY):scale(leaderboardSettings.store.leaderboardScale), false, COLOR.BLACK)

    for index = 1, 8, 1 do
        if index == leaderboardSettings.store.tyrePos and leaderboardSettings.store.tyreActive then
            drawTitle(language.get("TYRES"), data, data.tyreLenght)

        elseif index == leaderboardSettings.store.lapCountPos and leaderboardSettings.store.lapCountActive then
            drawTitle(language.get("LAPS"), data, data.lapCountLenght)

        elseif index == leaderboardSettings.store.lastLapPos and leaderboardSettings.store.lastLapLeaderboardActive then
            drawTitle(language.get("LAST"), data, data.lastLapLenght)

        elseif index == leaderboardSettings.store.bestLapPos and leaderboardSettings.store.bestLapLeaderboardActive then
            drawTitle(language.get("BEST"), data, data.bestLapLenght)

        elseif index == leaderboardSettings.store.gapPos and leaderboardSettings.store.gapActive then
            drawTitle(language.get("GAP"), data, data.gapLenght)
        
        elseif index == leaderboardSettings.store.intPos and leaderboardSettings.store.intActive then
            drawTitle(language.get("INT"), data, data.intLenght)

        elseif index == leaderboardSettings.store.overtakeArrowsPos and leaderboardSettings.store.overtakeArrowsActive then
            data.posX = data.posX + data.overtakingLenght

        elseif index == leaderboardSettings.store.statusPos and leaderboardSettings.store.statusActive then
            drawTitle(language.get("STATUS"), data, data.statusLenght)
        end
    end
end

return titles
