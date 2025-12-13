local config = require("common.config")
local Button = {}
Button.__index = Button

function Button.new()
    local self = setmetatable({}, Button)
    self.pos = vec2(0, 10)
    return self
end

--- @param pos vec2
--- @param key boolean
--- @param text string
--- @return boolean -- Se foi clicado
function Button:main(pos, key, text)
    local size = vec2(40, 20)
    local init = vec2(12, 10)
    local final = vec2(28, 10)
    if key then
        if self.pos.x < final.x then
            self.pos = self.pos + vec2(3, 0)
        else 
            self.pos = final
        end
        ui.drawRectFilled(pos, pos + size, UserUI.accentColor, 20)
        ui.drawCircleFilled(pos + self.pos, size.y / 2.2, COLOR.WHITE, 20)
    else 
        if self.pos.x > init.x then
            self.pos = self.pos - vec2(3, 0)
        else 
            self.pos = init
        end
        ui.drawRectFilled(pos, pos + size, COLOR.GRAY_BG, 20)
        ui.drawCircleFilled(pos + self.pos, size.y / 2.2, COLOR.WHITE, 20)
    end

    ui.dwriteDrawText(text, 12, pos + vec2(50, 2), COLOR.WHITE)
    if config.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + size.x, pos.y, pos.y + size.y) and ui.mouseClicked(ui.MouseButton.Left) then
        return true
    end
    return false
end

return Button
