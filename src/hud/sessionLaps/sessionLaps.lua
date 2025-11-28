local sessionLapsSettings = require("src.settings.tabs.sessionLapsSettings")
local language = require("lang.language")
local pinCheckBox = require("src.ui.pinCheckBox")
local config = require("common.config")
local sessionLaps = {}

local previouBestlap = 0

if ac.onSessionStart then
    ac.onSessionStart(function()
        previouBestlap = 0
    end)
end

local currentWindowSize
function sessionLaps.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- FONT TEXT

    local currentWindowWidth = 240 * sessionLapsSettings.store.sessionLapsScale
    local currentWindowHeight = 0
    
    local lastLap
    local minutes
    local seconds
    local milliseconds
    local bestLap
    local currentLap

    -- BACKGROUND
    ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, 5 * sessionLapsSettings.store.sessionLapsScale)

    -- Volta atual
    if sessionLapsSettings.store.currentLapActive then
        ui.setCursor(vec2(-60,1):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.image("assets/lapbackground.png", vec2(216, 21.6):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.WHITE, ui.ImageFit.Fit)
        ui.setCursor(vec2(-60,1):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.image("assets/lapbackground1.png", vec2(216, 21.6):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.YELLOW_DARK, ui.ImageFit.Fit)

        minutes = CAR.lapTimeMs / 60E3
        seconds = (minutes %1) * 60
        milliseconds = math.round((seconds % 1) * 1000)
        currentLap = string.format("%d:%02d.%03d", minutes, seconds, milliseconds)

        if not CAR.isLapValid then 
            ui.setCursor(vec2(132,0):scale(sessionLapsSettings.store.sessionLapsScale))
            ui.dwriteTextAligned("*", 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(160, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, COLOR.RED)
        end
        ui.setCursor(vec2(140,0):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.dwriteTextAligned(currentLap, 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(160, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, COLOR.WHITE)

        -- Texto CURRENT
        ui.setCursor(vec2(9,0):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.dwriteTextAligned(language.get("CURRENT"), 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, rgbm(WindowsColor.r, WindowsColor.g, WindowsColor.b, 1))
        -- LINE
        ui.drawRectFilled(vec2(5, 26):scale(sessionLapsSettings.store.sessionLapsScale), vec2(235, 27):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.GRAY, 1)

        currentWindowHeight = 26
    end
    --

    -- Última volta
    if sessionLapsSettings.store.lastLapActive then
        ui.setCursor(vec2(-60,currentWindowHeight + 1):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.image("assets/lapbackground.png", vec2(216, 21.6):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.WHITE, ui.ImageFit.Fit)
        ui.setCursor(vec2(-60,currentWindowHeight + 1):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.image("assets/lapbackground1.png", vec2(216, 21.6):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.YELLOW_DARK, ui.ImageFit.Fit)
        if CAR.previousLapTimeMs == 0 then
            lastLap = "-:--.---"
        else
            minutes = CAR.previousLapTimeMs / 60E3
            seconds = (minutes %1) * 60
            milliseconds = math.round((seconds % 1) * 1000)
            lastLap = string.format("%d:%02d.%03d", minutes, seconds, milliseconds)
            if not CAR.isLastLapValid then 
                ui.setCursor(vec2(132,currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale))
                ui.dwriteTextAligned("*", 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(160, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, COLOR.RED)
            end
        end
        ui.setCursor(vec2(140,currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.dwriteTextAligned(lastLap, 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(160, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, COLOR.WHITE)
    
        -- Texto LAST
        ui.setCursor(vec2(9,currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.dwriteTextAligned(language.get("LAST"), 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, rgbm(WindowsColor.r, WindowsColor.g, WindowsColor.b, 1))
        -- LINE
        ui.drawRectFilled(vec2(5, currentWindowHeight * 2):scale(sessionLapsSettings.store.sessionLapsScale), vec2(235, currentWindowHeight * 2 + 1):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.GRAY, 1)
        currentWindowHeight = currentWindowHeight + 26
    end
    -- 

    -- Melhor volta
    if CAR.previousLapTimeMs == CAR.bestLapTimeMs and CAR.isLastLapValid then
        previouBestlap = CAR.bestLapTimeMs
    end
    if sessionLapsSettings.store.bestLapActive then
        ui.setCursor(vec2(-60,currentWindowHeight + 1):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.image("assets/lapbackground.png", vec2(216, 21.6):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.WHITE, ui.ImageFit.Fit)
        ui.setCursor(vec2(-60,currentWindowHeight + 1):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.image("assets/lapbackground1.png", vec2(216, 21.6):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.YELLOW_DARK, ui.ImageFit.Fit)

        if previouBestlap == 0 then
            bestLap = "-:--.---"
        else
            minutes = previouBestlap / 60E3
            seconds = (minutes % 1) * 60
            milliseconds = math.round((seconds % 1) * 1000)
            bestLap = string.format("%d:%02d.%03d", minutes, seconds, milliseconds)
        end
        ui.setCursor(vec2(140,currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.dwriteTextAligned(bestLap, 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(160, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, COLOR.WHITE)

        -- Texto BEST
        ui.setCursor(vec2(9,currentWindowHeight - 1):scale(sessionLapsSettings.store.sessionLapsScale))
        ui.dwriteTextAligned(language.get("BEST"), 15 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25):scale(sessionLapsSettings.store.sessionLapsScale), false, rgbm(WindowsColor.r, WindowsColor.g, WindowsColor.b, 1))
        currentWindowHeight = currentWindowHeight + 27
    end
    --
    
    currentWindowSize = vec2(currentWindowWidth, currentWindowHeight * sessionLapsSettings.store.sessionLapsScale)

    config.resize(currentWindowSize, "Session Laps")

    pinCheckBox.main(sessionLapsSettings.store.sessionLapsScale, "Session Laps", config.getWindow("Session Laps"):pinned(), currentWindowSize)
end

return sessionLaps
