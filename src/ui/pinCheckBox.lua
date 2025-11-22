require("src.settings.settings")
local pinCheckBox = {}

--- @param pos vec2
--- @param scale number 
--- @param isActive boolean
function pinCheckBox.main(pos, scale, isActive)
    ui.drawRectFilled(pos, pos + vec2(20, 20):scale(scale), COLOR.GRAY_BG, 2 * scale)
    if isActive then
        ui.drawRectFilled(pos + vec2(4, 4):scale(scale), pos + vec2(16, 16):scale(scale), COLOR.WHITE, 2 * scale)
    end
end

return pinCheckBox