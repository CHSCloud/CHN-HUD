local mapSettings = {}
local colorSelector = require("src.ui.colorSelector")
local simpleCheckbox = require("src.ui.simpleCheckBox")
local language = require("lang.language")

local defaultValues = {
    mapScale = 0.7,
    angle = 0,
    colorTrack = rgbm.from0255(0, 0, 0, 1),
    colorBorder = rgbm.from0255(255, 255, 255, 1),
    colorSectors = rgbm.from0255(255, 255, 255, 1),
    borderActive = true,
    borderLenght = 4,
    trackLenght = 8
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
    mapSettings.store.colorSectors = rgbm.from0255(255, 255, 255, 1)
end

function mapSettings.mapSettings()
    local initPos = 55

    -- Escala:
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    mapSettings.store.mapScale = ui.slider("##Size", mapSettings.store.mapScale, 0.4, 2, string.format("%.2f", mapSettings.store.mapScale))
    

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
    mapSettings.store.trackLenght = ui.slider("##TrackLenght", mapSettings.store.trackLenght, 4, 15, string.format("%.0f", mapSettings.store.trackLenght))

    initPos = initPos + 30

    mapSettings.store.borderActive = simpleCheckbox.main("Border", mapSettings.store.borderActive, 20, initPos)
    if mapSettings.store.borderActive then
        if mapSettings.store.borderLenght == -2 then
            mapSettings.store.borderLenght = 4
        end
        initPos = initPos + 30
        ui.setCursor(vec2(15, initPos))
        ui.header("Border Lenght")
        initPos = initPos + 20
        ui.setCursor(vec2(20, initPos))
        mapSettings.store.borderLenght = ui.slider("##BorderLenght", mapSettings.store.borderLenght, 1, 10, string.format("%.0f", mapSettings.store.borderLenght))
    else
        mapSettings.store.borderLenght = -2 
    end

    initPos = initPos + 30
    ui.setCursor(vec2(20, initPos))    
    if ui.colorButton(
            '##TrackColor',
            mapSettings.store.colorTrack,
            ui.ColorPickerFlags.AlphaBar + ui.ColorPickerFlags.AlphaPreview + ui.ColorPickerFlags.PickerHueBar) then
        mapSettings.store.colorTrack = mapSettings.store.colorTrack
    end
    ui.setCursor(vec2(45, initPos + 5))
    ui.dwriteText("Track", 10, COLOR.WHITE)

    initPos = initPos + 30
    ui.setCursor(vec2(45, initPos + 5))
    ui.dwriteText("Sectors", 10, COLOR.WHITE)
    ui.setCursor(vec2(20, initPos))  
    if ui.colorButton(
            '##SectorsColor',
            mapSettings.store.colorSectors,
            ui.ColorPickerFlags.AlphaBar + ui.ColorPickerFlags.AlphaPreview + ui.ColorPickerFlags.PickerHueBar) then
        mapSettings.store.colorBorder = mapSettings.store.colorBorder
    end

    initPos = initPos + 30
    ui.setCursor(vec2(45, initPos + 5))
    ui.dwriteText("Border", 10, COLOR.WHITE)
    ui.setCursor(vec2(20, initPos))  
    if ui.colorButton(
            '##BorderColor',
            mapSettings.store.colorBorder,
            ui.ColorPickerFlags.AlphaBar + ui.ColorPickerFlags.AlphaPreview + ui.ColorPickerFlags.PickerHueBar) then
        mapSettings.store.colorBorder = mapSettings.store.colorBorder
    end
    
    --ui.colorPicker("track", mapSettings.store.colorTrack, ui.ColorPickerFlags.NoInputs + ui.ColorPickerFlags.NoSidePreview + ui.Color)

    ui.setCursor(vec2(20, initPos + 100))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end
    --colorTrackActive = colorSelector.main(mapSettings.store.colorTrack, "TRACK", vec2(50, initPos), 15, colorTrackActive)
    --colorBorderActive = colorSelector.main(mapSettings.store.colorBorder, "BORDER", vec2(50, initPos + 35), 15, colorBorderActive)
end

return mapSettings