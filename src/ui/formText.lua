local formText = {}

--- @param id string
--- @param pos vec2
--- @param text string
--- @param size vec2
--- @param rounding number
--- @param color rgbm
--- @param textFlags? ui.InputTextFlags
--- @return string, vec2, boolean
function formText.main(id, pos, text, size, rounding, color, textFlags)
    if ui.measureText(text).x > size.x - 15 then
        size.x = ui.measureText(text).x + 15
    end
    ui.drawRectFilled(pos, pos + size, color, rounding)
    ui.pushStyleColor(ui.StyleColor.FrameBg, rgbm.from0255(0,0,0,0))
    ui.pushStyleColor(ui.StyleColor.Text, COLOR.BLACK)
    ui.pushItemWidth(size.x)
    ui.setCursor(pos)
    text = ui.inputText("##".. id, text, textFlags)
    ui.popStyleColor(2)
    ui.popItemWidth()
    return text, size, ui.itemEdited()
end

return formText