local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")

local deltaBar = {}

function deltaBar.windowMain()
    --Limites e Tamanhos
    local limitBarDeltaBackground = {x = 500, y = 25}
    local limitBackgroundText = {x = 45, y = 40}

    local limitColorOnBackground = 5
    local limitBarDeltaBackground_limitBackgroundText = 2

    --Tamanho Fonte Texto Delta
    local fontTextDelta = 30

    --Bordas Arredondadas
    local cornerBarDeltaBackground = 8
    local cornerColorBarDelta = 8
    local cornerBackgroundText = 8

    --Cores Barra Delta
    local verde = {r= 102, g=213, b=79}
    local branco = {r= 255, g=255, b=255}
    local vermelho = {r= 226, g=9, b=38}

    --------------------------------------------------------------------------------------------------------------------------
    local barEnd = limitBarDeltaBackground.x / 2
    local delta = CAR.performanceMeter
    local deltaMeter = CAR.performanceMeterSpeedDifferenceMs
    
    --Background Barra Delta
    ui.drawRectFilled(vec2(0, 0), vec2(limitBarDeltaBackground.x, limitBarDeltaBackground.y), WindowsColor, cornerBarDeltaBackground)
    --Background Texto Delta
    ui.drawRectFilled(vec2(barEnd - limitBackgroundText.x, limitBarDeltaBackground_limitBackgroundText + limitBarDeltaBackground.y), vec2(barEnd + limitBackgroundText.x, limitBarDeltaBackground_limitBackgroundText +limitBackgroundText.y + limitBarDeltaBackground.y), WindowsColor, cornerBackgroundText)

    
    --Degradê Color da Barra
    local barColorPercent = math.clamp(deltaMeter / 2, -1, 1)
    local barColor = rgbm.from0255(branco.r + barColorPercent * (branco.r - vermelho.r), branco.g + barColorPercent * (branco.g - vermelho.g), branco.b + barColorPercent * (branco.b - vermelho.b))
    if barColorPercent > 0 then
        barColor = rgbm.from0255(branco.r - barColorPercent * (branco.r - verde.r), branco.g - barColorPercent * (branco.g - verde.g), branco.b - barColorPercent * (branco.b - verde.b))
    end

    local barEndPercent = math.clamp(delta / 2, -1, 1)
    local barCalculetorEnd = barEnd - barEndPercent * barEnd
    --Barra Arredondado no Lado Esquerdo
    if barCalculetorEnd < barEnd then
        ui.drawRectFilled(vec2(barCalculetorEnd + limitColorOnBackground, limitColorOnBackground), vec2(barEnd + limitColorOnBackground, limitBarDeltaBackground.y - limitColorOnBackground), barColor, cornerColorBarDelta, ui.CornerFlags.Left)
    end

    --Barra Arredondado no Lado Direito
    if barCalculetorEnd > barEnd then
        ui.drawRectFilled(vec2(barEnd - limitColorOnBackground, limitColorOnBackground), vec2(barCalculetorEnd - limitColorOnBackground, limitBarDeltaBackground.y - limitColorOnBackground), barColor, cornerColorBarDelta, ui.CornerFlags.Right)
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
    ui.setCursor(vec2(barEnd - limitBackgroundText.x, (limitBackgroundText.y / 2 + limitBarDeltaBackground_limitBackgroundText) - limitBackgroundText.y + limitBarDeltaBackground.y))
    ui.dwriteTextAligned(deltaText, fontTextDelta, ui.Alignment.Center, ui.Alignment.Center, vec2(limitBackgroundText.x + limitBackgroundText.x, limitBackgroundText.y + limitBackgroundText.y), false, textColor)
    ui.popDWriteFont()
end


return deltaBar