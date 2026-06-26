local window = require("common.window")
local droplist = {}

---@alias droplist.PosText
---| `droplist.PosText.Default` @Value: 0
---| `droplist.PosText.Start` @Value: 1
droplist.PosText = {
  Default = 0, ---@type droplist.PosText #Value: 0
  Start = 1, ---@type droplist.PosText #Value: 1
}

local active = {}
local height = 25
local padding = 2
local rounding = 5

--- @param id string
--- @param text string
--- @param pos vec2
--- @param size number
--- @param selected number
--- @param items string[]
--- @param posText? droplist.PosText @Default value: 0.
--- @return number
function droplist.main(id, text, pos, size, selected, items, posText)
    local itemsLenght = table.nkeys(items)
    local color = COLOR.GRAY_BG

    -- Posição do texto
    if posText == droplist.PosText.Default or posText == nil then
        ui.dwriteDrawText(text, 12, pos - vec2(5, 25), COLOR.WHITE)
    else
        ui.setCursor(pos)
        ui.dwriteTextAligned(text, 12, ui.Alignment.Start, ui.Alignment.Center, vec2(150, height), false, COLOR.WHITE)
        pos = pos + vec2(ui.measureDWriteText(text, 12).x + 12, 0)
    end
    
    -- Se o mouse estiver na droplist
    if window.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + size, pos.y,  pos.y + height) then
        color = USER_UI.accentColor
        if ui.mouseClicked(ui.MouseButton.Left) then
            active[id] = false
        end
    end
    -- Se o mouse estiver fora da droplist
    if not window.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + size, pos.y,  pos.y + (itemsLenght + 1) * height) then
        active[id] = false
    end
    ui.setCursor(pos)
    ui.invisibleButton("##"..id, vec2(size, height), ui.ButtonFlags.PressedOnClick)

    if ui.itemActive() or active[id] then
        ui.setMouseCursor(ui.MouseCursor.Hand)
        active[id] = true
        -- Desenha a droplist
        ui.setCursor(pos)
        local item = ui.childWindow("##droplist", vec2(size, height * (itemsLenght + 1)), false, ui.WindowFlags.None + ui.WindowFlags.NoBackground, function()
            ui.drawRectFilled(vec2(0,height), vec2(0,height) + vec2(size, height * (itemsLenght)), COLOR.GRAY_BG, rounding, ui.CornerFlags.Bottom)
            local i = 1
            for key, value in pairs(items) do
                if window.isMouseInWindow(ui.mouseLocalPos(), 0, size, i * height, (i + 1) * height) then
                    ui.drawRectFilled(vec2(padding, padding) + vec2(0, i * height), vec2(0,0) + vec2(0, i * height) + vec2(size - padding, height - padding), USER_UI.accentColor, rounding)
                    if ui.mouseClicked(ui.MouseButton.Left) then
                        active[id] = false
                        return key
                    end
                end
                ui.setCursor(vec2(0,0) + vec2(10, i * height))
                ui.dwriteTextAligned(value, 12, ui.Alignment.Start, ui.Alignment.Center, vec2(size, height), false, COLOR.WHITE) 
                i = i + 1
            end
            return nil
        end)
        ui.drawRectFilled(pos, pos + vec2(size, height), color, rounding, ui.CornerFlags.Top)
        ui.setCursor(pos + vec2(10))
        ui.dwriteTextAligned(items[selected], 12, ui.Alignment.Start, ui.Alignment.Center, vec2(size, height), false, COLOR.WHITE)
        ui.beginRotation()
        ui.drawImage("assets/arrow.png", vec2(pos.x + size - 28, pos.y + 4), vec2(pos.x + size - 8, pos.y + height - 4))
        ui.endRotation(180)

        if item ~= nil then
            return item
        end
        
    else
        if window.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + size, pos.y,  pos.y + height) then
            ui.setMouseCursor(ui.MouseCursor.Hand)
        end
        ui.drawRectFilled(pos, pos + vec2(size, height), color, rounding)
        ui.setCursor(pos + vec2(10))
        ui.dwriteTextAligned(items[selected], 12, ui.Alignment.Start, ui.Alignment.Center, vec2(size, height), false, COLOR.WHITE)
        ui.beginRotation()
        ui.drawImage("assets/arrow.png", vec2(pos.x + size - 28, pos.y + 4), vec2(pos.x + size - 8, pos.y + height - 4))
        ui.endRotation(0)
    end

    return selected
end

return droplist