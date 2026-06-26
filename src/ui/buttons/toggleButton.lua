local window = require("common.window")
local toggleButton = {}

local positions = {}

--- @param id string
--- @param pos vec2
--- @param key boolean
--- @param text string
--- @return boolean -- Se foi clicado
function toggleButton.main(id, pos, key, text)
    local size = vec2(40, 20)
    local init = vec2(12, 10)
    local final = vec2(28, 10)
    if positions[id] == nil then
        positions[id] = init
    end
    if key then
        if positions[id].x < final.x then
            positions[id] = positions[id] + vec2(3, 0)
        else
            positions[id] = final
        end
        ui.drawRectFilled(pos, pos + size, USER_UI.accentColor, 20)
        ui.drawCircleFilled(pos + positions[id], size.y / 2.2, COLOR.WHITE, 20)
    else
        if positions[id].x > init.x then
            positions[id] = positions[id] - vec2(3, 0)
        else
            positions[id] = init
        end
        ui.drawRectFilled(pos, pos + size, COLOR.GRAY_BG, 20)
        ui.drawCircleFilled(pos + positions[id], size.y / 2.2, COLOR.WHITE, 20)
    end

    ui.dwriteDrawText(text, 12, pos + vec2(50, 2), COLOR.WHITE)
    if window.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + size.x, pos.y, pos.y + size.y) then
        ui.setMouseCursor(ui.MouseCursor.Hand)
        if ui.mouseClicked(ui.MouseButton.Left) then
            return true
        end
    end
    return false
end

return toggleButton
