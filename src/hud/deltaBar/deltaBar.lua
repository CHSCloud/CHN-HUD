local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")

local deltaBar = {}
-- amostragem por posição da pista (persistente entre frames)
local currentLapSamples = {}
local previousLapSamples = {}
local lastPreviousLapTimeMs = 0
local sampleResolution = 1000 -- número de buckets por volta (0..1000)
-- Suavização exponencial do delta
local smoothingAlpha = 0.1 -- 0 = suave, 1 = sem suavização
local smoothedDelta = 0
local smoothedDeltaMeter = 0

function deltaBar.windowMain()
    --Limites e Tamanhos
    local limitBarDeltaBackground = vec2(500, 25)
    local limitBackgroundText = vec2(90, 40)

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
    -- Atualiza previousLapSamples quando uma volta anterior nova existir
    if CAR.previousLapTimeMs and CAR.previousLapTimeMs > 0 and CAR.previousLapTimeMs ~= lastPreviousLapTimeMs then
        previousLapSamples = currentLapSamples
        currentLapSamples = {}
        lastPreviousLapTimeMs = CAR.previousLapTimeMs
    end

    -- Amostragem da volta atual por posição (splinePosition de 0..1)
    local pos = CAR.splinePosition or 0
    local idx = math.floor(pos * sampleResolution + 0.5)
    if CAR.lapTimeMs and currentLapSamples[idx] == nil then
        currentLapSamples[idx] = CAR.lapTimeMs
    end

    -- Sempre comparar com a volta anterior na mesma posição, se disponível
    local rawDelta
    if previousLapSamples[idx] then
        rawDelta = (CAR.lapTimeMs - previousLapSamples[idx]) / 1000
    else
        rawDelta = CAR.performanceMeter or 0
    end
    local rawDeltaMeter = CAR.performanceMeterSpeedDifferenceMs or 0
    
    -- Aplicar suavização exponencial
    smoothedDelta = smoothingAlpha * rawDelta + (1 - smoothingAlpha) * smoothedDelta
    smoothedDeltaMeter = smoothingAlpha * rawDeltaMeter + (1 - smoothingAlpha) * smoothedDeltaMeter
    
    local delta = smoothedDelta
    local deltaMeter = smoothedDeltaMeter
    
    --Background Barra Delta
    ui.drawRectFilled(vec2(0, 0), limitBarDeltaBackground, WindowsColor, cornerBarDeltaBackground)
    --Background Texto Delta
    ui.drawRectFilled(vec2(barEnd - limitBackgroundText.x / 2, limitBarDeltaBackground_limitBackgroundText + limitBarDeltaBackground.y), vec2(barEnd + limitBackgroundText.x / 2, limitBarDeltaBackground_limitBackgroundText + limitBackgroundText.y + limitBarDeltaBackground.y), WindowsColor, cornerBackgroundText)

    
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
    ui.setCursor(vec2(barEnd - limitBackgroundText.x / 2, limitBarDeltaBackground_limitBackgroundText + limitBarDeltaBackground.y))
    ui.dwriteTextAligned(deltaText, fontTextDelta, ui.Alignment.Center, ui.Alignment.Center, limitBackgroundText, false, textColor)
    ui.popDWriteFont()
end


return deltaBar