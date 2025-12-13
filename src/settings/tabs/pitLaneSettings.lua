local language = require("lang.language")
local button = require("src.ui.button")
local slider = require("src.ui.slider")
local pitLaneSettings = {}

local defaultValues = {
    pitLaneScale = 1,
    optionPlate = "default"
}

pitLaneSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        pitLaneSettings.store[key] = value
    end
end

function pitLaneSettings.pitLaneSettings()
    local plates = {
        ["default"] = language.get("DEFAULT"),
        ["alert"] = language.get("ALERT_PIT")
    }
    
    local initPos = 75
    
    pitLaneSettings.store.pitLaneScale = slider.main(language.get("SIZE"), string.format("%.2f", pitLaneSettings.store.pitLaneScale), vec2(20, initPos), 250, pitLaneSettings.store.pitLaneScale, 0.7, 3)

    initPos = initPos + 35
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("STYLE"))
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    
    -- Combo box atualizando direto o store
    ui.combo('##resolution', plates[pitLaneSettings.store.optionPlate], function ()
        if ui.selectable(plates["default"]) then
            pitLaneSettings.store.optionPlate = "default"
        end

        if ui.selectable(plates["alert"]) then
            pitLaneSettings.store.optionPlate = "alert"
        end
    end)

    initPos = initPos + 40

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return pitLaneSettings