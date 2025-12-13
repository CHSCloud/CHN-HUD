
local language = require("lang.language")
local button = require("src.ui.button")
local slider = require("src.ui.slider")
local sessionFlagsSettings = {}

local defaultValues = {
    sessionFlagsScale = 1,
}

sessionFlagsSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        sessionFlagsSettings.store[key] = value
    end
end

function sessionFlagsSettings.sessionFlagsSettings()
    local initPos = 75

    -- Escala:
    sessionFlagsSettings.store.sessionFlagsScale = slider.main(language.get("SIZE"), string.format("%.2f", sessionFlagsSettings.store.sessionFlagsScale), vec2(20, initPos), 250, sessionFlagsSettings.store.sessionFlagsScale, 0.7, 3)

    initPos = initPos + 40

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return sessionFlagsSettings