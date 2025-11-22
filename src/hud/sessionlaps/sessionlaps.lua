require("src.settings.settings")
local language = require("lang.language")
local pinCheckBox = require("src.ui.pinCheckBox")
local config = require("common.config")
local sessionlaps = {}

local previouBestlap = 0

if ac.onSessionStart then
    ac.onSessionStart(function()
        previouBestlap = 0
    end)
end

function sessionlaps.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- FONT TEXT

    local currentWindowWidth = 240 * WindowSessionLapsScale
    local currentWindowHeight = 50 * WindowSessionLapsScale
    local currentWindowSize
    
    local lastLap
    local minutes
    local seconds
    local milliseconds
    local bestLap

    -- BACKGROUND
    ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, currentWindowHeight), WindowsColor, 5 * WindowSessionLapsScale)
    -- BACKGROUND IMAGEM
    ui.setCursor(vec2(-60,1):scale(WindowSessionLapsScale))
    ui.image("assets/lapbackground.png", vec2(216, 21.6):scale(WindowSessionLapsScale), COLOR.WHITE, ui.ImageFit.Fit)
    ui.setCursor(vec2(-60,1):scale(WindowSessionLapsScale))
    ui.image("assets/lapbackground1.png", vec2(216, 21.6):scale(WindowSessionLapsScale), COLOR.YELLOW_DARK, ui.ImageFit.Fit)
    ui.setCursor(vec2(-60,27):scale(WindowSessionLapsScale))
    ui.image("assets/lapbackground.png", vec2(216, 21.6):scale(WindowSessionLapsScale), COLOR.WHITE, ui.ImageFit.Fit)
    ui.setCursor(vec2(-60,27):scale(WindowSessionLapsScale))
    ui.image("assets/lapbackground1.png", vec2(216, 21.6):scale(WindowSessionLapsScale), COLOR.YELLOW_DARK, ui.ImageFit.Fit)
    -- LINE
    ui.drawRectFilled(vec2(5, 26):scale(WindowSessionLapsScale), vec2(235, 26):scale(WindowSessionLapsScale), COLOR.GRAY, 1)

    -- LAST LAP
    if CAR.previousLapTimeMs == 0 then
        lastLap = "-.---"
    else
        minutes = CAR.previousLapTimeMs / 60E3
        seconds = (minutes %1) * 60
        milliseconds = math.round((seconds % 1) * 1000)
        if minutes < 1 then
            lastLap = string.format("%d.%03d", seconds, milliseconds)
        else
            lastLap = string.format("%d:%02d.%03d", minutes, seconds, milliseconds)
        end
        if not CAR.isLastLapValid then lastLap = "*" .. lastLap end
    end
    ui.setCursor(vec2(20,0):scale(WindowSessionLapsScale))
    ui.dwriteTextAligned(lastLap, 15 * WindowSessionLapsScale, ui.Alignment.End, ui.Alignment.Center, vec2(160, 25):scale(WindowSessionLapsScale), false, COLOR.WHITE)

    if CAR.previousLapTimeMs == CAR.bestLapTimeMs and CAR.isLastLapValid then
        previouBestlap = CAR.bestLapTimeMs
    end

    -- BEST LAP
    if previouBestlap == 0 then
        bestLap = "-.---"
    else
        minutes = previouBestlap / 60E3
        seconds = (minutes % 1) * 60
        milliseconds = math.round((seconds % 1) * 1000)
        if minutes < 1 then
            bestLap = string.format("%d.%03d", seconds, milliseconds)
        else
            bestLap = string.format("%d:%02d.%03d", minutes, seconds, milliseconds)
        end
    end
    ui.setCursor(vec2(20,27):scale(WindowSessionLapsScale))
    ui.dwriteTextAligned(bestLap, 15 * WindowSessionLapsScale, ui.Alignment.End, ui.Alignment.Center, vec2(160, 25):scale(WindowSessionLapsScale), false, COLOR.WHITE)

    
    -- TEXT BEST
    ui.setCursor(vec2(9,25):scale(WindowSessionLapsScale))
    ui.dwriteTextAligned(language.get("BEST"), 15 * WindowSessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25):scale(WindowSessionLapsScale), false, rgbm(WindowsColor.r, WindowsColor.g, WindowsColor.b, 1))
    -- TEXT LAST
    ui.setCursor(vec2(9,0):scale(WindowSessionLapsScale))
    ui.dwriteTextAligned(language.get("LAST"), 15 * WindowSessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25):scale(WindowSessionLapsScale), false, rgbm(WindowsColor.r, WindowsColor.g, WindowsColor.b, 1))

    currentWindowSize = vec2(currentWindowWidth, currentWindowHeight)

    config.resize(currentWindowSize, "Session Laps")

    config.pinWindow("Session Laps", currentWindowSize)

    if config.isMouseInWindow(ui.mouseLocalPos(), currentWindowSize + vec2(20 * WindowSessionLapsScale, 0))then
        config.resize(currentWindowSize + vec2(22 * WindowSessionLapsScale), "Session Laps")
        pinCheckBox.main(vec2(currentWindowWidth + 2 * WindowSessionLapsScale, 10 * WindowSessionLapsScale), WindowSessionLapsScale, config.getWindow("Session Laps"):pinned())
    end
end

return sessionlaps