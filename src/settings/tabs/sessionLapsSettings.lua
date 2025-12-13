local language = require("lang.language")
local SimpleButton = require("src.ui.simpleButton")
local sessionLapsSettings = {}

local defaultValues = {
    sessionLapsScale = 1,
    currentLapActive = true,
    lastLapActive = true,
    bestLapActive = true,
}

local currentLapButton = SimpleButton.new()
local lastLapButton = SimpleButton.new()
local bestLapButton = SimpleButton.new()

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
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("LAPS"))
    initPos = initPos + 20
    sessionLapsSettings.store.currentLapActive = currentLapButton:main(vec2(20, initPos), sessionLapsSettings.store.currentLapActive, language.get("CURRENT"))

    initPos = initPos + 25
    sessionLapsSettings.store.lastLapActive = lastLapButton:main(vec2(20, initPos), sessionLapsSettings.store.lastLapActive, language.get("LAST"))

    initPos = initPos + 25
    sessionLapsSettings.store.bestLapActive = bestLapButton:main(vec2(20, initPos), sessionLapsSettings.store.bestLapActive, language.get("BEST"))


    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return sessionLapsSettings