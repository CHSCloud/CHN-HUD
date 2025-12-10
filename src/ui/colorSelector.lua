local config = require("common.config")
local colorSelector = {}

local function colorPicker(pos, size, color)
    ui.setCursor(pos)
    ui.setNextItemWidth(size * 8)
    ui.colorPicker("", color, ui.ColorPickerFlags.NoInputs + ui.ColorPickerFlags.NoSidePreview)
end

--- @param color rgbm
--- @param text string
--- @param pos vec2
--- @param size number
--- @return boolean
function colorSelector.main(color, text, pos, size, isActive) 
    ui.drawCircleFilled(pos, size, color, 40)
    --ui.dwriteDrawText(text, size - 2, pos + vec2(size * 1.5, -size/2), COLOR.WHITE)
    if isActive then

        ui.toolWindow("##colors", ui.windowPos() + pos, vec2(size * 8, size * 8), true, true, function()
            ui.setCursor(vec2(0, 0)) 
            ui.setNextItemWidth(size * 8)
            ui.colorPicker("##picker", color, ui.ColorPickerFlags.NoSidePreview + ui.ColorPickerFlags.NoInputs)
        end)
        --ui.setCursor(pos)
        --ui.setNextItemWidth(size * 8)
        --ui.colorPicker("", color, ui.ColorPickerFlags.NoInputs + ui.ColorPickerFlags.NoSidePreview)
        if ui.mouseClicked(ui.MouseButton.Left) and not config.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + 100, pos.y, pos.y + 100) then
            isActive = false
        end
    else
        ui.dwriteDrawText(text, size - 2, pos + vec2(size * 1.5, -size/2), COLOR.WHITE) 
    end
    if config.isMouseInWindow(ui.mouseLocalPos(), pos.x - size, pos.x + size, pos.y - size, pos.y + size) then
        if ui.mouseClicked(ui.MouseButton.Left) then
            isActive = true
        end
    end

    return isActive
end

return colorSelector