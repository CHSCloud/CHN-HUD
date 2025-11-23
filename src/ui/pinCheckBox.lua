require("src.settings.settings")
local config = require("common.config")
local pinCheckBox = {}

--- @param pos vec2
--- @param scale number 
--- @param nameWindow string
--- @param isPinned boolean
function pinCheckBox.main(pos, scale, nameWindow, isPinned)
    ui.drawRectFilled(pos, pos + vec2(20, 20):scale(scale), COLOR.GRAY_BG, 2 * scale)

    if config.isMouseInWindow(ui.mouseLocalPos(),pos.x, pos.x + 20, pos.y, pos.y + 20) and ui.mouseClicked(ui.MouseButton.Left) then
        config.pinWindow(nameWindow)
    end
    ac.log(isPinned)
    if isPinned then
        ui.drawRectFilled(pos + vec2(4, 4):scale(scale), pos + vec2(16, 16):scale(scale), COLOR.WHITE, 2 * scale)
    end
end

return pinCheckBox