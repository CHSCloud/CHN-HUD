local language = require("lang.language")
local sessionlaps = {}

function sessionlaps.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- Fonte do texto
    -- Last lap Milisegundos para Minutos
    local lasttimeinseconds = CAR.previousLapTimeMs / 1000
    local lastminutos = math.floor(lasttimeinseconds / 60)
    local lastseconds = lasttimeinseconds % 60
    local lastlap = string.format("%02d:%06.3f", lastminutos, lastseconds)

    -- Best lap Milisegundos para Minutos
    local besttimeinseconds = CAR.bestLapTimeMs / 1000
    local bestminutos = math.floor(besttimeinseconds / 60)
    local bestseconds = besttimeinseconds % 60
    local bestlap = string.format("%02d:%06.3f", bestminutos, bestseconds)

    -- Janela
    ui.drawRectFilled(vec2(0, 0), vec2(240, 50), rgbm(0, 0, 0, 0.7), 5)
    -- Linhas
    ui.drawRectFilled(vec2(5, 26), vec2(235, 26), rgbm(255, 255, 255, 0.3), 2)

    --Best Lap
    if bestlap == "00:00.000" then
        bestlap = "--.--.--"
        ui.dwriteTextAligned(bestlap, 15, ui.Alignment.Center, ui.Alignment.Center, vec2(230, 25), false, rgbm(1, 1, 1, 1))
    else
        ui.dwriteTextAligned(bestlap, 15, ui.Alignment.Center, ui.Alignment.Center, vec2(230, 25), false, rgbm(1, 1, 1, 1))
    end
    --Last Lap
    if lastlap == "00:00.000" then
        lastlap = "--.--.--"
        ui.dwriteTextAligned(lastlap, 14, ui.Alignment.Center, ui.Alignment.Start, vec2(230, 25), false, rgbm(1, 1, 1, 1))
    else
        ui.dwriteTextAligned(lastlap, 14, ui.Alignment.Center, ui.Alignment.Start, vec2(230, 25), false, rgbm(1, 1, 1, 1))
    end

    ui.setCursor(vec2(5,0))
    ui.dwriteTextAligned(language.get("BEST"), 15, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25), false, rgbm(255, 255, 0, 1))
    ui.setCursor(vec2(5,25))
    ui.dwriteTextAligned(language.get("LAST"), 15, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 25), false, rgbm(255, 255, 0, 1))
    
end

return sessionlaps