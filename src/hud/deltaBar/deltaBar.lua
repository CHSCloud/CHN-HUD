local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")

local deltaBar = {}

function deltaBar.windowMain()
    --Cores Barra Delta
    local verde = {r= 102, g=213, b=79}
    local branco = {r= 255, g=255, b=255}
    local vermelho = {r= 226, g=9, b=38}

    local delta = CAR.performanceMeter
    local barEndPercent = math.clamp(delta / 2, -1, 1)
    local barEnd = 250 - barEndPercent * 250
    local barColorPercent = math.clamp(CAR.performanceMeterSpeedDifferenceMs / 2, -1, 1)

    --Background Barra Delta
    ui.drawRectFilled(vec2(0, 0), vec2(500, 22), WindowsColor, 10)
    --Background Texto Delta
    ui.drawRectFilled(vec2(215, 25 ), vec2(285, 60), WindowsColor, 8)

    --Degradê Color da Barra
    local barColor = rgbm.from0255(branco.r + barColorPercent * (branco.r - vermelho.r), branco.g + barColorPercent * (branco.g - vermelho.g), branco.b + barColorPercent * (branco.b - vermelho.b))
    if barColorPercent > 0 then
        barColor = rgbm.from0255(branco.r - barColorPercent * (branco.r - verde.r), branco.g - barColorPercent * (branco.g - verde.g), branco.b - barColorPercent * (branco.b - verde.b))
    end

    --Barra Arredondado no Lado Esquerdo
    if barEnd < 250 then
        ui.drawRectFilled(vec2(barEnd, 0), vec2(250, 22), barColor, 10, ui.CornerFlags.Left)
    end

    --Barra Arredondado no Lado Direito
    if barEnd > 250 then
        ui.drawRectFilled(vec2(250, 0), vec2(barEnd, 22), barColor, 10, ui.CornerFlags.Right)
    end

    -- Delta Texto
    local deltaText = string.format("%.2f", delta)
    if math.abs(delta) > 1000 then
        deltaText = "inf"
    elseif math.abs(delta) > 100 then
        deltaText = string.format("%.0f", delta)
    elseif math.abs(delta) > 10 then
        deltaText = string.format("%.1f", delta)
    end

    -- +
    if delta > 0 then
        deltaText = "+" .. deltaText
    end

    --Degradê Color do Texto
    local textEndPercent = math.clamp(delta / 0.02, -1, 1)
    local textColor = rgbm.from0255(branco.r + textEndPercent * (branco.r - verde.r), branco.g + textEndPercent * (branco.g - verde.g), branco.b + textEndPercent * (branco.b - verde.b))
    if textEndPercent >= 0 then
        textColor = rgbm.from0255(branco.r - textEndPercent * (branco.r - vermelho.r), branco.g - textEndPercent * (branco.g - vermelho.g), branco.b - textEndPercent * (branco.b - vermelho.b))
    end

    --Chamando Texto Delta
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
    ui.setCursor(vec2(220 , 12))
    ui.dwriteTextAligned(deltaText, 20, ui.Alignment.Center, ui.Alignment.Center, vec2(60, 60), false, textColor)
    ui.popDWriteFont()
end


return deltaBar