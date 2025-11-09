local language = require("lang.language")
local pitlaneSettings = {}


local pitSettingsStore = ac.storage {
    windowPitScale = 1,
    optionPlate = "default"
}
local plates = {
    ["default"] = language.get("DEFAULT"),
    ["alert"] = language.get("ALERT_PIT")
}

WindowPitScale = pitSettingsStore.windowPitScale
OptionPlate = pitSettingsStore.optionPlate

local function resetToDefault()
    WindowPitScale = 1
    OptionPlate = "default"

    pitSettingsStore.windowPitScale = WindowPitScale
    pitSettingsStore.optionPlate = OptionPlate
end

function pitlaneSettings.pitlaneSettings()
    local initPos = 55
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))

    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    WindowPitScale = ui.slider("##Size", WindowPitScale, 0.7, 3, string.format("%.2f", WindowPitScale))
    pitSettingsStore.windowPitScale = WindowPitScale

    initPos = initPos + 35
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("STYLE"))
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    ui.combo('##resolution', plates[OptionPlate], function ()
        if ui.selectable(plates["default"]) then
            OptionPlate = "default"
            pitSettingsStore.optionPlate = OptionPlate
        end

        if ui.selectable(plates["alert"]) then
            OptionPlate = "alert"
            pitSettingsStore.optionPlate = OptionPlate
        end
    end)

    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return pitlaneSettings