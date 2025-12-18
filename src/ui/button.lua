local config = require("common.config")
local button = {}

function button.main(pos, text)
    local lenght =  ui.measureDWriteText(text, 12).x + 20
    local output = false
    local color = COLOR.GRAY_BG
    if config.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + lenght, pos.y, pos.y + 25) then
        color = UserUI.accentColor
        if ui.mouseClicked(ui.MouseButton.Left) and not ui.windowFocused(ui.FocusedFlags.ChildWindows) then
            output = true
        end
    end
    
    ui.drawRectFilled(pos, pos + vec2(lenght, 25), color, 20)
    ui.setCursor(pos)
    ui.dwriteTextAligned(text, 12, ui.Alignment.Center, ui.Alignment.Center, vec2(lenght, 25), false, COLOR.WHITE)

    return output
end

return button