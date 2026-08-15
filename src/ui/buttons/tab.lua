local window = require("common.window")

local tab = {}

local tabs = {}

---@param id string
---@param pos vec2
function tab.tabStart(id, pos)
    if tabs[id] == nil then
        tabs[id] = {}
        tabs[id].pos = vec2()
        tabs[id].currentTab = 1
        tabs[id].selectedTab = 1
    end
    tabs[id].pos = pos
    ui.drawLine(vec2(0 ,pos.y +22), pos + vec2(ui.windowSize().x,22), USER_UI.accentColor, 2)
end

---@param id string
function tab.tabEnd(id)
    tabs[id].currentTab = 1
end

--- @param id string
--- @param text string
--- @param content? function
function tab.item(id, text, content)
    local lenght = ui.measureDWriteText(text, 12).x + 10
    local backColor = COLOR.WHITE
    local textColor = COLOR.BLACK
    if window.isMouseInWindow(ui.mouseLocalPos(), tabs[id].pos.x, tabs[id].pos.x + lenght, tabs[id].pos.y, tabs[id].pos.y + 20)  or tabs[id].selectedTab == tabs[id].currentTab then
        if ui.mouseClicked(ui.MouseButton.Left) then
            tabs[id].selectedTab = tabs[id].currentTab
        end
        backColor = USER_UI.accentColor
        textColor =  COLOR.WHITE
    end

    if tabs[id].selectedTab == tabs[id].currentTab then
        if content ~= nil then
            content()
        end
    end

    ui.drawRectFilled(tabs[id].pos, tabs[id].pos + vec2(lenght, 20), backColor, 5, ui.CornerFlags.Top)

    ui.setCursor(tabs[id].pos)
    ui.dwriteTextAligned(text, 12, ui.Alignment.Center,ui.Alignment.Center, vec2(lenght, 20), false, textColor)
    
    tabs[id].pos.x = tabs[id].pos.x + lenght + 5
    tabs[id].currentTab = tabs[id].currentTab + 1
end


return tab