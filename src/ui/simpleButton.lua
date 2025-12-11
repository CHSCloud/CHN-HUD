local config = require("common.config")
local SimpleButton = {}
SimpleButton.__index = SimpleButton

function SimpleButton.new()
    local self = setmetatable({}, SimpleButton)
    self.key = false
    self.pos = vec2(0, 10)
    return self
end

--- @param pos vec2
--- @param key boolean
--- @param text string
function SimpleButton:main(pos, key, text)
    local size = vec2(40, 20)
    local init = vec2(12, 10)
    local final = vec2(28, 10)
    if key then
        if key ~= self.key  and self.pos.x < final.x then
            self.pos = self.pos + vec2(3, 0)
        else 
            self.pos = final
            self.key = key
        end
        ui.drawRectFilled(pos, pos + size, UserUI.accentColor, 20)
        ui.drawCircleFilled(pos + self.pos, size.y / 2.2, COLOR.WHITE, 20)
    else 
        if key ~= self.key and self.pos.x > init.x then
            self.pos = self.pos - vec2(3, 0)
        else 
            self.pos = init
            self.key = key
        end
        ui.drawRectFilled(pos, pos + size, COLOR.GRAY_BG, 20)
        ui.drawCircleFilled(pos + self.pos, size.y / 2.2, COLOR.WHITE, 20)
    end

    ui.drawText(text, pos + vec2(50, 2), COLOR.WHITE)
    if config.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + size.x, pos.y, pos.y + size.y) and ui.mouseClicked(ui.MouseButton.Left) then
        return not key
    end
    return key
end

return SimpleButton
