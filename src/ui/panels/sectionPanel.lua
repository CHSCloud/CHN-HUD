local button = require("src.ui.buttons.button")
local language = require("language.language")
local droplist = require("src.ui.selectors.droplist")
local formText = require("src.ui.forms.formText")

local utils = require("common.utils")
local window = require("common.window")
local sectionPanel = {}

--- @param pos vec2
--- @param size vec2
--- @return boolean
local function deleteSectionButton(pos, size)
    if window.isMouseInWindow(ui.mouseLocalPos(), pos.x, pos.x + size.x, pos.y, pos.y + size.y) then
        ui.drawRectFilled(pos, pos + size, USER_UI.accentColor, 2)
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
    local positions = {
        language.get("CENTER"),
        language.get("LEFT"),
        language.get("RIGHT")
    }

    local isEdited = false
    local resetSectionsINI = false
    local position = 0
    local numberSections = 0

    ui.drawRect(pos, pos + size, USER_UI.accentColor, 10, ui.CornerFlags.All, 3)
    ui.drawRect(pos + vec2(10, 40), pos + size - vec2(20, 40), COLOR.WHITE, 10, ui.CornerFlags.All, 3)
    ui.setCursor(pos + vec2(10, 43))
    isEdited = ui.childWindow("##" .. id, size - vec2(35, 85), false, ui.WindowFlags.None + ui.WindowFlags.NoBackground,
        ---@return boolean
        function()
            local isItemEdited = false
            local edited = false
            local progress, text
            local sizeText, sizeProgress
            local height = 0
            for index, section in iniFile:iterate("SECTION") do
                text, sizeText, isItemEdited = formText.main(
                    section .. "TEXT",
                    vec2(40, 10 + height),
                    iniFile:get(section, "TEXT", ""),
                    vec2(100, 20),
                    10,
                    COLOR.WHITE,
                    ui.InputTextFlags.NoHorizontalScroll + ui.InputTextFlags.NoUndoRedo +
                    ui.InputTextFlags.AlwaysInsertMode
                )
                iniFile:set(section, "TEXT", text)
                if isItemEdited and ui.windowFocused(ui.FocusedFlags.ChildWindows) then edited = true end

                ui.drawCircleFilled(vec2(20, 20 + height), 10, COLOR.GRAY_BG)
                ui.setCursor(vec2(20, 20 + height) - vec2(15, 15))
                ui.dwriteTextAligned(tostring(index), 12, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 30), false,
                    COLOR.WHITE)

                progress, sizeProgress, isItemEdited = formText.main(
                    section .. "PROGRESS",
                    vec2(45 + sizeText.x, 10 + height),
                    iniFile:get(section, "PROGRESS", "0"),
                    vec2(100, 20),
                    10,
                    COLOR.WHITE,
                    ui.InputTextFlags.CharsDecimal
                )
                iniFile:set(section, "PROGRESS", progress)
                if isItemEdited and ui.windowFocused(ui.FocusedFlags.ChildWindows) then edited = true end

                position = droplist.main(section .. "POSITION", "", vec2(sizeText.x + sizeProgress.x + 40, 8 + height),
                    utils.findLenghtLongestString(positions, 12).x + 40, iniFile:get(section, "POSITION", 1), positions,
                    droplist.PosText.Start)
                if position ~= iniFile:get(section, "POSITION", 1) then
                    iniFile:set(section, "POSITION", position)
                    edited = true
                end

                if deleteSectionButton(vec2(sizeText.x + sizeProgress.x + utils.findLenghtLongestString(positions, 12).x + 100, 10 + height), vec2(20, 20)) and ui.windowFocused(ui.FocusedFlags.ChildWindows) then
                    iniFile:mapConfig(deleteSection(iniFile.sections, section, index))
                    edited = true
                end

                numberSections = numberSections + 1
                height = height + sizeText.y + 10
            end

            ui.setCursor(vec2(20, height + 80))
            return edited
        end
    ) or false

    if button.main(pos + vec2(5, 5), language.get("ADD_SECTION"), ui.windowFocused(ui.FocusedFlags.ChildWindows)) then
        iniFile:set("SECTION_" .. tostring(numberSections), "TEXT", tostring(ac.getTrackName()))
        iniFile:set("SECTION_" .. tostring(numberSections), "PROGRESS", 0)
        iniFile:set("SECTION_" .. tostring(numberSections), "POSITION", 1)
        isEdited = true
    end

    if button.main(pos + vec2(10, size.y - 30), language.get("RESET_SECTIONS"), ui.windowFocused(ui.FocusedFlags.ChildWindows)) then
        resetSectionsINI = true
    end

    if button.main(pos + vec2(ui.measureText(language.get("RESET_SECTIONS")).x + 50, size.y - 30), language.get("CLEAR_SECTIONS"), ui.windowFocused(ui.FocusedFlags.ChildWindows)) then
        iniFile.sections = {}
        isEdited = true
    end

    if isEdited then
        iniFile:save()
    end

    return isEdited, resetSectionsINI
end

return sectionPanel
