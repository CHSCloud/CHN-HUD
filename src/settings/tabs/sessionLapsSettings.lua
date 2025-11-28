local language = require("lang.language")
local sessionLapsSettings = {}

local defaultValues = {
    sessionLapsScale = 1
}

sessionLapsSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        sessionLapsSettings.store[key] = value
    end
end

function sessionLapsSettings.sessionLapsSettings()
    local initPos = 55
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))

    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    
    -- Uso direto do store com a chave padronizada 'scale'
    sessionLapsSettings.store.sessionLapsScale = ui.slider("##Size", sessionLapsSettings.store.sessionLapsScale, 0.7, 3, string.format("%.2f", sessionLapsSettings.store.sessionLapsScale))

    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return sessionLapsSettings