
local language = require("lang.language")
local startingLightsSettings = {}

local defaultValues = {
    startingLightsScale = 1
}

startingLightsSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        startingLightsSettings.store[key] = value
    end
end

function startingLightsSettings.startingLightsSettings()
    local initPos = 55
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))

    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    
    -- Uso direto do store com a chave padronizada 'scale'
    startingLightsSettings.store.startingLightsScale = ui.slider("##Size", startingLightsSettings.store.startingLightsScale, 0.7, 3, string.format("%.2f", startingLightsSettings.store.startingLightsScale))

    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return startingLightsSettings