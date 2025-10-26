local language = require("lang.language")
local sessionlapsSettings = {}

local sessionlapsSettingsStorage = ac.storage {
    windowSessionLapsScale = 1
}

WindowSessionLapsScale = sessionlapsSettingsStorage.windowSessionLapsScale

function sessionlapsSettings.sessionlapsSettings()
    ui.setCursor(vec2(10, 55))
    ui.header(language.get("SIZE"))
    ui.setCursor(vec2(10, 75))
    WindowSessionLapsScale = ui.slider("##Size", WindowSessionLapsScale, 0.7, 3, string.format("%.2f", WindowSessionLapsScale))
    sessionlapsSettingsStorage.windowSessionLapsScale = WindowSessionLapsScale
end

return sessionlapsSettings