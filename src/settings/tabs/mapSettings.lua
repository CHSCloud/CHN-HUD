local mapSettings = {}
local colorSelector = require("src.ui.colorSelector")
local language = require("lang.language")

local defaultValues = {
    mapScale = 0.7,
    angle = 0,
    colorTrack = rgbm.from0255(0, 0, 0, 1),
    colorBorder = rgbm.from0255(255, 255, 255, 1),
}

local colorTrackActive = false
local colorBorderActive = false

mapSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        mapSettings.store[key] = value
    end
    mapSettings.store.colorTrack = rgbm.from0255(0, 0, 0, 1)
    mapSettings.store.colorBorder = rgbm.from0255(255, 255, 255, 1)
end

function mapSettings.mapSettings()
    local initPos = 55

    -- Escala:
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    mapSettings.store.mapScale = ui.slider("##Size", mapSettings.store.mapScale, 0.4, 2, string.format("%.2f", mapSettings.store.mapScale))
    initPos = initPos + 20

    
    ui.setCursor(vec2(15, initPos))
    ui.header("Angle")
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    mapSettings.store.angle = ui.slider("##Angle", mapSettings.store.angle, 0, 360, string.format("%.0f", mapSettings.store.angle))

    initPos = initPos + 60

    ui.setCursor(vec2(20, initPos + 100))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
    colorTrackActive = colorSelector.main(mapSettings.store.colorTrack, "TRACK", vec2(50, initPos), 15, colorTrackActive)
    colorBorderActive = colorSelector.main(mapSettings.store.colorBorder, "BORDER", vec2(50, initPos + 35), 15, colorBorderActive)
end

return mapSettings