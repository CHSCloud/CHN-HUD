local config = require("common.config")
local button = {}

--- @param pos vec2
--- @param text string
--- @param focused? boolean
function button.main(pos, text, focused)
    local lenght =  ui.measureDWriteText(text, 12).x + 20
    local output = false
    local color = COLOR.GRAY_BG

    if focused == nil then
        focused = ui.windowFocused(ui.FocusedFlags.RootWindow)
    end

    if config.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + lenght, pos.y, pos.y + 25) then
        color = USER_UI.accentColor
    end
    
    ui.drawRectFilled(pos, pos + vec2(lenght, 25), color, 10)
    ui.drawRect(pos + vec2(2,2), pos + vec2(lenght - 2, 23), COLOR.WHITE, 10,ui.CornerFlags.All, 2)
    ui.setCursor(pos)
    ui.dwriteTextAligned(text, 12, ui.Alignment.Center, ui.Alignment.Center, vec2(lenght, 25), false, COLOR.WHITE)

    
    ui.setCursor(pos)
    
    ui.invisibleButton("##" .. text, vec2(lenght, 25), ui.ButtonFlags.PressedOnClick)
    if ui.itemClicked(ui.MouseButton.Left) and focused then
        output = true
    end
    return output
end

return button