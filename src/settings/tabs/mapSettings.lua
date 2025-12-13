local mapSettings = {}
local colorSelector = require("src.ui.colorSelector")
local SimpleButton = require("src.ui.simpleButton")
local language = require("lang.language")

local defaultValues = {
    mapScale = 0.7,
    angle = 0,
    colorTrack = rgbm.from0255(0, 0, 0, 1),
    colorBorder = rgbm.from0255(255, 255, 255, 1),
    colorSectors = rgbm.from0255(255, 255, 255, 1),
    colorDRS = rgbm.from0255(0, 255, 0, 1),
    colorEnemies = rgbm.from0255(255, 255, 255, 1),
    colorPlayer = rgbm.from0255(255, 255, 0, 1),
    borderActive = true,
    borderLenght = 4,
    trackLenght = 8
}

local borderButton = SimpleButton.new()

mapSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        mapSettings.store[key] = value
    end
    mapSettings.store.colorTrack = rgbm.from0255(0, 0, 0, 1)
    mapSettings.store.colorBorder = rgbm.from0255(255, 255, 255, 1)
    mapSettings.store.colorSectors = rgbm.from0255(255, 255, 255, 1)
    mapSettings.store.colorDRS = rgbm.from0255(0, 255, 0, 1)
    mapSettings.store.colorEnemies = rgbm.from0255(255, 255, 255, 1)
    mapSettings.store.colorPlayer = rgbm.from0255(255, 255, 0, 1)
end

function mapSettings.mapSettings()
    local initPos = 55

    -- Escala:
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    mapSettings.store.mapScale = ui.slider("##Size", mapSettings.store.mapScale, 0.5, 2, string.format("%.2f", mapSettings.store.mapScale))
    

    initPos = initPos + 25
    ui.setCursor(vec2(15, initPos))
    ui.header("Angle")
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    mapSettings.store.angle = ui.slider("##Angle", mapSettings.store.angle, 0, 360, string.format("%.0f", mapSettings.store.angle))
    
    initPos = initPos + 25
    ui.setCursor(vec2(15, initPos))
    ui.header("Track Lenght")
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    ui.setNextItemWidth(200)
    mapSettings.store.trackLenght = ui.slider("##TrackLenght", mapSettings.store.trackLenght, 4, 15, string.format("%.0f", mapSettings.store.trackLenght))
    initPos = initPos + 30

    mapSettings.store.borderActive = borderButton:main(vec2(20, initPos), mapSettings.store.borderActive, "Border")
    if mapSettings.store.borderActive then
        if mapSettings.store.borderLenght == -2 then
            mapSettings.store.borderLenght = 4
        end
        ui.setCursor(vec2(120, initPos))
        ui.setNextItemWidth(200)
        mapSettings.store.borderLenght = ui.slider("##BorderLenght", mapSettings.store.borderLenght, 1, 10, string.format("%.0f", mapSettings.store.borderLenght))
    else
        mapSettings.store.borderLenght = -2 
    end

    initPos = initPos + 40
    ui.setCursor(vec2(15, initPos))
    ui.header("Map")
    ui.setCursor(vec2(95, initPos))
    ui.header("Players")
    mapSettings.store.colorPlayer = colorSelector.main("Player", mapSettings.store.colorPlayer, vec2(100, initPos + 20))
    mapSettings.store.colorEnemies = colorSelector.main("Enemies", mapSettings.store.colorEnemies, vec2(100, initPos + 50))

    initPos = initPos + 20
    mapSettings.store.colorTrack = colorSelector.main("Track", mapSettings.store.colorTrack, vec2(20, initPos))
    initPos = initPos + 30
    mapSettings.store.colorBorder = colorSelector.main("Border", mapSettings.store.colorBorder, vec2(20, initPos))
    initPos = initPos + 30
    mapSettings.store.colorSectors = colorSelector.main("Sectors", mapSettings.store.colorSectors, vec2(20, initPos))
    initPos = initPos + 30
    mapSettings.store.colorDRS = colorSelector.main("DRS", mapSettings.store.colorDRS, vec2(20, initPos))

    ui.setCursor(vec2(20, initPos + 30))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
end

return mapSettings