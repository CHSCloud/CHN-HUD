local config = require("common.config")
local slider = {}

--- @param text string -- Texto da barra
--- @param outputText string -- Texto de saída
--- @param pos vec2 -- Posição da barra
--- @param lenght number -- Tamanho da barra
--- @param value number -- Valor atual
--- @param init number -- Valor mínimo
--- @param final number -- Valor máximo
function slider.main(text, outputText, pos, lenght, value, init, final)
    local width = 6

    ui.dwriteDrawText(text, 12, pos - vec2(5, 25), COLOR.WHITE)

    ui.setCursor(pos)
    ui.invisibleButton("##" .. text, vec2(lenght, 15), ui.ButtonFlags.PressedOnClick)
    if ui.itemActive() then
        value = config.remapIntervalWithLimits(ui.mouseLocalPos().x, pos.x, pos.x + lenght, init, final)
    end

    local posValue = config.remapIntervalWithLimits(value, init, final, 0, lenght)
    ui.setCursor(pos)
    ui.drawRectFilled(pos, pos + vec2(lenght, 15), UserUI.accentColor, 20)
    ui.drawRectFilled(pos + vec2(posValue - width, - 5), pos + vec2(posValue + width, 20), COLOR.WHITE, 20)

    ui.setCursor(pos + vec2(lenght + 12))
    ui.dwriteTextAligned(outputText, 15, ui.Alignment.Start, ui.Alignment.Center, vec2(60, 15), false, COLOR.WHITE)
    return value
end

return slider