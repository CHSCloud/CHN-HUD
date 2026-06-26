local language = require("language.language")
local button = require("src.ui.buttons.button")
local slider = require("src.ui.selectors.slider")
local startingLightsSettings = {}

local defaultValues = {
    startingLightsScale = 1,
    numStartingLights = 4
}

startingLightsSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        startingLightsSettings.store[key] = value
    end
end

function startingLightsSettings.startingLightsSettings()
    local initPos = 75

    -- Escala:
    startingLightsSettings.store.startingLightsScale = slider.main(language.get("SIZE"),
        string.format("%.2f", startingLightsSettings.store.startingLightsScale), vec2(20, initPos), 250,
        startingLightsSettings.store.startingLightsScale, 0.7, 3)

    -- Número de Luzes:
    initPos = initPos + 50
    startingLightsSettings.store.numStartingLights = math.floor(slider.main(language.get("NUM_LIGHTS"),
        string.format("%i", startingLightsSettings.store.numStartingLights), vec2(20, initPos), 250,
        startingLightsSettings.store.numStartingLights, 4, 10))

    initPos = initPos + 40

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return startingLightsSettings
