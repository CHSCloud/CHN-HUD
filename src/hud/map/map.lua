local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local mapSettings = require("src.settings.tabs.mapSettings")

local map = {}

local minPos = vec2(math.huge, math.huge) -- Posição mínima da pista
local maxPos = vec2(-math.huge, -math.huge) -- Posição máxima da pista
local totalPoints -- Total de pontos do mapa
local mapPoints = {} -- Pontos do mapa
local sectors = {} -- Setores da pista
local drs = {} -- DRS da pista

local canvas = nil
local canvasSize = vec2(512, 512)-- Tamanho do Canvas
local canvasCenter = vec2(canvasSize.x / 2, canvasSize.y / 2) -- Centro do Canvas
local canvasScale -- Escala final do mapa

local padding = 10 -- Limite do mapa
local thickness -- Espessura do traço

-- Tamnho da janela
local currentWindowSize

-- Tamanho da pista
local trackLength
-- Centros da pista
local trackCenterX
local trackCenterY
local isTrackConnected = true

local transparancy = 0

local function initMap()
    totalPoints = config.remapInterval(SIM.trackLengthM, 0, 4000, 0, 450)
    -- Armazenando pontos do mapa
    for i = 0, 1, 1 / totalPoints do
        local posWorld = ac.trackCoordinateToWorld(vec3(0, 0, i))
        local posWorld2D = vec2(posWorld.x, posWorld.z)
        table.insert(mapPoints, posWorld2D)

        -- Definindo limites do mapa
        if posWorld2D.x < minPos.x then minPos.x = posWorld2D.x end
        if posWorld2D.y < minPos.y then minPos.y = posWorld2D.y end
        if posWorld2D.x > maxPos.x then maxPos.x = posWorld2D.x end
        if posWorld2D.y > maxPos.y then maxPos.y = posWorld2D.y end
    end

    -- Armazenando sectores
    for i, sector in ipairs(SIM.lapSplits) do
        local start = ac.trackCoordinateToWorld(vec3(0, 0, sector - 0.002))
        local final = ac.trackCoordinateToWorld(vec3(0, 0, sector + 0.002))
        table.insert(sectors, {
            start = vec2(start.x, start.z),
            final = vec2(final.x, final.z)
        })
    end

    -- Armazenando DRS
    local ini = ac.INIConfig.trackData("drs_zones.ini")
    if ini ~= nil then
        local sections = ini['sections']
        for name, data in pairs(sections) do
            local dataStart = data['START']
            local dataFinal = data['END']
            
            local start1 = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataStart[1]) - 0.002))
            local final1 = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataStart[1]) + 0.002))
            local start2 = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataFinal[1]) - 0.002))
            local final2 = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataFinal[1]) + 0.002))
            if dataStart[1] ~= nil and dataFinal[1] ~= nil then
                table.insert(drs, {
                    start1 = vec2(start1.x, start1.z),
                    final1 = vec2(final1.x, final1.z),
                    start2 = vec2(start2.x, start2.z),
                    final2 = vec2(final2.x, final2.z)
                })
            end
        end
    end

    -- Comprimento da pista
    trackLength = math.distance(minPos, maxPos)
    
    -- Verificando se a pista é conectada:
    local start = ac.trackCoordinateToWorld(vec3(0, 0, 0))
    local final = ac.trackCoordinateToWorld(vec3(0, 0, 0.99))
    local distance = math.distance(start, final)
    if distance > 60 then 
        isTrackConnected = false
    end

    canvasScale = (canvasSize.y - (padding * 2)) / trackLength
    
    -- Centros da pista
    trackCenterX = (minPos.x + maxPos.x) / 2
    trackCenterY = (minPos.y + maxPos.y) / 2
    
    canvas = ui.ExtraCanvas(canvasSize, 1, render.AntialiasingMode.None)
    canvas:setName("CANVAS")
end

--- @param thickness number -- Espessura do traço
--- @param color rgbm -- Cor do traço
local function drawMap(thickness, color)
    for i, point in ipairs(mapPoints) do
        local offsetX = (point.x - trackCenterX) * canvasScale
        local offsetY = (point.y - trackCenterY) * canvasScale

        local rotatePos = config.rotateVec(vec2(offsetX, offsetY), mapSettings.store.angle)

        local finalX = canvasCenter.x + rotatePos.x
        local finalY = canvasCenter.y + rotatePos.y
        
        ui.pathLineTo(vec2(finalX, finalY))
    end
    ui.pathStroke(color, isTrackConnected, thickness)
end

--- @param thickness number -- Espessura do setor
--- @param color rgbm -- Cor do setor
local function drawSectors(thickness, color)
    for i, sector in ipairs(sectors) do
        local rotatePosInit = config.rotateVec(vec2((sector.start.x - trackCenterX) * canvasScale, (sector.start.y - trackCenterY) * canvasScale), mapSettings.store.angle)
        local init = vec2(math.floor((canvasCenter.x + rotatePosInit.x) * 100) / 100, math.floor((canvasCenter.y + rotatePosInit.y) * 100) / 100)

        local rotatePosFinal = config.rotateVec(vec2((sector.final.x - trackCenterX) * canvasScale, (sector.final.y - trackCenterY) * canvasScale), mapSettings.store.angle)
        local final = vec2(math.floor((canvasCenter.x + rotatePosFinal.x) * 100) / 100, math.floor((canvasCenter.y + rotatePosFinal.y) * 100) / 100)
        if i == 1 then
            ui.drawLine(init, final, COLOR.RED, thickness)
        else 
            ui.drawLine(init, final, color, thickness)
        end
    end
end

--- @param car ac.StateCar -- Cara a ser desenhado
--- @param lenght number -- Tamanho do círculo
--- @param color rgbm -- Cor do círculo
local function drawPLayer(car, lenght, color)
    local posX = (car.position.x - trackCenterX) * canvasScale
    local posY = (car.position.z - trackCenterY) * canvasScale
    local rotatedPos = config.rotateVec(vec2(posX, posY), mapSettings.store.angle)
    rotatedPos = canvasCenter + rotatedPos
    ui.drawCircleFilled(rotatedPos, lenght / 2, color, 20)
    ui.drawCircle(rotatedPos, lenght / 2, COLOR.BLACK, 20, 5)
    ui.setCursor(rotatedPos - vec2(lenght,lenght)/2)
    ui.dwriteTextAligned(tostring(car.racePosition), 0.6 * lenght, ui.Alignment.Center, ui.Alignment.Center, vec2(lenght, lenght), false, COLOR.BLACK)
end

--- @param lenght number -- Tamanho dos círculos
local function drawPLayers(lenght)
    for i, car in ac.iterateCars.leaderboard() do
        if car.index ~= SIM.focusedCar then
            drawPLayer(car, lenght, mapSettings.store.colorEnemies)
        end
    end
    local car = ac.getCar(SIM.focusedCar)
    if car == nil then return end
    drawPLayer(car, lenght, mapSettings.store.colorPlayer)
end

--- @param thickness number -- Espessura do DRS
local function drawDRS(thickness)
    for i, data in pairs(drs) do
        local rotatePosInit = config.rotateVec(vec2((data.start1.x - trackCenterX) * canvasScale, (data.start1.y - trackCenterY) * canvasScale), mapSettings.store.angle)
        local init = vec2(math.floor((canvasCenter.x + rotatePosInit.x) * 100) / 100, math.floor((canvasCenter.y + rotatePosInit.y) * 100) / 100)

        local rotatePosFinal = config.rotateVec(vec2((data.final1.x - trackCenterX) * canvasScale, (data.final1.y - trackCenterY) * canvasScale), mapSettings.store.angle)
        local final = vec2(math.floor((canvasCenter.x + rotatePosFinal.x) * 100) / 100, math.floor((canvasCenter.y + rotatePosFinal.y) * 100) / 100)
        ui.drawLine(init, final, mapSettings.store.colorDRS, thickness)

        rotatePosInit = config.rotateVec(vec2((data.start2.x - trackCenterX) * canvasScale, (data.start2.y - trackCenterY) * canvasScale), mapSettings.store.angle)
        init = vec2(math.floor((canvasCenter.x + rotatePosInit.x) * 100) / 100, math.floor((canvasCenter.y + rotatePosInit.y) * 100) / 100)

        rotatePosFinal = config.rotateVec(vec2((data.final2.x - trackCenterX) * canvasScale, (data.final2.y - trackCenterY) * canvasScale), mapSettings.store.angle)
        final = vec2(math.floor((canvasCenter.x + rotatePosFinal.x) * 100) / 100, math.floor((canvasCenter.y + rotatePosFinal.y) * 100) / 100)
        ui.drawLine(init, final, mapSettings.store.colorDRS, thickness)
    end
end

function map.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
    currentWindowSize = vec2(300, 300):scale(mapSettings.store.mapScale)
    thickness = 50
    -- Animação do Background
    if config.isMouseInWindow(ui.mouseLocalPos(), 0, ui.windowSize().x, 0, ui.windowSize().y) then
        if transparancy < 0.85 then
            if 20 * Timer % 6 >= 1 then
                transparancy = transparancy + 0.1
            end
        end
        ui.drawRectFilled(vec2(0, 0), currentWindowSize, rgbm(WindowsColor.r,WindowsColor.g,WindowsColor.b, transparancy), 20 * mapSettings.store.mapScale)
    else
        if transparancy > 0 then
            if 20 * Timer % 6 >= 1 then
                transparancy = transparancy - 0.1
            end
             ui.drawRectFilled(vec2(0, 0), currentWindowSize, rgbm(WindowsColor.r,WindowsColor.g,WindowsColor.b, transparancy), 20 * mapSettings.store.mapScale)
        else
            transparancy = 0
        end
    end

    -- Desenha borda
    if canvas == nil then return end
    canvas:clear()
    canvas:update(function ()
        drawMap((mapSettings.store.trackLenght + mapSettings.store.borderLenght * 2), mapSettings.store.colorBorder)
        -- Desenha pista
        drawMap(mapSettings.store.trackLenght, mapSettings.store.colorTrack)
        -- Desenha DRS
        drawDRS(mapSettings.store.trackLenght)
        -- Desenha setores
        drawSectors(mapSettings.store.trackLenght, mapSettings.store.colorSectors)
        -- Desenha jogadores
        drawPLayers(thickness)
    end)
    
    ui.drawImage(canvas, 0, currentWindowSize.x)
    config.resize(currentWindowSize, "Map")
    pinCheckBox.main(mapSettings.store.mapScale * 1.5, "Map", config.getWindow("Map"):pinned(), currentWindowSize)
end

initMap()

return map