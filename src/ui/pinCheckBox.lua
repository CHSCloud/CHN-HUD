local config = require("common.config")
local language = require("lang.language")
local pinCheckBox = {}

local lenght = 20

--- @param pos vec2
--- @param scale number 
--- @param nameWindow string
--- @param isPinned boolean
--- @return boolean
local function checkBox(pos, scale, nameWindow, isPinned)

    ui.drawRectFilled(pos, pos + vec2(lenght, lenght):scale(scale), COLOR.GRAY_BG, 2 * scale)

    if isPinned then
        ui.drawLine(pos + vec2(4, 4):scale(scale), pos + vec2(lenght - 4, lenght - 4):scale(scale), COLOR.WHITE, 2 * scale)
        ui.drawLine(pos + vec2(4, lenght - 4):scale(scale), pos + vec2(lenght - 4, 4):scale(scale), COLOR.WHITE, 2 * scale)
    end

    if config.isMouseInWindow(ui.mouseLocalPos(),pos.x, pos.x + lenght * scale, pos.y, pos.y + lenght * scale) then
        if ui.mouseClicked(ui.MouseButton.Left) then
            config.pinWindow(nameWindow)
        end

        ui.drawRectFilled( pos + vec2((lenght + 4)* scale), pos + vec2(100 * scale, pos.y + 10 * scale), rgbm.from0255(0,0,0,0.70), 4 *scale)
        ui.setCursor(vec2(pos.x + (lenght + 4)* scale, pos.y))

        if isPinned then
            ui.dwriteTextAligned(language.get("PINNED"), 10 * scale, ui.Alignment.Center, ui.Alignment.Center, vec2(77 * scale, pos.y + 10 * scale))
        else 
            ui.dwriteTextAligned(language.get("NOT_PINNED"), 10 * scale, ui.Alignment.Center, ui.Alignment.Center, vec2(77 * scale, pos.y + 10 * scale))
        end

        return true
    end
end

--- @param scale number 
--- @param nameWindow string
--- @param isPinned boolean
--- @param windowSize vec2
function pinCheckBox.main(scale, nameWindow, isPinned, windowSize)
    if config.isMouseInWindow(ui.mouseLocalPos(), 0, windowSize.x + (lenght + 2) * scale, 0, windowSize.y)then
        config.resize(windowSize + vec2((lenght + 2) * scale), nameWindow)

        if ui.mouseClicked(ui.MouseButton.Right) then
            config.pinWindow(nameWindow)
        end

        if checkBox(vec2(windowSize.x + 2 * scale, 10 * scale), scale, nameWindow, isPinned) then
            config.resize(windowSize + vec2((lenght + 100) * scale), nameWindow)
        end
    end
end

return pinCheckBox