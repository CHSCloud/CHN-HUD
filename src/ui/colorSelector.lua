local colorSelector = {}

--- @param text string
--- @param color rgbm
--- @param pos vec2
--- @param id? string
function colorSelector.main(text, color, pos, id) 
    ui.setCursor(pos)    
    if id ~= nil then
        ui.colorButton(id, color, ui.ColorPickerFlags.AlphaBar + ui.ColorPickerFlags.AlphaPreview + ui.ColorPickerFlags.PickerHueBar)
    else 
        ui.colorButton('##'..text, color, ui.ColorPickerFlags.AlphaBar + ui.ColorPickerFlags.AlphaPreview + ui.ColorPickerFlags.PickerHueBar)
    end
    ui.setCursor(vec2(pos.x + 27, pos.y + 5))
    ui.dwriteText(text, 11, COLOR.WHITE)
    return color
end

return colorSelector