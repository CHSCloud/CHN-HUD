local config = require("common.config")
local colorSelector = {}

--- @param text string
--- @param color rgbm
--- @param pos vec2
function colorSelector.main(text, color, pos) 
    ui.setCursor(pos)    
    ui.colorButton('##'..text, color, ui.ColorPickerFlags.AlphaBar + ui.ColorPickerFlags.AlphaPreview + ui.ColorPickerFlags.PickerHueBar)
    ui.setCursor(vec2(pos.x + 27, pos.y + 5))
    ui.dwriteText(text, 10, COLOR.WHITE)
    return color
end

return colorSelector