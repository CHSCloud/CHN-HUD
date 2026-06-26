local window = require("common.window")
local language = require("language.language")
local pinCheckBox = {}

local maxLenght = 20

local lenghts = {
    ["Pedals"] = 0,
    ["Pit Lane"] = 0,
    ["Session Laps"] = 0,
    ["Starting Lights"] = 0,
    ["Session Flags"] = 0,
    ["Delta Bar"] = 0,
    ["Map"] = 0,
    ["Leaderboard"] = 0
}

--- @param pos vec2
--- @param scale number 
--- @param nameWindow string
--- @param isPinned boolean
--- @return boolean
local function checkBox(pos, scale, nameWindow, isPinned)

    ui.drawRectFilled(pos, pos + vec2(lenghts[nameWindow], maxLenght):scale(scale), COLOR.GRAY_BG, 2 * scale)

    if isPinned and lenghts[nameWindow] == maxLenght then
        ui.drawLine(pos + vec2(4, 4):scale(scale), pos + vec2(lenghts[nameWindow] - 4, lenghts[nameWindow] - 4):scale(scale), COLOR.WHITE, 2 * scale)
        ui.drawLine(pos + vec2(4, lenghts[nameWindow] - 4):scale(scale), pos + vec2(lenghts[nameWindow] - 4, 4):scale(scale), COLOR.WHITE, 2 * scale)
    end
    
    if window.isMouseInWindow(ui.mouseLocalPos(),pos.x, pos.x + lenghts[nameWindow] * scale, pos.y, pos.y + lenghts[nameWindow] * scale) then
        ui.setMouseCursor(ui.MouseCursor.Hand)
        if ui.mouseClicked(ui.MouseButton.Left) then
            window.pinWindow(nameWindow)
        end

        ui.drawRectFilled(pos + vec2((lenghts[nameWindow] + 4)* scale, 0), pos + vec2(100 * scale, lenghts[nameWindow] * scale), rgbm.from0255(0,0,0,0.70), 4 *scale)

        ui.setCursor(vec2(pos.x + (lenghts[nameWindow] + 4)* scale, pos.y))

        if isPinned then
            ui.dwriteTextAligned(language.get("PINNED"), 10 * scale, ui.Alignment.Center, ui.Alignment.Center, vec2(77 * scale, maxLenght * scale))
        else 
            ui.dwriteTextAligned(language.get("NOT_PINNED"), 10 * scale, ui.Alignment.Center, ui.Alignment.Center, vec2(77 * scale, maxLenght * scale))
        end

        return true
    end
    return false
end

--- @param scale number 
--- @param nameWindow string
--- @param isPinned boolean
--- @param windowSize vec2
function pinCheckBox.main(scale, nameWindow, isPinned, windowSize)
    if window.isMouseInWindow(ui.mouseLocalPos(), 0, windowSize.x, 0, windowSize.y) then
        if ui.mouseClicked(ui.MouseButton.Right) then 
            window.pinWindow(nameWindow)
        end
    end

    if window.isMouseInWindow(ui.mouseLocalPos(), 0, windowSize.x + (maxLenght + 3) * scale, 0, windowSize.y) then
        
        if lenghts[nameWindow] < maxLenght then
            if (10 * TIMER) % 4 >= 1 then 
                lenghts[nameWindow] = lenghts[nameWindow] + 4
            end
        end

        window.resize(windowSize + vec2((maxLenght + 3) * scale, 0), nameWindow)
        if checkBox(vec2(windowSize.x + 2 * scale, windowSize.y / 2 - (maxLenght * scale) / 2), scale, nameWindow, isPinned) then
            window.resize(windowSize + vec2((maxLenght + 100) * scale), nameWindow)
        end
    else 
        lenghts[nameWindow] = 0
    end
end

return pinCheckBox