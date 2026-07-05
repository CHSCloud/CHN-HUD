local language = require("language.language")
local slider = require("src.ui.selectors.slider")
local button = require("src.ui.buttons.button")
local toggleButton = require("src.ui.buttons.toggleButton")
local tyresSettings = {}

local defaultValues = {
    tyresScale = 1,

    idealTempActive = true,

    tyresNameActive = true,

    psiActive = true,
    psiDeltaActive = true,

    coreTempActive = true,

    wearActive = true,
}

tyresSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        tyresSettings.store[key] = value
    end
end

function tyresSettings.tyresSettings()
    local pos = vec2(20, 75)

    tyresSettings.store.tyresScale = slider.main(language.get("SIZE"),string.format("%.2f", tyresSettings.store.tyresScale), pos, 250, tyresSettings.store.tyresScale, 0.7, 3)

    pos.y = pos.y + 35;

    ui.dwriteDrawText(language.get("ELEMENTS"), 12, vec2(pos.x - 5, pos.y), COLOR.WHITE)
    pos.y = pos.y + 25;
    if toggleButton.main("idealTemp", vec2(pos.x, pos.y), tyresSettings.store.idealTempActive, language.get("IDEAL_TEMPERATURE")) then
        tyresSettings.store.idealTempActive = not tyresSettings.store.idealTempActive
    end

    pos.y = pos.y + 25;
    if toggleButton.main("tyreNames", vec2(pos.x, pos.y), tyresSettings.store.tyresNameActive, language.get("TYRES_NAME")) then
        tyresSettings.store.tyresNameActive = not tyresSettings.store.tyresNameActive
    end

    pos.y = pos.y + 25;
    if toggleButton.main("psiActive", vec2(pos.x, pos.y), tyresSettings.store.psiActive, language.get("PRESSURE")) then
        tyresSettings.store.psiActive = not tyresSettings.store.psiActive
    end

    pos.y = pos.y + 25;
    if toggleButton.main("psiDelta", vec2(pos.x, pos.y), tyresSettings.store.psiDeltaActive, language.get("PRESSURE_DELTA")) then
        tyresSettings.store.psiDeltaActive = not tyresSettings.store.psiDeltaActive
    end

    pos.y = pos.y + 25;
    if toggleButton.main("coreTemp", vec2(pos.x, pos.y), tyresSettings.store.coreTempActive, language.get("CORE_TEMPERATURE")) then
        tyresSettings.store.coreTempActive = not tyresSettings.store.coreTempActive
    end

    pos.y = pos.y + 25;
    if toggleButton.main("wear", vec2(pos.x, pos.y), tyresSettings.store.wearActive, language.get("WEAR")) then
        tyresSettings.store.wearActive = not tyresSettings.store.wearActive
    end
    
    pos.y = pos.y + 40

    if button.main(pos, language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return tyresSettings
