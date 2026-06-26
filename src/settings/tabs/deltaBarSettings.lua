local language = require("language.language")
local button = require("src.ui.buttons.button")
local slider = require("src.ui.selectors.slider")

local deltaBarSettings = {}

local defaultValues = {
    deltaBarScale = 1,
}

deltaBarSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        deltaBarSettings.store[key] = value
    end
end

function deltaBarSettings.deltaBarSettings()
    local initPos = 75

    -- Escala:
    deltaBarSettings.store.deltaBarScale = slider.main(language.get("SIZE"),
        string.format("%.2f", deltaBarSettings.store.deltaBarScale), vec2(20, initPos), 250,
        deltaBarSettings.store.deltaBarScale, 0.7, 2)

    initPos = initPos + 40

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return deltaBarSettings
