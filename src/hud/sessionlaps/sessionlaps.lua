local language = require("lang.language")
local sessionlaps = {}

function sessionlaps.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- FONT TEXT

    -- BACKGROUND
    ui.drawRectFilled(vec2(0, 0), vec2(240, 50), rgbm.from0255(18, 21, 29, 0.65), 5)
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
    ui.dwriteTextAligned(lastLap, 15, ui.Alignment.End, ui.Alignment.Center, vec2(160, 25), false, rgbm.from0255(255, 255, 255, 1))

    -- BEST LAP
    if CAR.bestLapTimeMs == 0 then
        bestLap = "-.---"
    else
        minutes = CAR.bestLapTimeMs / 60E3
        seconds = (minutes %1) * 60
        milliseconds = math.round((seconds % 1) * 1000)
        if minutes < 1 then
            bestLap = string.format("%d.%03d", seconds, milliseconds)
        else
            bestLap = string.format("%d:%02d.%03d", minutes, seconds, milliseconds)
        end
    end
    ui.dwriteTextAligned(bestLap, 15, ui.Alignment.End, ui.Alignment.Center, vec2(160, 25), false, rgbm.from0255(255, 255, 255, 1))

    -- TEXT BEST
    ui.setCursor(vec2(5,25))
    ui.dwriteTextAligned(language.get("BEST"), 15, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25), false, rgbm.from0255(255, 203, 0, 1))
    -- TEXT LAST
    ui.setCursor(vec2(5,0))
    ui.dwriteTextAligned(language.get("LAST"), 15, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25), false, rgbm.from0255(255, 203, 0, 1))
end

return sessionlaps