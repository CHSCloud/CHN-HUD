
local language = require("lang.language")
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
    local initPos = 55

    -- Escala:
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    sessionFlagsSettings.store.sessionFlagsScale = ui.slider("##Size", sessionFlagsSettings.store.sessionFlagsScale, 0.7, 3, string.format("%.2f", sessionFlagsSettings.store.sessionFlagsScale))

    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return sessionFlagsSettings