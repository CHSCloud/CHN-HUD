local mapSettings = {}
local colorSelector = require("src.ui.colorSelector")
local slider = require("src.ui.slider")
local button = require("src.ui.button")
local toggleButton = require("src.ui.toggleButton")
local droplist = require("src.ui.droplist")
local sectionPanel = require("src.ui.sectionPanel")
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

local defaultValuesSections = {
    sectionsTrackActive = false,
    resetSectionsINI = false,
    trackSectionsEdited = false,
    sectionsType = 1,
    sectionsLenght = 7
}

local defaultValuesPlayers = {
    colorEnemies = rgbm.from0255(255, 255, 255, 1),
    colorFocusedCar = rgbm.from0255(255, 255, 0, 1),
    colorExternalEnemies = rgbm.from0255(0, 0, 0, 1),
    colorExternalFocusedCar = rgbm.from0255(0, 0, 0, 1),

    focusedCarLenght = 10,
    enemiesLenght = 10
}  

config.copyTable(defaultValuesTrack, defaultValues)
config.copyTable(defaultValuesFeatures, defaultValues)
config.copyTable(defaultValuesPlayers, defaultValues)
config.copyTable(defaultValuesSections, defaultValues)
mapSettings.store = ac.storage(defaultValues)
mapSettings.isClockwise = false -- Sentido de orintação da pista

local function resetToDefaultTrack()
    for key, value in pairs(defaultValuesTrack) do
        mapSettings.store[key] = value
    end
    mapSettings.store.colorTrack = rgbm.from0255(0, 0, 0, 1)
    mapSettings.store.colorBorder = rgbm.from0255(255, 255, 255, 1)
end

local function resetToDefaultSections()
    for key, value in pairs(defaultValuesSections) do
        mapSettings.store[key] = value
    end
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

-- Reseta as seções do arquivo para o padrão
--- @return table
function mapSettings.resetSectionsINI()
    local trackSections = {}
    local filePath = ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\CHN-HUD\\user\\trackSections\\" .. ac.getTrackName() .. ".ini"
    if not io.fileExists(filePath) then
        io.save(filePath, "")
    end
    local userSectionsINI = ac.INIConfig.load(filePath)
    local defaultFilePath = ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\CHN-HUD\\user\\defaultTrackSections\\" .. ac.getTrackName() .. ".ini"
    if io.fileExists(defaultFilePath) then
        local defaultSectionsINI = ac.INIConfig.load(defaultFilePath)
        for i, section in defaultSectionsINI:iterate('SECTION', false) do
            local progress = defaultSectionsINI:get(section, 'PROGRESS', 0)
            local position = defaultSectionsINI:get(section, 'POSITION', 0)
            local text = defaultSectionsINI:get(section, 'TEXT', "")
            if progress ~= nil and position ~= nil and text ~= nil then
                userSectionsINI:set(section, "TEXT", text)
                userSectionsINI:set(section, "PROGRESS", progress)
                userSectionsINI:set(section, "POSITION", position)
                local worldLeft = ac.trackCoordinateToWorld(vec3(1, 0, tonumber(progress)))
                local worldLeft2d = vec2(worldLeft.x, worldLeft.z)
                local worldCenter = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(progress)))
                local worldCenter2d = vec2(worldCenter.x, worldCenter.z)
                local worldRight = ac.trackCoordinateToWorld(vec3(-1, 0, tonumber(progress)))
                local worldRight2d = vec2(worldRight.x, worldRight.z)
                table.insert(trackSections, {
                    number = tostring(i),
                    name = string.replace(text, '\\n', '\n'),
                    left = worldLeft2d,
                    center = worldCenter2d,
                    right = worldRight2d,
                    position = position,
                    namePosition = nil
                })
            end
        end
    else
        local sectionsINI = ac.INIConfig.trackData("sections.ini")
        if sectionsINI ~= nil then
            for i, section in sectionsINI:iterate('SECTION', false) do
                local start = sectionsINI:get(section, 'IN', 0)
                local final = sectionsINI:get(section, 'OUT', 0)
                local text = sectionsINI:get(section, 'TEXT', "")
                if start ~= nil and final ~= nil and text ~= nil then
                    local position = mapSettings.isClockwise and 2 or 3
                    local center = tonumber(((final - start) / 2) + start)
                    userSectionsINI:set(section, "TEXT", text)
                    userSectionsINI:set(section, "PROGRESS", center)
                    userSectionsINI:set(section, "POSITION", position)

                    local worldLeft = ac.trackCoordinateToWorld(vec3(1, 0, center))
                    local worldLeft2d = vec2(worldLeft.x, worldLeft.z)
                    local worldCenter = ac.trackCoordinateToWorld(vec3(0, 0, center))
                    local worldCenter2d = vec2(worldCenter.x, worldCenter.z)
                    local worldRight = ac.trackCoordinateToWorld(vec3(-1, 0, center))
                    local worldRight2d = vec2(worldRight.x, worldRight.z)
                    table.insert(trackSections, {
                        number = tostring(i),
                        name = string.replace(text, '\\n', '\n'),
                        left = worldLeft2d,
                        center = worldCenter2d,
                        right = worldRight2d,
                        position = position,
                        namePosition = nil
                    })
                end
            end
        end
    end
    userSectionsINI:save()
    return trackSections
end

-- Carrega as seções do arquivo
--- @return table
function mapSettings.loadSectionsINI()
    local trackSections = {}
    local filePath = ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\CHN-HUD\\user\\trackSections\\" .. ac.getTrackName() .. ".ini"
    -- Caso o arquivo do usuário não exista, cria um novo
    if not io.fileExists(filePath) then
        io.save(filePath, "")
        local userSectionsINI = ac.INIConfig.load(filePath)
        local defaultFilePath = ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\CHN-HUD\\user\\defaultTrackSections\\" .. ac.getTrackName() .. ".ini"
        -- Verifica se existe um arquivo padrão
        if io.fileExists(defaultFilePath) then
            local defaultSectionsINI = ac.INIConfig.load(defaultFilePath)
            for i, section in defaultSectionsINI:iterate('SECTION', false) do
                local progress = defaultSectionsINI:get(section, 'PROGRESS', 0)
                local position = defaultSectionsINI:get(section, 'POSITION', 0)
                local text = defaultSectionsINI:get(section, 'TEXT', "")
                if progress ~= nil and position ~= nil and text ~= nil then
                    userSectionsINI:set(section, "TEXT", text)
                    userSectionsINI:set(section, "PROGRESS", progress)
                    userSectionsINI:set(section, "POSITION", position)
                    local worldLeft = ac.trackCoordinateToWorld(vec3(1, 0, tonumber(progress)))
                    local worldLeft2d = vec2(worldLeft.x, worldLeft.z)
                    local worldCenter = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(progress)))
                    local worldCenter2d = vec2(worldCenter.x, worldCenter.z)
                    local worldRight = ac.trackCoordinateToWorld(vec3(-1, 0, tonumber(progress)))
                    local worldRight2d = vec2(worldRight.x, worldRight.z)
                    table.insert(trackSections, {
                        number = tostring(i),
                        name = string.replace(text, '\\n', '\n'),
                        left = worldLeft2d,
                        center = worldCenter2d,
                        right = worldRight2d,
                        position = position,
                        namePosition = nil
                    })
                end
            end
        else
            -- Alimenta o arquivo do usuário com o padrão do jogo
            local sectionsINI = ac.INIConfig.trackData("sections.ini")
            if sectionsINI ~= nil then
                for i, section in sectionsINI:iterate('SECTION', false) do
                    local start = sectionsINI:get(section, 'IN', 0)
                    local final = sectionsINI:get(section, 'OUT', 0)
                    local text = sectionsINI:get(section, 'TEXT', "")
                    if start ~= nil and final ~= nil and text ~= nil then
                        local position = mapSettings.isClockwise and 2 or 3 
                        local center = tonumber(((final - start) / 2) + start)
                        userSectionsINI:set(section, "TEXT", text)
                        userSectionsINI:set(section, "PROGRESS", center)
                        userSectionsINI:set(section, "POSITION", position)

                        local worldLeft = ac.trackCoordinateToWorld(vec3(1, 0, center))
                        local worldLeft2d = vec2(worldLeft.x, worldLeft.z)
                        local worldCenter = ac.trackCoordinateToWorld(vec3(0, 0, center))
                        local worldCenter2d = vec2(worldCenter.x, worldCenter.z)
                        local worldRight = ac.trackCoordinateToWorld(vec3(-1, 0, center))
                        local worldRight2d = vec2(worldRight.x, worldRight.z)
                        table.insert(trackSections, {
                            number = tostring(i),
                            name = string.replace(text, '\\n', '\n'),
                            left = worldLeft2d,
                            center = worldCenter2d,
                            right = worldRight2d,
                            position = position,
                            namePosition = nil
                        })
                    end
                end
            end
        end
        userSectionsINI:save()
    else 
        -- Carrega o arquivo do usuário
        local userSectionsINI = ac.INIConfig.load(filePath)
        if userSectionsINI ~= nil then
            for i, section in userSectionsINI:iterate('SECTION', false) do
                local progress = userSectionsINI:get(section, 'PROGRESS', 0)
                local position = userSectionsINI:get(section, 'POSITION', 0)
                local text = userSectionsINI:get(section, 'TEXT', "")
                if progress ~= nil and position ~= nil and text ~= nil then
                    local worldLeft = ac.trackCoordinateToWorld(vec3(1, 0, tonumber(progress)))
                    local worldLeft2d = vec2(worldLeft.x, worldLeft.z)
                    local worldCenter = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(progress)))
                    local worldCenter2d = vec2(worldCenter.x, worldCenter.z)
                    local worldRight = ac.trackCoordinateToWorld(vec3(-1, 0, tonumber(progress)))
                    local worldRight2d = vec2(worldRight.x, worldRight.z)
                    table.insert(trackSections, {
                        number = tostring(i),
                        name = string.replace(text, '\\n', '\n'),
                        left = worldLeft2d,
                        center = worldCenter2d,
                        right = worldRight2d,
                        position = position,
                        namePosition = nil
                    })
                end
            end
        end
    end

    return trackSections
end

-- Configurações da pista
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
    initPos = initPos + 30
    mapSettings.store.colorBorder = colorSelector.main(language.get("BORDER"), mapSettings.store.colorBorder, vec2(20, initPos))
    initPos = initPos + 30

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefaultTrack()
    end 
end

-- Configurações das Características da pista
local function featuresSettings()
    local initPos = 80
    if toggleButton.main("sectors", vec2(20, initPos), mapSettings.store.sectorsActive, language.get("SECTORS")) then
        mapSettings.store.sectorsActive = not mapSettings.store.sectorsActive
    end
    initPos = initPos + 30

    if toggleButton.main("drs", vec2(20, initPos), mapSettings.store.drsActive, language.get("DRS")) then
        mapSettings.store.drsActive = not mapSettings.store.drsActive
    end
    initPos = initPos + 30
    mapSettings.store.colorSectors = colorSelector.main(language.get("SECTORS"), mapSettings.store.colorSectors, vec2(20, initPos))
    mapSettings.store.colorDRS = colorSelector.main(language.get("DRS"), mapSettings.store.colorDRS, vec2(100, initPos))
    initPos = initPos + 40

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefaultFeatures()
    end
end

-- Configurações das Seções
local function sectionsSettings()
    local initPos = 80
    if toggleButton.main("sectionsTrackActive", vec2(20, initPos), mapSettings.store.sectionsTrackActive, language.get("SECTIONS")) then
        mapSettings.store.sectionsTrackActive = not mapSettings.store.sectionsTrackActive
    end
    --initPos = initPos + 30
    mapSettings.store.sectionsType = droplist.main("sectionsType", "Type", vec2(200, initPos), 100,  mapSettings.store.sectionsType, {"Numbers", "Names"}, droplist.PosText.Start)
    mapSettings.store.sectionsLenght = math.floor(slider.main("Lenght", string.format("%.0f", mapSettings.store.sectionsLenght), vec2(370, initPos + 5), 100, mapSettings.store.sectionsLenght, 5, 10, slider.PosText.Start))

    initPos = initPos + 40
    if mapSettings.store.sectionsTrackActive then
        local filePath = ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\CHN-HUD\\user\\trackSections\\" .. ac.getTrackName() .. ".ini"
        mapSettings.store.trackSectionsEdited, mapSettings.store.resetSectionsINI = sectionPanel.main("sectionsPanel", ac.INIConfig.load(filePath), vec2(20, initPos), vec2(WindowSettingsSize.x - 40, math.max(300, WindowSettingsSize.y - 200)))
        initPos = initPos + 310
    end

    if button.main(vec2(20, math.max(initPos, WindowSettingsSize.y - 70)), language.get("RESET_DEFAULT")) then
        resetToDefaultSections()
    end
end


-- Configurações dos Jogadores
local function playersSetitngs()
    local initPos = 100

    mapSettings.store.focusedCarLenght = math.floor(slider.main(language.get("FOCUSED_CAR_LENGHT"), string.format("%.0f", mapSettings.store.focusedCarLenght), vec2(20, initPos), 200, mapSettings.store.focusedCarLenght, 5, 15))
    initPos = initPos + 50
    mapSettings.store.enemiesLenght = math.floor(slider.main(language.get("ENEMIES_LENGHT"), string.format("%.0f", mapSettings.store.enemiesLenght), vec2(20, initPos), 200, mapSettings.store.enemiesLenght, 5, 15))

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

    if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
        resetToDefaultPlayers()
    end
end


function mapSettings.mapSettings()
    ui.tabBar('##ID',function ()
        ui.tabItem(language.get("TRACK"), trackSetitngs)
        ui.tabItem(language.get("FEATURES_OF_TRACK"), featuresSettings)
        ui.tabItem("Sections", sectionsSettings)
        ui.tabItem(language.get("PLAYERS"), playersSetitngs)
    end)
end

return mapSettings