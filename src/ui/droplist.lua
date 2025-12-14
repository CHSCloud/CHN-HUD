local config = require("common.config")
local droplist = {}

--- @param pos vec2
--- @param size number
--- @param selected string
--- @param items string[]
function droplist.main(pos, size, selected, items)
    local height = 25
    local color = COLOR.GRAY_BG
    if config.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + size, pos.y,  pos.y + height) then
        color = UserUI.accentColor

        if ui.mouseClicked(ui.MouseButton.Left) then
            for i=1, #items do
                ui.drawRectFilled(pos + vec2(0, i * height), pos + vec2(0, i * height) + vec2(size, height), color)
                ui.setCursor(pos + vec2(10, i * height))
                ui.dwriteTextAligned(items[i], 12, ui.Alignment.Start, ui.Alignment.Center, vec2(size, height), false, COLOR.WHITE)
            end
        end
    end

    ui.drawRectFilled(pos, pos + vec2(size, height), color, 7)
    ui.setCursor(pos + vec2(10))
    ui.dwriteTextAligned(selected, 12, ui.Alignment.Start, ui.Alignment.Center, vec2(size, height), false, COLOR.WHITE)


end

return droplist