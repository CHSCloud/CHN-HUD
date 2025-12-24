local mapSettings = {}
local colorSelector = require("src.ui.colorSelector")
local slider = require("src.ui.slider")
local button = require("src.ui.button")
local toggleButton = require("src.ui.toggleButton")

local config = require("common.config")
local language = require("lang.language")


local defaultValues = {}

local defaultValuesTrack = {
    mapScale = 1.3,
    angle = 0,
    focus = false,
    zoom = 100,
    colorTrack = rgbm.from0255(0, 0, 0, 1),
    colorBorder = rgbm.from0255(255, 255, 255, 1),
    borderActive = true,
    borderLenght = 4,
    trackLenght = 12
}

local defaultValuesFeatures = {
    sectorsActive = true,
    colorSectors = rgbm.from0255(255, 255, 255, 1),
    drsActive = true,
    colorDRS = rgbm.from0255(0, 255, 0, 1),
}
local defaultValuesPlayers = {
    colorEnemies = rgbm.from0255(255, 255, 255, 1),
    colorFocusedCar = rgbm.from0255(255, 255, 0, 1),
    colorExternalEnemies = rgbm.from0255(0, 0, 0, 1),
    colorExternalFocusedCar = rgbm.from0255(0, 0, 0, 1),

    focusedCarLenght = 20,
    enemiesLenght = 20
}  

config.copyTable(defaultValuesTrack, defaultValues)
config.copyTable(defaultValuesFeatures, defaultValues)
config.copyTable(defaultValuesPlayers, defaultValues)
mapSettings.store = ac.storage(defaultValues)


local function resetToDefaultTrack()
    for key, value in pairs(defaultValuesTrack) do
        mapSettings.store[key] = value
    end
    mapSettings.store.colorTrack = rgbm.from0255(0, 0, 0, 1)
    mapSettings.store.colorBorder = rgbm.from0255(255, 255, 255, 1)
end

local function resetToDefaultFeatures()
    for key, value in pairs(defaultValuesFeatures) do
        mapSettings.store[key] = value
    end
    mapSettings.store.colorSectors = rgbm.from0255(255, 255, 255, 1)
    mapSettings.store.colorDRS = rgbm.from0255(0, 255, 0, 1)
end

local function resetToDefaultPlayers()
    for key, value in pairs(defaultValuesPlayers) do
        mapSettings.store[key] = value
    end
    mapSettings.store.colorEnemies = rgbm.from0255(255, 255, 255, 1)
    mapSettings.store.colorFocusedCar = rgbm.from0255(255, 255, 0, 1)
    mapSettings.store.colorExternalFocusedCar = rgbm.from0255(0, 0, 0, 1)
    mapSettings.store.colorExternalEnemies = rgbm.from0255(0, 0, 0, 1)
end


local function trackSetitngs()
    local initPos = 100

    -- Escala:
    mapSettings.store.mapScale = slider.main(language.get("SIZE"), string.format("%.2f", mapSettings.store.mapScale), vec2(20, initPos), 250, mapSettings.store.mapScale, 1, 2)
    

    initPos = initPos + 50
    mapSettings.store.angle = math.floor(slider.main(language.get("ANGLE"), string.format("%.0f", mapSettings.store.angle), vec2(20, initPos), 250, mapSettings.store.angle, 0, 360))
    
    initPos = initPos + 50
    mapSettings.store.trackLenght = math.floor(slider.main(language.get("TRACK_LENGHT"), string.format("%.0f", mapSettings.store.trackLenght), vec2(20, initPos), 250, mapSettings.store.trackLenght, 12, 25))
    initPos = initPos + 30

    if toggleButton.main("borderMap", vec2(20, initPos), mapSettings.store.borderActive, language.get("BORDER")) then
        mapSettings.store.borderActive = not mapSettings.store.borderActive
    end
    if mapSettings.store.borderActive then
        if mapSettings.store.borderLenght == -2 then
            mapSettings.store.borderLenght = 4
        end
        mapSettings.store.borderLenght = math.floor(slider.main("", string.format("%.0f", mapSettings.store.borderLenght), vec2(130, initPos + 2), 200, mapSettings.store.borderLenght, 4, 10))
    else
        mapSettings.store.borderLenght = -2 
    end

    initPos = initPos + 40
    if toggleButton.main("focus",vec2(20, initPos), mapSettings.store.focus, language.get("FOCUS")) then
        mapSettings.store.focus = not mapSettings.store.focus
    end
    if mapSettings.store.focus then
        mapSettings.store.zoom = math.floor(slider.main(language.get("ZOOM"), string.format("%.0f", mapSettings.store.zoom), vec2(120, initPos + 2), 200, mapSettings.store.zoom, 0, 200, slider.PosText.Start))
    end
    

    initPos = initPos + 30
    ui.setCursor(vec2(15, initPos))
    ui.header("Colors")

    initPos = initPos + 20
    mapSettings.store.colorTrack = colorSelector.main(language.get("TRACK"), mapSettings.store.colorTrack, vec2(20, initPos))
    mapSettings.store.colorSectors = colorSelector.main(language.get("SECTORS"), mapSettings.store.colorSectors, vec2(100, initPos))
    initPos = initPos + 30
    mapSettings.store.colorBorder = colorSelector.main(language.get("BORDER"), mapSettings.store.colorBorder, vec2(20, initPos))
    mapSettings.store.colorDRS = colorSelector.main(language.get("DRS"), mapSettings.store.colorDRS, vec2(100, initPos))
    initPos = initPos + 30

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefaultTrack()
    end 
end

local function featuresSettings()
    local initPos = 80
    if toggleButton.main("sectors", vec2(20, initPos), mapSettings.store.sectorsActive, "Sectors") then
        mapSettings.store.sectorsActive = not mapSettings.store.sectorsActive
    end
    initPos = initPos + 30

    if toggleButton.main("drs", vec2(20, initPos), mapSettings.store.drsActive, "DRS") then
        mapSettings.store.drsActive = not mapSettings.store.drsActive
    end
    initPos = initPos + 30
    
    mapSettings.store.colorSectors = colorSelector.main("Sectors", mapSettings.store.colorSectors, vec2(20, initPos))
    mapSettings.store.colorDRS = colorSelector.main("DRS", mapSettings.store.colorDRS, vec2(100, initPos))
    initPos = initPos + 40

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefaultFeatures()
    end
end

local function playersSetitngs()
    local initPos = 100

    mapSettings.store.focusedCarLenght = math.floor(slider.main(language.get("FOCUSED_CAR_LENGHT"), string.format("%.0f", mapSettings.store.focusedCarLenght), vec2(20, initPos), 200, mapSettings.store.focusedCarLenght, 10, 30))
    initPos = initPos + 50
    mapSettings.store.enemiesLenght = math.floor(slider.main(language.get("ENEMIES_LENGHT"), string.format("%.0f", mapSettings.store.enemiesLenght), vec2(20, initPos), 200, mapSettings.store.enemiesLenght, 10, 30))

    initPos = initPos + 30
    ui.setCursor(vec2(20, initPos))
    ui.header(language.get("FOCUSED_CAR_COLOR"))
    initPos = initPos + 20
    mapSettings.store.colorFocusedCar = colorSelector.main(language.get("INTERNAL"), mapSettings.store.colorFocusedCar, vec2(20, initPos), "##InternalFocused")
    mapSettings.store.colorExternalFocusedCar = colorSelector.main(language.get("BORDER"), mapSettings.store.colorExternalFocusedCar, vec2(100, initPos), "##BorderFocused")

    initPos = initPos + 30
    ui.setCursor(vec2(20, initPos))
    ui.header("Enemies Color")
    initPos = initPos + 20
    mapSettings.store.colorEnemies = colorSelector.main(language.get("INTERNAL"), mapSettings.store.colorEnemies, vec2(20, initPos), "##InternalEnemies")
    mapSettings.store.colorExternalEnemies = colorSelector.main(language.get("BORDER"), mapSettings.store.colorExternalEnemies, vec2(100, initPos), "##BorderEnemies")

    initPos = initPos + 30
    ui.setCursor(vec2(20, initPos))
    ui.header("In Pit Lane")
    initPos = initPos + 20
    mapSettings.store.colorInPitLane = colorSelector.main(language.get("INTERNAL"), mapSettings.store.colorInPitLane, vec2(20, initPos), "##InternaInPitLane")
    mapSettings.store.colorExternalInPitLane = colorSelector.main(language.get("BORDER"), mapSettings.store.colorExternalInPitLane, vec2(100, initPos), "##BorderInPitLane")
    initPos = initPos + 30

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefaultPlayers()
    end
end


function mapSettings.mapSettings()
    ui.tabBar('##ID',function ()
        ui.tabItem(language.get("TRACK"), trackSetitngs)
        ui.tabItem(language.get("PLAYERS"), playersSetitngs)
    end)
end

return mapSettings