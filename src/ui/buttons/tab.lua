local window = require("common.window")

local tab = {}

local positions = {}

---@param id string
---@param pos vec2
function tab.tabStart(id, pos)
    if positions[id] == nil then
        positions[id] = {}
        positions[id].pos = vec2()
        positions[id].currentTab = 1
        positions[id].selectedTab = 1
    end
    positions[id].pos = pos
    ui.drawLine(vec2(0 ,pos.y +22), pos + vec2(ui.windowSize().x,22), USER_UI.accentColor, 2)
end

---@param id string
function tab.tabEnd(id)
    positions[id].currentTab = 1
end

--- @param id string
--- @param text string
--- @param content? function
function tab.item(id, text, content)
    local lenght = ui.measureDWriteText(text, 12).x + 10
    local backColor = COLOR.WHITE
    local textColor = COLOR.BLACK
    if window.isMouseInWindow(ui.mouseLocalPos(), positions[id].pos.x, positions[id].pos.x + lenght, positions[id].pos.y, positions[id].pos.y + 20)  or positions[id].selectedTab == positions[id].currentTab then
        if ui.mouseClicked(ui.MouseButton.Left) then
            positions[id].selectedTab = positions[id].currentTab
        end
        backColor = USER_UI.accentColor
        textColor =  COLOR.WHITE
    end

    if positions[id].selectedTab == positions[id].currentTab then
        if content ~= nil then
            content()
        end
    end

    ui.drawRectFilled(positions[id].pos, positions[id].pos + vec2(lenght, 20), backColor, 5, ui.CornerFlags.Top)

    ui.setCursor(positions[id].pos)
    ui.dwriteTextAligned(text, 12, ui.Alignment.Center,ui.Alignment.Center, vec2(lenght, 20), false, textColor)
    
    positions[id].pos.x = positions[id].pos.x + lenght + 5
    positions[id].currentTab = positions[id].currentTab + 1
end


return tab