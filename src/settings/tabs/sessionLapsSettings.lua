local language = require("lang.language")
local sessionlapsSettings = {}

local sessionlapsSettingsStorage = ac.storage {
    windowSessionLapsScale = 1
}

WindowSessionLapsScale = sessionlapsSettingsStorage.windowSessionLapsScale

local function resetToDefault()
    WindowSessionLapsScale = 1

    sessionlapsSettingsStorage.windowSessionLapsScale = WindowSessionLapsScale
end

function sessionlapsSettings.sessionlapsSettings()
    local initPos = 55
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))

    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    WindowSessionLapsScale = ui.slider("##Size", WindowSessionLapsScale, 0.7, 3, string.format("%.2f", WindowSessionLapsScale))
    sessionlapsSettingsStorage.windowSessionLapsScale = WindowSessionLapsScale

    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return sessionlapsSettings