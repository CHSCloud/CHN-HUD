require("src.settings.settings")
local config = require("common.config")
local language = require("lang.language")
local pinCheckBox = {}

PinCheckLenght = 20
--- @param pos vec2
--- @param scale number 
--- @param nameWindow string
--- @param isPinned boolean
function pinCheckBox.main(pos, scale, nameWindow, isPinned)
    ui.drawRectFilled(pos, pos + vec2(PinCheckLenght, PinCheckLenght):scale(scale), COLOR.GRAY_BG, 2 * scale)
    if isPinned then
        ui.drawLine(pos + vec2(4, 4):scale(scale), pos + vec2(PinCheckLenght - 4, PinCheckLenght - 4):scale(scale), COLOR.WHITE, 2 * scale)
        ui.drawLine(pos + vec2(4, PinCheckLenght - 4):scale(scale), pos + vec2(PinCheckLenght - 4, 4):scale(scale), COLOR.WHITE, 2 * scale)
    end

    if config.isMouseInWindow(ui.mouseLocalPos(),pos.x, pos.x + PinCheckLenght * scale, pos.y, pos.y + PinCheckLenght * scale) then
        if ui.mouseClicked(ui.MouseButton.Left) then
            config.pinWindow(nameWindow)
            PinAllApps = false
        end
        ui.drawRectFilled( pos + vec2((PinCheckLenght + 4)* scale), pos + vec2(100 * scale, pos.y + 10 * scale), rgbm.from0255(0,0,0,0.70), 4 *scale)
        ui.setCursor(vec2(pos.x + (PinCheckLenght + 4)* scale, pos.y))
        if isPinned then
            ui.dwriteTextAligned(language.get("PINNED"), 10 * scale, ui.Alignment.Center, ui.Alignment.Center, vec2(77 * scale, pos.y + 10 * scale))
        else 
            ui.dwriteTextAligned(language.get("NOT_PINNED"), 10 * scale, ui.Alignment.Center, ui.Alignment.Center, vec2(77 * scale, pos.y + 10 * scale))
        end
        return true
    end
    

end

return pinCheckBox