local config = require("common.config")
local slider = {}


---@alias slider.PosText
---| `slider.PosText.Default` @Value: 0
---| `slider.PosText.Start` @Value: 1
slider.PosText = {
  Default = 0, ---@type slider.PosText #Value: 0
  Start = 1, ---@type slider.PosText #Value: 1
}

--- @param text string -- Texto da barra
--- @param outputText string -- Texto de saída
--- @param pos vec2 -- Posição da barra
--- @param lenght number -- Tamanho da barra
--- @param value number -- Valor atual
--- @param init number -- Valor mínimo
--- @param final number -- Valor máximo
--- @param posText? slider.PosText @Default value: 0.
--- @return number
function slider.main(text, outputText, pos, lenght, value, init, final, posText)
    local width = 6
    if posText == slider.PosText.Default or posText == nil then
        ui.dwriteDrawText(text, 12, pos - vec2(5, 25), COLOR.WHITE)
    else 
        ui.setCursor(pos)
        ui.dwriteTextAligned(text, 12, ui.Alignment.Start, ui.Alignment.Center, vec2(150, 15), false, COLOR.WHITE)
        pos = pos + vec2(ui.measureDWriteText(text, 12).x + 12, 0)
    end

    ui.setCursor(pos)
    ui.invisibleButton("##" .. text, vec2(lenght, 15), ui.ButtonFlags.PressedOnClick)
    if ui.itemActive() then
        value = config.remapIntervalWithLimits(ui.mouseLocalPos().x, pos.x, pos.x + lenght, init, final)
    end

    local posValue = config.remapIntervalWithLimits(value, init, final, 0, lenght)
    ui.setCursor(pos)
    ui.drawRectFilled(pos, pos + vec2(lenght, 15), UserUI.accentColor, 20)
    ui.drawRectFilled(pos + vec2(posValue - width, - 5), pos + vec2(posValue + width, 20), COLOR.WHITE, 20)

    ui.setCursor(pos + vec2(lenght + 12, 0))
    ui.dwriteTextAligned(outputText, 15, ui.Alignment.Start, ui.Alignment.Center, vec2(60, 15), false, COLOR.WHITE)
    return value
end

return slider