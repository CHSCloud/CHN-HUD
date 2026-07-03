local language = require("language.language")
local utils = require("common.utils")
local button = require("src.ui.buttons.button")
local droplist = require("src.ui.selectors.droplist")
local slider = require("src.ui.selectors.slider")
local tyresSettings = {}

local defaultValues = {
    tyresScale = 1,
}

tyresSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        tyresSettings.store[key] = value
    end
end

function tyresSettings.tyresSettings()
    local initPos = 75

    tyresSettings.store.tyresScale = slider.main(language.get("SIZE"),
        string.format("%.2f", tyresSettings.store.tyresScale), vec2(20, initPos), 250,
        tyresSettings.store.tyresScale, 0.7, 3)

    
    initPos = initPos + 40

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return tyresSettings
