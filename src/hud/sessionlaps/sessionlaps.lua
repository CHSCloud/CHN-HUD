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
    ui.drawRectFilled(vec2(0, 0), vec2(145, 50), rgbm(0, 0, 0, 0.40), 5)
    --Best Lap
    if bestlap == "00:00.000" then
        bestlap = "--.--.--"
        ui.dwriteTextAligned(language.get("BEST") .. bestlap, 15, ui.Alignment.Center, ui.Alignment.Center, vec2(145, 25), false, rgbm(1, 1, 1, 1))
    else
        ui.dwriteTextAligned(language.get("BEST") .. bestlap, 15, ui.Alignment.Center, ui.Alignment.Center, vec2(145, 25), false, rgbm(1, 1, 1, 1))
    end
    --Last Lap
    if lastlap == "00:00.000" then
        lastlap = "--.--.--"
        ui.dwriteTextAligned(language.get("LAST") .. lastlap, 15, ui.Alignment.Center, ui.Alignment.Start, vec2(145, 25), false, rgbm(1, 1, 1, 1))
    else
        ui.dwriteTextAligned(language.get("LAST") .. lastlap, 15, ui.Alignment.Center, ui.Alignment.Start, vec2(145, 25), false, rgbm(1, 1, 1, 1))
    end
end

return sessionlaps