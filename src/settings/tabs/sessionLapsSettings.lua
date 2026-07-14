local language = require("language.language")
local slider = require("src.ui.selectors.slider")
local button = require("src.ui.buttons.button")
local toggleButton = require("src.ui.buttons.toggleButton")
local sessionLapsSettings = {}

local defaultValues = {
    sessionLapsScale = 1,
    currentLapActive = true,
    lastLapActive = true,
    bestLapActive = true,
    sectorsLapActive = true,
    numberDivisions = 7
}


sessionLapsSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        sessionLapsSettings.store[key] = value
    end
end

function sessionLapsSettings.sessionLapsSettings()
    local initPos = 75
    -- Uso direto do store com a chave padronizada 'scale'
    sessionLapsSettings.store.sessionLapsScale = slider.main(language.get("SIZE"),
        string.format("%.2f", sessionLapsSettings.store.sessionLapsScale), vec2(20, initPos), 250,
        sessionLapsSettings.store.sessionLapsScale, 0.7, 3)


    initPos = initPos + 30
    ui.dwriteDrawText(language.get("LAPS"), 12, vec2(15, initPos), COLOR.WHITE)

    initPos = initPos + 23
    if toggleButton.main("current", vec2(20, initPos), sessionLapsSettings.store.currentLapActive, language.get("CURRENT")) then
        sessionLapsSettings.store.currentLapActive = not sessionLapsSettings.store.currentLapActive
    end

    initPos = initPos + 25
    if toggleButton.main("last", vec2(20, initPos), sessionLapsSettings.store.lastLapActive, language.get("LAST")) then
        sessionLapsSettings.store.lastLapActive = not sessionLapsSettings.store.lastLapActive
    end

    initPos = initPos + 25
    if toggleButton.main("best", vec2(20, initPos), sessionLapsSettings.store.bestLapActive, language.get("BEST")) then
        sessionLapsSettings.store.bestLapActive = not sessionLapsSettings.store.bestLapActive
    end

    initPos = initPos + 25
    if toggleButton.main("sectorsLapActive", vec2(20, initPos), sessionLapsSettings.store.sectorsLapActive, language.get("SECTORS")) then
        sessionLapsSettings.store.sectorsLapActive = not sessionLapsSettings.store.sectorsLapActive
    end

    if sessionLapsSettings.store.sectorsLapActive then
        initPos = initPos + 30
        sessionLapsSettings.store.numberDivisions = math.floor(slider.main("",
            string.format("%d", sessionLapsSettings.store.numberDivisions), vec2(20, initPos), 250,
            sessionLapsSettings.store.numberDivisions, 3, 10))
    end

    initPos = initPos + 40

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return sessionLapsSettings
