local language = require("lang.language")
local button = require("src.ui.button")
local droplist = require("src.ui.droplist")
local slider = require("src.ui.slider")
local pitLaneSettings = {}

local defaultValues = {
    pitLaneScale = 1,
    optionPlate = 1
}

pitLaneSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        pitLaneSettings.store[key] = value
    end
end

function pitLaneSettings.pitLaneSettings()
    local plates = {
        language.get("DEFAULT"),
        language.get("ALERT_PIT")
    }
    
    local initPos = 75
    
    pitLaneSettings.store.pitLaneScale = slider.main(language.get("SIZE"), string.format("%.2f", pitLaneSettings.store.pitLaneScale), vec2(20, initPos), 250, pitLaneSettings.store.pitLaneScale, 0.7, 3)

    initPos = initPos + 60
    pitLaneSettings.store.optionPlate = droplist.main("##stylePitlane", language.get("STYLE"), vec2(20, initPos + 5), 100, pitLaneSettings.store.optionPlate, plates, droplist.PosText.Default)

    initPos = initPos + 40

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return pitLaneSettings