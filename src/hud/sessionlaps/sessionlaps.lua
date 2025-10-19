require("src.settings.settings")
local language = require("lang.language")
local sessionlaps = {}

previouBestlap = 0

if ac.onSessionStart then
    ac.onSessionStart(function()
        previouBestlap = 0
    end)
end

function sessionlaps.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- FONT TEXT

    -- BACKGROUND
    ui.drawRectFilled(vec2(0, 0), vec2(240, 50), WindowsColor, 5)
    -- BACKGROUND IMAGEM
    ui.setCursor(vec2(-60,1))
    ui.image("assets/lapbackground.png", vec2(240, 24):scale(0.9), rgbm.from0255(119, 118, 124, 1), ui.ImageFit.Fit)
    ui.setCursor(vec2(-60,27))
    ui.image("assets/lapbackground.png", vec2(240, 24):scale(0.9), rgbm.from0255(119, 118, 124, 1), ui.ImageFit.Fit)
    -- LINE
    ui.drawRectFilled(vec2(5, 26), vec2(235, 26), rgbm.from0255(119, 118, 124, 0.3), 1)

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
    ui.setCursor(vec2(20,0))
    ui.dwriteTextAligned(lastLap, 15, ui.Alignment.End, ui.Alignment.Center, vec2(160, 25), false, rgbm.from0255(255, 255, 255, 1))

    if CAR.previousLapTimeMs == CAR.bestLapTimeMs and CAR.isLastLapValid then
        previouBestlap = CAR.bestLapTimeMs
    end

    -- BEST LAP
    if previouBestlap == 0 then
        bestLap = "-.---"
    else
        minutes = previouBestlap / 60E3
        seconds = (minutes %1) * 60
        milliseconds = math.round((seconds % 1) * 1000)
        if minutes < 1 then
            bestLap = string.format("%d.%03d", seconds, milliseconds)
        else
            bestLap = string.format("%d:%02d.%03d", minutes, seconds, milliseconds)
        end
    end
    ui.setCursor(vec2(20,27))
    ui.dwriteTextAligned(bestLap, 15, ui.Alignment.End, ui.Alignment.Center, vec2(160, 25), false, rgbm.from0255(255, 255, 255, 1))

    
    -- TEXT BEST
    ui.setCursor(vec2(9,25))
    ui.dwriteTextAligned(language.get("BEST"), 15, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25), false, WindowsColor)
    -- TEXT LAST
    ui.setCursor(vec2(9,0))
    ui.dwriteTextAligned(language.get("LAST"), 15, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25), false, WindowsColor)
end

return sessionlaps