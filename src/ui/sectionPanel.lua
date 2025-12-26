local button = require("src.ui.button")
local formText = require("src.ui.formText")
local droplist = require("src.ui.droplist")

local config = require("common.config")
local sectionPanel = {}

--- @param pos vec2
--- @param size vec2
--- @return boolean
local function deleteSectionButton(pos, size)
    if config.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + size.x, pos.y, pos.y + size.y) then
        ui.drawRectFilled(pos, pos + size, UserUI.accentColor, 2)
        if ui.mouseClicked(ui.MouseButton.Left) then    
            return true
        end
    else
        ui.drawRectFilled(pos, pos + size, COLOR.GRAY_BG, 2)
    end

    ui.drawLine(pos + vec2(4, 4), pos + size - vec2(4, 4), COLOR.WHITE, 2)
    ui.drawLine(pos + vec2(4, size.y - 4), pos + vec2(size.x - 4, 4), COLOR.WHITE, 2)
    return false
end

--- @param sections table
--- @param section string
--- @param index number
--- @return table
local function deleteSection(sections, section, index)
    sections[section] = nil
    while sections["SECTION_" .. tostring(index)] ~= nil do
        sections["SECTION_" .. tostring(index - 1)] = sections["SECTION_" .. tostring(index)]
        sections["SECTION_" .. tostring(index)] = nil
        index = index + 1
    end
    
    return sections
end

---@param id string
---@param iniFile ac.INIConfig
---@param pos vec2
---@param size vec2
---@return boolean, boolean
function sectionPanel.main(id, iniFile, pos, size)
    local isEdited = false
    local resetSectionsINI = false
    local numberSections = 0
    
    --ui.drawRectFilled(pos, pos + size, COLOR.GRAY, 10, ui.CornerFlags.All)
    ui.drawRect(pos, pos + size, UserUI.accentColor, 10, ui.CornerFlags.All, 3)
    ui.drawRect(pos + vec2(10, 40), pos + size - vec2(20, 40), COLOR.WHITE, 10, ui.CornerFlags.All, 3)
    ui.setCursor(pos + vec2(10, 40))
    isEdited = ui.childWindow("##"..id, size - vec2(20,80), false, ui.WindowFlags.None + ui.WindowFlags.NoBackground, function()
        local isItemEdited = false
        local edited = false
        local progress, text
        local sizeText, sizeProgress
        for index, section in iniFile:iterate("SECTION") do
            ui.drawCircleFilled(vec2(20, 20 + (index - 1) * 30), 10, COLOR.GRAY_BG)
            ui.setCursor(vec2(20, 20 + (index - 1) * 30) - vec2(5,5))
            ui.dwriteTextAligned(tostring(index), 12, ui.Alignment.Center, ui.Alignment.Center, vec2(10,10), false, COLOR.WHITE)
            --ui.setCursor(vec2(15, 20 + index * 30))
            text, sizeText, isItemEdited = formText.main(
                section .. "TEXT",
                vec2(40, 10 + (index - 1) * 30),
                iniFile:get(section, "TEXT", ""), 
                vec2(100, 20), 
                10,
                COLOR.WHITE
            )
            iniFile:set(section, "TEXT", text)
            if isItemEdited and ui.windowFocused(ui.FocusedFlags.ChildWindows)then edited = true end

            progress, sizeProgress, isItemEdited = formText.main(
                section .. "PROGRESS",
                vec2(45 + sizeText.x, 10 + (index - 1) * 30),
                iniFile:get(section, "PROGRESS", "0"), 
                vec2(100, 20), 
                10,
                COLOR.WHITE,
                ui.InputTextFlags.CharsDecimal
            )
            iniFile:set(section, "PROGRESS", progress)
            if isItemEdited and ui.windowFocused(ui.FocusedFlags.ChildWindows) then edited = true end

            if deleteSectionButton(vec2(sizeText.x + sizeProgress.x + 50, 10 + (index - 1) * 30), vec2(20, 20)) and ui.windowFocused(ui.FocusedFlags.ChildWindows) then
                iniFile:mapConfig(deleteSection(iniFile.sections, section, index))
                edited = true
            end

            numberSections = numberSections + 1
        end
        return edited
    end)

    if button.main(pos + vec2(5,5), "Add Section", ui.windowFocused(ui.FocusedFlags.ChildWindows)) then
        iniFile:set("SECTION_".. tostring(numberSections), "TEXT", tostring(ac.getTrackName()))
        iniFile:set("SECTION_".. tostring(numberSections), "PROGRESS", "0")
        isEdited = true
    end

    if button.main(pos + vec2(10,size.y - 30), "Reset Sections to Default", ui.windowFocused(ui.FocusedFlags.ChildWindows)) then
        resetSectionsINI = true
    end
    iniFile:save()
    return isEdited, resetSectionsINI
end

return sectionPanel