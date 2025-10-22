local pitlaneSettings = {}

local pitSettingsStore = ac.storage{
    windowPitScale = 1,
}

WindowPitScale = pitSettingsStore.windowPitScale

function pitlaneSettings.pitlaneSettings()
    ui.setCursor(vec2(10, 55))
    WindowPitScale = ui.slider("##Size", WindowPitScale, 0.7, 3, string.format("%.2f", WindowPitScale))
    pitSettingsStore.windowPitScale = WindowPitScale
end

return pitlaneSettings