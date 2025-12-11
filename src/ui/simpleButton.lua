local config = require("common.config")
local simpleButton = {}

--- @param pos vec2
--- @param key boolean
function simpleButton.main(pos, key)
    local size = vec2(40, 20)
    local init = vec2(12, 10)
    local final = vec2(28, 10)
    if key then
        ui.drawRectFilled(pos, pos + size, COLOR.RED, 20)
        ui.drawCircleFilled(pos + final, size.y / 2.2, COLOR.WHITE, 20)
    else 
        ui.drawRectFilled(pos, pos + size, COLOR.RED, 20)
        ui.drawCircleFilled(pos + init, size.y / 2.2, COLOR.WHITE, 20)
    end

    if config.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + size.x, pos.y, pos.y + size.y) and ui.mouseClicked(ui.MouseButton.Left) then
        return not key
    end
    return key
end

return simpleButton
