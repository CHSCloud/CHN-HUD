local language = require("lang.language")
local button = require("src.ui.button")
local slider = require("src.ui.slider")

local leaderboardSettings = {}

local defaultValues = {
    leaderboardScale = 1,
}

leaderboardSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        leaderboardSettings.store[key] = value
    end
end

function leaderboardSettings.leaderboardSettings()
    local initPos = 75

    -- Escala:
    leaderboardSettings.store.leaderboardScale = slider.main(language.get("SIZE"), string.format("%.2f", leaderboardSettings.store.leaderboardScale), vec2(20, initPos), 250, leaderboardSettings.store.leaderboardScale, 0.7, 2)

    initPos = initPos + 40

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefault()
    end 
end


return leaderboardSettings