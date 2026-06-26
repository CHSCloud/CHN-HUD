local sessionLapsSettings = require("src.settings.tabs.sessionLapsSettings")
local language = require("lang.language")
local laps = {}

---@param posY number
local function drawBanner(posY)
    ui.setCursor(vec2(-60,posY + 1):scale(sessionLapsSettings.store.sessionLapsScale))
    ui.image("assets/lapbackground.png", vec2(216, 21.6):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.WHITE, ui.ImageFit.Fit)
    ui.setCursor(vec2(-60,posY + 1):scale(sessionLapsSettings.store.sessionLapsScale))
    ui.image("assets/lapbackground1.png", vec2(216, 21.6):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.YELLOW_DARK, ui.ImageFit.Fit)
end

---@param data sessionLapsData
function laps.drawCurrent(data)
    drawBanner(0)

    data.minutes = CAR.lapTimeMs / 60E3
    data.seconds = (data.minutes %1) * 60
    data.milliseconds = math.round((data.seconds % 1) * 1000)
    data.currentLap = string.format("%d:%02d.%03d", data.minutes, data.seconds, data.milliseconds)

    if not CAR.isLapValid then 
        ui.setCursor(vec2(132,0):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.dwriteTextAligned("*", 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(160, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, COLOR.RED)
    end

    ui.setCursor(vec2(140,0):scale(sessionLapsSettings.store.sessionLapsScale))
    ui.dwriteTextAligned(data.currentLap, 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(160, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, COLOR.WHITE)

    -- Texto CURRENT
    ui.setCursor(vec2(9,0):scale(sessionLapsSettings.store.sessionLapsScale))
    ui.dwriteTextAligned(language.get("CURRENT"), 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, rgbm(WindowsColor.r, WindowsColor.g, WindowsColor.b, 1))
    -- LINE
    ui.drawRectFilled(vec2(5, 26):scale(sessionLapsSettings.store.sessionLapsScale), vec2(235, 27):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.GRAY, 1)

    data.currentWindowHeight = 26
end

---@param data sessionLapsData
function laps.drawLast(data)
    drawBanner(data.currentWindowHeight)

    if CAR.previousLapTimeMs == 0 then
        data.lastLap = "-:--.---"
    else
        data.minutes = CAR.previousLapTimeMs / 60E3
        data.seconds = (data.minutes %1) * 60
        data.milliseconds = math.round((data.seconds % 1) * 1000)
        data.lastLap = string.format("%d:%02d.%03d", data.minutes, data.seconds, data.milliseconds)
        if not CAR.isLastLapValid then 
            ui.setCursor(vec2(132,data.currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale))
            ui.dwriteTextAligned("*", 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(160, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, COLOR.RED)
        end
    end

    ui.setCursor(vec2(140,data.currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale))
    ui.dwriteTextAligned(data.lastLap, 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(160, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, COLOR.WHITE)

    -- Texto LAST
    ui.setCursor(vec2(9,data.currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale))
    ui.dwriteTextAligned(language.get("LAST"), 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, rgbm(WindowsColor.r, WindowsColor.g, WindowsColor.b, 1))
    -- LINE
    data.currentWindowHeight = data.currentWindowHeight + 26
    ui.drawRectFilled(vec2(5, data.currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale), vec2(235, data.currentWindowHeight + 1):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.GRAY, 1)

end

---@param data sessionLapsData
function laps.drawBest(data)
    drawBanner(data.currentWindowHeight)

    if data.previousBestlap == 0 then
        data.bestLap = "-:--.---"
    else
        data.minutes = data.previousBestlap / 60E3
        data.seconds = (data.minutes % 1) * 60
        data.milliseconds = math.round((data.seconds % 1) * 1000)
        data.bestLap = string.format("%d:%02d.%03d", data.minutes, data.seconds, data.milliseconds)
    end

    ui.setCursor(vec2(140,data.currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale))
    ui.dwriteTextAligned(data.bestLap, 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(160, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, COLOR.WHITE)
    
    -- Texto BEST
    ui.setCursor(vec2(9,data.currentWindowHeight - 1):scale(sessionLapsSettings.store.sessionLapsScale))
    ui.dwriteTextAligned(language.get("BEST"), 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, rgbm(WindowsColor.r, WindowsColor.g, WindowsColor.b, 1))
    data.currentWindowHeight = data.currentWindowHeight + 27
end

return laps