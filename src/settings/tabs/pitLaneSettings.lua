local language = require("lang.language")
local pitlaneSettings = {}

local defaultValues = {
    pitlaneScale = 1,
    optionPlate = "default"
}

pitlaneSettings.store = ac.storage(defaultValues)

local plates = {
    ["default"] = language.get("DEFAULT"),
    ["alert"] = language.get("ALERT_PIT")
}

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        pitlaneSettings.store[key] = value
    end
end

function pitlaneSettings.pitlaneSettings()
    
    local initPos = 55
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))

    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    
    -- Uso direto do store com a chave padronizada 'scale'
    pitlaneSettings.store.pitlaneScale = ui.slider("##Size", pitlaneSettings.store.pitlaneScale, 0.7, 3, string.format("%.2f", pitlaneSettings.store.pitlaneScale))

    initPos = initPos + 35
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("STYLE"))
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    
    -- Combo box atualizando direto o store
    ui.combo('##resolution', plates[pitlaneSettings.store.optionPlate], function ()
        if ui.selectable(plates["default"]) then
            pitlaneSettings.store.optionPlate = "default"
        end

        if ui.selectable(plates["alert"]) then
            pitlaneSettings.store.optionPlate = "alert"
        end
    end)

    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return pitlaneSettings