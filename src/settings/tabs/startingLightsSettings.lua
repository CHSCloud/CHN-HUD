
local language = require("lang.language")
local startingLightsSettings = {}

local defaultValues = {
    startingLightsScale = 1,
    numStartingLights = 5
}

startingLightsSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        startingLightsSettings.store[key] = value
    end
end

function startingLightsSettings.startingLightsSettings()
    local initPos = 55

    -- Escala:
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    startingLightsSettings.store.startingLightsScale = ui.slider("##Size", startingLightsSettings.store.startingLightsScale, 0.7, 3, string.format("%.2f", startingLightsSettings.store.startingLightsScale))
    
    -- Número de Luzes:
    initPos = initPos + 30
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("NUM_LIGHTS"))
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    startingLightsSettings.store.numStartingLights = math.floor(ui.slider("##NumLightsStart", startingLightsSettings.store.numStartingLights, 4, 10, string.format("%i", startingLightsSettings.store.numStartingLights)))

    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return startingLightsSettings