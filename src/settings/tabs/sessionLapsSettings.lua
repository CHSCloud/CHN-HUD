local language = require("lang.language")
local sessionlapsSettings = {}

local defaultValues = {
    sessionLapsScale = 1
}

sessionlapsSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        sessionlapsSettings.store[key] = value
    end
end

function sessionlapsSettings.sessionlapsSettings()
    local initPos = 55
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))

    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    
    -- Uso direto do store com a chave padronizada 'scale'
    sessionlapsSettings.store.sessionLapsScale = ui.slider("##Size", sessionlapsSettings.store.sessionLapsScale, 0.7, 3, string.format("%.2f", sessionlapsSettings.store.sessionLapsScale))

    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return sessionlapsSettings