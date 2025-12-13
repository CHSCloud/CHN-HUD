local language = require("lang.language")
local slider = require("src.ui.slider")
local button = require("src.ui.button")
local ToggleButton = require("src.ui.toggleButton")
local sessionLapsSettings = {}

local defaultValues = {
    sessionLapsScale = 1,
    currentLapActive = true,
    lastLapActive = true,
    bestLapActive = true,
}

local currentLapButton = ToggleButton.new()
local lastLapButton = ToggleButton.new()
local bestLapButton = ToggleButton.new()

sessionLapsSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        sessionLapsSettings.store[key] = value
    end
end

function sessionLapsSettings.sessionLapsSettings()
    local initPos = 75
    -- Uso direto do store com a chave padronizada 'scale'
    sessionLapsSettings.store.sessionLapsScale = slider.main(language.get("SIZE"), string.format("%.2f", sessionLapsSettings.store.sessionLapsScale), vec2(20, initPos), 250, sessionLapsSettings.store.sessionLapsScale, 0.7, 3)

    
    initPos = initPos + 40
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("LAPS"))
    initPos = initPos + 20
    if currentLapButton:main(vec2(20, initPos), sessionLapsSettings.store.currentLapActive, language.get("CURRENT")) then
        sessionLapsSettings.store.currentLapActive = not sessionLapsSettings.store.currentLapActive
    end

    initPos = initPos + 25
    if lastLapButton:main(vec2(20, initPos), sessionLapsSettings.store.lastLapActive, language.get("LAST")) then
        sessionLapsSettings.store.lastLapActive = not sessionLapsSettings.store.lastLapActive
    end

    initPos = initPos + 25
    if bestLapButton:main(vec2(20, initPos), sessionLapsSettings.store.bestLapActive, language.get("BEST")) then
        sessionLapsSettings.store.bestLapActive = not sessionLapsSettings.store.bestLapActive
    end

    initPos = initPos + 40
    
    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return sessionLapsSettings